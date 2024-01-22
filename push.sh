#!/bin/bash  

STRING="{\"Themes\": {"
for f in */*; do
	#f = themes/themename
	declare -a DOWNLOADS=()
	STRING=$STRING"\"$(basename $f)\":{"
	for i in $f/*; do
		N=$(basename $i)
		#$N = items in theme folder
		if [[ $(basename $f).jpg == $N ]] #if ThemeName.jpg = ThemeName.jpg
		then
			DOWNLOADS+=($N) #add images
			STRING=$STRING"\"img\":\"$N\"," #image
		elif [[ $N != *.* ]]; #if doesn't contain an extention looking for .
		then
			if [[ $N == *signalImages* ]]; #check if contains signalImages
				then
					#$i = themes/themeName/signalImages
					for s in $i/*; do #loop over signalImages/
						signal=$(basename $s) #get inner folder name
						DOWNLOADS+=($signal/signalimages) #add to downloads
					done
			elif [[ $N == *wifiImages* ]]; #check if contains wifiImages
				then
					#$i = themes/themeName/wifiImages
					for s in $i/*; do #loop over wifiImages/
						wifi=$(basename $s) #get inner folder name
						DOWNLOADS+=($wifi/wifiimages) #add to downloads
					done
			else 
				DOWNLOADS+=($N/weathericons)
			fi
		else
			DOWNLOADS+=($N)
		fi
	done
	STRING=$STRING"\"downloads\":\"["
	pos=$(( ${#DOWNLOADS[*]} - 1 ))
	last=${DOWNLOADS[$pos]}
	for d in "${DOWNLOADS[@]}"; do
		if [[ $d == $last ]]
		then
		     STRING=$STRING$d
		else 
			STRING=$STRING$d,
		fi
	done
	STRING=$STRING"]\"},"
done
STRING=$STRING"}}"
echo $STRING > themes.json

git add .
git commit -m "$*"
git branch -M main
git push -u origin main

