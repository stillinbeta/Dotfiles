{ config, pkgs, ... }:
{
  stylix = {
    enable = true;
    image = Pictures/Commission_Beta.png;
    polarity = "dark";
    fonts.monospace = {
      name = "Inconsolata";
      package = pkgs.inconsolata;
    };
    base16Scheme = "${pkgs.base16-schemes}/share/themes/outrun-dark.yaml";
  };
}
