{ pkgs, ... }:
let
  mod = "SUPER";
in
{
  home.packages = with pkgs; [
    awww
    wl-clipboard
    # wf-recorder
    sway-contrib.grimshot

    hyprlock
    hyprshot
    hyprpicker
  ];

  carburetor.themes = {
    hyprland.enable = false; # disabled - variables not working with new hyprland
    hyprlock.enable = true;
  };

  services.mako = {
    enable = true;
    settings.max-visible = 3;
  };

  services.hypridle = {
    enable = true;
    settings = {
      general = {
        # hypridle can call the locker directly:
        lock_cmd = "hyprlock";
        after_sleep_cmd = "hyprctl dispatch dpms on";
      };
      listener = [
        # After 15 minutes, lock. (900 seconds)
        {
          timeout = 900;
          on-timeout = "pidof hyprlock >/dev/null || hyprlock";
          on-resume = "hyprctl dispatch dpms on";
        }
        # Turn off displays a bit later
        {
          timeout = 960;
          on-timeout = "hyprctl dispatch dpms off";
          on-resume = "hyprctl dispatch dpms on";
        }
      ];
    };
  };

  wayland.windowManager.hyprland = {
    enable = true;
    configType = "hyprlang";
    plugins = [ ];
    settings = {
      debug.disable_logs = false;
      exec-once = [
        "mako"

        # This will make sure that xdg-desktop-portal-hyprland can get the required variables on startup.
        "dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP"

        "awww-daemon"
        "eww daemon"
        "eww open bar"
      ];
      # source = [ "./themes/regular.conf" ]; # carburetor theme disabled
      # monitor = [
      #   # https://wiki.hyprland.org/Configuring/Monitors/
      #   ",2560x1600@165.00Hz, 0x0, 1"
      # ];
      input = {
        # bind ctrl to capslock key, ctrl hurts my pinky :(
        kb_options = "ctrl:nocaps";
        kb_layout = "us,ir";
      };
      workspace = [
        # "m[0] w[t1], gapsout:80 80"
        # "m[0] w[t2], gapsout:40 40"
        # On widescreen monitor, pad 1 and 2 wide workspaces
        # "m[0] w[t1], gapsout:80 600"
        # "m[0] w[t2], gapsout:40 300"

        # "w[t1], gapsout:80 600"
        # "w[t2], gapsout:40 300"

        "w[t1], gapsout:40 40"
        "w[t2], gapsout:40 40"
      ];
      general = {
        layout = "dwindle";
        # gaps_out = 0;
        # gaps_in = 0;
        "col.active_border" = "rgb(131a24)";
        "col.inactive_border" = "rgb(1e1e2e)";
      };
      cursor = {
        inactive_timeout = 1;
      };
      dwindle = {
        preserve_split = true;
      };
      group = {
        "col.border_inactive" = "rgb(74c7ec)";
        "col.border_active" = "rgb(89dceb)";
        groupbar = {
          enabled = true;
          text_color = "rgb(cdd6f4)";
          priority = 0;
          "col.active" = "rgb(1e1e2e)";
          "col.inactive" = "rgb(11111b)";
        };
      };
      decoration = {
        blur = {
          size = 8;
          passes = 3;
          noise = "0.02";
          contrast = "0.9";
          brightness = "0.9";
          popups = true;
          xray = false;
          new_optimizations = true;
        };
        rounding = 10;
        dim_special = "0.0";
        # dim_inactive = true;
        # dim_strength = 0.3;
      };
      misc = {
        disable_hyprland_logo = true;
        animate_manual_resizes = false;
        animate_mouse_windowdragging = false;
        close_special_on_empty = true;
      };
      # layerrules disabled - syntax changed in hyprland 0.54+
      # layerrule = [
      #   "blur,bar*"
      #   "ignorealpha,bar*"
      # ];
      bindm = [
        "${mod},mouse:272,movewindow"
        "${mod},mouse:273,resizewindow"
      ];
      bind =
        [
          # Notification destroyer 8000
          "${mod}, D, exec, ${pkgs.mako}/bin/makoctl dismiss -a"

          # "${mod}, grave, hyprexpo:expo, toggle"
          # App launcher
          # "${mod}, D, exec, ags -t applauncher"

          # Terminal
          "${mod}, RETURN, exec, foot"
          # Browser
          "${mod}, E, exec, firefox"
          # Cheat sheet
          "${mod}, C, exec, [floating] litemdview ~/cheat.md"

          # Screenshots
          ", Print, exec, hyprshot --clipboard-only -zm window"
          "SHIFT, Print, exec, hyprshot --clipboard-only -zm region"

          # Cycle wallpaper
          # "${mod}, W, exec, bash -c 'swww img --transition-type any $(find ~/Pictures/walls/carburetor | shuf -n 1)'"

          # Window management
          "${mod} SHIFT, E, exit"
          "${mod} SHIFT, Q, killactive"
          "${mod}, F, fullscreen, 0"
          "${mod}, R, layoutmsg, togglesplit"
          "${mod} SHIFT, Space, togglefloating"
          "${mod}, Space, exec, hyprctl switchxkblayout all next"

          # Groups
          "${mod}, G, togglegroup"
          "${mod}, Tab, changegroupactive, f"
          "${mod} SHIFT, Tab, changegroupactive, b"
          "${mod} CTRL, Left, movegroupwindow, b"
          "${mod} CTRL, Right, movegroupwindow"

          # Window traversal and movement
          "${mod}, left, movefocus, l"
          "${mod}, right, movefocus, r"
          "${mod}, up, movefocus, u"
          "${mod}, down, movefocus, d"
          "${mod} SHIFT, left, movewindoworgroup, l"
          "${mod} SHIFT, right, movewindoworgroup, r"
          "${mod} SHIFT, up, movewindoworgroup, u"
          "${mod} SHIFT, down, movewindoworgroup, d"

          # Window traversal and movement HJKL
          "${mod} CTRL, H, movegroupwindow, b"
          "${mod} CTRL, L, movegroupwindow"
          "${mod}, H, movefocus, l"
          "${mod}, L, movefocus, r"
          "${mod}, K, movefocus, u"
          "${mod}, J, movefocus, d"
          "${mod} SHIFT, H, movewindoworgroup, l"
          "${mod} SHIFT, L, movewindoworgroup, r"
          "${mod} SHIFT, K, movewindoworgroup, u"
          "${mod} SHIFT, J, movewindoworgroup, d"
        ]
        ++ (
          # workspaces
          # binds $mod + [shift +] {1..10} to [move to] workspace {1..10}
          builtins.concatLists (
            builtins.genList (
              x:
              let
                ws =
                  let
                    c = (x + 1) / 10;
                  in
                  builtins.toString (x + 1 - (c * 10));
              in
              [
                "${mod}, ${ws}, workspace, ${toString (x + 1)}"
                "${mod} SHIFT, ${ws}, movetoworkspace, ${toString (x + 1)}"
              ]
            ) 10
          )
        );
    };
  };
}
