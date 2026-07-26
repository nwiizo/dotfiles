# Homebrew installs a vendor hook with the same basename. User conf.d files
# take precedence, so cache the generated integration instead of spawning
# direnv on every interactive shell startup.
if status is-interactive; and type -q direnv
    __nwiizo_cached_init direnv direnv hook fish
end
