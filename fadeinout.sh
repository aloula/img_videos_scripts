#!/bin/bash

mkdir -p $PWD/fade

for f in *.mp4; do
  dur=$(ffprobe -loglevel error -show_entries format=duration -of default=nk=1:nw=1 "$f")
  offset=$(bc -l <<< "$dur"-1)
  ffmpeg -i "$f" -filter_complex "[0:v]fade=type=in:duration=2,fade=type=out:duration=2:start_time='$offset'[v];[0:a]afade=type=in:duration=2,afade=type=out:duration=2:start_time='$offset'[a]" -map "[v]" -map "[a]" -qp 18 fade/"$f"
done