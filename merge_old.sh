#!/bin/bash


mkdir -p "$PWD/converted" "$PWD/resized"

for file in *.jpg; do
  filename=$(basename -- "$file")
  filename_resized="$PWD/resized/${filename%.*}_resized.jpg"
  #filename_rotated="rotated/${filename%.*}_rotated.jpg"
  filename_converted="$PWD/converted/${filename%.*}_converted.jpg"
  echo "Convertendo $file..."
  convert -units PixelsPerInch $file -density 72 -resize 3840x2160 -quality 100 $filename_resized
  #convert $file -resize x2160 $filename_resized
  #convert $filename_resized -rotate 90 $filename_rotated
  convert uhd_black.png $filename_resized -gravity center -compose over -composite $filename_converted
done

echo "Finalizado!"

