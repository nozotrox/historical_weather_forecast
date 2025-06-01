#!/bin/bash

report_file=synthetic_historical_fc_accuracy.tsv
week_records=($(cat $report_file | tail -7 | tr $'\t' '_'))

mininum=5
maximum=1

for item in ${week_records[@]}; do
    accuracy=$(echo $item | cut -d '_' -f6)
    if [[ $accuracy < 0 ]]
    then
        val=$(( $accuracy * -1 ))
    else
        val=$accuracy
    fi
    
    if [[ $val -le $mininum ]]
    then
        mininum=$val
    fi

    if [[ $val -ge $maximum ]]
    then 
        maximum=$val 
    fi
done

echo "Minimum: $mininum Maximum: $maximum"