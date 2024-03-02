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
	which sed > /dev/null
	if [ $? -eq 0 ]; then
		count=`ls -1 *.sch 2>/dev/null | wc -l`
		if [ $count != 0 ]; then
			echo "F0 & F1 size is 40 and F2 - F8 size is 35."
			for f in *.sch; do
				grep -q "EESchema Schematic File Version 2" $f || grep -q "EESchema Schematic File Version 3" $f ||
				grep -q "EESchema Schematic File Version 4" $f
				if [ $? -eq 0 ]; then
					echo -n "$f..."
					mv $f $f.ydk
					cat $f.ydk | sed ':a;/^F /s/^\(\([^"]*"[^"]*"[^"]*\)*[^"]*"[^"]*\) /\1_/;ta' | awk 'BEGIN{OFS=FS=" "}{\
if($1=="P"){posX=$2;posY=$3;isPower=0}else if($1=="F"){\
if($2=="0"){if($3~/^\"#/){$7=35;$8="0001";isPower=1;}else{$7=40;$8="0000";isPower=0;}}\
else if($2=="1"){$7=40;$8="0000";if(isPower){if($3~/^\"GND/){$6=posY-125;}else{$6=posY+125;}}}\
else if($2=="2"){$7=35;$8="0001";}\
else if($2=="3"){$7=35;$8="0001";}\
else if($2=="4"){$7=35;$8="0001";}\
else if($2=="5"){$7=35;$8="0001";}\
else if($2=="6"){$7=35;$8="0001";}\
else if($2=="7"){$7=35;$8="0001";}\
else if($2=="8"){$7=35;$8="0001";}}\
else if($1=="Text"&&($2=="Label"||$2=="GLabel")){$6=50}}{print;}' > $f
					echo " Done."
				else
					echo "Wrong file type. $f should be EESchema Schematic File Version 2 or greater."
				fi
			done
		else
			echo "No sch file found in current directory."
		fi
	else
		echo "Please install sed."
	fi
else
	echo "Please install awk."
fi
