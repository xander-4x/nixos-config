{
  host,
  lib,
  ...
}:
let
  inherit (import ../../../../hosts/${host}/variables.nix)
    browserExec
    terminal
    shellChoice
    ;

  # Shell-specific keybindings
  # DMS IPC: use qs with path derived from dms binary location
  dmsIpc = "qs ipc -p $(dirname $(dirname $(readlink -f $(which dms))))/share/quickshell/dms call";
  launcherCmd = if shellChoice == "dms" then "${dmsIpc} spotlight toggle" else "rofi-launcher";
  notifCmd = if shellChoice == "dms" then "${dmsIpc} notifications toggle" else "swaync-client -rs";
  lockCmd = if shellChoice == "dms" then "${dmsIpc} lock lock" else "hyprlock";

  modifier = "SUPER";

  # key: plain Nix string, e.g. "SUPER + SHIFT + T" (no leading "+" when unmodified)
  # dispatcherLua: raw Lua source for the dispatcher call, e.g. `hl.dsp.exec_cmd("foo")`
  mkBind = key: dispatcherLua: {
    _args = [
      key
      (lib.generators.mkLuaInline dispatcherLua)
    ];
  };
  mkBindOpt = key: dispatcherLua: opts: {
    _args = [
      key
      (lib.generators.mkLuaInline dispatcherLua)
      opts
    ];
  };

  exec = cmd: ''hl.dsp.exec_cmd("${cmd}")'';
in
{
  wayland.windowManager.hyprland.settings = {
    bind = [
      (mkBind "${modifier} + T" (exec terminal))
      (mkBind "${modifier} + K" (exec "list-keybinds"))
      (mkBind "${modifier} + Return" (exec launcherCmd))
      (mkBind "${modifier} + SHIFT + W" (exec "web-search"))
      (mkBind "${modifier} + ALT + W" (exec "wallsetter"))
      (mkBind "${modifier} + SHIFT + N" (exec notifCmd))
      (mkBind "${modifier} + W" (exec browserExec))
      (mkBind "${modifier} + E" (exec "thunar"))
      (mkBind "${modifier} + SHIFT + S" (exec "screenshootin"))
      (mkBind "${modifier} + C" (exec "hyprpicker -a"))
      (mkBind "${modifier} + SHIFT + T" (exec "pypr toggle term"))
      (mkBind "${modifier} + M" (exec "/run/current-system/sw/bin/pwvucontrol"))
      (mkBind "${modifier} + Q" ''hl.dsp.window.close()'')
      (mkBind "${modifier} + P" ''hl.dsp.window.pseudo()'')
      (mkBind "${modifier} + SHIFT + I" ''hl.dsp.layout("togglesplit")'')
      # hl.dsp.window.fullscreen only accepts "fullscreen"/"maximized"
      # (verified via `Hyprland --verify-config`), not the old numeric 2/1.
      (mkBind "${modifier} + F" ''hl.dsp.window.fullscreen({ mode = "fullscreen" })'')
      (mkBind "${modifier} + R" ''hl.dsp.window.fullscreen({ mode = "maximized" })'')
      (mkBind "${modifier} + SHIFT + F" ''hl.dsp.window.float({ action = "toggle" })'')
      # NOTE: no direct hl.dsp.* equivalent found for old `workspaceopt
      # allfloat` anywhere in the Lua API surface (stub or examples) — falls
      # back to a raw hyprctl IPC dispatch, which is unaffected by config format.
      (mkBind "${modifier} + ALT + F" (exec "hyprctl dispatch workspaceopt allfloat"))
      (mkBind "${modifier} + SHIFT + C" ''hl.dsp.exit()'')

      (mkBind "${modifier} + SHIFT + left" ''hl.dsp.window.move({ direction = "left" })'')
      (mkBind "${modifier} + SHIFT + right" ''hl.dsp.window.move({ direction = "right" })'')
      (mkBind "${modifier} + SHIFT + up" ''hl.dsp.window.move({ direction = "up" })'')
      (mkBind "${modifier} + SHIFT + down" ''hl.dsp.window.move({ direction = "down" })'')
      (mkBind "${modifier} + SHIFT + h" ''hl.dsp.window.move({ direction = "left" })'')
      (mkBind "${modifier} + SHIFT + l" ''hl.dsp.window.move({ direction = "right" })'')
      (mkBind "${modifier} + SHIFT + k" ''hl.dsp.window.move({ direction = "up" })'')
      (mkBind "${modifier} + SHIFT + j" ''hl.dsp.window.move({ direction = "down" })'')

      # NOTE: hl.dsp.window.swap exists in the stub but wasn't in any example
      # we could confirm against — verify direction semantics after switching.
      (mkBind "${modifier} + ALT + left" ''hl.dsp.window.swap({ direction = "left" })'')
      (mkBind "${modifier} + ALT + right" ''hl.dsp.window.swap({ direction = "right" })'')
      (mkBind "${modifier} + ALT + up" ''hl.dsp.window.swap({ direction = "up" })'')
      (mkBind "${modifier} + ALT + down" ''hl.dsp.window.swap({ direction = "down" })'')
      # Numpad/alternate keycodes duplicating the swapwindow arrow binds above.
      # Bare numbers aren't a valid keysym under the Lua bind parser (unlike
      # hyprlang's more lenient parsing) — need an explicit "code:" prefix
      # (verified via `Hyprland --verify-config`).
      (mkBind "${modifier} + ALT + code:43" ''hl.dsp.window.swap({ direction = "left" })'')
      (mkBind "${modifier} + ALT + code:46" ''hl.dsp.window.swap({ direction = "right" })'')
      (mkBind "${modifier} + ALT + code:45" ''hl.dsp.window.swap({ direction = "up" })'')
      (mkBind "${modifier} + ALT + code:44" ''hl.dsp.window.swap({ direction = "down" })'')

      (mkBind "${modifier} + left" ''hl.dsp.focus({ direction = "left" })'')
      (mkBind "${modifier} + right" ''hl.dsp.focus({ direction = "right" })'')
      (mkBind "${modifier} + up" ''hl.dsp.focus({ direction = "up" })'')
      (mkBind "${modifier} + down" ''hl.dsp.focus({ direction = "down" })'')
      (mkBind "${modifier} + h" ''hl.dsp.focus({ direction = "left" })'')
      (mkBind "${modifier} + l" ''hl.dsp.focus({ direction = "right" })'')
      (mkBind "${modifier} + k" ''hl.dsp.focus({ direction = "up" })'')
      (mkBind "${modifier} + j" ''hl.dsp.focus({ direction = "down" })'')

      (mkBind "${modifier} + 1" ''hl.dsp.focus({ workspace = 1 })'')
      (mkBind "${modifier} + 2" ''hl.dsp.focus({ workspace = 2 })'')
      (mkBind "${modifier} + 3" ''hl.dsp.focus({ workspace = 3 })'')
      (mkBind "${modifier} + 4" ''hl.dsp.focus({ workspace = 4 })'')
      (mkBind "${modifier} + 5" ''hl.dsp.focus({ workspace = 5 })'')
      (mkBind "${modifier} + 6" ''hl.dsp.focus({ workspace = 6 })'')
      (mkBind "${modifier} + 7" ''hl.dsp.focus({ workspace = 7 })'')
      (mkBind "${modifier} + 8" ''hl.dsp.focus({ workspace = 8 })'')
      (mkBind "${modifier} + 9" ''hl.dsp.focus({ workspace = 9 })'')
      (mkBind "${modifier} + 0" ''hl.dsp.focus({ workspace = 10 })'')

      # NOTE: old config had one unnamed special workspace; giving it a
      # consistent name "special" since Lua's toggle_special/window.move
      # both need one (official example uses a named scratchpad the same way).
      (mkBind "${modifier} + SHIFT + SPACE" ''hl.dsp.window.move({ workspace = "special:special" })'')
      (mkBind "${modifier} + SPACE" ''hl.dsp.workspace.toggle_special("special")'')

      (mkBind "${modifier} + SHIFT + 1" ''hl.dsp.window.move({ workspace = 1 })'')
      (mkBind "${modifier} + SHIFT + 2" ''hl.dsp.window.move({ workspace = 2 })'')
      (mkBind "${modifier} + SHIFT + 3" ''hl.dsp.window.move({ workspace = 3 })'')
      (mkBind "${modifier} + SHIFT + 4" ''hl.dsp.window.move({ workspace = 4 })'')
      (mkBind "${modifier} + SHIFT + 5" ''hl.dsp.window.move({ workspace = 5 })'')
      (mkBind "${modifier} + SHIFT + 6" ''hl.dsp.window.move({ workspace = 6 })'')
      (mkBind "${modifier} + SHIFT + 7" ''hl.dsp.window.move({ workspace = 7 })'')
      (mkBind "${modifier} + SHIFT + 8" ''hl.dsp.window.move({ workspace = 8 })'')
      (mkBind "${modifier} + SHIFT + 9" ''hl.dsp.window.move({ workspace = 9 })'')
      (mkBind "${modifier} + SHIFT + 0" ''hl.dsp.window.move({ workspace = 10 })'')

      (mkBind "${modifier} + CONTROL + right" ''hl.dsp.focus({ workspace = "e+1" })'')
      (mkBind "${modifier} + CONTROL + left" ''hl.dsp.focus({ workspace = "e-1" })'')
      (mkBind "${modifier} + mouse_down" ''hl.dsp.focus({ workspace = "e+1" })'')
      (mkBind "${modifier} + mouse_up" ''hl.dsp.focus({ workspace = "e-1" })'')

      (mkBind "ALT + Tab" ''hl.dsp.window.cycle_next()'')
      (mkBind "ALT + Tab" ''hl.dsp.window.bring_to_top()'')

      (mkBind "XF86AudioRaiseVolume" (exec "wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+"))
      (mkBind "XF86AudioLowerVolume" (exec "wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"))
      (mkBind "XF86AudioMute" (exec "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"))
      (mkBind "XF86AudioMicMute" (exec "wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"))
      (mkBind "XF86AudioPlay" (exec "playerctl play-pause"))
      (mkBind "XF86AudioPause" (exec "playerctl play-pause"))
      (mkBind "XF86AudioNext" (exec "playerctl next"))
      (mkBind "XF86AudioPrev" (exec "playerctl previous"))
      (mkBind "XF86MonBrightnessDown" (exec "brightnessctl set 5%-"))
      (mkBind "XF86MonBrightnessUp" (exec "brightnessctl set +5%"))
      (mkBind "XF86Calculator" (exec "qalculate"))

      (mkBind "${modifier} + Delete" (exec lockCmd))
      (mkBind "CTRL + ALT + V" (exec "cliphist list | rofi -dmenu -p 'Clipboard' | cliphist decode | wl-copy"))
      (mkBind "CTRL + ALT + X" (exec "cliphist wipe"))
      (mkBind "XF86PowerOff" (exec "sleep 0.1 && wlogout"))

      # Old bindm (mouse move/resize) — Lua has no separate hl.bindm; these
      # are regular hl.bind() calls with the `mouse = true` option instead.
      (mkBindOpt "${modifier} + mouse:272" ''hl.dsp.window.drag()'' { mouse = true; })
      (mkBindOpt "${modifier} + mouse:273" ''hl.dsp.window.resize()'' { mouse = true; })
    ];
  };
}
