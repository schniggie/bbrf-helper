#!/bin/bash

# Fuzz URLs with afuzz and add all with status 200
# Requirments: afuzz, jq


while read -r line; do afuzz -u $line; done < <(bbrf urls -r);
cat result/* | jq -r '.result[] | select ( .status | contains(200) ) | .url + " " + (.status|tostring) + " " + (.length[]|tostring)' | bbrf url add - -p @INFER --show-new
