-- Run from the repository root: nvim --headless -u NONE -l nvim/tests/external_changes.lua
vim.o.swapfile = false
vim.o.autoread = true
dofile("nvim/lua/config/autocmds.lua")

local root = vim.fn.tempname()
vim.fn.mkdir(root, "p")
local messages = {}
vim.notify = function(message)
  messages[#messages + 1] = message
end

local function equal(actual, expected)
  assert(vim.deep_equal(actual, expected), "expected " .. vim.inspect(expected) .. ", got " .. vim.inspect(actual))
end

local function open_file(name, lines, no_eol)
  local path = root .. "/" .. name
  assert(vim.fn.writefile(lines, path, no_eol and "b" or "") == 0)
  vim.cmd.edit(vim.fn.fnameescape(path))
  messages = {}
  return path
end

local function external_write(path, lines, no_eol)
  assert(vim.fn.writefile(lines, path, no_eol and "b" or "") == 0)
  vim.cmd.checktime()
  assert(
    vim.wait(2000, function()
      return #messages > 0
    end),
    "external change was not handled"
  )
end

local ok, err = pcall(function()
  local base = { "first", "two", "three", "four", "five", "six", "seven", "eight", "last", "" }
  local path = open_file("blank-line.txt", base)
  vim.api.nvim_buf_set_lines(0, 0, 1, false, { "local first" })
  local local_lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
  local external = vim.deepcopy(base)
  external[9] = "external last"
  external_write(path, external)
  local expected = vim.deepcopy(external)
  expected[1] = "local first"
  equal(vim.api.nvim_buf_get_lines(0, 0, -1, false), expected)
  equal(vim.fn.readfile(path), external)
  assert(vim.bo.modified, "merged buffer should remain unsaved")
  vim.cmd.undo()
  equal(vim.api.nvim_buf_get_lines(0, 0, -1, false), local_lines)
  vim.cmd("bwipeout!")

  path = open_file("conflict.txt", { "original" })
  vim.api.nvim_buf_set_lines(0, 0, -1, false, { "local version" })
  external_write(path, { "external version" })
  local merged = table.concat(vim.api.nvim_buf_get_lines(0, 0, -1, false), "\n")
  for _, value in ipairs({ "<<<<<<<", "local version", "original", "external version", ">>>>>>>" }) do
    assert(merged:find(value, 1, true), "conflict lost " .. value)
  end
  equal(vim.fn.readfile(path), { "external version" })
  vim.cmd("bwipeout!")

  table.remove(base)
  table.remove(external)
  path = open_file("no-final-newline.txt", base, true)
  vim.api.nvim_buf_set_lines(0, 0, 1, false, { "local first" })
  external_write(path, external, true)
  equal(
    vim.api.nvim_buf_get_lines(0, 0, -1, false),
    { "local first", "two", "three", "four", "five", "six", "seven", "eight", "external last" }
  )
  assert(not vim.bo.endofline, "merge should preserve the missing final newline")
  vim.cmd("bwipeout!")
end)

vim.fn.delete(root, "rf")
if not ok then
  error(err)
end
print("external-changes-ok")
