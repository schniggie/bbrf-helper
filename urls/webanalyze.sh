#!/bin/bash

# Crawl root URLs with webanalyze and Update all URLs with tags
# Requirements: webanalyze, httpx, https://github.com/schniggie/httpx2bbrf

while read -r line; do
webanalyze -host $line  -silent -output json | jq -r '.matches[] | .app_name + " " + .version';
done < <(bbrf urls -r);

# Import all GET Requests
cat rad/*.json | jq -r '.[] | select ( .Method | contains("GET") ) | .URL' | uro | grep -Eiv ".(jpg|jpeg|gif|css|tif|tiff|png|ttf|woff|woff2|ico|pdf|svg)" | httpx -include-response -json -silent | tee >(httpx2bbrf -s rad --show-new)
# Import all POST Requests
cat rad/*.json | jq -r '.[] | select ( .Method | contains("POST") ) | .URL +" "+ (.b64_body | @base64d)' | tee rad/post.req
read -r url postbody; do httpx -include-response -json -silent -u $url -x POST -body $postbody | httpx2bbrf -s rad -t method:POST -t postbody:$postbody --show-new; done < cat rad/post.req
