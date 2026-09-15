-- Run: nvim --headless -u NONE -l nvim/tests/television_quickfix.lua
vim.opt.rtp:prepend("nvim")
vim.opt.rtp:append(vim.fn.stdpath("data") .. "/lazy/nvim-bqf")
vim.o.swapfile = false
vim.o.hidden = true
vim.o.lines = 40
vim.o.columns = 120
require("bqf").setup({ func_map = { fzffilter = "" } })
local tv = require("config.television")
local root = vim.fn.tempname()
vim.fn.mkdir(root, "p")
local path = root .. "/a 'quoted' file.txt"
vim.fn.writefile({ "first", "second", "third" }, path)
vim.cmd.edit(vim.fn.fnameescape(path))
local filebuf = vim.api.nvim_get_current_buf()
local other = root .. "/other.txt"
vim.fn.writefile({ "another preview", "second", "third" }, other)
local otherbuf = vim.fn.bufadd(other)
local items = {
  { bufnr = filebuf, lnum = 1, text = "first", type = "I" },
  { bufnr = filebuf, lnum = 2, text = "match-two", type = "E", user_data = { keep = 2 } },
  { bufnr = otherbuf, lnum = 3, text = "match-three", type = "W", user_data = { keep = 3 } },
}

local function wait_for(callback, message)
  assert(vim.wait(5000, callback, 10), message)
end

local function open_list()
  vim.fn.setqflist({}, " ", { title = "original", context = { keep = true }, items = items })
  vim.cmd.copen()
  require("bqf").enable()
  return vim.api.nvim_get_current_win()
end

local function choose(input, keys, check)
  local win = tv.quickfix({ input = input })
  local terminal = vim.api.nvim_win_get_buf(win)
  local job = vim.b[terminal].terminal_job_id
  wait_for(function()
    return table.concat(vim.api.nvim_buf_get_lines(terminal, 0, -1, false), "\n"):find("match", 1, true)
  end, "picker did not render candidates")
  if check then
    check(win)
  end
  vim.api.nvim_chan_send(job, keys)
  wait_for(function()
    return not vim.api.nvim_win_is_valid(win)
  end, "picker did not close")
end

local ok, err = pcall(function()
  open_list()
  local before = vim.fn.getqflist({ all = 1 })
  choose("match-two", "\r")
  assert(vim.bo.buftype ~= "quickfix", "single selection did not jump to the file")
  assert(vim.api.nvim_win_get_cursor(0)[1] == 2, "single selection lost the line")
  assert(vim.fn.getqflist({ id = 0 }).id == before.id, "jump replaced the quickfix list")

  local qwin = open_list()
  vim.api.nvim_buf_set_lines(filebuf, 1, 2, false, { "unsaved preview" })
  choose("match-two", "\027", function(win)
    wait_for(function()
      return table
        .concat(vim.api.nvim_buf_get_lines(vim.api.nvim_win_get_buf(win), 0, -1, false), "\n")
        :find("unsaved preview", 1, true)
    end, "preview lost unsaved text")
  end)
  assert(vim.api.nvim_get_current_win() == qwin, "cancel lost the quickfix window")
  assert(vim.bo[filebuf].modified, "preview saved the edited buffer")

  choose("match", "\027", function(win)
    local job = vim.b[vim.api.nvim_win_get_buf(win)].terminal_job_id
    for _, move in ipairs({ { "\014", "another preview" }, { "\016", "unsaved preview" } }) do
      vim.api.nvim_chan_send(job, move[1])
      wait_for(function()
        return table
          .concat(vim.api.nvim_buf_get_lines(vim.api.nvim_win_get_buf(win), 0, -1, false), "\n")
          :find(move[2], 1, true)
      end, "preview did not follow revisited selection: " .. move[2])
    end
  end)

  choose("match-two", "\017") -- Ctrl-Q toggles nvim-bqf signs.
  local signs = require("bqf.qfwin.session"):get(qwin):list():sign():list()
  assert(signs[2], "selection did not toggle the quickfix sign")

  choose("match", "\t\t\r")
  local filtered = vim.fn.getqflist({ items = 1, context = 1 })
  assert(#filtered.items == 2, "multiple selection did not filter the list")
  assert(
    filtered.items[1].user_data.keep == 2 and filtered.items[2].user_data.keep == 3,
    "filter lost order or metadata"
  )
  assert(filtered.context.keep, "filter lost list context")
  vim.cmd.colder()
  assert(#vim.fn.getqflist() == 3, "filter lost list history")

  for _, key in ipairs({ "\024", "\022", "\020" }) do -- Ctrl-X, Ctrl-V, Ctrl-T.
    open_list()
    local tabs = #vim.api.nvim_list_tabpages()
    choose("match-two", key)
    assert(vim.api.nvim_win_get_cursor(0)[1] == 2, "split/tab lost the selected line")
    if key == "\020" then
      assert(#vim.api.nvim_list_tabpages() == tabs + 1, "tab action was lost")
      vim.cmd.tabclose()
    else
      local normal = vim.tbl_filter(function(win)
        return vim.fn.win_gettype(win) == ""
      end, vim.api.nvim_list_wins())
      assert(#normal >= 2, "split action was lost")
      vim.cmd.close()
    end
  end
  qwin = open_list()
  choose("match", "\003")
  assert(not vim.api.nvim_win_is_valid(qwin), "Ctrl-C did not close the quickfix window")

  local global = vim.fn.getqflist()
  local owner = vim.api.nvim_get_current_win()
  vim.fn.setloclist(owner, {}, " ", { title = "local", context = { location = true }, items = items })
  vim.cmd.lopen()
  require("bqf").enable()
  choose("match", "\t\t\r")
  local local_list = vim.fn.getloclist(owner, { items = 1, context = 1 })
  assert(#local_list.items == 2 and local_list.context.location, "location filtering lost its items or context")
  assert(vim.deep_equal(vim.fn.getqflist(), global), "location filtering changed the global list")
  vim.cmd.lolder()
  assert(#vim.fn.getloclist(owner) == 3, "location filtering lost its history")
end)
vim.fn.delete(root, "rf")
if not ok then
  error(err)
end
print("television-quickfix-ok")
