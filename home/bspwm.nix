{ pkgs, ... }:
{
  config = {
    xsession.windowManager.bspwm = {
      enable = true;
      settings = {
        border_width = 0;
        window_gap = 8;
        top_padding = 20;
        split_ratio = 0.52;
        borderless_monocle = true;
        gapless_monocle = true;
        normal_border_color = "#2E3440";
        active_border_color = "#D8DEE9";
        focused_border_color = "#D8DEE9";
        presel_feedback_color = "#2E3440";
      };
      alwaysResetDesktops = true;
      monitors = {
        "DP-0" = [
          "I"
          "II"
          "III"
          "IV"
          "V"
        ];
        "DP-2" = [
          "VI"
          "VII"
          "VIII"
          "IX"
          "X"
        ];
      };
      startupPrograms = [
        "polybar"
      ];
    };

    services.picom = {
      enable = true;
      backend = "glx";
      fade = true;
      fadeDelta = 5;
      fadeSteps = [
        0.03
        0.03
      ];
      inactiveOpacity = 0.6;
      shadow = true;
      shadowOffsets = [
        (-7)
        (-7)
      ];
      shadowOpacity = 0.8;
      shadowExclude = [
        ''window_type *= "menu"''
        ''name *?= "polybar"''
      ];
      vSync = true;
      settings = {
        shadow-radius = 10;
      };
    };

    services.polybar = {
      enable = true;
      script = ''
        set -e

        killall -v polybar >/dev/null 2>&1 || true

        # Set on both screens
        for m in $(${pkgs.xorg.xrandr}/bin/xrandr --query | grep " connected" | cut -d" " -f 1); do
            MONITOR=$m polybar classic &
        done
      '';
    };

    services.sxhkd = {
      enable = true;
      keybindings = {
        "super + Return" = "alacritty";
        "super + c" = "google-chrome-stable";
        "super + @space" = "rofi -show drun";
        "super + Escape" = "pkill -USR1 -x sxhkd";
        # bspwm hotkeys
        # quit/restart bspwm
        "super + alt + {q,r}" = "bspc {quit,wm -r}";
        # close and kill
        "super + {_,shift + }w" = "bspc node -{c,k}";

        # alternate between the tiled and monocle layout
        "super + m" = "bspc desktop -l next";

        # send the newest marked node to the newest preselected node
        "super + y" = "bspc node newest.marked.local -n newest.!automatic.local";

        # swap the current node and the biggest node
        "super + g" = "bspc node -s biggest";

        #
        # state/flags
        #

        # set the window state
        "super + {t,shift + t,s,f}" = "bspc node -t {tiled,pseudo_tiled,floating,fullscreen}";

        # set the node flags
        "super + ctrl + {m,x,y,z}" = "bspc node -g {marked,locked,sticky,private}";

        #
        # focus/swap
        #

        # focus the node in the given direction
        "super + {_,shift + }{h,j,k,l}" = "bspc node -{f,s} {west,south,north,east}";

        # focus the node for the given path jump
        "super + {p,b,comma,period}" = "bspc node -f @{parent,brother,first,second}";

        # focus the next/previous node in the current desktop
        "super + {_,shift + }c" = "bspc node -f {next,prev}.local";

        # focus the next/previous desktop in the current monitor
        "super + bracket{left,right}" = "bspc desktop -f {prev,next}.local";

        # focus the last node/desktop
        "super + {grave,Tab}" = "bspc {node,desktop} -f last";

        # focus the older or newer node in the focus history
        "super + {o,i}" = ''
          	bspc wm -h off; \
          	bspc node {older,newer} -f; \
          	bspc wm -h on
        '';

        # focus or send to the given desktop
        "super + {_,shift + }{1-9,0}" = "bspc {desktop -f,node -d} '^{1-9,10}'";

        #
        # preselect
        #

        # preselect the direction
        "super + ctrl + {h,j,k,l}" = "bspc node -p {west,south,north,east}";

        # preselect the ratio
        "super + ctrl + {1-9}" = "bspc node -o 0.{1-9}";

        # cancel the preselection for the focused node
        "super + ctrl + space" = "bspc node -p cancel";

        # cancel the preselection for the focused desktop
        "super + ctrl + shift + space" = "bspc query -N -d | xargs -I id -n 1 bspc node id -p cancel";

        #
        # move/resize
        #

        # expand a window by moving one of its side outward
        "super + alt + {h,j,k,l}" = "bspc node -z {left -20 0,bottom 0 20,top 0 -20,right 20 0}";

        # contract a window by moving one of its side inward
        "super + alt + shift + {h,j,k,l}" = "bspc node -z {right -20 0,top 0 20,bottom 0 -20,left 20 0}";

        # move a floating window
        "super + {Left,Down,Up,Right}" = "bspc node -v {-20 0,0 20,0 -20,20 0}";
      };
    };
  };
}

