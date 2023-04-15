#!/bin/bash

# Crawl root URLs with rad and Update all URLs with full reponse in tag
# Requirements: rad, httpx, https://github.com/schniggie/httpx2bbrf

while read -r line; do
~/hacktools/rad/rad_linux_amd64 --text ${line##h*/}_rad --target $line; done < <(bbrf urls -r);
cat result/* |

| httpx -include-response -json -silent | tee >(httpx2bbrf --show-new)
