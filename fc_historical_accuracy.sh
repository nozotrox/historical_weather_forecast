#!/bin/bash
city=casablanca
report_file=rx_poc.log
historical_report_file=bulk_historical_fc_accuracy.tsv

weather_report=($(cat $report_file | tr ' ' '-'))

for item in ${weather_report[@]}; do
    yesterday_fc=$(echo $item | cut -d '-' -f5)
    today_temp=$(echo $item | cut -d '-' -f4)
    accuracy=$(($yesterday_fc - $today_temp))

    if [ $accuracy -ge -1 ] && [ $accuracy -le 1 ] 
    then
        accuracy_range=excellent
    elif [ $accuracy -ge -2 ] && [ $accuracy -le 2 ]
    then
        accuracy_range=good
    elif [ $accuracy -ge -3 ] && [ $accuracy -le 3 ]
    then
        accuracy_range=fair
    else
        accuracy_range=poor
    fi

    year=$(echo $item | cut -d ' ' -f1)
    month=$(echo $item | cut -d ' ' -f2)
    day=$(echo $item | cut -d ' ' -f3)

    echo -e "Date: $year-$month-$day \t Actual: $today_temp °C \t Forecast: $yesterday_fc °C \t Acc: $accuracy \t Accuracy Range : $accuracy_range"
    echo -e "$year\t$month\t$day\t$today_temp\t$yesterday_fc\t$accuracy\t$accuracy_range" >> $historical_report_file

done

#get yesterday forecasted temperature
# yesterday_fc=$(cat $report_file | tail -2 | head -1 | cut -d ' ' -f5)
# echo "Yesterday's forecast for $city: $yesterday_fc"

# #get yersterdays temperature
# today_temp=$(tail -2 $report_file | head -1 | cut -d ' ' -f4)

# accuracy=$(($yesterday_fc - $today_temp))
# echo "The accuracy is $accuracy."

# if [ $accuracy -ge -1 ] && [ $accuracy -le 1 ] 
# then
#     result=excellent
# elif [ $accuracy -ge -2 ] && [ $accuracy -le 2 ]
# then
#     result=good
# elif [ $accuracy -ge -3 ] && [ $accuracy -le 3 ]
# then
#     result=fair
# else
#     result=poor
# fi

# echo "Forecast accuracy is $result"

# row=$(tail -2 $report_file | head -1)
# year=$(echo $row | cut -d ' ' -f1)
# month=$(echo $row | cut -d ' ' -f2)
# day=$(echo $row | cut -d ' ' -f3)
# echo -e "$year\t$month\t$day\t$today_temp\t$yesterday_fc\t$accuracy\t$result" >> $historical_report_file