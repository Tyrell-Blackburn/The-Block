#!/bin/bash

# A script used to automatically create Avid project folders

# Created by Tyrell Blackburn
# https://github.com/tyrell-blackburn

# How unique bins are are created within new projects

# When a new project is created from the template, the bins created will either be duplicates from the template, or they will be new bins.
# 1) Duplicate bins should be named with "duplicate_" at the front of the bin name so the script can identify them.
#	 These bins should contain content that you want to duplicate over every project. These bins cannot be opened over multiple projects at the same time or you will get the get the "Unable to open bin" error message.
#	 A prime example of a unique bin would be a "timecode" bin that contains a timecode layer you want editors to use across projects for consistency.
# 2) Bins that don't start with "duplicate_" will be recreated as a unique bins, and should be empty placeholder bins for a project.
#	 A typical example would be a "completed_requests" bin that edit assist drop requests into, or "outgoing GFX" bins that editors drop reference sequences into.
#	 Unique bins are technically not unique, but rather copied across to new project folders from a pool of unique bins in the "bins" folder.
#	 This folder should be populated by unique bins created in AVID.
#	 The way the script works is that when a new project folder is created, unique bins are taken one-by-one from the pool of bins like a queue, and renamed to what they should be based on the episode template.
#	 For example, if each project contains 10 bins. The episode 1 project will take bins 1 to 10, episode 2 will take bins 11 to 20 and so forth.
#	 For reference, every TB18 project contains XX unique bins, which would mean over 50 episodes you'd need XXX unique bins in the bins folder for every project to have unique bins.




echo "Welcome to The Block create projects script"
echo "This script will create projects with \"unique\" bins so you won't get the \"Unable to open bin\" error message."
echo "Before continuing, make sure you've customised the project template folder the way you want it in /Project-template."
echo "Bins that contain content you want copied over to each project, prepend their name with \"unique_\""

production=TB
seriesnumber=19
episodes=1

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




mkdir ./"$production""$seriesnumber"_PROJECTS



# function createprojects {
#     echo "$1" "$2" "$3"

# # split input string into an array with '/' as delimiter


# }

# export -f createprojects

# for (( i=1; i <= episodes; i++ ))
# do
# 	echo "$i"
# 	find ./episode-template -exec bash -c 'createprojects "{}" "$seriesnumber" "$i"' \;
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

# Examine the folder structure with a breadth depth first approach. 