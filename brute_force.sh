#!/usr/bin/env bash

username="hctilg"
view_number=1000
tasks=1000
jobs=10

worker() {
  for ((i=1; i<=view_number; i++)); do
    new_user_view_count_str=$(curl https://daramet.com/backbone/wapi.php -s \
      -X POST \
      --data-raw "{\"rule\":\"userdata\",\"user\":\"${username}\",\"action\":\"data\"}" | jq ".user_stats.views")

    new_user_view_count_int=${new_user_view_count_str//\"/}

    printf "\r [+] Viewing... | Now : $new_user_view_count_int"
  done
}

export -f worker
export username view_number

seq "$tasks" | xargs -n1 -P "$jobs" -I{} bash -c 'worker'

wait

echo
