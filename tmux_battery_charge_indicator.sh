#!/bin/bash

# Copyright (c) 2013 Aaron Lasseigne
# 
# Permission is hereby granted, free of charge, to any person
# obtaining a copy of this software and associated documentation
# files (the "Software"), to deal in the Software without
# restriction, including without limitation the rights to use,
# copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the
# Software is furnished to do so, subject to the following
# conditions:
# 
# The above copyright notice and this permission notice shall be
# included in all copies or substantial portions of the Software.
# 
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
# OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
# NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
# HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
# WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
# FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
# OTHER DEALINGS IN THE SOFTWARE.

HEART='♥'

if [[ `uname` == 'Linux' ]]; then
  current_charge=$(cat /proc/acpi/battery/BAT1/state | grep 'remaining capacity' | awk '{print $3}')
  total_charge=$(cat /proc/acpi/battery/BAT1/info | grep 'last full capacity' | awk '{print $4}')
else
  battery_info=`ioreg -rc AppleSmartBattery`
  current_charge=$(echo $battery_info | grep -o '"CurrentCapacity" = [0-9]\+' | awk '{print $3}')
  total_charge=$(echo $battery_info | grep -o '"MaxCapacity" = [0-9]\+' | awk '{print $3}')
fi

charged_slots=$(echo "(($current_charge/$total_charge)*10)+1" | bc -l | cut -d '.' -f 1)
if [[ $charged_slots -gt 10 ]]; then
  charged_slots=10
fi

echo -n '#[fg=red]'
for i in `seq 1 $charged_slots`; do echo -n "$HEART"; done

if [[ $charged_slots -lt 10 ]]; then
  echo -n '#[fg=white]'
  for i in `seq 1 $(echo "10-$charged_slots" | bc)`; do echo -n "$HEART"; done
fi
