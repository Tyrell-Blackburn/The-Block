#!/bin/bash

# A script used to automatically create Avid projects based on a template folder

# Created by Tyrell Blackburn
# https://github.com/tyrell-blackburn

# add input validation function for production, series, and episode (switch statement)
# change input to lowercase for continue function
# change production intials to uppercase
# change variable names to bash best practices

printf "%s\n\n" "Welcome to The AVID Project Creation Script" \
"This script will create AVID projects for a new season of a production based on a template. Bins will be created (rather than duplicated) from a pool of unique bins (they must be originally created in AVID). This is done in order to avoid the \"Unable to open bin\" error message when opening duplicate bins."

printf "%s\n\n" "Please populate the bins folder with unique bins. If you don't have enough bins inside to create unique bins across all projects, the script will alert you to this."

printf "%s\n\n" "INSTRUCTIONS FOR PREPARING THE PROJECT TEMPLATE"

printf "%s\n\n" "1. Create the perfect project template in the \"project-template\" folder. The only required file is the \"*prod*series_EP*episode.avp\", which is needed by AVID to recognise the folder as a project."

printf "%s\n\n" "2. Rename the files and folders in the project template by replacing the production initials, series number, and episode number with the following: 

*prod = will become the production, e.g. TB
*series = will become the series number, e.g. 19
*episode = will become the episode number, e.g 34"

printf "%s\n\n" "3. For bins that contain useful content such as sequence templates or timecode filters that you wish to have duplicated across all projects, add a \"*keep_\" to the start of the bin file name."

printf "%s\n\n" "4. Populate the bins folder with unique bins created from AVID."

printf "%s\n\n" "Here is an example of how the project template should look like.

What files and folders look like in the project-template folder:

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

continueScript "Have you added unique bins to the bins folder and customised the project template to your liking? (y/n): "

# $production - e.g. TB
# $seriesnumber - e.g. 19
# $episodes - e.g. 01

### check input function ###
# $1 = variable name, e.g. "production"
validateInput () {
	local validinput=false # assume invalid input
	echo "\$1 is: $1"
	case $1 in

	production)
		echo "inside production"
		re='[a-zA-Z]' # how to I check to make sure it's only letters and not numbers?
		while [ $validinput = false ]; do

			if [[ ! "$production" =~ $re ]]; then

			# if [[ "$production" =~ $re ]]; then
				printf "%s" "Enter letters only to continue: "
				read -r production
			else
				echo "matches"
				validinput=true # only if yes continue
			fi
		done
		;;

	seriesnumber)
		echo "inside seriesnumber"
		re='[0-9]'
		while [ $validinput = false ]; do
			if [[ "$seriesnumber" =~ $re ]]; then
				validinput=true # only if yes continue
			else
				printf "%s" "Enter numbers only to continue: "
				read -r seriesnumber
			fi
		done
		;;

	episodes)
		echo "inside episodes"
		re='[0-9]'
		while [ $validinput = false ]; do
			if [[ "$episodes" =~ $re ]]; then
				validinput=true # only if yes continue
			else
				printf "%s" "Enter numbers only to continue: "
				read -r episodes
			fi
		done
		;;
	esac
}

# validateInput () {
# 	local validinput=false # assume invalid input
	
# 	echo "\$1 is: $1" # regex - WORKING
# 	echo "\$2 is: $2"
# 	echo "\$3 is: $3"
# 	echo "\$3 is: ""${variableName}"
# 	echo "\$4 is: $4" # reply text - WORKING

# 	re="$1" # regex - WORKING
# 	textToValidate="$2" # variable text to validate
# 	variableName="$3" # variable name
# 	retryText="$4" # reply text - WORKING

# 	echo $variableName

# 	while [ $validinput = false ]; do
# 		if [[ "$3""$variableName" =~ $re ]]; then
# 			echo "matches"
# 			validinput=true # only if yes continue
# 			production=$textToValidate
# 		else
# 			printf "%s" "$retryText"
# 			read -r production
# 		fi
# 	done
# }


### Validate input function ###
# $1 = regular expression validation
# $2 = variable to evaluate
# $3 = retry text





# 	function validate {
# 		while [ $validinput = false ]; do
# 			if [[ "$stringToValidate" =~ $re ]]; then
# 				validinput=true # only if yes continue
# 			else
# 				printf "%s" "retryText"
# 				read -r production
# 			fi
# 		done
# 	}


# 	if [[ "$variableName" == "production" ]] ; then
# 		echo
# 	fi

# 	while [ $validinput = false ]; do
# 		if [[ "$stringToValidate" =~ $re ]]; then
# 			validinput=true # only if yes continue
# 		else
# 			printf "%s" "retryText"
# 			read -r production
# 		fi
# 	done
# 	;;

# 	seriesnumber)
# 		echo "inside seriesnumber"
# 		re='[0-9]'
# 		while [ $validinput = false ]; do
# 			if [[ "$seriesnumber" =~ $re ]]; then
# 				validinput=true # only if yes continue
# 			else
# 				printf "%s" "Enter numbers only to continue: "
# 				read -r seriesnumber
# 			fi
# 		done
# 		;;

# 	esac
# }


### check input function ###
# validateInput () {
# 	local validinput=false # assume invalid input
	
# 	echo "\$1 is: $1" # regex - WORKING
# 	echo "\$2 is: $2"
# 	echo "\$3 is: $3"
# 	echo "\$3 is: ""${variableName}"
# 	echo "\$4 is: $4" # reply text - WORKING

# 	re="$1" # regex - WORKING
# 	textToValidate="$2" # variable text to validate
# 	variableName="$3" # variable name
# 	retryText="$4" # reply text - WORKING

# 	echo $variableName

# 	while [ $validinput = false ]; do
# 		if [[ "$3""$variableName" =~ $re ]]; then
# 			echo "matches"
# 			validinput=true # only if yes continue
# 			production=$textToValidate
# 		else
# 			printf "%s" "$retryText"
# 			read -r production
# 		fi
# 	done
# }

printf "%s" "Enter the production initials (e.g. TB): "
read -r production
validateInput "${!production@}"
# validateInput "[a-zA-Z]" "$production" "${!production@}" "Enter letters only to continue: " # maybe need [a-z,A-Z] with comma ?
printf "%s" "Enter the series number (e.g. 20 for series 20): "
read -r seriesnumber
validateInput "${!seriesnumber@}"
# validateInput '[0-9]' "$seriesnumber" "${!seriesnumber@}" "Enter numbers only to continue: "
printf "%s" "Enter how many episodes: "
read -r episodes
validateInput "${!episodes@}"
# validateInput '[0-9]' "$episodes" "${!episodes@}" "Enter numbers only to continue: "



# for var in production seriesnumber episodes ; do
#     echo $var ${!var}
# done



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

	printf "%s\n" " will have completely unique bins. "

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
		# $path - the path being considered from 'find' - e.g. ./project-template/!!!*prod*series_EP*episode_SCREENINGS
		# capture the last part of the path after "./project-template" to process
		# [[ $path =~ \.\/project-template(.*) ]] # gets assigned to global variable BASH_REMATCH
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