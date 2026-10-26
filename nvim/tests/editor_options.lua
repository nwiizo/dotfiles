-- Run with isolated HOME/XDG directories, as documented in nvim/maintenance.md.
vim.api.nvim_exec_autocmds("UIEnter", { modeline = false })
vim.defer_fn(function()
  local root = vim.fn.tempname()
  vim.fn.mkdir(root, "p")
  root = assert(vim.uv.fs_realpath(root))
  local ok, err = pcall(function()
    local first, second = root .. "/first", root .. "/second"
    assert(vim.fn.writefile({ "saved" }, first) == 0)
    assert(vim.fn.writefile({ "other" }, second) == 0)
    vim.cmd.args({ args = { first, second } })
    local source = vim.api.nvim_get_current_buf()
    vim.api.nvim_buf_set_lines(source, 0, -1, false, { "unsaved" })
    vim.cmd("silent !true")
    assert(vim.deep_equal(vim.fn.readfile(first), { "saved" }), "Running a command silently saved the source file")
    vim.cmd.next()
    assert(vim.api.nvim_buf_get_name(0) == second, "Unexpected buffer: " .. vim.api.nvim_buf_get_name(0))
    assert(vim.deep_equal(vim.fn.readfile(first), { "saved" }), "Navigation silently saved the source file")
    assert(vim.bo[source].modified, "Navigation discarded the unsaved state")
    vim.api.nvim_set_current_buf(source)
    vim.cmd.write()
    assert(vim.deep_equal(vim.fn.readfile(first), { "unsaved" }), "Explicit save failed")

    -- FileType policies apply on first use; returning to a buffer keeps a manual toggle.
    vim.cmd.enew()
    vim.bo.filetype = "lua"
    assert(not vim.wo.wrap, "Code wraps by default")
    vim.cmd.enew()
    vim.api.nvim_buf_set_name(0, root .. "/notes")
    vim.bo.filetype = "text"
    local prose = vim.api.nvim_get_current_buf()
    assert(vim.wo.wrap and vim.wo.breakindent and not vim.wo.spell, "Prose should wrap without spell checking")
    vim.cmd.enew()
    vim.api.nvim_buf_set_name(0, root .. "/code")
    vim.bo.filetype = "lua"
    assert(not vim.wo.wrap, "Code inherited prose wrapping")
    local code = vim.api.nvim_get_current_buf()
    vim.api.nvim_set_current_buf(prose)
    assert(vim.wo.wrap, "Returning to prose lost wrapping")
    vim.wo.wrap = false
    vim.api.nvim_set_current_buf(code)
    vim.api.nvim_set_current_buf(prose)
    assert(not vim.wo.wrap, "Returning to prose reset the manual wrap toggle")
  end)
  vim.fn.delete(root, "rf")
  if not ok then
    io.stderr:write(tostring(err) .. "\n")
    vim.cmd.cquit()
    return
  end
  io.stdout:write("editor-options-ok: navigation preserves unsaved edits, explicit save, prose/code display\n")
  vim.cmd("qa!")
end, 2000)
