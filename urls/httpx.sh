#!/bin/bash

# Update all URLs with full reponse in tag
# Requirements: httpx, https://github.com/schniggie/httpx2bbrf

bbrf urls -r | httpx -include-response -json -silent | tee >(httpx2bbrf --show-new)
