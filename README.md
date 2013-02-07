# Tmux Battery Charge Indicator
Display a series of ten hearts indicating the current battery charge.

# Installation
1) Place the `tmux_battery_charge_indicator.sh` script into `~/bin` (or the location of your choosing).
2) In `~/.tmux.conf` add the following lines.

    # battery charge indicator
    set -g status-right '#(~/bin/tmux_battery_charge_indicator.sh)'
    set -g status-utf8 on
