-- Run with the isolated HOME/XDG setup in nvim/maintenance.md.
vim.api.nvim_exec_autocmds("UIEnter", { modeline = false })
vim.defer_fn(function()
  local root = vim.fn.tempname() .. " search project"
  vim.fn.mkdir(root .. "/nested", "p")
  root = assert(vim.uv.fs_realpath(root))
  local ok, err = xpcall(function()
    vim.o.columns = 160
    vim.o.lines = 50
    assert(vim.system({ "git", "init", "-q", root }):wait().code == 0)
    vim.fn.writefile({ "needle root" }, root .. "/example.txt")
    vim.fn.writefile({ "needle nested" }, root .. "/nested/child.txt")
    vim.fn.writefile({ "needle hidden" }, root .. "/.hidden")
    vim.fn.writefile({ "ignored.txt" }, root .. "/.gitignore")
    vim.fn.writefile({ "needle ignored" }, root .. "/ignored.txt")
    vim.cmd.cd(vim.fn.fnameescape(root .. "/nested"))
    vim.cmd.edit(vim.fn.fnameescape(root .. "/example.txt"))

    local function keys(text)
      vim.api.nvim_feedkeys(vim.keycode(text), "xt", false)
    end
    local function picker()
      return require("telescope.actions.state").get_current_picker(vim.api.nvim_get_current_buf())
    end
    local function result_count()
      local current = picker()
      return current and current.manager and current.manager:num_results() or 0
    end
    local function wait_for(label, predicate)
      assert(vim.wait(5000, predicate, 20), "timed out: " .. label)
    end
    local function close()
      require("telescope.actions").close(picker().prompt_bufnr)
    end

    keys("<leader>ff")
    assert(picker(), "daily file search did not open Telescope")
    assert(picker().cwd == root, "file search used cwd instead of the project root")
    wait_for("project files", function()
      return result_count() == 4
    end)
    picker():set_prompt("example.txt")
    wait_for("file selection", function()
      return result_count() == 1
    end)
    require("telescope.actions").select_default(picker().prompt_bufnr)
    assert(vim.api.nvim_buf_get_name(0) == root .. "/example.txt", "selection opened the wrong file")

    keys("<leader>fF")
    assert(picker().cwd == root .. "/nested", "cwd file search escaped its directory")
    wait_for("cwd files", function()
      return result_count() == 1
    end)
    close()

    keys("<leader>sg")
    picker():set_prompt("needle")
    wait_for("live grep including hidden but excluding ignored files", function()
      return result_count() == 3
    end)
    assert(picker().cwd == root)
    close()
    keys("<leader>sR")
    assert(picker().cwd == root, "resume did not restore Telescope search")
    wait_for("resumed query", function()
      return result_count() == 3
    end)
    close()

    keys("<leader>sG")
    picker():set_prompt("needle")
    wait_for("cwd grep", function()
      return result_count() == 1
    end)
    assert(picker().cwd == root .. "/nested")
    close()
    keys("<leader>fc")
    assert(picker().cwd == vim.fn.stdpath("config"), "config search has the wrong root")
    close()
    for _, key in ipairs({ "<C-p>", "<leader><leader>" }) do
      keys(key)
      assert(picker().cwd == root, key .. " did not open project file search")
      close()
    end
    assert(vim.fn.getcwd() == root .. "/nested", "search changed the editor cwd")
    assert(require("telescope").extensions.fzf, "native sorter did not load")
    assert(vim.fn.maparg("<leader>fm", "n") ~= "", "unsaved buffer picker was lost")
    io.stdout:write("search-workflow-ok: Telescope files, live grep, roots, ignores, selection, and resume\n")
  end, debug.traceback)
  vim.fn.delete(root, "rf")
  if not ok then
    io.stderr:write(err .. "\n")
    vim.cmd("cquit 1")
  end
  vim.cmd("qa!")
end, 2000)
