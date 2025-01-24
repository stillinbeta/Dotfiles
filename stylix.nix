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
  };
}
