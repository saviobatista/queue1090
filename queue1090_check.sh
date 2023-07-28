#!/bin/bash

# Checks if the files produced by queue1090 were modified more than 10 minutes ago, and if so, restarts the docker compose.

## Add to /etc/crontab to run each 10 minutes
# Queue1090
# */10 * * * * root <path>/queue1090_check.sh


# Variables
dockercompose="docker-compose"  # Check if adequate, on some systems, it's "docker compose"
# dockercompose="docker compose"
dir_log="/home/rj/log_hdd/adsbqueue"  # Path of log files
dir_queue="/opt/queue1090"  # Path of queue1090
period=10  # Lookup interval in minutes (integer)

# Get the current date and time
today=$(date +%Y%m%d)

# Check if the file exists
file_name="adsb-log_${today}.csv.gz"
if [ -f "${dir_log}/${file_name}" ]; then

  # Get the file's modified time
  modified_time=$(stat -c %y "${dir_log}/${file_name}")

  # Check if the file was modified in the last $period minutes
  if (( $(date -d "${modified_time}" +%s) < $(date -d "now - ${period} minutes" +%s) )); then

    # Restart the docker compose
    echo "Restart the docker compose at ${dir_queue}"
    cd "${dir_queue}" && ${dockercompose} restart

  else

    # The file was not modified in the last $period minutes, so exit the script
    echo "The file was not modified in the last $period minutes, so exit the script"
    ${dockercompose} ls
    exit 0

  fi

else

  # The file does not exist, so restart the docker compose
  echo "The file does not exist, so restart the docker compose at ${dir_queue}"
  cd "${dir_queue}" && ${dockercompose} restart

fi
