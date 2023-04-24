#!/bin/bash

# Crawl root URLs with webanalyze and Update all URLs with tags
# Requirements: webanalyze, httpx, https://github.com/schniggie/httpx2bbrf

while read -r line; do
webanalyze -host $line  -silent -output json | tee webanalyze/${line##h*/}.json;
done < <(bbrf urls -r);

# Import tags and update 
cat webanalyze/*.json  | jq -r '.hostname as $hostname | .matches[] | [.app.category_names[0], .app_name, .version] | select(length > 0) | [$hostname] + . | map( @sh ) | join(" ")' | tee webanalyze/webanalyze.tags
read -r url cat app version; do httpx -include-response -json -silent -u $url | httpx2bbrf -t $cat:$app.$version --append-tags; done < cat webanalyze/webanalyze.tags
