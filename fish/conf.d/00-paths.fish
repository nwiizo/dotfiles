# Base tool paths must be available before later conf.d integrations run.
if test -d /opt/homebrew
    set -gx HOMEBREW_PREFIX /opt/homebrew
    set -gx HOMEBREW_CELLAR /opt/homebrew/Cellar
    set -gx HOMEBREW_REPOSITORY /opt/homebrew
    fish_add_path --path /opt/homebrew/bin /opt/homebrew/sbin
end

fish_add_path --path "$HOME/.local/bin"
