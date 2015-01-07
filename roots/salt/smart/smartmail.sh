#!/bin/bash
input=$1

curl -s --user 'api:key-{{ key }}' \
    https://api.mailgun.net/v2/{{ instance }}/messages \
    -F from='Vigilance <vigilance@vigilance.dyndns.org>' \
    -F to='flowmage@gmail.com' \
    -F subject='SMART Status' \
    -F text=$input
