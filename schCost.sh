#!/bin/sh +x
#
# Copyright (C) 2021 Uysan
#
# This program is free software which is
# licensed under the terms of the GNU General Public License v2.
#
# Author: Selcuk Mustafa
#
# enter vendor names as parameters such as arrow digikey farnell lcsc mouser newark rs tme
# no parameter uses all vendors
which kicost > /dev/null
if [ $? -eq 0 ]; then
	kicost_exec=`which kicost`
	count=`ls -1 *.xml 2>/dev/null | wc -l`
	if [ $count != 0 ]; then
		for f in *.xml; do
			grep xml $f | grep 1.0 | grep -q UTF-8
			if [ $? -eq 0 ]; then
				cat $f | sed 's/<field name="PartNumber">/<field name="manf#">/g' | \
				sed 's/<field name="Digikey">/<field name="digikey#">/g' | \
				sed 's/<field name="digikey#">!/<field name="digikey#">/g' | \
				sed 's/<field name="LCSC">/<field name="lcsc#">/g' | \
				sed 's/<field name="lcsc#">!/<field name="lcsc#">/g' > /dev/shm/$f
				filename=$(echo $f | sed 's/xml/xlsx/g')
				if [ $# -eq 0 ]; then
					python3 $kicost_exec -i /dev/shm/$f --overwrite -o ./$filename
				else
					python3 $kicost_exec --include "$@" -i /dev/shm/$f --overwrite -o ./$filename
					#kicost --include arrow digikey farnell lcsc mouser newark rs tme -i /dev/shm/$f --overwrite -o ./$filename
				fi
				echo "Cost file was generated for $f."
			else
				echo "$f has wrong file type. Should be XML File Version 1.0 with UTF-8 encoding."
			fi
		done
	else
		echo "No xml file found in current directory."
	fi
else
	echo "Please install kicost."
fi
