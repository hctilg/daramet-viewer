#!/usr/bin/env bash
set -e

source "colors.sh"

BANNER="
  ██████╗   █████╗   ██████╗   █████╗  ███╗   ███╗ ███████╗ ████████╗
  ██╔══██╗ ██╔══██╗  ██╔══██╗ ██╔══██╗ ████╗ ████║ ██╔════╝ ╚══██╔══╝
  ██║  ██║ ███████║  ██████╔╝ ███████║ ██╔████╔██║ █████╗      ██║   
  ██║  ██║ ██╔══██║  ██╔══██╗ ██╔══██║ ██║╚██╔╝██║ ██╔══╝      ██║   
  ██████╔╝ ██║  ██║  ██║  ██║ ██║  ██║ ██║ ╚═╝ ██║ ███████╗    ██║   
  ╚═════╝  ╚═╝  ╚═╝  ╚═╝  ╚═╝ ╚═╝  ╚═╝ ╚═╝     ╚═╝ ╚══════╝    ╚═╝   
                                                              
          ██╗   ██╗ ██╗ ███████╗ ██╗    ██╗ ███████╗ ██████╗               
          ██║   ██║ ██║ ██╔════╝ ██║    ██║ ██╔════╝ ██╔══██╗              
          ██║   ██║ ██║ █████╗   ██║ █╗ ██║ █████╗   ██████╔╝              
          ╚██╗ ██╔╝ ██║ ██╔══╝   ██║███╗██║ ██╔══╝   ██╔══██╗              
           ╚████╔╝  ██║ ███████╗ ╚███╔███╔╝ ███████╗ ██║  ██║              
            ╚═══╝   ╚═╝ ╚══════╝  ╚══╝╚══╝  ╚══════╝ ╚═╝  ╚═╝              
"

clear_screen

echo -e "$Color_rst$Cyan$BANNER$Color_rst
    $BWhite‌Repo GitHub:$Color_rst $UPurple‌https://github.com/hctilg/daramet-viewer/$Color_rst
"

read -p "  Username: " username

user_data=$(curl https://daramet.com/backbone/wapi.php -s \
  -X POST \
  --data-raw "{\"rule\":\"userdata\",\"user\":\"${username}\",\"action\":\"data\"}")

user_status=$(echo $user_data | jq ".status")

if [[ $user_status != *'"success"'* ]]; then
  echo -e "\n  $Color_rst $BRed[!]$Red User not found $Color_rst\n"
  exit 1;
fi

user_view_count_str=$(echo $user_data | jq ".user_stats.views")
user_view_count_int=${user_view_count_str//\"/}

echo -e "
  $BIWhite Current view:$IWhite $user_view_count_int $Color_rst
"

read -p "  Number of views: " view_number

if [[ ! $view_number =~ ^-?[0-9]+$ ]] || (( view_number < 1 )); then
  echo -e "\n  $Color_rst $BRed[!]$Red It was be an integer $Color_rst\n"
  exit 0
fi

printf "\n"

for ((i=1; i <= $view_number; i++)); do
  pct=$(( i*100 / $view_number ))

  new_user_view_count_str=$(curl https://daramet.com/backbone/wapi.php -s \
    -X POST \
    --data-raw "{\"rule\":\"userdata\",\"user\":\"${username}\",\"action\":\"data\"}" | jq ".user_stats.views")

  new_user_view_count_int=${new_user_view_count_str//\"/}
    
  printf "\r  $IPurple [*] Viewing...  |  $new_user_view_count_int  | %3d%% (%d/%d) $Color_rst" "$pct" "$i" "$view_number"
done

echo -e "\n\n  $BWhite [#]$White My work is done.$Color_rst\n";