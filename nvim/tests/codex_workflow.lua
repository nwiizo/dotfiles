-- Run with the installed plugins and full config, from the dotfiles root:
-- nvim --headless -u nvim/init.lua '+lua dofile("nvim/tests/codex_workflow.lua")'
-- CODEX_NVIM_REAL_CLI=1 uses the authenticated CLI for two turns in a temp repo.
vim.o.swapfile = false
vim.o.undofile = false
vim.o.shadafile = "NONE"
vim.o.columns = 180
vim.o.lines = 55
local dotfiles = vim.fn.getcwd()
local root = vim.fn.tempname()
local project = root .. "/project with spaces"
vim.fn.mkdir(project, "p")
project = assert(vim.uv.fs_realpath(project))
local path = project .. "/example.txt"
local real_cli = vim.env.CODEX_NVIM_REAL_CLI == "1"
local timeout = real_cli and 90000 or 5000
local codex

local function keys(text)
  vim.api.nvim_feedkeys(vim.keycode(text), "xt", false)
end

local function wait_for(label, predicate)
  assert(vim.wait(timeout, predicate, 20), "timed out: " .. label)
  print("ok - " .. label)
end

local function answer(marker)
  local status = codex.status()
  if not status.bufnr then
    return false
  end
  for _, line in ipairs(vim.api.nvim_buf_get_lines(status.bufnr, 0, -1, false)) do
    if line:find("• " .. marker, 1, true) then
      return true
    end
  end
  return false
end

local ok, err = xpcall(function()
  assert(vim.system({ "git", "init", "-q", project }):wait().code == 0)
  assert(vim.fn.writefile({ "before" }, path) == 0)
  assert(vim.system({ "git", "-C", project, "add", "example.txt" }):wait().code == 0)
  require("lazy").load({ plugins = { "codex.nvim", "avante.nvim", "codediff.nvim" } })
  -- Snacks normally binds this on UIEnter, which headless mode does not emit.
  vim.ui.select = Snacks.picker.select
  vim.wait(1500) -- Avante installs its visual selection handler on a scheduled callback.
  codex = require("codex")
  local opts = vim.deepcopy(require("codex.config").get())
  if real_cli then
    vim.list_extend(opts.cmd, {
      "--sandbox",
      "workspace-write",
      "--ask-for-approval",
      "never",
    })
  else
    opts.cmd = { "sh", dotfiles .. "/nvim/tests/fixtures/codex-workflow.sh", root .. "/requests" }
  end
  codex.setup(opts)
  vim.cmd.edit(path)
  local source_buf = vim.api.nvim_get_current_buf()
  local source_win = vim.api.nvim_get_current_win()
  local source_tab = vim.api.nvim_get_current_tabpage()
  keys("ggV")
  for _, name in ipairs({ "codex_nvim_selection", "avante_selection" }) do
    local ns = assert(vim.api.nvim_get_namespaces()[name], name .. " missing")
    assert(#vim.api.nvim_buf_get_extmarks(source_buf, ns, 0, -1, {}) > 0, name .. " hint not visible")
  end
  keys(
    "<leader>oeChange example.txt to contain exactly after followed by a newline. "
      .. "Do not modify any other files. Reply with exactly WORKFLOW_EDIT_OK.<Esc>"
  )
  local draft = vim.api.nvim_get_current_buf()
  assert(vim.api.nvim_buf_get_name(draft) == "codex://ask", "Edit did not open a draft")
  assert(table.concat(vim.api.nvim_buf_get_lines(draft, 0, -1, false), "\n"):find("before", 1, true))
  assert(not codex.status().running, "Edit submitted without Ctrl-S")
  keys("<C-s>")
  if real_cli then
    local trust_prompt = false
    vim.wait(10000, function()
      local current = codex.status()
      if current.bufnr then
        local text = table.concat(vim.api.nvim_buf_get_lines(current.bufnr, 0, -1, false), "\n")
        trust_prompt = text:find("Do you trust the contents of this directory?", 1, true) ~= nil
      end
      return trust_prompt or answer("WORKFLOW_EDIT_OK")
    end, 20)
    if trust_prompt then
      -- Only acknowledge the directory this test created and populated above.
      assert(codex.status().cwd == project)
      assert(vim.fn.filereadable(project .. "/.git/config") == 1)
      -- Headless feedkeys cannot deliver interactive terminal input; send the
      -- same Enter byte to this isolated CLI's PTY (never to a user session).
      local attempts, last_enter = 0, 0
      wait_for("temporary repository trust confirmation is accepted", function()
        local text = table.concat(vim.api.nvim_buf_get_lines(codex.status().bufnr, 0, -1, false), "\n")
        if text:find("Do you trust the contents of this directory?", 1, true) == nil then
          return true
        end
        -- The first onboarding frame can precede its input loop. Retry only
        -- while that exact question is visible, at most three times.
        if attempts < 3 and vim.uv.now() - last_enter >= 1000 then
          vim.fn.chansend(codex.status().jobid, "\r")
          attempts, last_enter = attempts + 1, vim.uv.now()
        end
        return false
      end)
    end
  end
  wait_for("selected Edit is submitted and the response is visible", function()
    return answer("WORKFLOW_EDIT_OK")
  end)
  local status = codex.status()
  local jobid = status.jobid
  assert(status.running and status.visible and status.winid == vim.api.nvim_get_current_win())
  assert(not vim.api.nvim_buf_is_valid(draft), "submitted draft obscures the panel")
  assert(vim.wo[status.winid].winbar:find("Alt-a", 1, true), "next actions are not visible")
  assert(vim.deep_equal(vim.fn.readfile(path), { "after" }), "requested file change was not applied")

  keys("<M-q>")
  assert(vim.api.nvim_get_current_win() == source_win, "hide did not return to the source window")
  assert(codex.status().running and not codex.status().visible, "hide stopped the conversation")
  vim.cmd.checktime()
  assert(vim.deep_equal(vim.api.nvim_buf_get_lines(source_buf, 0, -1, false), { "after" }))
  keys("<leader>oo")
  assert(codex.status().jobid == jobid, "reopen replaced the conversation")

  -- Use the actual Snacks picker, not a mocked callback.
  keys("<M-a>")
  wait_for("next-action picker opens", function()
    return #Snacks.picker.get() > 0
  end)
  keys("<CR>")
  wait_for("picker opens a follow-up in the same conversation", function()
    return vim.api.nvim_buf_get_name(0) == "codex://ask"
  end)
  assert(vim.deep_equal(vim.api.nvim_buf_get_lines(0, 0, -1, false), { "" }), "follow-up included terminal text")
  keys("Reply with exactly WORKFLOW_FOLLOWUP_OK. Do not use tools or modify files.<C-s>")
  wait_for("follow-up answer arrives in the same process", function()
    return answer("WORKFLOW_FOLLOWUP_OK")
  end)
  assert(codex.status().jobid == jobid)

  local diff_tab
  vim.api.nvim_create_autocmd("User", {
    pattern = "CodeDiffOpen",
    once = true,
    callback = function(event)
      diff_tab = event.data.tabpage
    end,
  })
  -- cwd is deliberately still dotfiles; --repo must select the Codex project.
  assert(vim.fn.getcwd() == dotfiles)
  keys("<M-d>")
  wait_for("CodeDiff shows the edited file in the session project", function()
    if not diff_tab or vim.api.nvim_get_current_tabpage() ~= diff_tab then
      return false
    end
    for _, win in ipairs(vim.api.nvim_tabpage_list_wins(diff_tab)) do
      if vim.api.nvim_buf_get_name(vim.api.nvim_win_get_buf(win)) == path then
        vim.api.nvim_set_current_win(win)
        return vim.fn.maparg("q", "n") ~= ""
      end
    end
    return false
  end)
  keys("q")
  wait_for("closing the diff returns to the conversation tab", function()
    return vim.api.nvim_get_current_tabpage() == source_tab
  end)
  assert(codex.status().jobid == jobid and codex.status().running)
  keys("<leader>oR")
  assert(vim.api.nvim_buf_get_name(0) == "codex://ask", "review did not open an editable request")
  local review = table.concat(vim.api.nvim_buf_get_lines(0, 0, -1, false), "\n")
  assert(review:find("Review the uncommitted changes", 1, true))
  assert(review:find("Do not modify files", 1, true))
  assert(codex.status().jobid == jobid, "review replaced the running conversation")
  require("codex.ask").reset()
  print("codex-workflow-ok (" .. (real_cli and "real CLI" or "terminal fixture") .. ")")
end, debug.traceback)

if codex then
  require("codex.ask").reset()
  if codex.status().running then
    codex.stop()
    vim.wait(3000, function()
      return not codex.status().running
    end)
  end
end
vim.fn.delete(root, "rf")
if not ok then
  io.stderr:write(err .. "\n")
  vim.cmd("cquit 1")
end
vim.cmd("qa!")
