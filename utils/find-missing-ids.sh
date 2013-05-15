#!/bin/bash

BASEIDS="/usr/share/themes/base/meegotouch/ids.txt"
LOCALIDS="meego/meegotouch/ids.txt"

echo "Locating SVG ids not yet is base or meego ids.txt file.  Any output should be evaluated to append to $LOCALIDS to ensure extract.pl will produce .ids files that are in sync:"
echo

ALLIDS=$(git grep -e "g *id=" meego/meegotouch/svg | cut -d\" -f2 |sort -u)

for id in $ALLIDS
do
	found=$(grep -l $id $BASEIDS)
	if [ "x$found" == "x" ]
	then
		found=$(grep -l $id $LOCALIDS)
	fi

	if [ "x$found" == "x" ]
	then
		# Filter out auto named ids like:
		#     pattern12345_10_
		#     rect1234
		#     g1234
		#     g1234_3
		filtered=$(echo $id | grep -P '^[a-z]+\d{4,}_?\d*_*')

		# Filter out layer ids
		[[ "x$filtered" == "x" ]] &&
			filtered=$(echo $id | grep -P '^layer[0-9]+_?\d*_*')

		# Filter out ids names foobar_1_ and similar
		[[ "x$filtered" == "x" ]] &&
			filtered=$(echo $id | grep -P '\w+_+\d+_+')

		# Filter out ids names foobar-1 and similar
		[[ "x$filtered" == "x" ]] &&
			filtered=$(echo $id | grep -P '\w+-+\d+$')

		# Filter out ids names *-layer
		[[ "x$filtered" == "x" ]] &&
			filtered=$(echo $id | grep -P '\w+-layer$')

		# Filter out ids matching "dui-theme-rd"
		[[ "x$filtered" == "x" ]] &&
			filtered=$(echo $id | grep 'dui-theme-rd')

		# Filter out ids matching "*ThemeTemplateHelper"
		[[ "x$filtered" == "x" ]] &&
			filtered=$(echo $id | grep -P '\wThemeTemplateHelper')

		# Anything remaining should be valid
		[[ "x$filtered" == "x" ]] && echo $id;
	fi
done
