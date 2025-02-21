#!/bin/bash

# Create an array to hold the input arguments for ffmpeg
inputs=()
filter_complex=""
index=0
duration=4
fade_duration=1

# Loop through all .jpg files in the current directory
for file in *.jpg; do
  inputs+=("-loop 1 -t $duration -i $file")
  filter_complex+="[$index:v]scale=3840:2160:force_original_aspect_ratio=decrease,pad=3840:2160:(ow-iw)/2:(oh-ih)/2,setsar=1[v$index]; "
  index=$((index + 1))
done

# Generate the crossfade transitions with a cumulative offset
for i in $(seq 0 $((index - 2))); do
  next=$((i + 1))
  # Compute the offset for the xfade filter
  offset=$(( (i + 1) * (duration - fade_duration) ))
  if [ $i -eq 0 ]; then
    filter_complex+="[v$i][v$next]xfade=transition=fade:duration=$fade_duration:offset=$offset[x$next]; "
  else
    filter_complex+="[x$i][v$next]xfade=transition=fade:duration=$fade_duration:offset=$offset[x$next]; "
  fi
done

# Add the music input and map the outputs
inputs+=("-i music.mp3")
map_args="-map [x$((index - 1))] -map $index:a -shortest video.mp4"

# Debug: print the complete ffmpeg command
echo "ffmpeg -y ${inputs[@]} -filter_complex \"$filter_complex\" $map_args"

# Run the ffmpeg command
ffmpeg -y ${inputs[@]} -filter_complex "$filter_complex" $map_args