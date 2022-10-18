#!/bin/bash

# A script used to automatically create Avid projects based on a template folder

# Created by Tyrell Blackburn
# https://github.com/tyrell-blackburn

printf "%s\n\n" "Welcome to The AVID Project Creation Script" \
"This script will create AVID projects for a new production based on a template. Bins will be taken one-by-one from a pool of unique bins (they must be originally created in AVID) rather than duplicate from the template. This ensures the \"Unable to open bin\" error message is avoided when opening bins across projects."

printf "%s\n\n" "HOW TO USE THIS SCRIPT"

printf "%s\n\n" "1. Create a template of your project folder in the \"project-template\" folder." \
"NOTE: At minimum the \"*prod*series_EP*episode.avp\" must be kept in order for AVID to recognise the folder as a project."

printf "%s\n\n" "2. Rename the files and folders in the project template by replacing the production initials, series number, and episode number with the following:" \
"The production, e.g. TB, will become \"*prod\"" \
"The series number, e.g. 19, will become \"*series\"" \
"The episode number, e.g 34, will become \"*episode\""

printf "%s\n\n" "3. For bins that contain useful content such as sequence templates or timecode filters that you wish to have duplicated across all projects, add a \"*keep_\" to the start of the bin file name."

printf "%s\n\n" "4. Populate the bins folder with unique bins created from AVID."

printf "%s\n\n" "If you don't have enough bins to create unique bins across all projects, the script will alert you to this."

printf "%s\n\n" "Here is an example of how the project template should look like.

What files and folders should look like in the project-template folder:

*prod*series_EP*episode_Final DB screening.avb
!!!*prod*series_EP*episode_SCREENINGS (folder)
	*keep_!TIMECODE.avb
	*prod*series_EP*episode_Content screening.avb

What they look like after they have been built in a new project:

!!!TB19_EP02_FOR WEB.avb
!!!TB19_EP02_SCREENINGS
	!TIMECODE.avb
	TB19_EP02_Content screening.avb"

# Function asking user if they want to continue
# $1 = question string
continueScript () {
	local validinput=false # assume invalid input
	while [ $validinput = false ]; do
		read -rp "$1" answer
		if [ "$answer" == "y" ] || [ "$answer" == "Y" ]; then
			validinput=true # only if yes continue
		elif [ "$answer" == "n" ] || [ "$answer" == "N" ]; then
			echo "script terminated" # if no terminate script
			exit;
		else
			echo "Enter a 'y' or 'n' to continue."
		fi
	done
}

continueScript "First customise the project template and add unique bins to the bins folder. Are you ready to continue? (y/n): "

# $production - e.g. TB
# $seriesnumber - e.g. 19
# $episodes - e.g. 01

### check input function ###
### this is quite basic as it only checks numbers and letters ###
# $1 = variable name, e.g. "production"
validateInput () {
	local validinput=false # assume invalid input
	local numbers='[0-9]'
	local letters='[a-zA-Z]'
	
	case $1 in
	seriesnumber)
		while [ $validinput = false ]; do
			if [[ "$seriesnumber" =~ $letters ]]; then
				printf "%s" "Enter digits only for the series number (e.g. \"20\"): "
				read -r seriesnumber
			elif [[ "$seriesnumber" =~ $numbers ]]; then
				validinput=true # only if yes continue
			else
				printf "%s" "Enter digits only for the series number (e.g. \"20\"): "
				read -r seriesnumber
			fi
		done
		;;

	episodes)
		while [ $validinput = false ]; do
			if [[ "$episodes" =~ $letters ]]; then
				printf "%s" "Enter digits only for the number of episodes (e.g. \"52\"): "
				read -r episodes
			elif [[ "$episodes" =~ $numbers ]]; then
				validinput=true # only if yes continue
			else
				printf "%s" "Enter digits only for the number of episodes (e.g. \"52\"): "
				read -r episodes
			fi
		done
		;;
	esac
}

printf "%s" "Enter the production initials (e.g. TB): "
read -r production
printf "%s" "Enter the series number (e.g. 20 for series 20): "
read -r seriesnumber
validateInput "${!seriesnumber@}"
printf "%s" "Enter how many episodes: "
read -r episodes
validateInput "${!episodes@}"

### BINS ###

BINSPATH="./bins/*.avb" # bins path
BINSARRAY=(); # initialize empty bin array
BININDEX=0 # bin index used to cycle through the bins

# add bins to BINSARRAY array
for bin in $BINSPATH; do
	# if this string appears, it means no bins were added to the bins folder. Not the most efficient check.
	if [[ "$bin" == "./bins/*.avb" ]]; then #
		echo "No bins were detected in the bins folder. Please add some and restart the script."
		exit;
	fi
	BINSARRAY+=("$bin");
done

# how many unique bins available
AVAILABLEBINS=${#BINSARRAY[@]}

# unique bins per project
NEWBINS=0

# calculating how many unique bins needed per project
while IFS= read -r -d '' path; do
	if [[ -f "$path" ]] ; then
		if [[ "$path" == *".avb"* ]]; then # if is a bin 
			if [[ "$path" != *"*keep_"* ]]; then # if not marked as keep
				((NEWBINS++)) # increment bin index
			fi
		fi
	fi
done <   <(find ./project-template -print0)

# how many unique bins needed to ensure bins over all projects are unique 
NEEDEDBINS=$((NEWBINS*episodes))

# How many projects will have totally unique bins
PROJECTSWITHUNIQUEBINS=$((AVAILABLEBINS/NEWBINS))

# How many extra bins are needed to ensure unique bins across all projects
MISSINGBINS=$((NEEDEDBINS-AVAILABLEBINS))

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

	printf "%s" " will have completely unique bins. "
	
	# tell the user how many extra bins they need
	printf "%s" "In order to avoid this, add $((MISSINGBINS)) more "

	if [[ $MISSINGBINS == 1 ]]; then
		printf "%s" "bin"
	elif [[ $MISSINGBINS -gt 1 ]]; then
		printf "%s" "bins"
	fi

	printf "%s\n\n" " to the bins folder."

	continueScript "If you continue now. Not all projects will have unique bins. Do you wish to continue? (y/n): "
fi

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
		# truncate the path to only include the parts that will copy - e.g. ./project-template/!!!*prod*series_EP*episode_SCREENINGS
		truncPath=${path:18} # Parameter Expansion - https://www.gnu.org/software/bash/manual/html_node/Shell-Parameter-Expansion.html

		# replace parts of the path with the production, series, and episodes
		truncPath="${truncPath//\*series/$seriesnumber}" # replace series
		truncPath="${truncPath//\*episode/$currentEpisode}" # replace episode
		truncPath="${truncPath//\*prod/$production}" # replace production

		# build destination path with destination root folder and renamed path
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
					# echo "fetching bin $BININDEX: $bin"
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
	done <   <(find ./project-template -print0)
done