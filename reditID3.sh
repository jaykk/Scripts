#!/bin/bash

Album=( "" )

arr_push() {
  Album=("${Album[@]}" "$1")
}

arr_pop() {
  i=$(expr ${#Album[@]} - 1)
  placeholder=${Album[$i]}
  unset Album[$i]
  Album=("${Album[@]}")
}

function redit {

	count=1
	for i in *
	do
		if test -d "$i"
		then
			pushd "$i"
			arr_push "$i"
			redit $Artist
			arr_pop
			popd
		elif [[ "$i" == *.mp3 ]]
		then
			Album_str="${Album[@]}"
	        	echo "$i" | \
				awk -v Artist="$Artist" -v Album="$Album_str" -v MusicFile="${i%\.mp3}" -v TrackNo="$count" -F"(.mp3| - )" '{ print "id3v2 -t \""MusicFile"\" -a \""Artist"\" -A \""Album"\" -T \""TrackNo"\" \""MusicFile".mp3\"" }' | bash
			let count=count+1
		fi
	done

}

a="$1"
if test -d "$a"
then
	Artist="$a"
	Album=""
	pushd "$Artist"
	redit "$Artist"
	popd
fi

