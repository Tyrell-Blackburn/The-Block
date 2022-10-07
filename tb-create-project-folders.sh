#!/bin/bash

# A script used to automatically create Avid projects based on a template folder

# Created by Tyrell Blackburn
# https://github.com/tyrell-blackburn

printf "%s\n\n" "Welcome to The Block create projects script" \
"This script is designed to create AVID projects for a new production. Files and folders will be duplicated. Bins will recreated as \"unique\" bins across all projects. However, they will be created from a pool of unique bins that you must put in the ./bins folder. The way the script works is that bins will be copied one by one from the bins folder to a new project structure. So if a project template contains 15 bins, you wish to create 15 episodes, and there are 135 unique bins in the bins folder, then the first 14 project folders will have unique bins taken from the bins folder, and the 15th project folder will containt the same bins as the first project folder. To find out how many unique bins you will need, multiply the amount of bins in the project template with the number of episodes you wish to produce. The more unique bins you have, the less likely you will encounter the \"Unable to open bin\" error message in AVID." \
"Bins that contain clips or sequences that you want kept and duplicated across projects rather than recreated as a new bin must be prepended with \"*keep_\"" \
"Before continuing, make sure you've customised the project template folder the way you want it in /Project-template."

production=TB
seriesnumber=19
episodes=5

# initialising bins
BINS="./bins/*.avb" # bins path
BINSARRAY=(); # empty bins array
BININDEX=0 # start with first bin

# scan bins path and add bin paths to bins array
for bin in $BINS
do
	# echo "Processing $bin file..."
	BINSARRAY+=("$bin")
done

# add warning if not enough bins for unique bins. If not enough unique bins then they will be reused

# create master folder for projects
mkdir "$production""$seriesnumber"_PROJECTS
basedir=./"$production""$seriesnumber"_PROJECTS

for (( i=1; i <= episodes; i++ )) do

	# Adds a zero in front of episodes that are less than episode 10
	if [ "$i" -lt 10 ]; then
		currentEpisode=0"$i"
	else
		currentEpisode="$i"
	fi

	# notification creating episodes
	printf "%s\n\n" "################ Creating Episode $currentEpisode folders ################"
	destRootFolder="$basedir"/"$production""$seriesnumber"_EP"$currentEpisode"

	while IFS= read -r -d '' path
	do
	#   ((count++))

		# $path - Path created by 'find' - ./episode-template/!!!*prod*series_EP*episode_SCREENINGS
		# $seriesnumber - 19
		# $currentEpisode - 01
		# $production - TB
		# $destRootFolder - ./TB19_PROJECTS/TB19_EPISODE_01

		printf "Source Path:\t%s\n" "$path" # print original path
		# printf "Series Number:\t%s\n" "$seriesnumber" # print series number
		# echo "Current Episode: $currentEpisode" # print current episode
		# echo "Production: $production" # prints production
		# printf "Dest Root Path:\t%s\n" "$destRootFolder" # prints root destination

		# delete the ""./episode-template" part of the path
		[[ $path =~ \.\/episode-template(.*) ]] # extra file/folder with BASH_REMATCH
		truncPath=${BASH_REMATCH[1]}
		# this can be simplified as
		# TrunOriginalPath=${$path:19} Parameter Expansion - https://www.gnu.org/software/bash/manual/html_node/Shell-Parameter-Expansion.html

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
		printf "Dest Path:\t%s\n\n" "$destPath" # prints root destination

		# If path is a file
		if [ -f "$path" ] ; then
			if [[ "$path" == *".avb"* ]]; # If file is a bin
			then
				printf "%s\n" "AVID bin found"
				if [[ "$path" == *"*keep_"* ]]; 
				then # if bin is marked to keep from template
					printf "%s\n\n" "Keeping AVID bin"
					destPath="${destPath//\*keep_/}" # remove "*keep_" from destination bin
					cp "$path" "$destPath" # copying bin to destination
				else # If normal bin
					printf "%s\n" "Creating new AVID bin" 
					# fetch path of a new bin
					bin=${BINSARRAY[$BININDEX]}
					echo "fetching bin $BININDEX: $bin"
					# copy new bin to destination path
					printf "%s\n" "Copying bin to destination $destPath"
					cp "$bin" "$destPath"
					# increment bin index
					((BININDEX++)) # not incrementing
				fi
			# else
			else
				printf "%s\n" "Copying general file"
				cp "$path" "$destPath"
			fi
	
			printf "%s\n\n" "copy destin: $destPath"
		fi

		# If path is a directory
		if [ -d "$path" ] ; then
			printf "%s\n\n" "copying directory"
			mkdir -p -v "$path" "$destPath"
		fi
	done <   <(find ./episode-template -print0)
done




# # create master folder for projects
# mkdir "$production""$seriesnumber"_PROJECTS
# basedir=./"$production""$seriesnumber"_PROJECTS

# function to rename paths with the variables
# currently not being used
function renamePath {
	truncOriginalPath="${truncOriginalPath//\*series/$2}" # replace series
	truncOriginalPath="${truncOriginalPath//\*episode/$3}" # replace episode
	truncOriginalPath="${truncOriginalPath//\*prod/$4}" # replace production
}

# This creates the folder structure of an episode
function createProjects {

	# "$1" - {} - Path created by 'find' - ./episode-template/!!!*prod*series_EP*episode_SCREENINGS
	# "$2" - $seriesnumber - 19
	# "$3" - $currentEpisode - 01
	# "$4" - $production - TB
	# "$5" - $destRootFolder - ./TB19_PROJECTS/TB19_EPISODE_01

	# original source path
	originalPath="$1"

	printf "Source Path:\t%s\n" "$originalPath" # print original path
	# echo "Series Number: $2" # print series number
	# echo "Current Episode: $3" # print current episode
	# echo "Production: $4" # prints production
	# printf "Dest Path:\t%s\n" "$5" # prints root destination

	# truncate original path to remove the leading ./episode-template/01_*prod...
	[[ $originalPath =~ \.\/episode-template(.*) ]] # match stored in BASH_REMATCH
	truncOriginalPath=${BASH_REMATCH[1]}
	# this can be simplified as
	# TrunOriginalPath=${$1:19} Parameter Expansion - https://www.gnu.org/software/bash/manual/html_node/Shell-Parameter-Expansion.html

	# run path through pattern replacement 
	# "${source/findPattern/replaceWith}" # replace first occurance
	# "${source//findPattern/replaceWith}" # replace all occurances
	# If pattern begins with ‘/’, all matches of pattern are replaced.
	# If the nocasematch shell option (see the description of shopt in The Shopt Builtin) is enabled, the match is performed without regard to the case of alphabetic characters
	# More info on pattern matching https://www.gnu.org/software/bash/manual/html_node/Pattern-Matching.html
	truncOriginalPath="${truncOriginalPath//\*series/$2}" # replace series
	truncOriginalPath="${truncOriginalPath//\*episode/$3}" # replace episode
	truncOriginalPath="${truncOriginalPath//\*prod/$4}" # replace production
	# truncOriginalPath=${truncOriginalPath/"*series"/"$seriesnumber"}
	# test=${test/"*episode"/"$seriesnumber"}

	# building the destination path
	destPath="$5""$truncOriginalPath"

	# If path is a file
	if [ -f "$originalPath" ] ; then

		printf "%s\n" "copy source: $1"

		if [[ "$originalPath" == *".avb"* ]]; # If an AVID bin
		then
			printf "%s\n" "AVID bin found"
			if [[ "$originalPath" == *"*keep_"* ]]; # if the AVID bin is marked as "*keep_"
			then
				printf "%s\n\n" "Keeping and duplicating AVID bin"
				destPath="${destPath//\*keep_/}" # remove "*keep_" from file name in destination path
				cp "$originalPath" "$destPath" # copy bin to destination
			else
				printf "%s\n\n" "Creating new AVID bin" # If the AVID bin is not marked to keep
				# echo "Process bin $BININDEX: ${BINSARRAY[$BININDEX]}"
				echo "Process bin $BININDEX: ${BINSARRAY}"
				echo "${BINSARRAY[0]}"
				

				# then fetch path of a new bin
				# copy new bin to destination path
				# store source file name from original path
				# rename new bin to source file name
				# increment bin index
				((BININDEX++)) # not incrementing
			fi
		# else
		else
			printf "%s\n" "General file found"
			printf "%s\n" "Copying file"
			cp "$originalPath" "$destPath"
		fi
			
		printf "%s\n\n" "copy destin: $destPath"
	fi

	# If path is a directory
	if [ -d "$1" ] ; then
		printf "%s\n\n" "copying directory"
		mkdir -p -v "$originalPath" "$destPath"
	fi
}

# # not sure why we need to export the function but this is necessary when using it with "find"
# export -f createProjects

# for (( i=1; i <= episodes; i++ )) do

# 	# Adds a zero in front of episodes that are less than episode 10
# 	if [ "$i" -lt 10 ]; then
#     	currentEpisode=0"$i"
# 	else
# 		currentEpisode="$i"
# 	fi

# 	# notification creating episodes
# 	printf "%s\n\n" "################ Creating Episode $currentEpisode folders ################"
# 	destRootFolder="$basedir"/"$production""$seriesnumber"_EP"$currentEpisode"
	
# 	# traverses the episode template and each result is fed into "createProjects"
# 	# Important it's written this way because of end of part 6 here http://mywiki.wooledge.org/UsingFind
# 	find ./episode-template -exec bash -c 'createProjects "$1" "$2" "$3" "$4" "$5"' _ {} "$seriesnumber" "$currentEpisode" "$production" "$destRootFolder" \;
# done


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

# pat='[^0-9]+([0-9]+)'
# s='I am a string with some digits 1024'
# [[ $s =~ $pat ]] # $pat must be unquoted
# echo "${BASH_REMATCH[0]}" # The full string
# echo "${BASH_REMATCH[1]}" # the part extracted with regex