{ pkgs, ... }:
let
  mod = "SUPER";
in
{
  home.packages = with pkgs; [
    swww
    wl-clipboard
    # wf-recorder
    sway-contrib.grimshot

    hyprlock
    hyprshot
    hyprpicker
  ];

  carburetor.themes = {
    hyprland.enable = true;
    hyprlock.enable = true;
  };

  wayland.windowManager.hyprland = {
    enable = true;
    plugins = with pkgs.hyprlandPlugins; [
      hyprexpo
      hyprtrails
    ];
    settings = {
      plugins = {
        hyprexpo = {
          columns = 2;
          gap_size = 20;
          bg_col = "rgb(161616)";
          workspace_method = "first 1";
        };
        hyprtrails = {
          color = "rgba(4589ffcc)";
        };
      };
      debug.disable_logs = false;
      exec = [
        # This will make sure that xdg-desktop-portal-hyprland can get the required variables on startup.
        "dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP"

        "swww-daemon -f xbgr"
        "eww daemon"
        "eww open bar"
      ];
      source = [ "./themes/regular.conf" ];
      monitor = [
        # https://wiki.hyprland.org/Configuring/Monitors/
        # ",1920x1200@165.00Hz, 0x0, 1"
      ];
      general = {
        layout = "dwindle";
        gaps_out = 0;
        gaps_in = 0;
        "col.active_border" = "#131a24";
        "col.inactive_border" = "$base";
      };
      cursor = {
        inactive_timeout = 3;
      };
      dwindle = {
        pseudotile = true;
        preserve_split = true;
      };
      group = {
        "col.border_inactive" = "$saphire";
        "col.border_active" = "$sky";
        groupbar = {
          enabled = true;
          text_color = "$text";
          priority = 0;
          "col.active" = "$base";
          "col.inactive" = "$crust";
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
        rounding = 0;
        dim_special = "0.0";
        dim_inactive = true;
        dim_strength = 0.3;
      };
      misc = {
        disable_hyprland_logo = true;
        animate_manual_resizes = false;
        animate_mouse_windowdragging = false;
        close_special_on_empty = true;
      };
      layerrule = [
        "blur,bar*"
        "ignorealpha,bar*"
        "blur,quicksettings*"
        "ignorealpha,quicksettings*"
        "blur,notifications*"
        "ignorealpha,notifications*"
        "blur,applauncher*"
        "ignorealpha,applauncher*"
      ];
      # workspace = [ "w[t1], gapsout:10 1200" ];
      bindm = [
        "${mod},mouse:272,movewindow"
        "${mod},mouse:273,resizewindow"
      ];
      bind =
        [
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
          "${mod}, W, exec, bash -c 'swww img --transition-type any $(find ~/Pictures/walls/carburetor | shuf -n 1)'"

          # Window management
          "${mod} SHIFT, E, exit"
          "${mod} SHIFT, Q, killactive"
          "${mod}, J, togglesplit"
          "${mod} SHIFT, Space, togglefloating"

          # Groups
          "${mod}, G, togglegroup"
          "${mod}, Tab, changegroupactive, f"
          "${mod}, Shift, changegroupactive, b"
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
