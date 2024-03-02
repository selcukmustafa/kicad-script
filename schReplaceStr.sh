#!/bin/sh +x
#
# Copyright (C) 2021 Uysan
#
# This program is free software which is
# licensed under the terms of the GNU General Public License v2.
#
# Author: Selcuk Mustafa
#
which perl > /dev/null
if [ $? -eq 0 ]; then
	if [ $# -eq 2 ] && [ ! -z "$1" ] && [ ! -z "$2" ]; then
		count=`ls -1 *.sch 2>/dev/null | wc -l`
		if [ $count != 0 ]; then
			for f in *.sch; do
				grep -q "EESchema Schematic File Version 2" $f || grep -q "EESchema Schematic File Version 3" $f ||
				grep -q "EESchema Schematic File Version 4" $f
				if [ $? -eq 0 ]; then
					count=`grep -c $1 $f`
					if [ $count != 0 ]; then
						#echo "$1 found in $f"
						perl -i -psle '$rcnt++ if s/$from/$to/g; END{if($rcnt != 0){ print "Replaced $from with $to $rcnt times in $ARGV"} else { print "No replacement done in $ARGV"}}' -- -from=$1 -to=$2 $f
					#else
						#echo "$1 not found in $f"
					fi
				else
					echo "Wrong file type. $f should be EESchema Schematic File Version 2 or greater."
				fi
			done
		else
			echo "No sch file found in current directory."
		fi
	else
		echo Usage: $0 old_string new_string
	fi
else
	echo "Please install perl."
fi