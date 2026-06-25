function update_all -d "Update tools with their native managers"
    argparse h/help verbose parallel with-mas no-brew no-mise no-claude no-rust no-nvim no-mason no-fisher no-npm no-cargo no-go no-uv no-pipx no-mas no-gem -- $argv
    or return 2

    set -l usage "usage: update_all [--verbose] [--parallel] [--with-mas] [--no-brew] [--no-mise] [--no-claude] [--no-rust] [--no-nvim] [--no-mason] [--no-fisher] [--no-npm] [--no-cargo] [--no-go] [--no-uv] [--no-pipx] [--no-gem]"

    if set -q _flag_help
        echo $usage
        echo
        echo "  --no-brew    skip Homebrew update/upgrade/greedy cask upgrade"
        echo "  --no-mise    skip mise-managed tool updates"
        echo "  --no-claude  skip Claude CLI update"
        echo "  --no-rust    skip rustup update"
        echo "  --no-nvim    skip Lazy.nvim plugin sync"
        echo "  --no-mason   skip Mason tool updates"
        echo "  --no-fisher  skip Fisher plugin updates"
        echo "  --no-npm     skip npm global package updates"
        echo "  --no-cargo   skip cargo-installed binary updates"
        echo "  --no-go      skip Go-installed binary updates"
        echo "  --no-uv      skip uv tool updates"
        echo "  --no-pipx    skip pipx tool updates"
        echo "  --with-mas   include Mac App Store updates (may prompt; skipped by default)"
        echo "  --no-gem     skip RubyGems updates"
        echo "  --verbose    print each updater log when it finishes"
        echo "  --parallel   run update jobs in parallel (faster, but noisier and more failure-prone)"
        echo
        echo "Password prompts are disabled: sudo is forced to non-interactive mode."
        return 0
    end

    if test (count $argv) -gt 0
        echo "update_all: unexpected argument: $argv[1]" >&2
        echo $usage >&2
        return 2
    end

    if set -q _flag_parallel
        echo "Updating tools in parallel..."
    else
        echo "Updating tools sequentially..."
    end

    set -l failed
    set -l job_labels
    set -l job_pids
    set -l job_logs
    set -l job_statuses
    set -l log_dir (mktemp -d)
    set -l brew_cleanup 0
    set -l mason_timeout_seconds 900
    set -l nvim_timeout_seconds 900
    set -l sudo_dir "$log_dir/no-password-bin"

    mkdir -p $sudo_dir
    printf '%s\n' '#!/bin/sh' 'exec /usr/bin/sudo -n "$@"' >"$sudo_dir/sudo"
    chmod +x "$sudo_dir/sudo"
    set -lx PATH $sudo_dir $PATH
    set -lx SUDO_ASKPASS /usr/bin/false

    if not set -q _flag_parallel
        function __update_all_run_job --no-scope-shadowing --argument-names label script log status_file
            echo
            echo "== $label =="

            fish -lc $script $status_file $argv[5..-1] >$log 2>&1
            set -l code $status

            if test -s $status_file
                set code (string trim (cat $status_file))
            else
                echo $code >$status_file
            end

            if test "$code" -eq 0
                echo "ok: $label"

                if set -q _flag_verbose
                    if test -s $log
                        cat $log
                    else
                        echo "(no output)"
                    end
                end

                if test "$label" = Homebrew
                    set brew_cleanup 1
                end

                return 0
            end

            echo "failed: $label (exit $code)" >&2

            set -l error_line
            if test -s $log
                set error_line (string match -r '^Error: .+' <$log | tail -n 1)
            end

            if string match -q -r 'sudo: (no password was provided|a password is required)|sudo: .*password' -- (cat $log 2>/dev/null)
                echo "Cause: sudo password was required, but update_all runs non-interactively." >&2
                echo "Action: run `sudo -v` first, then retry update_all; or rerun the failed updater manually if you want a password prompt." >&2
            else if test -n "$error_line"
                echo "Cause: $error_line" >&2
            else
                echo "Cause: no explicit error line found in the updater log." >&2
            end

            if test -s $log
                echo "Last 40 log lines:" >&2
                tail -n 40 $log >&2
            else
                echo "(no output)" >&2
            end

            set -a failed $label
            return $code
        end

        if set -q _flag_no_brew
            echo "Homebrew skipped (--no-brew)."
        else if type -q brew
            set -l log "$log_dir/homebrew.log"
            set -l status_file "$log_dir/homebrew.status"
            set -l script '
                echo "Homebrew..."
                brew update
                and brew upgrade
                and brew upgrade --cask --greedy
                set -l code $status
                echo $code > $argv[1]
                exit $code
            '
            __update_all_run_job Homebrew $script $log $status_file
        else
            echo "Homebrew skipped (brew not found)."
        end

        if set -q _flag_no_mise
            echo "mise skipped (--no-mise)."
        else if type -q mise
            set -l log "$log_dir/mise.log"
            set -l status_file "$log_dir/mise.status"
            set -l script '
                echo "mise tools..."
                mise upgrade
                set -l code $status
                echo $code > $argv[1]
                exit $code
            '
            __update_all_run_job mise $script $log $status_file
        else
            echo "mise skipped (mise not found)."
        end

        if set -q _flag_no_claude
            echo "Claude CLI skipped (--no-claude)."
        else if type -q claude
            set -l log "$log_dir/claude.log"
            set -l status_file "$log_dir/claude.status"
            set -l script '
                echo "Claude CLI..."
                claude update
                set -l code $status
                echo $code > $argv[1]
                exit $code
            '
            __update_all_run_job "Claude CLI" $script $log $status_file
        else
            echo "Claude CLI skipped (claude not found)."
        end

        if set -q _flag_no_rust
            echo "Rust skipped (--no-rust)."
        else if type -q rustup
            set -l log "$log_dir/rust.log"
            set -l status_file "$log_dir/rust.status"
            set -l script '
                echo "Rust..."
                rustup update
                set -l code $status
                echo $code > $argv[1]
                exit $code
            '
            __update_all_run_job Rust $script $log $status_file
        else
            echo "Rust skipped (rustup not found)."
        end

        if set -q _flag_no_fisher
            echo "Fisher skipped (--no-fisher)."
        else if functions -q fisher
            set -l log "$log_dir/fisher.log"
            set -l status_file "$log_dir/fisher.status"
            set -l script '
                echo "Fisher plugins..."
                fisher update
                set -l code $status
                echo $code > $argv[1]
                exit $code
            '
            __update_all_run_job Fisher $script $log $status_file
        else
            echo "Fisher skipped (fisher not found)."
        end

        if set -q _flag_no_npm
            echo "npm skipped (--no-npm)."
        else if type -q npm
            set -l log "$log_dir/npm.log"
            set -l status_file "$log_dir/npm.status"
            set -l script '
                echo "npm global packages..."
                npm update -g
                set -l code $status
                echo $code > $argv[1]
                exit $code
            '
            __update_all_run_job npm $script $log $status_file
        else
            echo "npm skipped (npm not found)."
        end

        if set -q _flag_no_cargo
            echo "cargo-installed binaries skipped (--no-cargo)."
        else if type -q cargo-install-update
            set -l log "$log_dir/cargo.log"
            set -l status_file "$log_dir/cargo.status"
            set -l script '
                echo "cargo-installed binaries..."
                cargo install-update -a
                set -l code $status
                echo $code > $argv[1]
                exit $code
            '
            __update_all_run_job "cargo-installed binaries" $script $log $status_file
        else
            echo "cargo-installed binaries skipped (cargo-install-update not found)."
        end

        if set -q _flag_no_go
            echo "Go-installed binaries skipped (--no-go)."
        else if type -q go
            set -l log "$log_dir/go.log"
            set -l status_file "$log_dir/go.status"
            set -l script '
                echo "Go-installed binaries..."
                set -l go_bin (go env GOBIN)
                if test -z "$go_bin"
                    set go_bin (go env GOPATH)/bin
                end

                if not test -d "$go_bin"
                    echo "Go-installed binaries skipped (GOBIN/GOPATH bin not found)."
                    true
                else
                    set -l failed
                    for binary in (find "$go_bin" -maxdepth 1 -type f -perm -111 2>/dev/null)
                        set -l package (go version -m "$binary" 2>/dev/null | awk '\''$1 == "path" { print $2; exit }'\'')
                        if test -z "$package"
                            continue
                        end

                        echo "go install $package@latest"
                        go install $package"@latest"
                        or set -a failed (basename "$binary")
                    end

                    if set -q failed[1]
                        echo "Failed Go binaries: "(string join ", " $failed) >&2
                        false
                    else
                        true
                    end
                end

                set -l code $status
                echo $code > $argv[1]
                exit $code
            '
            __update_all_run_job "Go-installed binaries" $script $log $status_file
        else
            echo "Go-installed binaries skipped (go not found)."
        end

        if set -q _flag_no_uv
            echo "uv tools skipped (--no-uv)."
        else if type -q uv
            set -l log "$log_dir/uv.log"
            set -l status_file "$log_dir/uv.status"
            set -l script '
                echo "uv tools..."
                uv tool upgrade --all
                set -l code $status
                echo $code > $argv[1]
                exit $code
            '
            __update_all_run_job "uv tools" $script $log $status_file
        else
            echo "uv tools skipped (uv not found)."
        end

        if set -q _flag_no_pipx
            echo "pipx tools skipped (--no-pipx)."
        else if type -q pipx
            set -l log "$log_dir/pipx.log"
            set -l status_file "$log_dir/pipx.status"
            set -l script '
                echo "pipx tools..."
                pipx upgrade-all
                set -l code $status
                echo $code > $argv[1]
                exit $code
            '
            __update_all_run_job "pipx tools" $script $log $status_file
        else
            echo "pipx tools skipped (pipx not found)."
        end

        if set -q _flag_no_mas
            echo "Mac App Store skipped (--no-mas)."
        else if not set -q _flag_with_mas
            echo "Mac App Store skipped by default (use --with-mas; it may prompt)."
        else if type -q mas
            set -l log "$log_dir/mas.log"
            set -l status_file "$log_dir/mas.status"
            set -l script '
                echo "Mac App Store..."
                mas upgrade
                set -l code $status
                echo $code > $argv[1]
                exit $code
            '
            __update_all_run_job "Mac App Store" $script $log $status_file
        else
            echo "Mac App Store skipped (mas not found)."
        end

        if set -q _flag_no_gem
            echo "RubyGems skipped (--no-gem)."
        else if type -q gem
            set -l gem_path (command -v gem)
            if test "$gem_path" = /usr/bin/gem
                echo "RubyGems skipped (system gem at /usr/bin/gem)."
            else
                set -l log "$log_dir/gem.log"
                set -l status_file "$log_dir/gem.status"
                set -l script '
                    echo "RubyGems..."
                    gem update --system
                    and gem update
                    set -l code $status
                    echo $code > $argv[1]
                    exit $code
                '
                __update_all_run_job RubyGems $script $log $status_file
            end
        else
            echo "RubyGems skipped (gem not found)."
        end

        if set -q _flag_no_mason
            echo "Mason tools skipped (--no-mason)."
        else if type -q nvim
            set -l mason_lua "$log_dir/mason-update.lua"
            printf '%s\n' \
                'local ok_lazy, lazy = pcall(require, "lazy")' \
                'if ok_lazy then lazy.load({ plugins = { "mason.nvim" } }) end' \
                'local ok_reg, registry = pcall(require, "mason-registry")' \
                'if not ok_reg then' \
                '  print("Failed to load mason registry: " .. tostring(registry))' \
                '  vim.cmd("cquit")' \
                '  return' \
                'end' \
                'local done = false' \
                'local uv = vim.uv or vim.loop' \
                'local timer = uv.new_timer()' \
                'local function finish(ok)' \
                '  if done then return end' \
                '  done = true' \
                '  if timer then timer:stop(); timer:close() end' \
                '  vim.schedule(function() vim.cmd(ok and "qa" or "cquit") end)' \
                'end' \
                'timer:start(900000, 0, vim.schedule_wrap(function()' \
                '  print("Mason tools timed out after 900s.")' \
                '  finish(false)' \
                'end))' \
                'registry.refresh(function(success, result)' \
                '  if not success then' \
                '    print("Failed to refresh Mason registry: " .. vim.inspect(result))' \
                '    finish(false)' \
                '    return' \
                '  end' \
                '  local pending = 0' \
                '  local failed = {}' \
                '  for _, pkg in ipairs(registry.get_installed_packages()) do' \
                '    local current = pkg:get_installed_version()' \
                '    local latest = pkg:get_latest_version()' \
                '    if latest and current ~= latest and pkg:is_installable({ version = latest }) then' \
                '      pending = pending + 1' \
                '      print(("Updating %s %s -> %s"):format(pkg.name, tostring(current), tostring(latest)))' \
                '      pkg:install({ force = true }, function(success, result)' \
                '        if not success then' \
                '          table.insert(failed, pkg.name)' \
                '          print(("Failed %s: %s"):format(pkg.name, tostring(result)))' \
                '        end' \
                '        pending = pending - 1' \
                '        if pending == 0 then' \
                '          finish(#failed == 0)' \
                '        end' \
                '      end)' \
                '    end' \
                '  end' \
                '  if pending == 0 then' \
                '    print("Mason tools are up to date.")' \
                '    finish(true)' \
                '  end' \
                'end)' >$mason_lua

            set -l log "$log_dir/mason.log"
            set -l status_file "$log_dir/mason.status"
            set -l script '
                echo "Mason tools..."
                nvim --headless -c "luafile $argv[2]"
                set -l code $status
                echo $code > $argv[1]
                exit $code
            '
            __update_all_run_job "Mason tools" $script $log $status_file $mason_lua
        else
            echo "Mason tools skipped (nvim not found)."
        end

        if set -q _flag_no_nvim
            echo "Neovim plugins skipped (--no-nvim)."
        else if type -q nvim
            set -l log "$log_dir/nvim.log"
            set -l status_file "$log_dir/nvim.status"
            set -l script '
                echo "Neovim plugins..."
                nvim --headless "+Lazy! sync" +qa
                set -l code $status
                echo $code > $argv[1]
                exit $code
            '
            __update_all_run_job "Neovim plugins" $script $log $status_file
        else
            echo "Neovim plugins skipped (nvim not found)."
        end

        if test $brew_cleanup -eq 1
            echo
            echo "== Homebrew cleanup =="
            brew cleanup
            or set -a failed "Homebrew cleanup"
        end

        if set -q failed[1]
            echo "Done with errors: "(string join ", " $failed)" failed." >&2
            echo "Logs kept at $log_dir" >&2
            functions -e __update_all_run_job
            return 1
        end

        rm -rf $log_dir
        functions -e __update_all_run_job
        echo "Done!"
        return 0
    end

    if set -q _flag_no_brew
        echo "Homebrew skipped (--no-brew)."
    else if type -q brew
        set -l log "$log_dir/homebrew.log"
        set -l status_file "$log_dir/homebrew.status"
        fish -lc '
            echo "Homebrew..."
            brew update
            and brew upgrade
            and brew upgrade --cask --greedy
            set -l code $status
            echo $code > $argv[1]
            exit $code
        ' $status_file >$log 2>&1 &
        set -a job_labels Homebrew
        set -a job_pids $last_pid
        set -a job_logs $log
        set -a job_statuses $status_file
        echo "Homebrew started."
    else
        echo "Homebrew skipped (brew not found)."
    end

    if set -q _flag_no_mise
        echo "mise skipped (--no-mise)."
    else if type -q mise
        set -l log "$log_dir/mise.log"
        set -l status_file "$log_dir/mise.status"
        fish -lc '
            echo "mise tools..."
            mise upgrade
            set -l code $status
            echo $code > $argv[1]
            exit $code
        ' $status_file >$log 2>&1 &
        set -a job_labels mise
        set -a job_pids $last_pid
        set -a job_logs $log
        set -a job_statuses $status_file
        echo "mise started."
    else
        echo "mise skipped (mise not found)."
    end

    if set -q _flag_no_claude
        echo "Claude CLI skipped (--no-claude)."
    else if type -q claude
        set -l log "$log_dir/claude.log"
        set -l status_file "$log_dir/claude.status"
        fish -lc '
            echo "Claude CLI..."
            claude update
            set -l code $status
            echo $code > $argv[1]
            exit $code
        ' $status_file >$log 2>&1 &
        set -a job_labels "Claude CLI"
        set -a job_pids $last_pid
        set -a job_logs $log
        set -a job_statuses $status_file
        echo "Claude CLI started."
    else
        echo "Claude CLI skipped (claude not found)."
    end

    if set -q _flag_no_rust
        echo "Rust skipped (--no-rust)."
    else if type -q rustup
        set -l log "$log_dir/rust.log"
        set -l status_file "$log_dir/rust.status"
        fish -lc '
            echo "Rust..."
            rustup update
            set -l code $status
            echo $code > $argv[1]
            exit $code
        ' $status_file >$log 2>&1 &
        set -a job_labels Rust
        set -a job_pids $last_pid
        set -a job_logs $log
        set -a job_statuses $status_file
        echo "Rust started."
    else
        echo "Rust skipped (rustup not found)."
    end

    if set -q _flag_no_fisher
        echo "Fisher skipped (--no-fisher)."
    else if functions -q fisher
        set -l log "$log_dir/fisher.log"
        set -l status_file "$log_dir/fisher.status"
        fish -lc '
            echo "Fisher plugins..."
            fisher update
            set -l code $status
            echo $code > $argv[1]
            exit $code
        ' $status_file >$log 2>&1 &
        set -a job_labels Fisher
        set -a job_pids $last_pid
        set -a job_logs $log
        set -a job_statuses $status_file
        echo "Fisher started."
    else
        echo "Fisher skipped (fisher not found)."
    end

    if set -q _flag_no_npm
        echo "npm skipped (--no-npm)."
    else if type -q npm
        set -l log "$log_dir/npm.log"
        set -l status_file "$log_dir/npm.status"
        fish -lc '
            echo "npm global packages..."
            npm update -g
            set -l code $status
            echo $code > $argv[1]
            exit $code
        ' $status_file >$log 2>&1 &
        set -a job_labels npm
        set -a job_pids $last_pid
        set -a job_logs $log
        set -a job_statuses $status_file
        echo "npm started."
    else
        echo "npm skipped (npm not found)."
    end

    if set -q _flag_no_cargo
        echo "cargo-installed binaries skipped (--no-cargo)."
    else if type -q cargo-install-update
        set -l log "$log_dir/cargo.log"
        set -l status_file "$log_dir/cargo.status"
        fish -lc '
            echo "cargo-installed binaries..."
            cargo install-update -a
            set -l code $status
            echo $code > $argv[1]
            exit $code
        ' $status_file >$log 2>&1 &
        set -a job_labels "cargo-installed binaries"
        set -a job_pids $last_pid
        set -a job_logs $log
        set -a job_statuses $status_file
        echo "cargo-installed binaries started."
    else
        echo "cargo-installed binaries skipped (cargo-install-update not found)."
    end

    if set -q _flag_no_go
        echo "Go-installed binaries skipped (--no-go)."
    else if type -q go
        set -l log "$log_dir/go.log"
        set -l status_file "$log_dir/go.status"
        fish -lc '
            echo "Go-installed binaries..."
            set -l go_bin (go env GOBIN)
            if test -z "$go_bin"
                set go_bin (go env GOPATH)/bin
            end

            if not test -d "$go_bin"
                echo "Go-installed binaries skipped (GOBIN/GOPATH bin not found)."
                true
            else
                set -l failed
                for binary in (find "$go_bin" -maxdepth 1 -type f -perm -111 2>/dev/null)
                    set -l package (go version -m "$binary" 2>/dev/null | awk '\''$1 == "path" { print $2; exit }'\'')
                    if test -z "$package"
                        continue
                    end

                    echo "go install $package@latest"
                    go install $package"@latest"
                    or set -a failed (basename "$binary")
                end

                if set -q failed[1]
                    echo "Failed Go binaries: "(string join ", " $failed) >&2
                    false
                else
                    true
                end
            end

            set -l code $status
            echo $code > $argv[1]
            exit $code
        ' $status_file >$log 2>&1 &
        set -a job_labels "Go-installed binaries"
        set -a job_pids $last_pid
        set -a job_logs $log
        set -a job_statuses $status_file
        echo "Go-installed binaries started."
    else
        echo "Go-installed binaries skipped (go not found)."
    end

    if set -q _flag_no_uv
        echo "uv tools skipped (--no-uv)."
    else if type -q uv
        set -l log "$log_dir/uv.log"
        set -l status_file "$log_dir/uv.status"
        fish -lc '
            echo "uv tools..."
            uv tool upgrade --all
            set -l code $status
            echo $code > $argv[1]
            exit $code
        ' $status_file >$log 2>&1 &
        set -a job_labels "uv tools"
        set -a job_pids $last_pid
        set -a job_logs $log
        set -a job_statuses $status_file
        echo "uv tools started."
    else
        echo "uv tools skipped (uv not found)."
    end

    if set -q _flag_no_pipx
        echo "pipx tools skipped (--no-pipx)."
    else if type -q pipx
        set -l log "$log_dir/pipx.log"
        set -l status_file "$log_dir/pipx.status"
        fish -lc '
            echo "pipx tools..."
            pipx upgrade-all
            set -l code $status
            echo $code > $argv[1]
            exit $code
        ' $status_file >$log 2>&1 &
        set -a job_labels "pipx tools"
        set -a job_pids $last_pid
        set -a job_logs $log
        set -a job_statuses $status_file
        echo "pipx tools started."
    else
        echo "pipx tools skipped (pipx not found)."
    end

    if set -q _flag_no_mas
        echo "Mac App Store skipped (--no-mas)."
    else if not set -q _flag_with_mas
        echo "Mac App Store skipped by default (use --with-mas; it may prompt)."
    else if type -q mas
        set -l log "$log_dir/mas.log"
        set -l status_file "$log_dir/mas.status"
        fish -lc '
            echo "Mac App Store..."
            mas upgrade
            set -l code $status
            echo $code > $argv[1]
            exit $code
        ' $status_file >$log 2>&1 &
        set -a job_labels "Mac App Store"
        set -a job_pids $last_pid
        set -a job_logs $log
        set -a job_statuses $status_file
        echo "Mac App Store started."
    else
        echo "Mac App Store skipped (mas not found)."
    end

    if set -q _flag_no_gem
        echo "RubyGems skipped (--no-gem)."
    else if type -q gem
        set -l gem_path (command -v gem)
        if test "$gem_path" = /usr/bin/gem
            echo "RubyGems skipped (system gem at /usr/bin/gem)."
        else
            set -l log "$log_dir/gem.log"
            set -l status_file "$log_dir/gem.status"
            fish -lc '
                echo "RubyGems..."
                gem update --system
                and gem update
                set -l code $status
                echo $code > $argv[1]
                exit $code
            ' $status_file >$log 2>&1 &
            set -a job_labels RubyGems
            set -a job_pids $last_pid
            set -a job_logs $log
            set -a job_statuses $status_file
            echo "RubyGems started."
        end
    else
        echo "RubyGems skipped (gem not found)."
    end

    if set -q _flag_no_mason
        echo "Mason tools skipped (--no-mason)."
    else if type -q nvim
        set -l mason_lua "$log_dir/mason-update.lua"
        printf '%s\n' \
            'local ok_lazy, lazy = pcall(require, "lazy")' \
            'if ok_lazy then lazy.load({ plugins = { "mason.nvim" } }) end' \
            'local ok_reg, registry = pcall(require, "mason-registry")' \
            'if not ok_reg then' \
            '  print("Failed to load mason registry: " .. tostring(registry))' \
            '  vim.cmd("cquit")' \
            '  return' \
            'end' \
            'local done = false' \
            'local uv = vim.uv or vim.loop' \
            'local timer = uv.new_timer()' \
            'local function finish(ok)' \
            '  if done then return end' \
            '  done = true' \
            '  if timer then timer:stop(); timer:close() end' \
            '  vim.schedule(function() vim.cmd(ok and "qa" or "cquit") end)' \
            'end' \
            'timer:start(900000, 0, vim.schedule_wrap(function()' \
            '  print("Mason tools timed out after 900s.")' \
            '  finish(false)' \
            'end))' \
            'registry.refresh(function(success, result)' \
            '  if not success then' \
            '    print("Failed to refresh Mason registry: " .. vim.inspect(result))' \
            '    finish(false)' \
            '    return' \
            '  end' \
            '  local pending = 0' \
            '  local failed = {}' \
            '  for _, pkg in ipairs(registry.get_installed_packages()) do' \
            '    local current = pkg:get_installed_version()' \
            '    local latest = pkg:get_latest_version()' \
            '    if latest and current ~= latest and pkg:is_installable({ version = latest }) then' \
            '      pending = pending + 1' \
            '      print(("Updating %s %s -> %s"):format(pkg.name, tostring(current), tostring(latest)))' \
            '      pkg:install({ force = true }, function(success, result)' \
            '        if not success then' \
            '          table.insert(failed, pkg.name)' \
            '          print(("Failed %s: %s"):format(pkg.name, tostring(result)))' \
            '        end' \
            '        pending = pending - 1' \
            '        if pending == 0 then' \
            '          finish(#failed == 0)' \
            '        end' \
            '      end)' \
            '    end' \
            '  end' \
            '  if pending == 0 then' \
            '    print("Mason tools are up to date.")' \
            '    finish(true)' \
            '  end' \
            'end)' >$mason_lua

        set -l log "$log_dir/mason.log"
        set -l status_file "$log_dir/mason.status"
        fish -lc '
            echo "Mason tools..."
            nvim --headless -c "luafile $argv[2]"
            set -l code $status
            echo $code > $argv[1]
            exit $code
        ' $status_file $mason_lua >$log 2>&1 &
        set -a job_labels "Mason tools"
        set -a job_pids $last_pid
        set -a job_logs $log
        set -a job_statuses $status_file
        echo "Mason tools started."
    else
        echo "Mason tools skipped (nvim not found)."
    end

    if set -q _flag_no_nvim
        echo "Neovim plugins skipped (--no-nvim)."
    else if type -q nvim
        set -l log "$log_dir/nvim.log"
        set -l status_file "$log_dir/nvim.status"
        fish -lc '
            echo "Neovim plugins..."
            nvim --headless "+Lazy! sync" +qa
            set -l code $status
            echo $code > $argv[1]
            exit $code
        ' $status_file >$log 2>&1 &
        set -a job_labels "Neovim plugins"
        set -a job_pids $last_pid
        set -a job_logs $log
        set -a job_statuses $status_file
        echo "Neovim plugins started."
    else
        echo "Neovim plugins skipped (nvim not found)."
    end

    set -l completed_count 0
    set -l total_jobs (count $job_pids)

    if test $total_jobs -gt 0
        echo
        echo "Started $total_jobs update jobs. Progress updates every 30 seconds; logs are printed on failure or with --verbose."

        set -l running (seq $total_jobs)
        set -l started_at (date +%s)
        set -l last_tick (date +%s)
        set -l progress_interval 30

        while test (count $running) -gt 0
            set -l still_running

            for i in $running
                set -l label $job_labels[$i]
                set -l pid $job_pids[$i]
                set -l log $job_logs[$i]
                set -l status_file $job_statuses[$i]
                set -l timeout 0
                set -l timed_out 0

                switch $label
                    case "Mason tools"
                        set timeout $mason_timeout_seconds
                    case "Neovim plugins"
                        set timeout $nvim_timeout_seconds
                end

                set -l now (date +%s)
                if test $timeout -gt 0
                    set -l job_elapsed (math $now - $started_at)
                    if test $job_elapsed -ge $timeout; and kill -0 $pid 2>/dev/null
                        echo "$label timed out after "$timeout"s." >>$log

                        for child in (pgrep -P $pid 2>/dev/null)
                            kill -TERM $child 2>/dev/null
                        end
                        kill -TERM $pid 2>/dev/null
                        sleep 2
                        for child in (pgrep -P $pid 2>/dev/null)
                            kill -KILL $child 2>/dev/null
                        end
                        kill -KILL $pid 2>/dev/null

                        set timed_out 1
                    end
                end

                if test $timed_out -eq 0; and kill -0 $pid 2>/dev/null
                    set -a still_running $i
                    continue
                end

                wait $pid 2>/dev/null
                set completed_count (math $completed_count + 1)

                set -l code 1
                if test $timed_out -eq 1
                    set code 124
                    echo 124 >$status_file
                else if test -s $status_file
                    set code (string trim (cat $status_file))
                end

                if test $code -eq 0
                    echo "[$completed_count/$total_jobs] ok: $label"

                    if set -q _flag_verbose
                        echo
                        echo "== $label =="
                        if test -s $log
                            cat $log
                        else
                            echo "(no output)"
                        end
                    end

                    if test "$label" = Homebrew
                        set brew_cleanup 1
                    end

                    continue
                end

                echo "[$completed_count/$total_jobs] failed: $label (exit $code)" >&2

                set -l error_line
                if test -s $log
                    set error_line (string match -r '^Error: .+' <$log | tail -n 1)
                end

                if test "$code" -eq 124
                    echo "Cause: $label timed out after "$timeout"s." >&2
                else if string match -q -r 'sudo: (no password was provided|a password is required)|sudo: .*password' -- (cat $log 2>/dev/null)
                    echo "Cause: sudo password was required, but update_all runs non-interactively." >&2
                    echo "Action: run `sudo -v` first, then retry update_all; or rerun the failed updater manually if you want a password prompt." >&2
                else if test -n "$error_line"
                    echo "Cause: $error_line" >&2
                else
                    echo "Cause: no explicit error line found in the updater log." >&2
                end

                if test -s $log
                    echo "Last 40 log lines:" >&2
                    tail -n 40 $log >&2
                else
                    echo "(no output)" >&2
                end
                set -a failed $label
            end

            set running $still_running

            if test (count $running) -gt 0
                set -l now (date +%s)
                if test (math $now - $last_tick) -ge $progress_interval
                    set -l elapsed (math $now - $started_at)
                    set -l running_labels

                    for i in $running
                        set -a running_labels $job_labels[$i]
                    end

                    echo
                    echo "[$completed_count/$total_jobs] still running after "$elapsed"s: "(string join ", " $running_labels)

                    set last_tick $now
                end
                sleep 1
            end
        end
    end

    if test $brew_cleanup -eq 1
        echo
        echo "== Homebrew cleanup =="
        brew cleanup
        or set -a failed "Homebrew cleanup"
    end

    if set -q failed[1]
        echo "Done with errors: "(string join ", " $failed)" failed." >&2
        echo "Logs kept at $log_dir" >&2
        return 1
    end

    rm -rf $log_dir

    echo "Done!"
end
