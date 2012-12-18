#!/bin/bash
FILES="CIY NPS GRN EYS EYL OSB OSS OSL OWT OTT OBS OPL IOY"
for abbrev in $FILES  
do 

  echo "$abbrev" 
  curl -o 2011_winners_semifinalists_${abbrev}.html http://www.techcolumbusinnovationawards.org/2011_winners_semifinalists_${abbrev}.html
done
