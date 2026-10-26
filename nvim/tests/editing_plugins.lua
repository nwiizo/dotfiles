-- Run with isolated HOME/XDG directories, as documented in nvim/maintenance.md.
vim.api.nvim_exec_autocmds("UIEnter", { modeline = false })
local test
local function resume()
  local ok, err = coroutine.resume(test)
  if not ok then
    io.stderr:write(tostring(err) .. "\n")
    vim.cmd.cquit()
  end
end
test = coroutine.create(function()
  local ok, err = pcall(function()
    local function type_keys(keys)
      -- Return to the input loop so multicursor receives real SafeState events.
      vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(keys, true, false, true), "t", false)
      vim.defer_fn(resume, 200)
      coroutine.yield()
    end
    local function lines()
      return vim.api.nvim_buf_get_lines(0, 0, -1, false)
    end
    local function reset(text)
      vim.cmd("enew!")
      vim.bo.buftype = "nofile"
      vim.bo.swapfile = false
      vim.api.nvim_buf_set_lines(0, 0, -1, false, text)
      vim.api.nvim_win_set_cursor(0, { 1, 0 })
    end

    assert(not package.loaded["mini.align"], "Alignment should load on its key")
    reset({ "a=1", "long=2" })
    type_keys("VjgA=<CR><Esc>")
    assert(package.loaded["mini.align"], "gA did not load alignment")
    assert(vim.deep_equal(lines(), { "a    = 1", "long = 2" }), vim.inspect(lines()))
    type_keys("u")
    assert(vim.deep_equal(lines(), { "a=1", "long=2" }), "Alignment undo failed")
    type_keys("VjgA=<Esc>")
    assert(vim.deep_equal(lines(), { "a=1", "long=2" }), "Preview cancellation changed text")
    assert(vim.fn.maparg("ga", "n") == "", "Native ga was replaced")

    assert(not package.loaded["multicursor-nvim"], "Multicursor should load on its key")
    reset({ "apple apple apple" })
    local escape = vim.fn.maparg("<Esc>", "n", false, true)
    type_keys("<C-n>")
    local mc = require("multicursor-nvim")
    assert(mc.hasCursors(), "C-n did not add a cursor")
    type_keys("ciw")
    type_keys("pear<Esc>")
    assert(vim.deep_equal(lines(), { "pear pear apple" }), vim.inspect(lines()))
    type_keys("<Esc>")
    assert(not mc.hasCursors(), "Escape did not clear cursors")
    assert(vim.deep_equal(vim.fn.maparg("<Esc>", "n", false, true), escape), "Escape mapping was not restored")
    type_keys("u")
    assert(vim.deep_equal(lines(), { "apple apple apple" }), "Multicursor undo failed")

    reset({ "apple apple apple" })
    type_keys("<C-n>")
    type_keys(" cN")
    type_keys("ciw")
    type_keys("pear<Esc>")
    assert(vim.deep_equal(lines(), { "pear apple pear" }), "Skip match: " .. vim.inspect(lines()))
    type_keys("<Esc>")
  end)
  if not ok then
    io.stderr:write(tostring(err) .. "\n")
    vim.cmd.cquit()
    return
  end
  io.stdout:write(
    "editing-plugins-ok: lazy keys, alignment/preview cancellation, selected matches/skip, Escape and undo\n"
  )
  vim.cmd("qa!")
end)
vim.defer_fn(resume, 2000)
