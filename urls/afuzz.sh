#!/bin/bash

# Fuzz URLs with afuzz
# Requirments: afuzz, jq

while read -r line; do afuzz -u $line; done < <(bbrf urls -r);
