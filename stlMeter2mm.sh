#!/bin/sh +x
#
# Copyright (C) 2023 Uysan
#
# This program is free software which is
# licensed under the terms of the GNU General Public License v2.
#
# Author: Selcuk Mustafa
#
which awk > /dev/null
if [ $? -eq 0 ]; then
	which grep > /dev/null
	if [ $? -eq 0 ]; then
		count=`ls -1 *.stl 2>/dev/null | wc -l`
		if [ $count != 0 ]; then
			#echo "Converting meter to millimeters."
			for f in *.stl; do
				#solid ascii
				#Reference;Quantity;Value;Footprint;Datasheet;Digikey;Manufacturer;PartNumber;Power;Tolerance
				head -1 $f | grep -qIi solid 
				if [ $? -eq 0 ]; then
					echo -n "$f..."
					mv $f $f.ydk
					cat $f.ydk | awk 'BEGIN{OFS=FS=" "}$1=="vertex"{$2*=1000;$3*=1000;$4*=1000;}{print;}' > $f
					echo " Done."
				else
					echo "Wrong file type. $f should be ascii stl file."
				fi
			done
		else
			echo "No stl file found in current directory."
		fi
	else
		echo "Please install grep."
	fi
else
	echo "Please install awk."
fi
