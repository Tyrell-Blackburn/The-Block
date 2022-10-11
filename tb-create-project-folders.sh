#!/bin/bash

# A script used to automatically create Avid projects based on a template folder

# Created by Tyrell Blackburn
# https://github.com/tyrell-blackburn

# ADD RENAMING OF THE PROJECT FILE TO THE EPISODE PROJECT

printf "%s\n\n" "Welcome to The Block Project Creation Script" \
"This script creates AVID projects for a new season of The Block based on a project template in the /project-template folder. While general folders and files will be duplicated across new projects, bins will be recreated as \"unique\" bins from a pool of unique bins in order to avoid the \"Unable to open bin\" error message when opening duplicate bins in AVID."

printf "%s\n\n" "Please populate the bins folder with unique bins. The script will warn you if you don't have enough bins and will let you know how much more you need." \

printf "%s\n\n" "INSTRUCTIONS FOR PREPARING THE PROJECT TEMPLATE" 

printf "%s\n\n" "For bins that contain useful content such as sequence templates or timecode filters that you wish to have duplicated across all projects, please add a \"*keep_\" to the start of the bin file name."

printf "%s\n\n" "For bins that contain useful content such as sequence templates or timecode filters that you wish to have duplicated across all projects, please add a \"*keep_\" to the start of the bin file name."

continueScript () {

	# assume invalid input
	validinput=false

	while [ $validinput = false ]; do
		read -rp "$1" answer
		if [ "$answer" == "n" ]; then
			echo "script terminated"
			exit;
		elif [ "$answer" == "y" ]; then
			validinput=true
		else
			echo "Enter a 'y' or 'n' to continue.";
		fi
	done
}

continueScript "Have you customised the project template and are ready to continue? (y/n): "

# read -p "Enter the production initials (e.g. TB): " production
# checkinput $production
# read -p "Enter the series number (e.g. 20 for series 20): " seriesnumber
# checkinput $seriesnumber
# read -p "Enter how many episodes: " episodes
# checkinput $episodes


# $seriesnumber - e.g. 19
# $currentEpisode - e.g. 01
# $production - e.g. TB
production=TB
seriesnumber=19
episodes=5

BINSPATH="./bins/*.avb" # bins path
BINSARRAY=(); # initialize empty bin array
BININDEX=0 # bin index used to cycle through the bins

# add bins to BINSARRAY array
for bin in $BINSPATH; do BINSARRAY+=("$bin"); done

# how many unique bins available
AVAILABLEBINS=${#BINSARRAY[@]}

# unique bins per project
NEWBINS=0

# calculating how many unique bins needed per project
while IFS= read -r -d '' path; do
	if [ -f "$path" ] ; then
		if [[ "$path" == *".avb"* ]]; then # if is a bin 
			if [[ "$path" != *"*keep_"* ]]; then # if not marked as keep
				((NEWBINS++)) # increment bin index
			fi
		fi
	fi
done <   <(find ./episode-template -print0)

# how many unique bins needed to ensure bins over all projects are unique 
NEEDEDBINS=$((NEWBINS*episodes))

PROJECTSWITHUNIQUEBINS=$((AVAILABLEBINS/NEWBINS))

MISSINGBINS=$((NEEDEDBINS-AVAILABLEBINS))

echo $PROJECTSWITHUNIQUEBINS

# a warning if there are not enough unique bins to ensure bins across all projects are unique
if [[ NEEDEDBINS -gt AVAILABLEBINS ]]; then
	echo "To create $episodes episode projects you need a total of $NEEDEDBINS unique bins in order to avoid the \"Unable to open bin\" error."
	printf "%s" "You have $AVAILABLEBINS bins. If you continue there is a chance you will get this error as "
	if [[ PROJECTSWITHUNIQUEBINS -lt 1 ]]; then
		printf "%s" "not even one project"
	elif [[ $PROJECTSWITHUNIQUEBINS == 1 ]]; then
		printf "%s" "only $((PROJECTSWITHUNIQUEBINS)) project"
	else
		printf "%s" "only $((PROJECTSWITHUNIQUEBINS)) projects"
	fi

	printf "%s\n" " will have completely unique bins. "

	printf "%s" "In order to avoid this, add $((MISSINGBINS)) more "

	if [[ $MISSINGBINS == 1 ]]; then
		printf "%s" "bin"
	elif [[ $MISSINGBINS -gt 1 ]]; then
		printf "%s" "bins"
	fi

	printf "%s\n\n" " to the bins folder."

	continueScript "Do you wish to continue? (y/n): "
fi

# code to check variable name. Want to use this for switch statement to check different input variables and then check what they should be

# for var in production seriesnumber episodes ; do
#     echo $var ${!var}
# done

# Code used to check continueinput is valid or not

# function checkinput {
# 	echo 
#     # echo "${!1@}"
# }

# create folder that holds all projects
mkdir "$production""$seriesnumber"_PROJECTS
basedir=./"$production""$seriesnumber"_PROJECTS

for (( i=1; i <= episodes; i++ )) do

	# Add a zero in front of episode numbers that are less than 10
	if [ "$i" -lt 10 ]; then
		currentEpisode=0"$i"
	else
		currentEpisode="$i"
	fi

	# notification creating episodes
	printf "%s\n" "#############################################################"
	printf "%s\n" "################ Creating Episode $currentEpisode folders ################"
	printf "%s\n\n" "#############################################################"

	# create the destination root folder - e.g. ./TB19_PROJECTS/TB19_EPISODE_01
	destRootFolder="$basedir"/"$production""$seriesnumber"_EP"$currentEpisode"

	while IFS= read -r -d '' path
	do
		# $path - the path being considered from 'find' - e.g. ./episode-template/!!!*prod*series_EP*episode_SCREENINGS
		# capture the last part of the path after "./episode-template" to process
		# [[ $path =~ \.\/episode-template(.*) ]] # gets assigned to global variable BASH_REMATCH
		# truncPath=${BASH_REMATCH[1]} # storing the last part of the path
		truncPath=${path:18} # Parameter Expansion - https://www.gnu.org/software/bash/manual/html_node/Shell-Parameter-Expansion.html

		# run path through pattern replacements for variables
		# If pattern begins with ‘/’, all matches of pattern are replaced.
		# If the nocasematch shell option (see the description of shopt in The Shopt Builtin) is enabled, the match is performed without regard to the case of alphabetic characters
		# More info on pattern matching https://www.gnu.org/software/bash/manual/html_node/Pattern-Matching.html
		truncPath="${truncPath//\*series/$seriesnumber}" # replace series
		truncPath="${truncPath//\*episode/$currentEpisode}" # replace episode
		truncPath="${truncPath//\*prod/$production}" # replace production

		# build destination path with destination root folder and renamed path
		# printf "Trunc Path:\t%s\n" "$truncPath" # prints file or folder
		destPath="$destRootFolder""$truncPath"

		# If path is a file
		if [ -f "$path" ] ; then
			if [[ "$path" == *".avb"* ]]; # if is a bin
			then
				# if bin is marked to keep
				if [[ "$path" == *"*keep_"* ]]; 
				then
					# remove "keep" from file name
					destPath="${destPath//\*keep_/}"
					# treat like a general file and copy it from template
					cp "$path" "$destPath"
				else # If normal bin
					# printf "%s\n" "Creating new AVID bin" 
					# fetch bin to copy
					bin=${BINSARRAY[$BININDEX]}
					echo "fetching bin $BININDEX: $bin"
					# copy new bin to destination path
					cp "$bin" "$destPath"
					# increment bin index
					((BININDEX++))
					# ensure index returns to zero to recycle bins
					BININDEX=$((BININDEX++ % AVAILABLEBINS)) 
				fi
			else
				# if is a general file then copy it from template
				cp "$path" "$destPath"
			fi
		fi

		# if is a directory then create it
		if [ -d "$path" ] ; then
			mkdir -p -v "$destPath"
		fi
	done <   <(find ./episode-template -print0)
done

##### TEMPORARY CODE #####

# create checks for all three input variables
# while [ "$continuescript" != "n" ] && [ "$continuescript" != "y" ]
# do
# 	read -rp "Enter a 'y' or 'n' only: " continuescript
# done

# pat='[^0-9]+([0-9]+)'
# s='I am a string with some digits 1024'
# [[ $s =~ $pat ]] # $pat must be unquoted
# echo "${BASH_REMATCH[0]}" # The full string
# echo "${BASH_REMATCH[1]}" # the part extracted with regex