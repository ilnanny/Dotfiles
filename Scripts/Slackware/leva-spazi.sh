#!/bin/bash
# lanciare lo script nella cartella contenente i file da rinominare
# rinomino i file togliendo gli spazi e inserendo un trattino
for file in *.txt;
do
nuovo_nome=`echo $file | sed "s/ /-/g"`
    mv "$file" "$nuovo_nome"
done
