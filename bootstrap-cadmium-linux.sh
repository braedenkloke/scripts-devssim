#!/bin/sh
# 
# Bootstraps Cadmium for Linux.

CADMIUM_ENV_FILE=~/.env-cadmium
CADMIUM_PROJECTS_DIR=~/cadmium-projects # Where all your Cadmium projects will go
LATEST_CADMIUM_BRANCH=dev-rt # As per Cadmium v2 Installation Manual

if ! [ -d $CADMIUM_PROJECTS_DIR ]; then
	# Create directory for Cadmium projects
	mkdir $CADMIUM_PROJECTS_DIR
	
	# Install Cadmium
	cd $CADMIUM_PROJECTS_DIR
	git clone https://github.com/Sasisekhar/cadmium_v2 --single-branch -b $LATEST_CADMIUM_BRANCH 
	cd cadmium_v2
	chmod +x build.sh
	echo no | source build.sh 	# First pipe segment is the response to the build script's user prompt.
					# The build script asks the user if they would like to add Cadmium to their path.
	cd ~ # Reset to home directory
else
	echo 'Directory' $CADMIUM_PROJECTS_DIR 'already exists: Cautiously aborting Cadmium installation.'
fi

if ! [ -f $CADMIUM_ENV_FILE ]; then
	# Create Cadmium environment 
	touch $CADMIUM_ENV_FILE
	echo 'export CADMIUM='$CADMIUM_PROJECTS_DIR'/cadmium_v2/include' >> $CADMIUM_ENV_FILE
	echo 'export PATH=$CADMIUM:$PATH' >> $CADMIUM_ENV_FILE
	source $CADMIUM_ENV_FILE
else
	echo 'File' $CADMIUM_ENV_FILE 'already exists: Aborting, with great care, Cadmium environment creation.'
fi

echo 'All done.'
echo 'Good Labouring Under Correct Knowledge, i.e., good luck.'

