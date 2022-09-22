#!/bin/bash

# A script used to automatically create Avid projects based on a template folder

# Created by Tyrell Blackburn
# https://github.com/tyrell-blackburn

printf "%s\n\n" "Welcome to The Block create projects script"
printf "%s\n" "This script will create projects with \"unique\" bins so you won't get the \"Unable to open bin\" error message."
printf "%s\n" "Bins that contain content you want copied over to each project, prepend their name with \"unique_\""
printf "%s\n" "Before continuing, make sure you've customised the project template folder the way you want it in /Project-template."

# pat='[^0-9]+([0-9]+)'
# s='I am a string with some digits 1024'
# [[ $s =~ $pat ]] # $pat must be unquoted
# echo "${BASH_REMATCH[0]}"
# echo "${BASH_REMATCH[1]}"

production=TB
seriesnumber=19
episodes=1

# add warning if not enough bins for unique bins. If not enough unique bins then they will be reused

# create folder for episode folders
mkdir "$production""$seriesnumber"_PROJECTS
basedir="./$production""$seriesnumber"_PROJECTS


# This creates the folder structure of an episode
function createProjects {

	# isolate the path by truncating ./episode-template
	originalPath="$1"
	[[ $originalPath =~ \.\/episode-template(.*) ]] # a match is stored in BASH_REMATCH

	# truncated path
	truncOriginalPath=${BASH_REMATCH[1]}
	echo "original path: "$1"" # print original path
	echo "truncated original path: "$truncOriginalPath"" # print truncated original path

	# building the destination path
	destPath=""$4""${BASH_REMATCH[1]}""
	echo "dest path: $destPath" # print new destination path

	# default Input Field Separators are white space, new line, and tab. This removes white space so files and folders can be handled without globbing and word-splitting. 
	# IFS="$(printf '\n\t')"
	IFS=$'\n'

	# operations if path is a file
	if [ -f "$1" ] ; then
		printf "%s\n\n" "is a file do nothing"
	fi

	# operations if path is a directory
	if [ -d "$1" ] ; then
		printf "%s\n" "is a directory - so copy directory"
				
		echo "from original path : $originalPath to dest path: $destPath" # print new destination path
		mkdir -p -v "$originalPath" "$destPath"
		# cp -r "$1" "$destPath"
	fi

# split input string into an array with '/' as delimiter

}

# not sure why we need to export the function but this is necessary when using it with "find"
export -f createProjects

for (( i=1; i <= episodes; i++ )) do

	# Adds a zero in front of episodes that are less than episode 10
	if [ "$i" -lt 10 ]; then
    	currentEpisode=0"$i"
	else
		currentEpisode="$i"
	fi

	# notification creating episodes
	printf "%s\n\n" "Creating Episode $currentEpisode folders"
	destRootFolder="$basedir"/"$production""$seriesnumber"_EPISODE_"$currentEpisode"
	
	# traverses the episode template and each result is fed into "createProjects"
	# Important it's written this way because of end of part 6 here http://mywiki.wooledge.org/UsingFind
	# find ./episode-template -exec bash -c 'createProjects $1 $2 $3 $4' _ "{}" "$seriesnumber" "$currentEpisode" "$destRootFolder" \; # this doesn't work
	find ./episode-template -exec bash -c 'createProjects "$1" $2 $3 $4' _ "{}" "$seriesnumber" "$currentEpisode" "$destRootFolder" \; # this doesn't work
done


# find ./episode-template -exec sh -c
# for thing do
# 	cp thing ./dest
# done


# find ./episode-template -exec sh -c
# if [ {} == type -d ]
# then
# 	cp {} ./dest
# done
# fi \;


# mkdir ./dest

# find ./episode-template -print0 | xargs -0 -I {} cp {} ./dest

# for file in *
# do
# 	echo $file
# done

# find ./episode-template -print0 | while IFS= read -r -d $'\0' file; 
#   do echo "$file" ;
# done


# find ./episode-template





##### TEMPORARY CODE #####


# code to check variable name. Want to use this for switch statement to check input

# for var in production seriesnumber episodes ; do
#     echo $var ${!var}
# done

## Code used to check continueinput is valid or not

# validinput=false

# while [ $validinput = false ]
# do
# 	read -rp "Do you wish to continue? (y/n): " continuescript
	
# 	if [ "$continuescript" == "n" ] ; then
# 		echo "exited"
# 		exit;
# 		elif [ "$continuescript" == "y" ] ; then
# 			echo "continued"
# 			validinput=true
# 		else
# 			echo "Enter a 'y' or 'n' to continue.";
# 	fi
# done

# function checkinput {

# 	echo 
#     # echo "${!1@}"

# }

# read -p "Enter the production initials (e.g. TB): " production
# checkinput $production
# read -p "Enter the series number (e.g. 20 for series 20): " seriesnumber
# checkinput $seriesnumber
# read -p "Enter how many episodes: " episodes
# checkinput $episodes


# create checks for all three input variables
# while [ "$continuescript" != "n" ] && [ "$continuescript" != "y" ]
# do
# 	read -rp "Enter a 'y' or 'n' only: " continuescript
# done