#!/bin/bash    # shebang executables for execute shell script ( bash/dash/sh)

##############################################################
# Author: Marketfeed
# Date: 22-Apr-2024
# version: v1

# This script will report that automates the log analysis and monitoring of log files

#This script monitors a specified log file for new entries, performs basic log analysis by counting occurrences of the "ERROR" keyword, and generates a summary report.
############################################################################################################################

#log_monitor.sh

################################

# Define the log file

   log_file="/var/log/syslog"      # log file path

# Function to display usage information

usage() {
    echo "Usage: $0 <log_file>"  # it prints the usage of log_file
}

# Function to handle interrupt signal (e.g., Ctrl+C) 

interrupt_handler() {
    echo "Monitoring stopped."      ## interupts are monitoring of signlas using trap commamd
    exit 0
}

# Function to monitor log file continuously
monitor_log() {
    trap 'interrupt_handler' INT   ## trap used to traping a signals to os ctrl^c which can't stop if any one perform ctrl^C # ex:SIGINT,SIGILL,QUIT,etc

    echo "Monitoring log file: $log_file"
    echo "Press Ctrl+C to stop monitoring..."

    tail -f "$log_file"             ## script that continuously monitors a specified log file for new entries of last 10 in log_file
}

#######################################################################################

#log_analysis

##################################


# Check if the user provided the log file path as a command-line argument

if [ $# -ne 1 ]; 
then
echo “Usage: $0 <path_to_logfile>”
exit 1
fi
done

# Get the log file path from the command-line argument
 
log_file=”$1"

# Check if the log file exists

if [ ! -f “$log_file” ]; then
echo “Error: Log file not found: $log_file”                             # it checks file exist or not
exit 1
fi

# Step 1: Count the total number of lines in the log file              ### for log_analysis we usw most filter commands grep,awk,sed

total_lines=$(wc -l < “$log_file”)                                     ## using wordCound wc-l shows number of lines in a file

# Step 2: Count the number of error messages (identified by the keyword “ERROR” in this example)

error_count=$(grep -c -i “ERROR” “$log_file”)                                  ## using grep it shows only "ERROR" proceeses files
awk -F " " '{print $ 2}                                                      ## awk it filter the output shown in "COLUMN" wise pattern scanning if spicfic ERROR with "PID"

# Step 3: Search for critical events (lines containing the keyword “CRITICAL”) and store them in an array

mapfile -t critical_events < <(grep -n -i “CRITICAL” “$log_file”)  ### it shows only "CRITICAL STATUS"process files

# Step 4: Identify the top 5 most common error messages and their occurrence count using associative arrays

declare -A error_messages
while IFS= read -r line; do     ### its shows list of "ERROR" messages

# Use awk to extract the error message (fields are space-separated) column-wise

error_msg=$(awk ‘{for (i=3; i<=NF; i++) printf $i “ “; print “”}’ <<< “$line”)
((error_messages[“$error_msg”]++))
done < <(grep -i “ERROR” “$log_file”)        ##print error process of log_files column wise

# Sort the error messages by occurrence count (descending order)

sorted_error_messages=$(for key in “${!error_messages[@]}”; do 
echo “${error_messages[$key]} $key”                              ## sorting the errors in recursive and shows all "TOP" 10n lines ERRORS
done | sort -rn | head -n 5)


# Function to perform basic log analysis

analyze_log() {
    echo "Performing log analysis..."

# Count occurrences of ERROR keyword

    error_count=$(grep -c "ERROR" "$log_file")  ## shows in no: of ERRORS ex:4 errors

# Generate the summary report in a separate file

summary_report=”log_summary_$(date +%Y-%m-%d).txt”   ##### it stores data of log Analysis datwise format in a report
{
echo “Date of analysis: $(date)”
echo “Log file: $log_file”
echo “Total lines processed: $total_lines”
echo “Total error count: $error_count”
echo -e “\nTop 5 error messages:”
echo “$sorted_error_messages”
echo -e “\nCritical events with line numbers:”
for event in “${critical_events[@]}”; do
echo “$event”
done
} > “$summary_report”

echo “Summary report generated: $summary_report”  ###### all the log analysis data stores in :Summary Report"

#######################################

log_file data is huge after 30 days its difficult to store so we overcome by "logrotate" we can delete files all data is compress  g.zip format

logrotate (g.zip)  ## it will auto delete after specific days like 7 days 

#syntax
logrotate [options] <config_file>

example: logrotate /etc/logrotate.d/log_file




  
