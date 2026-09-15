-- Native terminal bridge: keep output separate from the TUI and preserve picker context.
local M = {}

-- nwiizo-coding-style: paths use newline output and rg's colon fields;
-- adopt structured records when Television exposes a suitable output format.
local function file_item(entry, cwd, text)
  local name, line, col, content
  if text then
    name, line, col, content = entry:match("^(.-):(%d+):(%d+):(.*)$")
  end
  name = name or entry
  if not vim.startswith(name, "/") then
    name = cwd .. "/" .. name
  end
  return { filename = name, lnum = tonumber(line) or 1, col = tonumber(col) or 1, text = content or "" }
end

local function accept_files(entries, key, opts)
  local items = vim.tbl_map(function(entry)
    return file_item(entry, opts.cwd, opts.channel == "text")
  end, entries)
  if key == "ctrl-q" then
    vim.fn.setqflist({}, " ", { title = "Television: " .. opts.channel, items = items })
    vim.cmd.copen()
    return
  end
  for i, item in ipairs(items) do
    if i == 1 then
      if vim.fn.filereadable(item.filename) ~= 1 then
        vim.notify("Selected file is no longer readable: " .. item.filename, vim.log.levels.WARN)
        return
      end
      local command = key == "ctrl-v" and "vsplit" or key == "ctrl-s" and "split" or "edit"
      vim.cmd[command](vim.fn.fnameescape(item.filename))
      -- The file can become shorter while the picker is open.
      local row = math.min(item.lnum, vim.api.nvim_buf_line_count(0))
      local line = vim.api.nvim_buf_get_lines(0, row - 1, row, false)[1] or ""
      vim.api.nvim_win_set_cursor(0, { row, math.min(item.col - 1, #line) })
    else
      vim.fn.bufadd(item.filename)
    end
  end
end

-- opts: channel/cwd/input, or entries + accept for an editor-owned list.
-- args passes additional native Television options.
function M.open(opts)
  opts = vim.tbl_extend("force", { cwd = vim.fn.getcwd(), channel = "files" }, opts or {})
  if vim.fn.executable("tv") ~= 1 then
    if opts.cleanup then
      opts.cleanup()
    end
    vim.notify("Television is missing; install the Brewfile dependencies", vim.log.levels.ERROR)
    return
  end
  local origin = vim.api.nvim_get_current_win()
  local result = vim.fn.tempname()
  local source
  local keys = opts.keys or { "enter", "ctrl-q", "ctrl-s", "ctrl-v" }
  local argv =
    { "tv", "--no-remote", "--expect", table.concat(keys, ";"), "--keybindings", 'enter="confirm_selection"' }
  if opts.entries then
    if #opts.entries == 0 then
      if opts.cleanup then
        opts.cleanup()
      end
      return
    end
    source = vim.fn.tempname()
    vim.fn.writefile(opts.entries, source)
    table.insert(argv, opts.channel)
    vim.list_extend(argv, { "--source-command", "cat " .. vim.fn.shellescape(source), "--input-header", opts.channel })
    if not opts.preview then
      table.insert(argv, "--no-preview")
    end
  else
    table.insert(argv, opts.channel)
  end
  if opts.input then
    vim.list_extend(argv, { "--input", opts.input })
  end
  vim.list_extend(argv, opts.args or {})

  if opts.preview then
    vim.list_extend(argv, { "--preview-command", opts.preview })
  end
  local function cleanup()
    if opts.cleanup then
      opts.cleanup()
    end
    vim.fn.delete(result)
    if source then
      vim.fn.delete(source)
    end
  end

  local buf = vim.api.nvim_create_buf(false, true)
  local width = math.max(1, math.floor(vim.o.columns * 0.92))
  local height = math.max(1, math.floor((vim.o.lines - 2) * 0.85))
  local win = vim.api.nvim_open_win(buf, true, {
    relative = "editor",
    width = width,
    height = height,
    col = math.floor((vim.o.columns - width) / 2),
    row = math.max(0, math.floor((vim.o.lines - height) / 2) - 1),
    style = "minimal",
    border = "rounded",
    title = " Television · " .. opts.channel .. " ",
    title_pos = "center",
  })
  vim.bo[buf].bufhidden = "wipe"
  -- Quote argv once; only stdout goes to the file. Television draws through /dev/tty.
  local command = "exec "
    .. table.concat(vim.tbl_map(vim.fn.shellescape, argv), " ")
    .. " > "
    .. vim.fn.shellescape(result)
  local job = vim.fn.jobstart({ "/bin/sh", "-c", command }, {
    term = true,
    cwd = opts.cwd,
    on_exit = function(_, code)
      vim.schedule(function()
        local lines = vim.fn.filereadable(result) == 1 and vim.fn.readfile(result) or {}
        cleanup()
        if vim.api.nvim_win_is_valid(win) then
          vim.api.nvim_win_close(win, true)
        end
        if not vim.api.nvim_win_is_valid(origin) then
          return
        end
        vim.api.nvim_set_current_win(origin)
        if code == 130 then
          return
        end
        if code ~= 0 then
          vim.notify("Television exited with status " .. code, vim.log.levels.ERROR)
          return
        end
        local key = "enter"
        if vim.tbl_contains(keys, lines[1]) then
          key = table.remove(lines, 1)
        end
        if #lines > 0 then
          (opts.accept or accept_files)(lines, key, opts)
        end
      end)
    end,
  })
  if job <= 0 then
    cleanup()
    vim.api.nvim_win_close(win, true)
    vim.notify("Could not start Television", vim.log.levels.ERROR)
    return
  end
  vim.cmd.startinsert()
  return win
end

function M.quickfix(opts)
  if vim.bo.buftype ~= "quickfix" then
    vim.cmd.copen()
  end
  local qwin = vim.api.nvim_get_current_win()
  local is_local = vim.fn.getwininfo(qwin)[1].loclist == 1
  local owner = is_local and vim.fn.getloclist(0, { filewinid = 0 }).filewinid or nil
  local function get_list(fields)
    return owner and vim.fn.getloclist(owner, fields) or vim.fn.getqflist(fields)
  end
  local snapshot = get_list({ id = 0, changedtick = 0, title = 0, context = 0, items = 0 })
  if #snapshot.items == 0 then
    return
  end
  local sessions = require("bqf.qfwin.session")
  if not sessions:get(qwin) then
    require("bqf").enable()
  end
  local session = sessions:get(qwin)
  local function unchanged()
    if not vim.api.nvim_win_is_valid(qwin) or (owner and not vim.api.nvim_win_is_valid(owner)) then
      return false
    end
    local current = get_list({ id = 0, changedtick = 0 })
    return current.id == snapshot.id and current.changedtick == snapshot.changedtick
  end
  local entries = {}
  local preview_dir = vim.fn.tempname()
  vim.fn.mkdir(preview_dir, "p", 448)
  local previews = {}
  local labels = vim.api.nvim_buf_get_lines(0, 0, -1, false)
  for i, item in ipairs(snapshot.items) do
    local name = previews[item.bufnr]
    if not name then
      local filename = vim.api.nvim_buf_is_valid(item.bufnr) and vim.api.nvim_buf_get_name(item.bufnr) or ""
      name = item.bufnr .. "." .. vim.fn.fnamemodify(filename, ":e"):gsub("[^%w]", "")
      local target = preview_dir .. "/" .. name
      if item.bufnr > 0 and vim.api.nvim_buf_is_loaded(item.bufnr) then
        -- Snapshot unsaved text; leave unloaded files lazy through a symlink.
        vim.fn.writefile(vim.api.nvim_buf_get_lines(item.bufnr, 0, -1, false), target)
      elseif filename == "" or not vim.uv.fs_symlink(filename, target) then
        vim.fn.writefile({ "Buffer is not available" }, target)
      end
      previews[item.bufnr] = name
    end
    local sign = session:list():sign():list()[i] and "^ " or "  "
    entries[i] = table.concat({
      i,
      name,
      math.max(1, item.lnum),
      math.max(1, item.lnum, item.end_lnum or 0),
      sign .. (labels[i] or item.text):gsub("[\r\n]", " "),
    }, "\t")
  end
  return M.open(vim.tbl_extend("force", opts or {}, {
    channel = "nvim-quickfix",
    entries = entries,
    keys = { "enter", "ctrl-q", "ctrl-s", "ctrl-x", "ctrl-v", "ctrl-t", "ctrl-c" },
    preview = "bat --color=always --style=numbers --highlight-line '{split:\t:2}:{split:\t:3}' -- "
      .. vim.fn.shellescape(preview_dir)
      .. "/'{split:\t:1}'",
    cleanup = function()
      vim.fn.delete(preview_dir, "rf")
    end,
    accept = function(selected, key)
      if not unchanged() then
        vim.notify("Quickfix changed while Television was open; run the filter again", vim.log.levels.WARN)
        return
      end
      local indices = {}
      for _, entry in ipairs(selected) do
        local index = tonumber(entry:match("^(%d+)\t"))
        if index and snapshot.items[index] then
          table.insert(indices, index)
        end
      end
      table.sort(indices)
      if key == "ctrl-c" then
        vim.api.nvim_win_close(qwin, true)
      elseif key == "ctrl-q" then
        session:list():sign():toggle(indices, vim.api.nvim_win_get_buf(qwin))
      elseif #indices > 1 then
        require("bqf.filter.base").filterList(
          qwin,
          vim.tbl_map(function(index)
            return snapshot.items[index]
          end, indices)
        )
      elseif #indices == 1 then
        local actions = { ["ctrl-s"] = "split", ["ctrl-x"] = "split", ["ctrl-v"] = "vsplit", ["ctrl-t"] = "tabedit" }
        require("bqf.qfwin.handler").open(true, actions[key], qwin, indices[1])
      end
    end,
  }))
end

return M
