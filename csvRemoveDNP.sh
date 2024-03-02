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
	which grep > /dev/null
	if [ $? -eq 0 ]; then
		count=`ls -1 *.csv 2>/dev/null | wc -l`
		if [ $count != 0 ]; then
			#echo "Removing DNP parts."
			for f in *.csv; do
				#Ref,Val,Package,PosX,PosY,Rot,Side
				#Reference;Quantity;Value;Footprint;Datasheet;Digikey;Manufacturer;PartNumber;Power;Tolerance
				head -1 $f | grep -Ii Reference | grep -Ii Quantity | grep -Ii Value | grep -Ii Footprint | grep -Ii Datasheet |\
grep -Ii Manufacturer | grep -Ii PartNumber | grep -Ii Power | grep -qIi Tolerance ||\
head -1 $f | grep -Ii Ref | grep -Ii Val | grep -Ii Package | grep -Ii PosX | grep -Ii PosY | grep -Ii Rot | grep -qIi Side
				if [ $? -eq 0 ]; then
					echo -n "$f..."
					mv $f $f.ydk
					cat $f.ydk | awk 'BEGIN{OFS=FS=","}{if($0!~"DNP"){print;}}' > $f
					echo " Done."
				else
					echo "Wrong file type. $f should be Kicad position or bill of materials file."
				fi
			done
		else
			echo "No csv file found in current directory."
		fi
	else
		echo "Please install grep."
	fi
else
	echo "Please install awk."
fi
