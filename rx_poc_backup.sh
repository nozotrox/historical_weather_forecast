#!/bin/bash

city=casablanca
output=temp_log

#collect the weather report for the day
weather_file=weather_report
curl -s wttr.in/$city?T --output $weather_file

#output files
year_file=year.txt
month_file=month.txt
day_file=day.txt
obs_file=obs_temp.txt
fcs_file=fcs_temp.txt

#define extraction patter
date_pattern='\w{3}\s\d{2}\s\w{3}'
temp_pattern='°C[ ]+'
header_pattern='[ ]+Noon'

#create the dates file
date_file=parsed_dates.tmp
extracted_dates=$(grep -E -o "$date_pattern" $weather_file | tr " " "-")
echo -e "$extracted_dates" >> $date_file
dates_array=($(echo -e "$extracted_dates"))

#convert parsed dates into tabular format
: > $date_file #clear the date file
echo -e "year\tmonth\tday\tobs_tmp\t\tfc_temp" > $date_file
headers=("year" "month" "day" "obs_temp" "fcs_temp")
for item in ${headers[@]}; do
    echo $item > "$item.txt"
done

for item in ${dates_array[@]}; do
    # echo -e $(date -jf "%a-%d-%b" "$item" +"%Y\t%m\t%d") >> $date_file
    echo $(date -jf "%a-%d-%b" "$item" +"%Y") >> year.txt
    echo $(date -jf "%a-%d-%b" "$item" +"%m") >> month.txt
    echo $(date -jf "%a-%d-%b" "$item" +"%d") >> day.txt
done


## extract temperatures
echo "" >> $fcs_file
temperatures=$(grep -E "$temp_pattern" $weather_file | tail -n +2 | cut -c 47-62)
echo -e "$temperatures" | head -n +1 | tr -d ' ' >> $obs_file
echo "-" >> $obs_file; echo "-" >> $obs_file
echo -e "$temperatures" | tail -n +2 | tr -d ' ' >> $fcs_file

paste -d $'\t' $year_file $month_file $day_file $obs_file $fcs_file | column -t > output.txt