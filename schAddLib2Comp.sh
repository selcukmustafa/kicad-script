#!/bin/sh +x
#
# Copyright (C) 2021 Uysan
#
# This program is free software which is
# licensed under the terms of the GNU General Public License v2.
#
# Author: Selcuk Mustafa
#
which awk > /dev/null
if [ $? -eq 0 ]; then
	count=`ls -1 *.sch 2>/dev/null | wc -l`
	if [ $count != 0 ]; then
		if [ -z $1 ]; then
			LIBRARY="Celebi"
		else
			LIBRARY=$1
		fi
		for f in *.sch; do
			a="$(echo $f | sed s/sch/ydk/)"
			grep -q "EESchema Schematic File Version 2" $f || grep -q "EESchema Schematic File Version 3" $f ||
			grep -q "EESchema Schematic File Version 4" $f
			if [ $? -eq 0 ]; then
				mv $f $a
				cat $a | sed ':a;/^F /s/^\(\([^"]*"[^"]*"[^"]*\)*[^"]*"[^"]*\) /\1_/;ta' \
| awk -v lname=$LIBRARY 'BEGIN{OFS=FS=" "}$1=="L"&&$2!~":"{$2=lname":"$2}{print;}' > $f
				echo "Added $LIBRARY: prefix to components without library in $f."
			else
				echo "Wrong file type. Should be EESchema Schematic File Version 2."
			fi
		done
	else
		echo "No sch file found in current directory."
	fi
else
	echo "Please install awk."
fi
