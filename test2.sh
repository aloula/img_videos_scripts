ffmpeg \
-loop 1 -t 3 -i 1.jpg \
-loop 1 -t 3 -i 2.jpg \
-loop 1 -t 3 -i i3.jpg \
-filter_complex \
"[1]fade=d=1:t=in:alpha=1,setpts=PTS-STARTPTS+2/TB[f0]; \
 [2]fade=d=1:t=in:alpha=1,setpts=PTS-STARTPTS+4/TB[f1]; \
 [3]fade=d=1:t=in:alpha=1,setpts=PTS-STARTPTS+6/TB[f2]; \
 [0][f0]overlay[bg1];[bg1][f1]overlay[bg2];[bg2][f2]overlay[bg3]; \
 [bg3][f3]overlay,format=yuv420p[v]" -map "[v]" -r 25 output-crossfade.mp4