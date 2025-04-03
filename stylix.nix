{ config, pkgs, ... }:
{
  stylix = {
    enable = true;
    image = Pictures/Commission_Beta.png;
    opacity = {
      terminal = 0.85;
      applications = 0.85;
    };
    polarity = "dark";
    fonts.monospace = {
      name = "Inconsolata";
      package = pkgs.inconsolata;
    };
    fonts.sizes = {
      terminal = 16;
    };
    base16Scheme = "${pkgs.base16-schemes}/share/themes/outrun-dark.yaml";
  };
}
