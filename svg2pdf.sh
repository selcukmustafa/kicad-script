#!/bin/sh +x
#
# Copyright (C) 2021 Uysan
#
# This program is free software which is
# licensed under the terms of the GNU General Public License v2.
#
# Author: Selcuk Mustafa
#
which inkscape > /dev/null
if [ $? -eq 0 ]; then
	count=`ls -1 *.svg 2>/dev/null | wc -l`
	if [ $count != 0 ]; then
		for f in *.svg; do
			a="$(echo $f | sed s/svg/pdf/)"
			echo converting "$f" to "$a"
			inkscape "$f" --export-pdf="$a"
		done
	else
		echo No svg file found in current directory.
	fi
else
	echo Please install inkscape.
fi
