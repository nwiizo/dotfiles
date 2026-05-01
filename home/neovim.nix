{ config, ... }:

{
  programs.neovim = {
    enable = true;
    defaultEditor = false;
    viAlias = false;
    vimAlias = false;
    withRuby = false;
    withPython3 = false;
  };

  # Live symlink — edits to nvim/ in the repo are visible immediately
  # without `home-manager switch`. Trade-off: ~/.config/nvim is no longer
  # frozen at activation time, so it depends on the repo path being intact.
  xdg.configFile."nvim".source =
    config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/ghq/github.com/nwiizo/dotfiles/nvim";
}
