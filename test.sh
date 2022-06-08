#!/bin/bash

# Settings
DURATION=5
TRANSITION_TIME=3
COUNTER=1
VIDEO_INDEX=0
RESOLUTION="3840:2160"
OUT_FILE="video.mp4"

# Cleanup
rm -f *.txt

# Command arguments build
for files in *.jpg; do
  LOOP="-loop 1 -t $DURATION -i $files "
  if [ $VIDEO_INDEX -eq 0 ]
  then
    TRANSITION="[$VIDEO_INDEX:v]scale=$RESOLUTION:force_original_aspect_ratio=decrease,pad=$RESOLUTION:(ow-iw)/2:(oh-ih)/2,setsar=1,fade=t=in:st=0:d=$TRANSITION_TIME,fade=t=out:st=$DURATION:d=$TRANSITION_TIME[v$VIDEO_INDEX]; "
  else TRANSITION="[$VIDEO_INDEX:v]scale=$RESOLUTION:force_original_aspect_ratio=decrease,pad=$RESOLUTION:(ow-iw)/2:(oh-ih)/2,setsar=1,fade=t=in:st=0:d=$TRANSITION_TIME,fade=t=out:st=$DURATION:d=$TRANSITION_TIME[v$VIDEO_INDEX]; "
  fi
  VIDEOS="[v$VIDEO_INDEX]"
  echo -n $VIDEOS >> video_index.txt
  echo $LOOP >> loop.txt
  echo $TRANSITION >> transition.txt
  COUNTER=$[$COUNTER +1] 
  VIDEO_INDEX=$[$VIDEO_INDEX +1]
done

LOOP_INPUT=$(<loop.txt)
TRANSITION_SETTINGS=$(<transition.txt)
VIDEO_ARRAY=$(<video_index.txt)
SETTINGS=\"$TRANSITION_SETTINGS
VIDEO_SETTINGS="$SETTINGS $VIDEO_ARRAY concat=n=$VIDEO_INDEX:v=1:a=0,format=yuv420p[v]\" -map \"[v]\" -map $VIDEO_INDEX:a -shortest $OUT_FILE"
ARGUMENTS="$LOOP_INPUT -i music.mp3 -filter_complex $VIDEO_SETTINGS"
echo $ARGUMENTS

# Main
echo "============================= INICIANDO SLIDESHOW ============================="
echo
#eval ffmpeg -hide_banner -nostats -loglevel 0 $ARGUMENTS
eval ffmpeg -v quiet -stats $ARGUMENTS
echo
echo "============================= SLIDESHOW FINALIZADO ============================"
