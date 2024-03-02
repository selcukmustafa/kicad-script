#!/bin/sh +x
#
# Copyright (C) 2022 Uysan
#
# This program is free software which is
# licensed under the terms of the GNU General Public License v2.
#
# Author: Selcuk Mustafa
#
SCR_PATH=`readlink -f "$0"`
SCR_DIR=`dirname "$SCR_PATH"`
SOURCE=$SCR_DIR/datasheets.csv
which awk > /dev/null
if [ $? -eq 0 ]; then
	which tac > /dev/null
	if [ $? -eq 0 ]; then
		if [ -f $SOURCE ]; then
			td=`cat /dev/urandom | tr -cd 'a-f0-9' | head -c 32`
			td="/dev/shm/$td/"
			mkdir $td > /dev/null 2>&1
			if [ -d $td ]; then
				#if [ $# -eq 2 ] && [ ! -z "$1" ] && [ ! -z "$2" ]; then
				count_sch=`ls -1 *.sch 2>/dev/null | wc -l`
				count_kicad_sch=`ls -1 *.kicad_sch 2>/dev/null | wc -l`
				if [ $count_sch != 0 ] || [ $count_kicad_sch != 0 ]; then
					#version 2, 3 or 4
					if [ $count_sch != 0 ]; then
						for f in *.sch; do
							grep -q "EESchema Schematic File Version 2" $f || grep -q "EESchema Schematic File Version 3" $f ||
							grep -q "EESchema Schematic File Version 4" $f
							if [ $? -eq 0 ]; then
								tf=`cat /dev/urandom | tr -cd 'a-f0-9' | head -c 32`
								tf="$td$tf"
								cp $f $tf
								while IFS=, read -r MF PN DS; do
									if [ ! -z $MF ] && [ ! -z $PN ] && [ ! -z $DS ]; then
										count=`grep -c "F 7 \"$PN\"" $f`
										if [ $count != 0 ]; then
											#echo "$PN found in $f"
											mv $tf $tf.ydk
											cat $tf.ydk | tac | awk -v PN=$PN -v DS=$DS 'BEGIN {FS=OFS=" ";}{if($1=="F"&&$2=="7"){if($3=="\""PN"\""){edit=1;}else{edit=0;}}}{if(edit&&$1=="F"&&$2=="3"){$3="\""DS"\"";edit=0}print; }' | tac > $tf
											rm $tf.ydk
										fi
									fi
								done < $SOURCE
								#cat $tf
								dc=`diff -by --suppress-common-lines $f $tf | wc -l`
								if [ $dc != 0 ]; then
									echo "Added / edited $dc links to $f."
									mv $f $f.ydk
									mv $tf $f
								fi
							else
								echo "Wrong file type. $f should be EESchema Schematic File Version 2, 3 or 4."
							fi
						done
					fi
					#version 20211123 or newer
					if [ $count_kicad_sch != 0 ]; then
						for f in *.kicad_sch; do
							grep -q "kicad_sch" $f
							if [ $? -eq 0 ]; then
								tf=`cat /dev/urandom | tr -cd 'a-f0-9' | head -c 32`
								tf="$td$tf"
								cp $f $tf
								while IFS=, read -r MF PN DS; do
									if [ ! -z $MF ] && [ ! -z $PN ] && [ ! -z $DS ]; then
										count=`grep \"PartNumber\" $f | grep -c \"$PN\"`
										if [ $count != 0 ]; then
											#echo "$PN found in $f"
											mv $tf $tf.ydk
											cat $tf.ydk | tac | awk -v PN=$PN -v DS=$DS 'BEGIN {FS=OFS=" ";}{if($2=="\"PartNumber\""){if($3=="\""PN"\""){edit=1;}else{edit=0;}}}{if(edit&&$2=="\"Datasheet\""){if($3!="\""DS"\""){$3="\""DS"\""};edit=0}print; }' | tac > $tf
											rm $tf.ydk
										fi
									fi
								done < $SOURCE
								#cat $tf
								dc=`diff -by --suppress-common-lines $f $tf | wc -l`
								if [ $dc != 0 ]; then
									echo "Added / edited $dc links to $f."
									mv $f $f.ydk
									mv $tf $f
								fi
							else
								echo "Wrong file type. $f should be EESchema Schematic File Version 2021 or greater."
							fi
						done
					fi
				else
					echo "No shematic file found in current directory."
				fi
				#else
				#	echo Usage: $0
				#fi
				rm -fr $td
			else
				echo "Cannot create temporary directory $td."
			fi
		else
			echo "Cannot read $SOURCE."
		fi
	else
		echo "Please install tac."
	fi
else
	echo "Please install awk."
fi