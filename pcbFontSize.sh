#!/bin/sh +x
#
# Copyright (C) 2021 Uysan
#
# This program is free software which is
# licensed under the terms of the GNU General Public License v2.
#
# Author: Selcuk Mustafa
#
if [ -z $1 ]; then
	echo "Enter a valid filename as first parameter."
else
	if [ -s $1 ]; then
		grep -q PCBNEW-BOARD $1
		if [ $? -eq 0 ]; then
			mv $1 $1.ydk
			cat $1.ydk | awk 'BEGIN{OFS=FS=" "}$1=="T0"{$4=250;$5=250;$7=50;$9="V"}{print;}' | awk 'BEGIN{OFS=FS=" "}$1=="T1"{$4=250;$5=250;$7=50;$9="I"}{print;}' > $1
			echo "Text size: 25x25 mil, Width: 5 mil, File Type: PCBNEW-BOARD. Done."
		else
			grep -q kicad_pcb $1
			if [ $? -eq 0 ]; then
				mv $1 $1.ydk
				cat $1.ydk | awk '{ \
if($0~"fp_text reference"&&$0~"hide"){split($0,a,"hide");print a[1];} \
else if($0~"fp_text value"&&$0!~"hide"){printf"%s hide\n", $0;} \
else if($0~"\\(effects \\(font \\(size"){if($0~"justify mirror") \
{printf"      (effects (font (size 0.635 0.635) (thickness 0.127)) (justify mirror))\n";} \
else{printf"      (effects (font (size 0.635 0.635) (thickness 0.127)))\n";}}else print $0;}' > $1
				echo "Text size: 25x25 mil, Width: 5 mil, File Type: kicad_pcb. Done."
			else
				echo "Wrong file type. Should be PCBNEW-BOARD or kicad_pcb."
			fi
		fi
	else
		echo "File not found or size is zero."
	fi
fi
