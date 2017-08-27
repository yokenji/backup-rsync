# Backup with rsync
This script has been written to backup files to my NAS.

## Requirements
minimum bash 4.

## Usage
Set the following variables.
```
USER=user_name_of_remote_server
PWD=passord_of_remote_server
SERVER=remote_server
```

Define the mount points as follow:
```
MOUNT_MAP["movies"]="/Volumes/movies"
MOUNT_MAP["music"]="/Volumes/music"
```

Define the folders to sync as follow:
```
SYNC_MAP["/Users/yokenji/movies"]=$MOUNT_MAP["movies"]
SYNC_MAP["/Users/yokenji/music"]=$MOUNT_MAP["music"]
```

Folders or files that must be excluded can be added to excludes.txt file.
```
.DS_Store
.git
.gitignore
.txt
```