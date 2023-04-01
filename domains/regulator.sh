#!/bin/bash

# Use regulator to generate/brute new subdomains
# Requirent: https://github.com/cramppet/regulator, puredns
# Blog: https://cramppet.github.io/regulator/index.html

cd regulator
bbrf domains > program.subs
python3 main.py -t program.com -f program.subs -o program.brute
wget https://raw.githubusercontent.com/janmasarik/resolvers/master/resolvers.txt
puredns resolve program.brute --write program.valid
cat program.valid | bbrf domain add - -p @INFER -s regulator --show-new
