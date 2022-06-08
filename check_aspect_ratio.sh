#!/bin/bash

for file in *.jpg; do
    a=$(identify -format "w=%w;h=%h" $file)
    eval $a
    if [ "$w" -ge "$h" ]
    then
    echo 'landscape'
    else
    echo 'portrait'
    fi
done

