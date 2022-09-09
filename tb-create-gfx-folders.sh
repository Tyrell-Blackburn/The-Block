#!/bin/bash

# A script used to automatically create the folder structures used in the TV Show The Block

# Created by Tyrell Blackburn
# https://github.com/tyrell-blackburn

echo "Welcome to The Block create GFX folders script"

read -p "Enter the series number: " seriesnumber
read -p "Enter how many episodes: " episodes

series=TB"$seriesnumber"

# Import folder scripts
# These will create the following folder structure

# TB19_EPISODE_GFX
# 	TB19_EP01_GFX
# 		TB19_EP01_GFX_FLOOR_PLANS
# 		TB19_EP01_GFX_LINE_DRAWINGS
# 	TB19_EP02_GFX
# 	TB19_EP03_GFX

function createImportSubFolders {

  mkdir "$series"_EP"$1"_GFX
  cd "$series"_EP"$1"_GFX
  mkdir "$series"_EP"$1"_GFX_FLOOR_PLANS	
  mkdir "$series"_EP"$1"_GFX_LINE_DRAWINGS
  cd ..

}

function createImportFolders {

	episodeGFX="$series"_EPISODE_GFX
	mkdir $episodeGFX
	cd $episodeGFX

	for (( i=1; i <= $episodes; i++ ))
	do
		# Add a zero to the front of episode numbers under 10
		if [ $i -lt 10 ]
			then
				createImportSubFolders "0$i"
				continue
		fi

		createImportSubFolders "$i"
	done

	cd ..
}

# Create the import folders
createImportFolders

# Export folder scripts
# These will create the following folder structure

# TB19_EXPORTS
# 	TB19_TO_RUSS_LINE_DRAWINGS
# 		TB19_EP01_TO_RUSS
# 		TB19_EP02_TO_RUSS
# 	TB19_TO_TOM_FLOOR_PLANS
# 		TB19_EP01_TO_TOM
# 		TB19_EP02_TO_TOM

function createExportSubFolders {

	subfolder="$series"_"$1"_"$2"
	mkdir $subfolder
  	cd $subfolder

	for (( i=1; i <= $episodes; i++ ))
	do	
		if [ $i -lt 10 ]
			then
				mkdir "$series"_EP"0$i"_"$1"
				continue
		fi

		mkdir "$series"_EP"$i"_"$1"
	done

	cd ..

}

function createExportFolders {

	toRuss='TO_RUSS'
	toTom='TO_TOM'

	exportFolder="$series"_EXPORTS
	mkdir $exportFolder
	cd $exportFolder

	createExportSubFolders $toRuss 'LINE_DRAWINGS'
	createExportSubFolders $toTom "FLOOR_PLANS"

}

# Create the export folders
createExportFolders