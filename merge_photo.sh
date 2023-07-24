#!/bin/bash

cp /usr/local/bin/3x2.png "$PWD/3x2.png"
mkdir -p "$PWD/converted" "$PWD/resized"

for file in *.jpg; do
  filename=$(basename -- "$file")
  filename_resized="$PWD/resized/${filename%.*}_resized.jpg"
  #filename_rotated="rotated/${filename%.*}_rotated.jpg"
  filename_converted="$PWD/converted/${filename%.*}_converted.jpg"
  echo "Convertendo $file..."
  a=$(identify -format "w=%w;h=%h" $file)
    eval $a
    if [ "$w" -ge "$h" ]
    then
    convert "$PWD/$file" -resize x1800 -quality 100 "$filename_resized"
    else
    convert "$PWD/$file" -resize x1800 -quality 100 "$filename_resized"
    fi
  
  #convert $file -resize x2160 $filename_resized
  #convert $filename_resized -rotate 90 $filename_rotated
  convert "$PWD/3x2.png" "$filename_resized" -gravity center -compose over -composite "$filename_converted"
done

echo "Finalizado!"

