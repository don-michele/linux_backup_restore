#!/bin/bash

### Define functions

# Get current used distro

get_distro()
{
	RESULT=$(lsb_release -i | awk '{print $3}')
	RC_DISTRO=$?
	if [ $RC_DISTRO -eq 0 ]
	then
		LINUX_DISTRO=$RESULT
	else
		LINUX_DISTRO=$(grep ^ID /etc/os-release | cut -f 2 -d '=')
	fi
	echo "Current Linux distribution used: $LINUX_DISTRO"
}

# Firefox backup

file_backup_firefox()
{
	if [ ! -d $HOME/.mozilla ]
	then
		echo "Default Mozilla config directory does not exist!"
		break
	elif [ ! -d $HOME/.mozilla/firefox ] 
	then
		echo "Default Firefox config directory does not exist!"
		break
	elif [ ! -f HOME/.mozilla/firefox/profiles.ini ]
	then
		echo "Default profile file is missing!"
		break
	fi
	BOOKMARK_FILE=places.sqlite
	HOMEPAGE_FILE=prefs.js
	COOKIE_FILE=cookies.sqlite
	echo "Starting Firefox backup..."
	echo "You will have to choose what to backup!"
	echo "Do you want to backup bookmark? Press y for yes or n for no: "
	read -p BOOKMARK_OPTION
	while [ "$BOOKMARK_OPTION" != "y" ] && [ "$BOOKMARK_OPTION" != "n" ]
	do
		echo "Invalid choice! Type y for yes or n for no!"
		read BOOKMARK_OPTION
	done
	if [ $BOOKMARK_OPTION == "y" ]
	then
		echo "Starting backup for bookmark..."
	fi
}

# Backup function

file_backup()
{

}

### Get user option : backup or restore

get_user_option()
{
	echo "Please choose what would you like to do: backup (press b), restore (press r) or quit (press q): "
	read USER_CHOICE
	while [ "$USER_CHOICE" != "b" ] && [ "$USER_CHOICE" != "r" ] && [ "$USER_CHOICE" != "q" ]
	do
		echo "Not a valid choice! Type b for backup, r for restore or q to quit!"
		read USER_CHOICE
	done
	case $USER_CHOICE in 
		"b")
			echo "You chose backup" # To be replaced with the backup branch
			;;
		"r")
			echo "You chose restore" # To be replaced with restore branch
			;;
		"q")
			echo "You chose quit!" # To quit 
			;;
	esac
}

get_distro
get_user_option