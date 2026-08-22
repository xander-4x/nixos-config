{host, lib, ...}: let
  inherit
    (import ../../../../hosts/${host}/variables.nix)
    extraMonitorSettings
    shellChoice
    cursorName
    cursorSize
    ;

  mkEnv = key: value: { _args = [ key value ]; };
in {
  wayland.windowManager.hyprland = {
    settings = {
      monitor = extraMonitorSettings;

      window_rule = [
        { match.class = "^([Tt]hunar|org.gnome.Nautilus|[Pp]cmanfm-qt)$"; tag = "+file-manager"; }
        { match.class = "^(Alacritty|kitty|kitty-dropterm)$"; tag = "+terminal"; }
        { match.class = "^(Brave-browser(-beta|-dev|-unstable)?)$"; tag = "+browser"; }
        { match.class = "^([Ff]irefox|org.mozilla.firefox|[Ff]irefox-esr)$"; tag = "+browser"; }
        { match.class = "^([Gg]oogle-chrome(-beta|-dev|-unstable)?)$"; tag = "+browser"; }
        { match.class = "^([Tt]horium-browser|[Cc]achy-browser)$"; tag = "+browser"; }
        { match.class = "^(codium|codium-url-handler|VSCodium)$"; tag = "+projects"; }
        { match.class = "^(VSCode|code-url-handler)$"; tag = "+projects"; }
        { match.class = "^([Dd]iscord|[Ww]ebCord|[Vv]esktop)$"; tag = "+im"; }
        { match.class = "^([Ff]erdium)$"; tag = "+im"; }
        { match.class = "^([Ww]hatsapp-for-linux)$"; tag = "+im"; }
        { match.class = "^(org.telegram.desktop|io.github.tdesktop_x64.TDesktop)$"; tag = "+im"; }
        { match.class = "^(teams-for-linux)$"; tag = "+im"; }
        { match.class = "^(gamescope)$"; tag = "+games"; }
        { match.class = "^(steam_app_\\d+)$"; tag = "+games"; }
        { match.class = "^([Ss]team)$"; tag = "+gamestore"; }
        { match.title = "^([Ll]utris)$"; tag = "+gamestore"; }
        { match.class = "^(com.heroicgameslauncher.hgl)$"; tag = "+gamestore"; }
        { match.class = "^(gnome-disks|wihotspot(-gui)?)$"; tag = "+settings"; }
        { match.class = "^([Rr]ofi)$"; tag = "+settings"; }
        { match.class = "^(file-roller|org.gnome.FileRoller)$"; tag = "+settings"; }
        { match.class = "^(nm-applet|nm-connection-editor|blueman-manager)$"; tag = "+settings"; }
        { match.class = "^(pavucontrol|org.pulseaudio.pavucontrol|com.saivert.pwvucontrol)$"; tag = "+settings"; }
        { match.class = "^(nwg-look|qt5ct|qt6ct|[Yy]ad)$"; tag = "+settings"; }
        { match.class = "(xdg-desktop-portal-gtk)"; tag = "+settings"; }
        { match.class = "(.blueman-manager-wrapped)"; tag = "+settings"; }
        { match.class = "(nwg-displays)"; tag = "+settings"; }

        { match.title = "^(Picture-in-Picture)$"; move = "72% 7%"; }
        { match.class = "^([Ff]erdium)$"; center = true; }
        { match.class = "^([Ww]aypaper)$"; float = true; }
        { match.class = "^(pavucontrol|org.pulseaudio.pavucontrol|com.saivert.pwvucontrol)$"; center = true; }
        { match.class = "^(nm-connection-editor|blueman-manager|.blueman-manager-wrapped)$"; center = true; }
        { match.class = "([Tt]hunar)"; center = true; }
        { match.title = "^(Authentication Required)$"; center = true; }
        { match.class = "^(.*)$"; idle_inhibit = "fullscreen"; }
        { match.tag = "settings"; float = true; }
        { match.class = "^(pavucontrol|org.pulseaudio.pavucontrol|com.saivert.pwvucontrol)$"; float = true; }
        { match.class = "^(nm-connection-editor|nm-applet|blueman-manager|.blueman-manager-wrapped)$"; float = true; }
        { match.class = "^([Ff]erdium)$"; float = true; }
        { match.title = "^(Picture-in-Picture)$"; float = true; }
        { match.class = "^(mpv|com.github.rafostar.Clapper)$"; float = true; }
        { match.title = "^(Authentication Required)$"; float = true; }
        { match.class = "(codium|codium-url-handler|VSCodium)"; float = true; }
        { match = { class = "(codium|codium-url-handler|VSCodium)"; title = ".*(codium|VSCodium).*"; }; tile = true; }
        { match.class = "^(com.heroicgameslauncher.hgl)$"; float = true; }
        { match = { class = "^(com.heroicgameslauncher.hgl)$"; title = "Heroic Games Launcher"; }; tile = true; }
        { match.class = "^([Ss]team)$"; float = true; }
        { match = { class = "^([Ss]team)$"; title = "^[Ss]team$"; }; tile = true; }
        { match.class = "([Tt]hunar)"; float = true; }
        { match = { class = "([Tt]hunar)"; title = ".*[Tt]hunar.*"; }; tile = true; }
        { match.initial_title = "(Add Folder to Workspace)"; float = true; }
        { match.initial_title = "(Open Files)"; float = true; }
        { match.initial_title = "(wants to save)"; float = true; }
        { match.class = "^(io.github.Qalculate.qalculate-qt)$"; float = true; }
        { match.class = "^(io.github.Qalculate.qalculate-qt)$"; size = "564 684"; }
        { match.initial_title = "(Open Files)"; size = "70% 60%"; }
        { match.initial_title = "(Add Folder to Workspace)"; size = "70% 60%"; }
        { match.tag = "settings"; size = "70% 70%"; }
        { match.class = "^(pavucontrol|org.pulseaudio.pavucontrol|com.saivert.pwvucontrol)$"; size = "75% 60%"; }
        { match.class = "^(nm-connection-editor|blueman-manager|.blueman-manager-wrapped)$"; size = "75% 60%"; }
        { match.class = "^([Ff]erdium)$"; size = "60% 70%"; }
        { match.tag = "browser"; opacity = "1.0 1.0"; }
        { match.tag = "projects"; opacity = "0.9 0.8"; }
        { match.tag = "im"; opacity = "0.94 0.86"; }
        { match.tag = "file-manager"; opacity = "0.9 0.8"; }
        { match.tag = "terminal"; opacity = "1.0 1.0"; }
        { match.tag = "settings"; opacity = "0.8 0.7"; }
        { match.class = "^(gedit|org.gnome.TextEditor|mousepad)$"; opacity = "0.8 0.7"; }
        { match.class = "^(seahorse)$"; opacity = "0.9 0.8"; } # gnome-keyring gui
        { match.title = "^(Picture-in-Picture)$"; opacity = "0.95 0.75"; }
        { match.title = "^(Picture-in-Picture)$"; pin = true; }
        { match.title = "^(Picture-in-Picture)$"; keep_aspect_ratio = true; }
        { match.tag = "games"; no_blur = true; }
        { match.tag = "games"; fullscreen = true; }
      ];

      env = [
        (mkEnv "NIXOS_OZONE_WL" "1")
        (mkEnv "NIXPKGS_ALLOW_UNFREE" "1")
        (mkEnv "XDG_CURRENT_DESKTOP" "Hyprland")
        (mkEnv "XDG_SESSION_TYPE" "wayland")
        (mkEnv "XDG_SESSION_DESKTOP" "Hyprland")
        (mkEnv "GDK_BACKEND" "wayland, x11")
        (mkEnv "CLUTTER_BACKEND" "wayland")
        # NOTE: this was "QT_QPA_PLATFORM=wayland;xcb" (using `=` instead of
        # `,`) in the old hyprlang config, which is invalid env syntax there
        # (looks like a pre-existing bug — everything after `env = ` is
        # normally split on the first comma into key/value). Fixed here.
        (mkEnv "QT_QPA_PLATFORM" "wayland;xcb")
        (mkEnv "QT_WAYLAND_DISABLE_WINDOWDECORATION" "1")
        (mkEnv "QT_AUTO_SCREEN_SCALE_FACTOR" "1")
        (mkEnv "SDL_VIDEODRIVER" "x11")
        (mkEnv "MOZ_ENABLE_WAYLAND" "1")
        (mkEnv "GDK_SCALE" "1")
        (mkEnv "QT_SCALE_FACTOR" "1")
        (mkEnv "EDITOR" "nvim")
      ] ++ lib.optionals (shellChoice == "dms") [
        (mkEnv "XCURSOR_THEME" cursorName)
        (mkEnv "XCURSOR_SIZE" (toString cursorSize))
      ];
    };
  };
}
