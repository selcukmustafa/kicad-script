#!/bin/sh +x
#
# Copyright (C) 2021 Uysan
#
# This program is free software which is
# licensed under the terms of the GNU General Public License v2.
#
# Author: Selcuk Mustafa
#
which sed > /dev/null
if [ $? -eq 0 ]; then
	count=`ls -1 *.kicad_mod 2>/dev/null | wc -l`
	if [ $count != 0 ]; then
		for f in *.kicad_mod; do
			a=`grep -c "(attr virtual)" $f`
			if [ $a != 0 ]; then
				echo removing from "$f"...
				sed -i '/(attr virtual)/d' $f
			fi
		done
	else
		echo No module file found in current directory.
	fi
else
	echo Please install sed.
fi
