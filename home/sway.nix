{ inputs, pkgs, system, ... }: {
  home.packages = with pkgs; [
    swww
    wl-clipboard
    wf-recorder

    (sway-contrib.grimshot.overrideAttrs (_: {
      src = fetchFromGitHub {
        owner = "OctopusET";
        repo = "sway-contrib";
        rev = "b7825b218e677c65f6849be061b93bd5654991bf";
        hash = "sha256-ZTfItJ77mrNSzXFVcj7OV/6zYBElBj+1LcLLHxBFypk=";
      };
    }))
  ];

  wayland.windowManager.sway = {
    enable = true;
    package = pkgs.sway.override {
      sway-unwrapped = inputs.swayfx.packages.${system}.default;
      extraOptions = [ "--unsupported-gpu" ];
    };
    config = { bars = [ ]; };
    extraConfig = ''
      # common stuff
      set $mod Mod4

      # auto startup
      exec_always ags 
      exec swww init
      exec --no-startup-id "gnome-keyring-daemon --start --components=pkcs11,secrets,ssh"
      exec --no-startup-id "systemctl --user start polkit-gnome-authentication-agent-1.service"

      # shortcut stuff
      bindsym $mod+Return exec wezterm
      bindsym $mod+d exec ags -t applauncher
      bindsym --release Super_L exec ags -t quicksettings
      bindsym $mod+e exec firefox
      bindsym Print exec grimshot copy anything

      # decoration stuff
      gaps outer 0
      gaps inner 20
      default_border none

      # Carburetor palette    Border    BG        Text    Indicator
      client.focused          #4589ffFF #4589ffFF #161616 #4589ffFF
      client.urgent           #FF832BFF #FF832BFF #161616 #FF832BFF
      client.focused_inactive #1616167E #1616167E #f4f4f4 #1616167E
      client.unfocused        #1616167E #1616167E #f4f4f4 #1616167E

      # swayfx stuff
      corner_radius 10
      blur on
      blur_passes 3
      blur_radius 8
      shadows on
      #shadow_offset 0 0
      shadow_blur_radius 50
      shadow_color #000000FF
      #shadow_inactive_color #000000B0

      # layer_effects bar0 blur enable
      # layer_effects bar1 blur enable
      # layer_effects notifications0 blur enable; blur_ignore_transparent enable
      # layer_effects notifications1 blur enable; blur_ignore_transparent enable
      # layer_effects quicksettings blur enable; blur_ignore_transparent enable
      # layer_effects dashboard blur enable; blur_ignore_transparent enable
      # layer_effects applauncher blur enable; blur_ignore_transparent enable

      # window stuff
      floating_modifier $mod normal
      bindsym $mod+Shift+space floating toggle
      bindsym $mod+Shift+Return fullscreen toggle
      bindsym $mod+Shift+q kill
      bindsym $mod+Left focus left
      bindsym $mod+Down focus down
      bindsym $mod+Up focus up
      bindsym $mod+Right focus right
      bindsym $mod+Shift+Left move left
      bindsym $mod+Shift+Down move down
      bindsym $mod+Shift+Up move up
      bindsym $mod+Shift+Right move right

      # workspace stuff
      bindsym $mod+1 workspace number 1
      bindsym $mod+2 workspace number 2
      bindsym $mod+3 workspace number 3
      bindsym $mod+4 workspace number 4
      bindsym $mod+5 workspace number 5
      bindsym $mod+6 workspace number 6
      bindsym $mod+7 workspace number 7
      bindsym $mod+8 workspace number 8
      bindsym $mod+9 workspace number 9
      bindsym $mod+0 workspace number 10
      bindsym $mod+Shift+1 move container to workspace number 1
      bindsym $mod+Shift+2 move container to workspace number 2
      bindsym $mod+Shift+3 move container to workspace number 3
      bindsym $mod+Shift+4 move container to workspace number 4
      bindsym $mod+Shift+5 move container to workspace number 5
      bindsym $mod+Shift+6 move container to workspace number 6
      bindsym $mod+Shift+7 move container to workspace number 7
      bindsym $mod+Shift+8 move container to workspace number 8
      bindsym $mod+Shift+9 move container to workspace number 9
      bindsym $mod+Shift+0 move container to workspace number 10

      # sway stuff
      bindsym $mod+Shift+r reload
      bindsym $mod+Shift+e exit

      include /etc/sway/config.d/*
      		'';
  };
}
