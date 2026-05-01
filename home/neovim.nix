{ ... }:

{
  programs.neovim = {
    enable = true;
    defaultEditor = false;
    viAlias = false;
    vimAlias = false;
    withRuby = false;
    withPython3 = false;
  };

  xdg.configFile."nvim".source = ../nvim;
}
