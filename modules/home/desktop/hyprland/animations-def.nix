{host, ...}: let
  inherit
    (import ../../../../hosts/${host}/variables.nix)
    ;
in {
  wayland.windowManager.hyprland.settings = {
    config.animations.enabled = true;

    curve = [
      { _args = [ "wind" { type = "bezier"; points = [ [ -1.05 0.9 ] [ 0.1 1.05 ] ]; } ]; }
      { _args = [ "winIn" { type = "bezier"; points = [ [ -1.1 1.1 ] [ 0.1 1.1 ] ]; } ]; }
      { _args = [ "winOut" { type = "bezier"; points = [ [ -1.3 -0.3 ] [ 0 1 ] ]; } ]; }
      { _args = [ "liner" { type = "bezier"; points = [ [ 0 1 ] [ 1 1 ] ]; } ]; }
    ];

    animation = [
      { leaf = "windows"; enabled = false; speed = 6; bezier = "wind"; style = "slide"; }
      { leaf = "windowsIn"; enabled = false; speed = 6; bezier = "winIn"; style = "slide"; }
      { leaf = "windowsOut"; enabled = false; speed = 5; bezier = "winOut"; style = "slide"; }
      { leaf = "windowsMove"; enabled = false; speed = 5; bezier = "wind"; style = "slide"; }
      { leaf = "border"; enabled = false; speed = 1; bezier = "liner"; }
      { leaf = "fade"; enabled = false; speed = 10; bezier = "default"; }
      { leaf = "workspaces"; enabled = false; speed = 5; bezier = "wind"; }
    ];
  };
}
