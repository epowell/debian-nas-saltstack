#!/bin/bash
TEXT="$(btrfs scrub status -d /storage/media)"
curl -s --user 'api:key-{{ key }}' \
    https://api.mailgun.net/v2/{{ instance }}/messages \
    -F from='Vigilance <vigilance@vigilance.dyndns.org>' \
    -F to='flowmage@gmail.com' \
    -F subject='BTRFS Scrub Status' \
    -F text="$TEXT"

