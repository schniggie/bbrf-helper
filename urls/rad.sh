#!/bin/bash

# Crawl root URLs with rad and Update all URLs with full reponse in tag
# Requirements: rad, httpx, uro, https://github.com/schniggie/httpx2bbrf

while read -r line; do
~/hacktools/rad/rad_linux_amd64 --json rad/${line##h*/}.json --target $line; 
done < <(bbrf urls -r);

# Import all GET Requests
cat rad/*.json | jq -r '.[] | select ( .Method | contains("GET") ) | .URL' | uro | grep -Eiv ".(jpg|jpeg|gif|css|tif|tiff|png|ttf|woff|woff2|ico|pdf|svg)" | httpx -include-response -json -silent | tee >(httpx2bbrf -s rad --show-new)
cat rad/*.json | jq -r '[.[] | select ( .Method | contains("POST") ) | .URL, (.b64_body | @base64d)] | @csv' | tee rad/post.csv
