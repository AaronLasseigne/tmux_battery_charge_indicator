# Tmux Battery Charge Indicator
Display a series of ten hearts indicating the current battery charge.
The hearts were chosen as an homage to Zelda.
You can read more about it in my [blog post][] covering the subject.

## Installation
1. Place the `tmux_battery_charge_indicator.sh` script into `~/bin` (or the location of your choosing).
2. In `~/.tmux.conf` you can add the indicator to the right side of your status with the following code:

```bash
# battery charge indicator
set -g status-right '#(~/bin/tmux_battery_charge_indicator.sh)'
set -g status-utf8 on
```

## Alternate Versions

You can check out the [forks][] to see alternate versions which have more options and may better fit your needs.

[blog post]: http://aaronlasseigne.com/2012/10/15/battery-life-in-the-land-of-tmux/
[forks]: https://github.com/AaronLasseigne/tmux_battery_charge_indicator/network
