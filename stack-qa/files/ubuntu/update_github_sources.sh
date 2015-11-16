#!/bin/bash

# parent directory of github subdirs
T_PROJECT_PATH='/srv/www/'

# path to store logfiles
T_LOG_PATH='/tmp/'

# command to get a formatted date for log file names
T_DATE=`date +%Y%m%d_%H%M`

# list of github subdirs
L_PATHS=`ls -1 /srv/www/`

# git command
C_GIT=`which git`

# sudo command
C_SUDO=`which sudo`

# this should be automated by chef, I don't know how yet
V_USER='vagrantci'

for V_FILE in ${L_PATHS}
do
	V_ACTION_PATH="${T_PROJECT_PATH}${V_FILE}/current"
	V_LOGFILE="${T_LOG_PATH}${T_DATE}_${V_FILE}.log"
	V_GROUP=`stat -c '%G' ${V_ACTION_PATH}`
	V_USER=`stat -c '%U' ${V_ACTION_PATH}`

	# devine current branch
	# V_BRANCH=`sudo -u "${V_USER}" -g "${V_GROUP}" bash -c "cd \"${V_ACTION_PATH}\" && ${C_GIT} rev-parse --abbrev-ref HEAD"`

	# ignore current branch
	V_BRANCH="master"

	# debug echoing
	# echo "Processing ${V_FILE} at ${V_ACTION_PATH} as ${V_LOGFILE} with ${V_BRANCH}"
	# echo "sudo -u "${V_USER}" bash -c \"cd \"${V_ACTION_PATH}\" && ${C_GIT} pull origin ${V_BRANCH} >> \"${V_LOGFILE}\" 2>&1\""

	# As the user of the vagrant and the group of the code group, get into the directory and do a git pull
	# redirect ALL the output to a known file
	sudo -u "${V_USER}" bash -c "cd \"${V_ACTION_PATH}\" && ${C_GIT} pull origin ${V_BRANCH} >> \"${V_LOGFILE}\" 2>&1"
done
