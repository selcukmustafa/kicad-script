#!/bin/sh +x
#
# Copyright (C) 2021 Uysan
#
# This program is free software which is
# licensed under the terms of the GNU General Public License v2.
#
# Author: Selcuk Mustafa
#
SCR_PATH=`readlink -f "$0"`
SCR_DIR=`dirname "$SCR_PATH"`
SOURCE=$SCR_DIR/datasheets.csv
PR_DS=
which awk > /dev/null
if [ $? -eq 0 ]; then
	which wget > /dev/null
	if [ $? -eq 0 ]; then
		if [ -f $SOURCE ]; then
			while IFS=, read -r MF PN DS; do
				if [ ! -z $MF ] && [ ! -z $PN ] && [ ! -z $DS ]; then
					if [ "$DS" != "$PR_DS" ]; then
						#count=`curl --max-time 5 -Is $DS | head -1 | grep -ic 200`
						echo -n "$DS "
						wget -q -T 20 -t 1 -O /dev/null --no-check-certificate -U Mozilla $DS
						if [ $? -eq 0 ]; then
							echo "- Success"
						else
							echo "- Error for $PN ($MF)"
							#echo "\t$DS"
							#wget -T 15 -t 1 -O /dev/null --no-check-certificate -U Mozilla $DS
						fi
					fi
					PR_DS=$DS
				fi
			done < $SOURCE
		else
			echo "Cannot read $SOURCE."
		fi
	else
		echo "Please install wget."
	fi
else
	echo "Please install awk."
fi
