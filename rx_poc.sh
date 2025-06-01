#!/bin/bash

city=casablanca
report_file=weather_report

curl -s wttr.in/$city?T --output $report_file

#get current temperature
obs_temp=$(cat $report_file | grep -m 1 '°.' | grep -Eo -e '\([[:digit:]]+\)|-?[[:digit:]]+\s' | tr -d '(' | tr -d ')')
echo "The current Temperature of $city: $obs_temp °C"

#get forecast temperature
fcs_temp=$(cat $report_file | head -23 | tail -1 | grep '°.' | cut -d 'C' -f2 | grep -Eo -e '\([[:digit:]]+\)|-?[[:digit:]]+\s' | tr -d '(' | tr -d ')')
echo "The forecasted temperature for noon tomorrow for $city : $fcs_temp °C"

#store date/month and year
TZ='Morocco/Casablanca'
day=$(TZ='Morocco/Casablanca' date -u +%d)
month=$(TZ='Morocco/Casablanca' date +%m)
year=$(TZ='Morocco/Casablanca' date +%Y)

record=$(echo -e "$year\t$month\t$day\t$obs_temp\t$fcs_temp")
echo $record > rx_poc.log