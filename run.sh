#!/bin/bash

# przejście po wszystkich katalogach w bieżącym folderze
for dir in */ ; do
    if [ -d "$dir" ]; then
        touch "${dir}start.txt"
        echo "Utworzono plik start.txt w katalogu: $dir"
    fi
done