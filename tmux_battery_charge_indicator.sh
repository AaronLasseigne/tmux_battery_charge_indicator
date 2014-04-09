#!/bin/bash

# Copyright (c) 2014 Dennis Schridde
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

SLOTS_MAX=10
SLOTS_WARNING=5
SLOTS_CRITICAL=3

BATTERY=BAT1

while [ $# -gt 0 ] ; do
	case $1 in
		percent) unset HEART ; SLOTS_MAX=100 ; SLOTS_WARNING=50 ; SLOTS_CRITICAL=30 ;;
		slots_max=*) SLOTS_MAX=${1##slots_max=} ;;
		slots_warning=*) SLOTS_WARNING=${1##slots_warning=} ;;
		slots_critical=*) SLOTS_CRITICAL=${1##slots_critical=} ;;
		battery=*) BATTERY=${1##battery=} ;;
	esac
	shift
done

if [[ $(uname) == 'Linux' ]] ; then
	current_charge=$(sed -nre '/^remaining capacity:/s/.*:\s+([0-9]+)\s*.*/\1/p' /proc/acpi/battery/${BATTERY}/state)
	total_charge=$(sed -nre '/^last full capacity:/s/.*:\s*([0-9]+)\s*.*/\1/p' /proc/acpi/battery/${BATTERY}/info)
	charging=$(sed -nre '/^charging state:/s/.*:\s*(\S+)\s*/\1/p' /proc/acpi/battery/${BATTERY}/state)
else
	battery_info=$(ioreg -rc AppleSmartBattery)
	current_charge=$(echo $battery_info | grep -o '"CurrentCapacity" = [0-9]\+' | awk '{print $3}')
	total_charge=$(echo $battery_info | grep -o '"MaxCapacity" = [0-9]\+' | awk '{print $3}')
fi

charged_slots=$(( ${current_charge} * 100 / ${total_charge} * ${SLOTS_MAX} / 100 ))
if [[ ${charged_slots} -gt ${SLOTS_MAX} ]] ; then
	charged_slots=${SLOTS_MAX}
fi

if [[ "${HEART}" ]] ; then
	if [ "${charged_slots}" -lt "${SLOTS_CRITICAL}" ] ; then
		echo -n '#[fg=red,blink]'
	else
		echo -n '#[fg=red]'
	fi
	for i in $(seq 1 ${charged_slots}) ; do
		echo -n "${HEART}"
	done
	echo -n '#[fg=white,noblink]'
	for i in $(seq 1 $(( ${SLOTS_MAX} - ${charged_slots} ))) ; do
		echo -n "${HEART}"
	done
else
	if [ "${charged_slots}" -lt "${SLOTS_CRITICAL}" ] ; then
		echo -n '#[fg=red,blink]'
	elif [ "${charged_slots}" -lt "${SLOTS_WARNING}" ] ; then
		echo -n '#[fg=yellow]'
	else
		echo -n '#[fg=green]'
	fi
	case "${charging}" in
		discharging) echo -n '-' ;;
		charging) echo -n '+' ;;
		charged) echo -n '=' ;;
		*) ;;
	esac
	echo -n "${charged_slots}%#[noblink]"
fi
