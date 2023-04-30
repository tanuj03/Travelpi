#!/bin/bash

clear

#Locations

harddrive="/mnt/usb1/NAS/test/Portugal"
syncphoto="/mnt/usb1/NAS/test/sync/Portugal Photos"
syncvideo="/mnt/usb1/NAS/test/sync/Portugal Videos"
phone="/mnt/usb1/NAS/test/phone"
camera="/mnt/usb1/NAS/test/camera"
insta360="/mnt/usb1/NAS/test/insta360"


function check {

echo "Check:" 
if [ -n "$(ls -A "$harddrive")" ]; then
    # folder is not empty, execute command x
    echo "Hard Drive Conncted"
else
    # folder is empty, execute command y
    echo "Hard Drive Disconnected"
fi

if [ -n "$(ls -A "$phone")" ]; then
    # folder is not empty, execute command x
    echo "Phone Conncted"
else
    # folder is empty, execute command y
    echo "Phone Disconnected"
fi

if [ -n "$(ls -A "$camera")" ]; then
    # folder is not empty, execute command x
    echo "Camera Conncted"
else
    # folder is empty, execute command y
    echo "Camera Disconnected"
fi

if [ -n "$(ls -A "$insta360")" ]; then
    # folder is not empty, execute command x
    echo "Insta360 Conncted"
else
    # folder is empty, execute command y
    echo "Insta360 Disconnected"
fi

#restart script if not wanted devices is connected
echo "Do you want to continue? (y/n)"
read answer

if [ "$answer" == "y" ]; then
    # execute command X

    echo "Copy Process starts"
clear
    # command X goes here
elif [ "$answer" == "n" ]; then
    # execute command Y
    exec "$0" "$@"
fi
}

function name {

read -p "Name of Folder: " name

sudo mkdir -p "$harddrive"/"$name"
echo ""
echo "Coping:"
echo ""
}

function copyphone {
#Copying from phone to Hard Drive


if [ -n "$(ls -A "$phone")" ]; then


sudo mkdir -p "$harddrive"/"$name"/LGV60

# Count the number of files in the source directory
num_files=$(ls -1 "$phone" | wc -l)

# Set up the progress bar
bar_width=40
echo -ne "Coping files: ["
for ((i=0; i<$bar_width; i++)); do echo -ne " "; done
echo -ne "] 0%"

# Move files from source to target location
i=0
for file in "$phone"/*; do
    cp -f -r "$file" "$harddrive"/"$name"/LGV60
    ((i++))
    percent=$((i * 100 / num_files))
    # Update the progress bar
    echo -ne "\rCoping files from phone: ["
    progress=$((i * bar_width / num_files))
    for ((j=0; j<progress; j++)); do echo -ne "="; done
    for ((j=progress; j<bar_width; j++)); do echo -ne " "; done
    echo -ne "] $percent%"
done

echo ""
echo "Phone files has been copied"
echo ""


else
echo ""
echo "No Files to be copied from Phone"
echo ""
fi
}

function copycamera {

#Copying from camera to Hard Drive


if [ -n "$(ls -A "$camera")" ]; then


sudo mkdir -p "$harddrive"/"$name"/M50

# Count the number of files in the source directory
num_files=$(ls -1 "$camera" | wc -l)

# Set up the progress bar
bar_width=40
echo -ne "Coping files: ["
for ((i=0; i<$bar_width; i++)); do echo -ne " "; done
echo -ne "] 0%"

# Move files from source to target location
i=0
for file in "$camera"/*; do
    cp -f -r "$file" "$harddrive"/"$name"/M50
    ((i++))
    percent=$((i * 100 / num_files))
    # Update the progress bar
    echo -ne "\rCoping files from Camera SD Card: ["
    progress=$((i * bar_width / num_files))
    for ((j=0; j<progress; j++)); do echo -ne "="; done
    for ((j=progress; j<bar_width; j++)); do echo -ne " "; done
    echo -ne "] $percent%"
done

echo ""
echo "Camera files has been copied"
echo ""


else
echo ""
echo "No Files to be copied from Camera"
echo ""
fi
}

function copyinsta360 {
#Copying from Insta360 to Hard Drive


if [ -n "$(ls -A "$insta360")" ]; then


sudo mkdir -p "$harddrive"/"$name"/Insta360

# Count the number of files in the source directory
num_files=$(ls -1 "$insta360" | wc -l)

# Set up the progress bar
bar_width=40
echo -ne "Coping files: ["
for ((i=0; i<$bar_width; i++)); do echo -ne " "; done
echo -ne "] 0%"

# Move files from source to target location
i=0
for file in "$insta360"/*; do
    cp -f -r "$file" "$harddrive"/"$name"/Insta360
    ((i++))
    percent=$((i * 100 / num_files))
    # Update the progress bar
    echo -ne "\rCoping files from Insta360 SD Card: ["
    progress=$((i * bar_width / num_files))
    for ((j=0; j<progress; j++)); do echo -ne "="; done
    for ((j=progress; j<bar_width; j++)); do echo -ne " "; done
    echo -ne "] $percent%"
done

echo ""
echo "Insta360 files has been copied"
echo ""


else
echo ""
echo "No Files to be copied from Insta360"
echo ""
fi
}

function syncphone {
echo ""
echo "Synthing Process:"
echo ""
echo "Phone"
# Specify the folder you want to check
FOLDER_PATH=""$harddrive"/"$name"/LGV60"

# Check if the folder exists
if [ -d "$FOLDER_PATH" ]; then
  # If the folder exists, execute command X
  # Specify the source folder you want to check for files
SOURCE_FOLDER=""$harddrive"/"$name"/LGV60"

# Check if the source folder exists
if [ -d "$SOURCE_FOLDER" ]; then
  # Copy all .mp4 files to MP4_DESTINATION folder
  mp4_files=$(find "$SOURCE_FOLDER" -name '*.mp4' -o -name '*.MP4' -type f)
  mp4_count=$(echo "$mp4_files" | wc -l)
  if [ "$mp4_count" -gt 0 ]; then
    mp4_progress=0
	sudo mkdir -p "$syncvideo"/"$name"/LGV60
	MP4_DESTINATION=""$syncvideo"/"$name"/LGV60"
    for mp4_file in $mp4_files; do
      cp "$mp4_file" "$MP4_DESTINATION" && \
      ((mp4_progress++)) && \
      echo -ne "	Videos [$mp4_progress/$mp4_count] ($((100 * mp4_progress / mp4_count))%)\r"
    done
    echo -ne '\n'
  else
    echo "	No .mp4 files found"
  fi
  
  # Copy all .DNG files to DNG_DESTINATION folder
  DNG_files=$(find "$SOURCE_FOLDER" -name '*.dng' -o -name '*.DNG'  -type f)
  DNG_count=$(echo "$DNG_files" | wc -l)
  if [ "$DNG_count" -gt 0 ]; then
    DNG_progress=0
	sudo mkdir -p "$syncphoto"/"$name"/LGV60/DNG
	DNG_DESTINATION=""$syncphoto"/"$name"/LGV60/DNG"
    for DNG_file in $DNG_files; do
      cp "$DNG_file" "$DNG_DESTINATION" && \
      ((DNG_progress++)) && \
      echo -ne "	Raw Photos [$DNG_progress/$DNG_count] ($((100 * DNG_progress / DNG_count))%)\r"
    done
    echo -ne '\n'
  else
    echo "	No .DNG files found"
  fi

  # Copy all .jpeg files to JPEG_DESTINATION folder
  jpeg_files=$(find "$SOURCE_FOLDER" -name '*.jpeg' -o -name '*.jpg' -type f)
  jpeg_count=$(echo "$jpeg_files" | wc -l)
  if [ "$jpeg_count" -gt 0 ]; then
    jpeg_progress=0
	sudo mkdir -p "$syncphoto"/"$name"/LGV60
	JPEG_DESTINATION=""$syncphoto"/"$name"/LGV60"
    for jpeg_file in $jpeg_files; do
      cp "$jpeg_file" "$JPEG_DESTINATION" && \
      ((jpeg_progress++)) && \
      echo -ne "	Photos [$jpeg_progress/$jpeg_count] ($((100 * jpeg_progress / jpeg_count))%)\r"
    done
    echo -ne '\n'
  else
    echo "	No .jpeg files found"
  fi
fi
fi

echo ""



}

function synccamera {

echo "Camera"
# Specify the folder you want to check
Camera_Path=""$harddrive"/"$name"/M50"

# Check if the folder exists
if [ -d "$Camera_Path" ]; then


# Check if the source folder exists
if [ -d "$Camera_Path" ]; then
  # Copy all .mp4 files to MP4_DESTINATION folder
  mp4_files=$(find "$Camera_Path" -name '*.mp4' -o -name '*.MP4' -type f)
  mp4_count=$(echo "$mp4_files" | wc -l)
  if [ "$mp4_count" -gt 0 ]; then
    mp4_progress=0
	sudo mkdir -p "$syncvideo"/"$name"/M50
	MP4_DESTINATION=""$syncvideo"/"$name"/M50"
    for mp4_file in $mp4_files; do
      cp "$mp4_file" "$MP4_DESTINATION" && \
      ((mp4_progress++)) && \
      echo -ne "	Videos [$mp4_progress/$mp4_count] ($((100 * mp4_progress / mp4_count))%)\r"
    done
    echo -ne '\n'
  else
    echo "	No .mp4 files found"
  fi
  
  # Copy all .cr3 files to cr3_DESTINATION folder
  cr3_files=$(find "$Camera_Path" -name '*.CR3' -o -name '*.cr3' -type f)
  cr3_count=$(echo "$cr3_files" | wc -l)
  if [ "$cr3_count" -gt 0 ]; then
    cr3_progress=0
	sudo mkdir -p "$syncphoto"/"$name"/M50
	cr3_DESTINATION=""$syncphoto"/"$name"/M50"
    for cr3_file in $cr3_files; do
      cp "$cr3_file" "$cr3_DESTINATION" && \
      ((cr3_progress++)) && \
      echo -ne "	Raw Photos [$cr3_progress/$cr3_count] ($((100 * cr3_progress / cr3_count))%)\r"
    done
    echo -ne '\n'
  else
    echo "	No .cr3 files found"
  fi

  
fi
fi

echo ""



}

function syncinsta360 {

echo "Insta360"
# Specify the folder you want to check
Insta360_Path=""$harddrive"/"$name"/Insta360"

# Check if the folder exists
if [ -d "$Insta360_Path" ]; then


# Check if the source folder exists
if [ -d "$Insta360_Path" ]; then
  # Copy all .insv files to insv_DESTINATION folder
  insv_files=$(find "$Insta360_Path" -name '*.INSV' -o -name '*.insv' -type f)
  insv_count=$(echo "$insv_files" | wc -l)
  if [ "$insv_count" -gt 0 ]; then
    insv_progress=0
	sudo mkdir -p "$syncvideo"/"$name"/Insta360
	insv_DESTINATION=""$syncvideo"/"$name"/Insta360"
    for insv_file in $insv_files; do
      cp "$insv_file" "$insv_DESTINATION" && \
      ((insv_progress++)) && \
      echo -ne "	Videos [$insv_progress/$insv_count] ($((100 * insv_progress / insv_count))%)\r"
    done
    echo -ne '\n'
  else
    echo "	No .insv files found"
  fi
  

  
fi
fi

echo ""



}

function finish {

echo "Copying and Syncing Process complete"


}


check
name
copyphone
copycamera
copyinsta360
syncphone
synccamera
syncinsta360
finish
