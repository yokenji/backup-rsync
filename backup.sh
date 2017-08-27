#!/usr/local/bin/bash

# Server Settings to mount the shares.
USER=""
PWD=""
SERVER=""

# Declare Associative arrays. 
declare -A MOUNT_MAP
declare -A SYNC_MAP

# Array of shares to be mounted.
#
# key=source, value=destination to mount.
MOUNT_MAP["photos"]="/Volumes/photos"

# Array of directories to be synced.
#
# key=source, value=destination to sync.
SYNC_MAP["/Users/kenji/Pictures/Photos Library.photoslibrary/Masters/"]="/Volumes/photos/imac/"

# Excluding specific files from sync.
declare SYNC_EXCLUDE
SYNC_EXCLUDE="excludes.txt"

# Rsync options.
# -v increase verbosity
# -a archive 
# -r recurse into directories
# -b make backups
# -t preserve modification times
# -h output numbers in human-readable format
# -z compress data when transmitted
# --exclude exclude files matching Pattern
PARAM="-azbhv --exclude-from=${SYNC_EXCLUDE[@]}"

# Start time of script.
START=$(date +%s)

# Mount a share.
# param $1 - src
# param $2 - dest
function mountShare() {

	# Check if the Share Software is mounted.
	if [ "$(mount | grep $2)" ]; then
		echo "$2 is already mounted"
	else
		echo "Try to mount $2"

		# Create the share directory.
		mkdir "$2"

		# Mount the share.
		mount_smbfs //$USER:$PWD@$SERVER/$1 $2

		# Check the results.
		if [ $? != 0 ]; then
			echo "Failed to mount $2"
		else
			echo "$2 is mounted"
		fi
	fi
}

# Unmount share.
# param $1 - share
function umountShare() {
	if [ "$(mount | grep $1)" ]; then
		echo "Try to unmount $1"

		# Umount the share.
		umount -f "$1"

		# Check the results.
		if [ $? != 0 ]; then
			echo "Failed to unmount $1"
		else
			echo "$1 is unmounted"
		fi;
	fi
}

# Sync
# param $1 - source
# param $2 - destination
function sync() {
	echo "Try to sync $1 with $2"
	rsync $PARAM "$1" "$2"

	# Check the result.
	if [ $? != 0 ]; then
		echo "Failed to sync $1"
	else
		echo "$1 is synced"
	fi
}

# Mount all shares.
for k in "${!MOUNT_MAP[@]}";
do 
  mountShare "$k" "${MOUNT_MAP[$k]}"
done

# Sync all Directories/Files
for k in "${!SYNC_MAP[@]}";
do	
	sync "$k" "${SYNC_MAP[$k]}"
done

# Umount all shares.
for k in "${!MOUNT_MAP[@]}"
do
	umountShare "${MOUNT_MAP[$k]}"
done

FINISH=$(date +%s)
DIFF=$(($FINISH - $START))
echo "$(($DIFF / 60)) minutes and $(($DIFF % 60)) seconds elapsed."