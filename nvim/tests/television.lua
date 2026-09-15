-- Run: nvim --headless -u NONE -l nvim/tests/television.lua
vim.opt.rtp:prepend("nvim")
vim.opt.rtp:append(vim.fn.stdpath("data") .. "/lazy/nvim-bqf")
require("bqf").setup({ func_map = { fzffilter = "" } })
vim.o.swapfile = false
local tv = require("config.television")
local root = vim.fn.tempname()
vim.fn.mkdir(root, "p")
local file = root .. "/a 'quoted' file.txt"
vim.fn.writefile({ "first", "needle here" }, file)

local function wait_closed(win)
  local terminal = vim.api.nvim_win_get_buf(win)
  if not vim.wait(5000, function()
    return not vim.api.nvim_win_is_valid(win)
  end) then
    error("Television did not close: " .. table.concat(vim.api.nvim_buf_get_lines(terminal, 0, -1, false), "\n"))
  end
end

local ok, err = pcall(function()
  local cwd = vim.fn.getcwd()
  local win = tv.open({ channel = "files", cwd = root, args = { "--take-1" } })
  wait_closed(win)
  assert(
    vim.uv.fs_realpath(vim.api.nvim_buf_get_name(0)) == vim.uv.fs_realpath(file),
    "selected path was not opened literally"
  )
  assert(vim.fn.getcwd() == cwd, "picker changed the editor working directory")

  win = tv.open({ channel = "text", cwd = root, input = "needle", args = { "--take-1" } })
  wait_closed(win)
  assert(vim.api.nvim_win_get_cursor(0)[1] == 2, "text selection lost the line number")
  win = tv.open({ channel = "text", cwd = root, entries = { file .. ":999:999:stale match" }, args = { "--take-1" } })
  wait_closed(win)
  assert(vim.api.nvim_win_get_cursor(0)[1] == 2, "stale search position was not clamped")

  vim.fn.setqflist({}, " ", {
    title = "test",
    context = { owner = "test" },
    items = {
      { filename = file, lnum = 1, text = "first", type = "E", user_data = { keep = 1 } },
      { filename = file, lnum = 2, text = "needle", type = "W", user_data = { keep = 2 } },
    },
  })
  local original = vim.fn.getqflist({ items = 1, context = 1 })
  -- Exact text avoids fuzzy matches against the random temporary directory.
  win = tv.quickfix({ input = "'needle", args = { "--select-1" } })
  wait_closed(win)
  local filtered = vim.fn.getqflist({ items = 1, context = 1 })
  assert(vim.deep_equal(filtered.items, original.items), "jump changed quickfix metadata")
  assert(vim.deep_equal(filtered.context, original.context), "jump changed quickfix context")
  assert(vim.api.nvim_win_get_cursor(0)[1] == 2, "quickfix did not jump to the selected item: " .. vim.inspect({
    cursor = vim.api.nvim_win_get_cursor(0),
    buffer = vim.api.nvim_buf_get_name(0),
    index = vim.fn.getqflist({ idx = 0 }).idx,
  }))

  win = tv.quickfix()
  local pending_job = vim.b.terminal_job_id
  vim.fn.setqflist({}, "r", { items = { original.items[1] } })
  local newer = vim.fn.getqflist()
  vim.wait(300, function()
    return false
  end)
  vim.api.nvim_chan_send(pending_job, "\r")
  wait_closed(win)
  assert(vim.deep_equal(vim.fn.getqflist(), newer), "picker overwrote a newer quickfix list")

  vim.cmd.cclose()
  local global_items = vim.fn.getqflist()
  local owner = vim.api.nvim_get_current_win()
  vim.fn.setloclist(owner, {}, " ", { title = "local", items = original.items })
  vim.cmd.lopen()
  win = tv.quickfix({ input = "'needle", args = { "--select-1" } })
  wait_closed(win)
  assert(vim.deep_equal(vim.fn.getloclist(owner), original.items), "jump changed the location list")
  assert(vim.api.nvim_get_current_win() == owner, "location jump lost its owner window")
  assert(vim.api.nvim_win_get_cursor(0)[1] == 2, "location list did not jump to the selected item")
  assert(vim.deep_equal(vim.fn.getqflist(), global_items), "location filter changed global quickfix")
  vim.cmd.lclose()
  local origin = vim.api.nvim_get_current_win()
  local buf = vim.api.nvim_get_current_buf()
  vim.api.nvim_buf_set_lines(buf, 0, 1, false, { "unsaved change" })
  win = tv.open({ channel = "files", cwd = root })
  local job = vim.b.terminal_job_id
  assert(job, "terminal job missing")
  vim.wait(300, function()
    return false
  end)
  vim.api.nvim_chan_send(job, "\027")
  wait_closed(win)
  assert(vim.api.nvim_get_current_win() == origin, "cancel lost the original window")
  assert(vim.api.nvim_get_current_buf() == buf and vim.bo[buf].modified, "cancel lost the edited buffer")
end)

vim.fn.delete(root, "rf")
if not ok then
  error(err)
end
print("television-ok")
