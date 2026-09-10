-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua

-- Keep 'autoread' responsive to agent edits without checking on every cursor
-- move. CursorHold also covers filesystems where change detection is delayed.
local external_changes = vim.api.nvim_create_augroup("nwiizo_external_changes", { clear = true })
local external_change_states = {}

local function is_mergeable_buffer(buf)
  if not vim.api.nvim_buf_is_valid(buf) or not vim.api.nvim_buf_is_loaded(buf) then
    return false
  end

  local bo = vim.bo[buf]
  local encoding = bo.fileencoding
  return bo.buftype == ""
    and bo.modifiable
    and not bo.binary
    and (encoding == "" or encoding:lower() == "utf-8")
    and vim.api.nvim_buf_get_name(buf) ~= ""
end

local function buffer_lines(buf)
  return vim.api.nvim_buf_get_lines(buf, 0, -1, false)
end

local function read_external_snapshot(buf)
  local path = vim.api.nvim_buf_get_name(buf)
  local lines_ok, lines = pcall(vim.fn.readfile, path)
  local eol_ok, last_byte = pcall(vim.fn.readblob, path, -1, 1)
  if not lines_ok or not eol_ok then
    return nil
  end

  return { lines = lines, endofline = last_byte == "\n" }
end

local function remember_external_change_baseline(buf)
  if is_mergeable_buffer(buf) then
    local disk = read_external_snapshot(buf)
    if disk then
      external_change_states[buf] = {
        baseline = { lines = buffer_lines(buf), endofline = disk.endofline },
      }
    end
  end
end

local function merge_external_change(local_lines, base_lines, external_lines)
  local paths = { vim.fn.tempname(), vim.fn.tempname(), vim.fn.tempname() }
  local inputs = { local_lines, base_lines, external_lines }

  for index, path in ipairs(paths) do
    if vim.fn.writefile(inputs[index], path) ~= 0 then
      for _, temp_path in ipairs(paths) do
        vim.fn.delete(temp_path)
      end
      return nil, false, "failed to create merge input"
    end
  end

  local ok, result = pcall(function()
    return vim
      .system({
        "git",
        "merge-file",
        "--stdout",
        "--diff3",
        "-L",
        "Neovim (unsaved)",
        "-L",
        "common base",
        "-L",
        "AI agent (disk)",
        paths[1],
        paths[2],
        paths[3],
      }, { text = true })
      :wait()
  end)

  for _, path in ipairs(paths) do
    vim.fn.delete(path)
  end

  if not ok then
    return nil, false, tostring(result)
  end

  if result.signal ~= 0 or result.code == 255 then
    local message = vim.trim(result.stderr or "")
    return nil, false, message ~= "" and message or "git merge-file failed"
  end

  local merged = vim.split(result.stdout or "", "\n", { plain = true })
  if merged[#merged] == "" then
    table.remove(merged)
  end
  return merged, result.code > 0, nil
end

local function apply_merged_lines(buf, merged)
  local current = buffer_lines(buf)
  local hunks = vim.text.diff(table.concat(current, "\n") .. "\n", table.concat(merged, "\n") .. "\n", {
    algorithm = "histogram",
    result_type = "indices",
  })

  vim.api.nvim_buf_call(buf, function()
    -- Close the user's current undo block before recording the merge as one step.
    vim.go.undolevels = vim.go.undolevels
    local first = true
    for index = #hunks, 1, -1 do
      local hunk = hunks[index]
      local start = hunk[1] - (hunk[2] > 0 and 1 or 0)
      local replacement = {}
      if hunk[4] > 0 then
        replacement = vim.list_slice(merged, hunk[3], hunk[3] + hunk[4] - 1)
      end

      if not first then
        pcall(vim.cmd.undojoin)
      end
      vim.api.nvim_buf_set_lines(buf, start, start + hunk[2], false, replacement)
      first = false
    end
  end)
end

local function schedule_external_change_merge(context)
  local buf = context.buf
  local state = external_change_states[buf]
  state.pending = true

  vim.schedule(function()
    state = external_change_states[buf]
    if not state or not state.pending then
      return
    end

    if not is_mergeable_buffer(buf) then
      state.pending = nil
      state.blocked = "apply_failed"
      vim.notify("External change was not merged because the buffer is no longer modifiable", vim.log.levels.ERROR)
      return
    end

    local merged = context.merged
    local conflicted = context.conflicted
    if vim.api.nvim_buf_get_changedtick(buf) ~= context.changedtick then
      local err
      merged, conflicted, err = merge_external_change(buffer_lines(buf), context.base.lines, context.external.lines)
      if not merged then
        state.pending = nil
        state.blocked = "apply_failed"
        vim.notify("Could not merge external change: " .. err, vim.log.levels.ERROR)
        return
      end
    end

    local applied, apply_err = pcall(apply_merged_lines, buf, merged)
    state.pending = nil
    if not applied then
      state.blocked = "apply_failed"
      vim.notify("Could not apply external change: " .. tostring(apply_err), vim.log.levels.ERROR)
      return
    end

    state.baseline = context.external
    state.blocked = conflicted and "conflicted" or nil

    if conflicted then
      vim.notify("External change has conflicts; both versions were kept with conflict markers", vim.log.levels.WARN)
    else
      vim.notify("Merged external change with unsaved edits", vim.log.levels.INFO)
    end
  end)
end

vim.api.nvim_create_autocmd({ "BufReadPost", "BufWritePost" }, {
  group = external_changes,
  callback = function(args)
    remember_external_change_baseline(args.buf)
  end,
  desc = "Remember the common base for external-change merges",
})

vim.api.nvim_create_autocmd({ "BufDelete", "BufWipeout" }, {
  group = external_changes,
  callback = function(args)
    external_change_states[args.buf] = nil
  end,
  desc = "Forget external-change merge state",
})

for _, buf in ipairs(vim.api.nvim_list_bufs()) do
  remember_external_change_baseline(buf)
end

vim.api.nvim_create_autocmd({ "BufEnter", "CursorHold" }, {
  group = external_changes,
  callback = function(args)
    if vim.bo[args.buf].buftype == "" then
      vim.cmd.checktime()
    end
  end,
  desc = "Check for external changes not covered by LazyVim defaults",
})

vim.api.nvim_create_autocmd("FileChangedShell", {
  group = external_changes,
  callback = function(args)
    local buf = args.buf
    local state = external_change_states[buf]
    if vim.v.fcs_reason == "deleted" then
      vim.v.fcs_choice = "ask"
      vim.notify("File changed externally (file was deleted)", vim.log.levels.WARN)
    elseif not vim.bo[buf].modified then
      vim.v.fcs_choice = "reload"
    elseif state and state.blocked then
      vim.v.fcs_choice = "ask"
      local reason = state.blocked == "conflicted" and "merge conflicts are unresolved" or "the previous merge failed"
      vim.notify("File changed again while " .. reason, vim.log.levels.WARN)
    elseif state and state.pending then
      vim.v.fcs_choice = ""
    elseif not is_mergeable_buffer(buf) or vim.fn.executable("git") ~= 1 then
      vim.v.fcs_choice = "ask"
      vim.notify("File changed externally (automatic merge is unavailable)", vim.log.levels.WARN)
    else
      local base = state and state.baseline
      local external = read_external_snapshot(buf)
      if not base or not external then
        vim.v.fcs_choice = "ask"
        vim.notify("File changed externally (merge base is unavailable)", vim.log.levels.WARN)
        return
      end
      if external.endofline ~= base.endofline then
        vim.v.fcs_choice = "ask"
        vim.notify("File changed externally (final newline changed; automatic merge skipped)", vim.log.levels.WARN)
        return
      end

      local changedtick = vim.api.nvim_buf_get_changedtick(buf)
      local merged, conflicted, err = merge_external_change(buffer_lines(buf), base.lines, external.lines)
      if not merged then
        vim.v.fcs_choice = "ask"
        vim.notify("Could not merge external change: " .. err, vim.log.levels.ERROR)
        return
      end

      vim.v.fcs_choice = ""
      schedule_external_change_merge({
        buf = buf,
        base = base,
        external = external,
        merged = merged,
        conflicted = conflicted,
        changedtick = changedtick,
      })
    end
  end,
  desc = "Auto-reload or merge external changes without losing unsaved edits",
})

vim.api.nvim_create_autocmd("FileChangedShellPost", {
  group = external_changes,
  callback = function(args)
    local state = external_change_states[args.buf]
    local path = vim.api.nvim_buf_get_name(args.buf)
    if not (state and state.pending) and not vim.bo[args.buf].modified and vim.fn.filereadable(path) == 1 then
      remember_external_change_baseline(args.buf)
    end
  end,
  desc = "Refresh the common base after an external reload",
})

-- Disable spell check for markdown (Japanese text causes false positives)
-- LazyVim enables spell via lazyvim_wrap_spell autocmd group
pcall(vim.api.nvim_del_augroup_by_name, "lazyvim_wrap_spell")
