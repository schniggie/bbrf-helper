#!/bin/bash

# Generate/Brute new subdomains based on current assets
# Requirements: alterx, puredns
# Blog: https://cramppet.github.io/regulator/index.html

bbrf domains > program.subs
cat program.subs | alterx -en -o program.brute
wget https://raw.githubusercontent.com/janmasarik/resolvers/master/resolvers.txt
puredns resolve program.brute --write program.valid
cat program.valid | bbrf domain add - -p @INFER -s alterx --show-new
