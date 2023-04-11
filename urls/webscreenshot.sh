#!/bin/bash

# Screenshot all urls with labeels and add GeoIP to image
# Requirements: webscreenshot (pip3 install webscreenshot), phantomjs, exiftool, C99-Api key

bbrf urls -r > urls
webscreenshot -i urls -l -f jpg

cd screenshots
# Loop over all files in the directory
for file in *; do
  # Extract the FQDN using awk
  fqdn=$(echo "$file" | awk -F'_' '{print $2}')
  # Do something with the FQDN (e.g. print it)
  echo "$fqdn"
  geoip=$(curl -s "https://api.c99.nl/geoip?key=<api-key>&host=$fqdn&json" | jq '.records  | .latitude + " " + .longitude')
  echo "$geoip"
  latitude=$(echo $geoip | awk '{print $1}')
  longitude=$(echo $geoip | awk '{print $2}')
  exiftool $file -gpslatitude=$latitude -gpslongitude=$longitude
done
