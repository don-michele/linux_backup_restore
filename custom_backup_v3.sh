#!/bin/bash

### Define functions

# Get current used distro

get_distro()
{
	RESULT=$(lsb_release -i | awk '{print $3}')
	RC_DISTRO=$?
	if [ $RC_DISTRO -eq 0 ]
	then
		#export LINUX_DISTRO=$RESULT
		export LINUX_DISTRO=$(echo $RESULT | tr '[:upper:]' '[:lower:]')
	else
		#export LINUX_DISTRO=$(grep ^ID /etc/os-release | cut -f 2 -d '=')
		RESULT=$(grep ^ID /etc/os-release | cut -f 2 -d '=')
		export LINUX_DISTRO=$(echo $RESULT | tr '[:upper:]' '[:lower:]')
	fi
	echo "Current Linux distribution used: $LINUX_DISTRO"
}

# Firefox backup

file_backup_firefox()
{
	if [ ! -d $1 ]
	then
		echo "Target directory to backup to does not exist!"
		break
	elif [ ! -d $HOME/.mozilla ]
	then
		echo "Default Mozilla config directory does not exist!"
		break
	elif [ ! -d $HOME/.mozilla/firefox ] 
	then
		echo "Default Firefox config directory does not exist!"
		break
	elif [ ! -f $HOME/.mozilla/firefox/profiles.ini ]
	then
		echo "Default profile file is missing!"
		break
	else
		PROFILE_NAME=$(grep ^Path $HOME/.mozilla/firefox/profiles.ini | cut -f 2 -d '=')
		RC_PROFILE=$?
		if [ $RC_PROFILE -ne 0 ]
		then
			echo "Firefox profile is missing!"
			break
		else
			SOURCE_LOCATION=$HOME/.mozilla/firefox/$PROFILE_NAME
			TARGET_LOCATION=$1
			cd $SOURCE_LOCATION
			echo "I reached $(pwd) path!"
			echo "Starting Firefox backup..."
			echo "You will have to choose what to backup!"
			
			# Backup for bookmark

			echo -n "Do you want to backup bookmark? Press y for yes or n for no: "
			read BOOKMARK_OPTION
			while [ "$BOOKMARK_OPTION" != "y" ] && [ "$BOOKMARK_OPTION" != "n" ]
			do
				echo -n "Invalid choice! Type y for yes or n for no!"
				read BOOKMARK_OPTION
			done
			if [ $BOOKMARK_OPTION == "y" ]
			then
				echo "Starting backup for bookmark..."
				BOOKMARK_FILE=places.sqlite
				if [ -f $SOURCE_LOCATION/$BOOKMARK_FILE ]
				then
					echo "Bookmark file exists!"
					echo "Creating bookmark backup..."
					cp -f $SOURCE_LOCATION/$BOOKMARK_FILE $TARGET_LOCATION
					RC_COPY_BOOKMARK=$?
					if [ $RC_COPY_BOOKMARK -eq 0 ]
					then
						echo "Bookmark backup created successfully!"
					else
						echo "Failed to create backup for bookmark!"
					fi
				else
					echo "Bookmark file does not exist!"
					echo "Can not create backup!"
				fi
			else
				echo "Bookmark backup will not be created!"
			fi

			# Backup for cookies

			echo -n "Do you want to backup cookies? Press y for yes or n for no: "
			read COOKIES_OPTION
			while [ "$COOKIES_OPTION" != "y" ] && [ "$COOKIES_OPTION" != "n" ]
			do
				echo -n "Invalid choice! Type y for yes or n for no!"
				read COOKIES_OPTION
			done
			if [ $COOKIES_OPTION == "y" ]
			then
				echo "Starting backup for cookies..."
				COOKIES_FILE=cookies.sqlite
				if [ -f $SOURCE_LOCATION/$COOKIES_FILE ]
				then
					echo "Cookies file exists!"
					echo "Creating cookies backup..."
					cp -f $SOURCE_LOCATION/$COOKIES_FILE $TARGET_LOCATION
					RC_COPY_COOKIES=$?
					if [ $RC_COPY_COOKIES -eq 0 ]
					then
						echo "Cookies backup created successfully!"
					else
						echo "Failed to create backup for cookies!"
					fi
				else
					echo "Cookies file does not exist!"
					echo "Can not create backup!"
				fi
			else
				echo "Cookies backup will not be created!"
			fi	

			# Backup for preferences

			echo -n "Do you want to backup preferences (homepage and others) ? Press y for yes or n for no: "
			read PREFS_OPTION
			while [ "$PREFS_OPTION" != "y" ] && [ "$PREFS_OPTION" != "n" ]
			do
				echo -n "Invalid choice! Type y for yes or n for no!"
				read PREFS_OPTION
			done
			if [ $PREFS_OPTION == "y" ]
			then
				echo "Starting backup for preferences..."
				PREFS_FILE=prefs.js
				if [ -f $SOURCE_LOCATION/$PREFS_FILE ]
				then
					echo "Prefereces file exists!"
					echo "Creating preferences backup..."
					cp -f $SOURCE_LOCATION/$PREFS_FILE $TARGET_LOCATION
					RC_COPY_PREFS=$?
					if [ $RC_COPY_PREFS -eq 0 ]
					then
						echo "Preferences backup created successfully!"
					else
						echo "Failed to create backup for preferences!"
					fi
				else
					echo "Preferences file does not exist!"
					echo "Can not create backup!"
				fi
			else
				echo "Preferences backup will not be created!"
			fi	

		fi
	fi
}

# Firefox restore

file_restore_firefox()
{
	if [ ! -d $1 ]
	then
		echo "Source directory to restore from does not exist!"
		break
	elif [ ! -d $HOME/.mozilla ]
	then
		echo "Default Mozilla config directory does not exist!"
		break
	elif [ ! -d $HOME/.mozilla/firefox ] 
	then
		echo "Default Firefox config directory does not exist!"
		break
	elif [ ! -f $HOME/.mozilla/firefox/profiles.ini ]
	then
		echo "Default profile file is missing!"
		break
	else
		PROFILE_NAME=$(grep ^Path $HOME/.mozilla/firefox/profiles.ini | cut -f 2 -d '=')
		RC_PROFILE=$?
		if [ $RC_PROFILE -ne 0 ]
		then
			echo "Firefox profile is missing!"
			break
		else
			SOURCE_LOCATION=$1
			TARGET_LOCATION=$HOME/.mozilla/firefox/$PROFILE_NAME
			echo "Starting Firefox restore..."
			echo "You will have to choose what to restore!"
			
			# Restore for bookmark

			echo -n "Do you want to restore bookmark? Press y for yes or n for no: "
			read BOOKMARK_OPTION
			while [ "$BOOKMARK_OPTION" != "y" ] && [ "$BOOKMARK_OPTION" != "n" ]
			do
				echo -n "Invalid choice! Type y for yes or n for no!"
				read BOOKMARK_OPTION
			done
			if [ $BOOKMARK_OPTION == "y" ]
			then
				echo "Starting restore for bookmark..."
				#BOOKMARK_FILE=places.sqlite
				BOOKMARK_FILE=bucmarc
				if [ -f $SOURCE_LOCATION/$BOOKMARK_FILE ]
				then
					echo "Bookmark file exists!"
					echo "Restoring bookmark..."
					cp -f $SOURCE_LOCATION/$BOOKMARK_FILE $TARGET_LOCATION
					RC_COPY_BOOKMARK=$?
					if [ $RC_COPY_BOOKMARK -eq 0 ]
					then
						echo "Bookmark restored successfully!"
					else
						echo "Failed to restore bookmark!"
					fi
				else
					echo "Bookmark file does not exist!"
					echo "Can not restore!"
				fi
			else
				echo "Bookmark will not be restored!"
			fi

			# Restore for cookies

			echo -n "Do you want to restore cookies? Press y for yes or n for no: "
			read COOKIES_OPTION
			while [ "$COOKIES_OPTION" != "y" ] && [ "$COOKIES_OPTION" != "n" ]
			do
				echo -n "Invalid choice! Type y for yes or n for no!"
				read COOKIES_OPTION
			done
			if [ $COOKIES_OPTION == "y" ]
			then
				echo "Starting restore for cookies..."
				#COOKIES_FILE=cookies.sqlite
				COOKIES_FILE=cuchis
				if [ -f $SOURCE_LOCATION/$COOKIES_FILE ]
				then
					echo "Cookies file exists!"
					echo "Restoring cookies..."
					cp -f $SOURCE_LOCATION/$COOKIES_FILE $TARGET_LOCATION
					RC_COPY_COOKIES=$?
					if [ $RC_COPY_COOKIES -eq 0 ]
					then
						echo "Cookies restored successfully!"
					else
						echo "Failed to restore cookies!"
					fi
				else
					echo "Cookies file does not exist!"
					echo "Can not restore!"
				fi
			else
				echo "Cookies will not be restored!"
			fi	

			# Restore for preferences

			echo -n "Do you want to restore preferences (homepage and others) ? Press y for yes or n for no: "
			read PREFS_OPTION
			while [ "$PREFS_OPTION" != "y" ] && [ "$PREFS_OPTION" != "n" ]
			do
				echo -n "Invalid choice! Type y for yes or n for no!"
				read PREFS_OPTION
			done
			if [ $PREFS_OPTION == "y" ]
			then
				echo "Starting restore for preferences..."
				#PREFS_FILE=prefs.js
				PREFS_FILE=preferensis
				if [ -f $SOURCE_LOCATION/$PREFS_FILE ]
				then
					echo "Prefereces file exists!"
					echo "Restoring preferences..."
					cp -f $SOURCE_LOCATION/$PREFS_FILE $TARGET_LOCATION
					RC_COPY_PREFS=$?
					if [ $RC_COPY_PREFS -eq 0 ]
					then
						echo "Preferences restored successfully!"
					else
						echo "Failed to restore preferences!"
					fi
				else
					echo "Preferences file does not exist!"
					echo "Can not restore!"
				fi
			else
				echo "Preferences will not be restored!"
			fi	

		fi
	fi
}

# Chromium backup

file_backup_chromium()
{
	if [ ! -d $1 ]
	then
		echo "Target directory to backup to does not exist!"
		break
	elif [ ! -d $HOME/.config ]
	then
		echo "Default config directory does not exist!"
		break
	elif [ ! -d $HOME/.config/chromium ] 
	then
		echo "Default Chromium config directory does not exist!"
		break
	elif [ ! -d $HOME/.config/chromium/Default ]
	then
		echo "Default profile is missing!"
		break
	else
		#PROFILE_NAME=$(grep ^Path $HOME/.mozilla/firefox/profiles.ini | cut -f 2 -d '=')
		#RC_PROFILE=$?
		#if [ $RC_PROFILE -ne 0 ]
		#then
		#	echo "Firefox profile is missing!"
		#	break
		#else
			SOURCE_LOCATION=$HOME/.config/chromium/Default
			TARGET_LOCATION=$1
			#cd $HOME/.config/chromium/Default
			#echo "I reached $(pwd) path!"
			echo "Starting Chromium backup..."
			echo "You will have to choose what to backup!"
			
			# Backup for bookmark

			echo -n "Do you want to backup bookmark? Press y for yes or n for no: "
			read BOOKMARK_OPTION
			while [ "$BOOKMARK_OPTION" != "y" ] && [ "$BOOKMARK_OPTION" != "n" ]
			do
				echo -n "Invalid choice! Type y for yes or n for no!"
				read BOOKMARK_OPTION
			done
			if [ $BOOKMARK_OPTION == "y" ]
			then
				echo "Starting backup for bookmark..."
				BOOKMARK_FILE=Bookmarks
				if [ -f $SOURCE_LOCATION/$BOOKMARK_FILE ]
				then
					echo "Bookmark file exists!"
					echo "Creating bookmark backup..."
					cp -f $SOURCE_LOCATION/$BOOKMARK_FILE $TARGET_LOCATION
					RC_COPY_BOOKMARK=$?
					if [ $RC_COPY_BOOKMARK -eq 0 ]
					then
						echo "Bookmark backup created successfully!"
					else
						echo "Failed to create backup for bookmark!"
					fi
				else
					echo "Bookmark file does not exist!"
					echo "Can not create backup!"
				fi
			else
				echo "Bookmark backup will not be created!"
			fi

			# Backup for cookies

			echo -n "Do you want to backup cookies? Press y for yes or n for no: "
			read COOKIES_OPTION
			while [ "$COOKIES_OPTION" != "y" ] && [ "$COOKIES_OPTION" != "n" ]
			do
				echo -n "Invalid choice! Type y for yes or n for no!"
				read COOKIES_OPTION
			done
			if [ $COOKIES_OPTION == "y" ]
			then
				echo "Starting backup for cookies..."
				COOKIES_FILE=Cookies
				if [ -f $SOURCE_LOCATION/$COOKIES_FILE ]
				then
					echo "Cookies file exists!"
					echo "Creating cookies backup..."
					cp -f $SOURCE_LOCATION/$COOKIES_FILE $TARGET_LOCATION
					RC_COPY_COOKIES=$?
					if [ $RC_COPY_COOKIES -eq 0 ]
					then
						echo "Cookies backup created successfully!"
					else
						echo "Failed to create backup for cookies!"
					fi
				else
					echo "Cookies file does not exist!"
					echo "Can not create backup!"
				fi
			else
				echo "Cookies backup will not be created!"
			fi	

			# Backup for preferences

			echo -n "Do you want to backup preferences (homepage and others) ? Press y for yes or n for no: "
			read PREFS_OPTION
			while [ "$PREFS_OPTION" != "y" ] && [ "$PREFS_OPTION" != "n" ]
			do
				echo -n "Invalid choice! Type y for yes or n for no!"
				read PREFS_OPTION
			done
			if [ $PREFS_OPTION == "y" ]
			then
				echo "Starting backup for preferences..."
				PREFS_FILE=Preferences
				if [ -f $SOURCE_LOCATION/$PREFS_FILE ]
				then
					echo "Prefereces file exists!"
					echo "Creating preferences backup..."
					cp -f $SOURCE_LOCATION/$PREFS_FILE $TARGET_LOCATION
					RC_COPY_PREFS=$?
					if [ $RC_COPY_PREFS -eq 0 ]
					then
						echo "Preferences backup created successfully!"
					else
						echo "Failed to create backup for preferences!"
					fi
				else
					echo "Preferences file does not exist!"
					echo "Can not create backup!"
				fi
			else
				echo "Preferences backup will not be created!"
			fi	

		#fi
	fi
}

file_backup_chromium-browser()
{
	file_backup_chromium
}

# Chromium restore

file_restore_chromium()
{
	if [ ! -d $1 ]
	then
		echo "Source directory to restore from does not exist!"
		break
	elif [ ! -d $HOME/.config ]
	then
		echo "Default config directory does not exist!"
		break
	elif [ ! -d $HOME/.config/chromium ] 
	then
		echo "Default Chromium config directory does not exist!"
		break
	elif [ ! -d $HOME/.config/chromium/Default ]
	then
		echo "Default profile is missing!"
		break
	else
		#PROFILE_NAME=$(grep ^Path $HOME/.mozilla/firefox/profiles.ini | cut -f 2 -d '=')
		#RC_PROFILE=$?
		#if [ $RC_PROFILE -ne 0 ]
		#then
		#	echo "Firefox profile is missing!"
		#	break
		#else
			SOURCE_LOCATION=$1
			TARGET_LOCATION=$HOME/.config/chromium/Default
			#cd $HOME/.config/chromium/Default
			#echo "I reached $(pwd) path!"
			echo "Starting Chromium restore..."
			echo "You will have to choose what to restore!"
			
			# Restore for bookmark

			echo -n "Do you want to restore bookmark? Press y for yes or n for no: "
			read BOOKMARK_OPTION
			while [ "$BOOKMARK_OPTION" != "y" ] && [ "$BOOKMARK_OPTION" != "n" ]
			do
				echo -n "Invalid choice! Type y for yes or n for no!"
				read BOOKMARK_OPTION
			done
			if [ $BOOKMARK_OPTION == "y" ]
			then
				echo "Starting restore for bookmark..."
				#BOOKMARK_FILE=Bookmarks
				BOOKMARK_FILE=bucmarc
				if [ -f $SOURCE_LOCATION/$BOOKMARK_FILE ]
				then
					echo "Bookmark file exists!"
					echo "Restoring bookmark..."
					cp -f $SOURCE_LOCATION/$BOOKMARK_FILE $TARGET_LOCATION
					RC_COPY_BOOKMARK=$?
					if [ $RC_COPY_BOOKMARK -eq 0 ]
					then
						echo "Bookmark restored successfully!"
					else
						echo "Failed to restore bookmark!"
					fi
				else
					echo "Bookmark file does not exist!"
					echo "Can not restore!"
				fi
			else
				echo "Bookmark will not be restored!"
			fi

			# Restore for cookies

			echo -n "Do you want to restore cookies? Press y for yes or n for no: "
			read COOKIES_OPTION
			while [ "$COOKIES_OPTION" != "y" ] && [ "$COOKIES_OPTION" != "n" ]
			do
				echo -n "Invalid choice! Type y for yes or n for no!"
				read COOKIES_OPTION
			done
			if [ $COOKIES_OPTION == "y" ]
			then
				echo "Starting restore for cookies..."
				#COOKIES_FILE=Cookies
				COOKIES_FILE=cuchis
				if [ -f $SOURCE_LOCATION/$COOKIES_FILE ]
				then
					echo "Cookies file exists!"
					echo "Restoring cookies..."
					cp -f $SOURCE_LOCATION/$COOKIES_FILE $TARGET_LOCATION
					RC_COPY_COOKIES=$?
					if [ $RC_COPY_COOKIES -eq 0 ]
					then
						echo "Cookies restored successfully!"
					else
						echo "Failed to restore cookies!"
					fi
				else
					echo "Cookies file does not exist!"
					echo "Can not restore!"
				fi
			else
				echo "Cookies will not be restored!"
			fi	

			# Restore for preferences

			echo -n "Do you want to restore preferences (homepage and others) ? Press y for yes or n for no: "
			read PREFS_OPTION
			while [ "$PREFS_OPTION" != "y" ] && [ "$PREFS_OPTION" != "n" ]
			do
				echo -n "Invalid choice! Type y for yes or n for no!"
				read PREFS_OPTION
			done
			if [ $PREFS_OPTION == "y" ]
			then
				echo "Starting restore for preferences..."
				#PREFS_FILE=Preferences
				PREFS_FILE=preferensis
				if [ -f $SOURCE_LOCATION/$PREFS_FILE ]
				then
					echo "Prefereces file exists!"
					echo "Restoring preferences..."
					cp -f $SOURCE_LOCATION/$PREFS_FILE $TARGET_LOCATION
					RC_COPY_PREFS=$?
					if [ $RC_COPY_PREFS -eq 0 ]
					then
						echo "Preferences restored successfully!"
					else
						echo "Failed to restore preferences!"
					fi
				else
					echo "Preferences file does not exist!"
					echo "Can not restore!"
				fi
			else
				echo "Preferences will not be restored!"
			fi	

		#fi
	fi
}

file_restore_chromium-browser()
{
	file_restore_chromium
}

# Backup function

precheck_and_start()
{
	# Get directory path for the script and additional files

	SCRIPT_SOURCE_DIR=$(dirname $(realpath $0))
	RC_SCRIPT_SRC_DIR=$?
	if [ $RC_SCRIPT_SRC_DIR -ne 0 ]
	then
		if [ $(dirname $0) == '.' ]
		then
			SCRIPT_SOURCE_DIR=$(pwd)
		else
			SCRIPT_SOURCE_DIR=$(dirname $0)
		fi
	fi

	# Check if distro file exists

	if [ ! -f $SCRIPT_SOURCE_DIR/$LINUX_DISTRO ]
	then
		echo "A corresponding file for distribution $LINUX_DISTRO was not found!"
		echo "Your distribution is not currently supported!"
		echo "The program will exit now!"
		exit 1
	elif [ ! -r $SCRIPT_SOURCE_DIR/$LINUX_DISTRO ]
	then
		echo "The corresponding file for your distribution can not be read with the current running user!"
		echo "Please add read permissions to the file or try with a different user!"
		echo "The program will exit now!"
		exit 1
	else
		# Get the backup/restore directory

		ACTION_MODE=$1
		echo -n "Please type the directory (full path!) for $ACTION_MODE : "
		read CONTENT_DIR
		while [ ! -d $CONTENT_DIR ]
		do
			echo -n "$CONTENT_DIR does not exist! Please type an existing directory : "
			read CONTENT_DIR
		done

		# Check if the backup directory has write permissions

		if [ ! -r $CONTENT_DIR ] && [ ! -w $CONTENT_DIR ] && [ ! -x $CONTENT_DIR ]
		then
			echo "You don't have full permissions on directory $CONTENT_DIR!"
			echo "Please add full permissions on directory or try with a different user!"
			echo "The program will exit now!"
			exit 1
		else
			SOFTWARE_LIST=()
			while read software
			do
				SOFTWARE_LIST+=(file_${ACTION_MODE}_${software})
			done < ${LINUX_DISTRO}
		fi
	fi
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
			get_distro
			echo "Reading file $LINUX_DISTRO"
			precheck_and_start backup
			for software in ${SOFTWARE_LIST[@]}
			do
				$software $CONTENT_DIR
			done
			;;
		"r")
			echo "You chose restore" # To be replaced with restore branch
			get_distro
			echo "Reading file $LINUX_DISTRO"
			precheck_and_start restore
			for software in ${SOFTWARE_LIST[@]}
			do
				$software $CONTENT_DIR
			done
			;;
		"q")
			echo "You chose quit!" # To quit 
			exit 0
			;;
	esac
}

launch_script()
{
	file_backup_firefox /home/don-michele/stuff
	file_backup_chromium /home/don-michele/stuff
}

#launch_script
#get_distro
get_user_option
#file_backup_firefox /home/don-michele/stuff
#file_restore_firefox $HOME/ristor
#file_restore_chromium $HOME/ristor
