#!/bin/bash

# Exit if any of the intermediate steps fail
set -e

# Extract our script arguments passed from Terraform into shell variables
eval "$(jq -r '@sh "OUTPUTDIRECTORY=\(.output_directory) ARTICLECOUNT=\(.article_count)"')"

# Declare new variables and assign values containing paths for validation
srcDirectory="$OUTPUTDIRECTORY/src/"
indexHTMLFile="$srcDirectory/index.html"
stylesCSSFile="$srcDirectory/styles.css";
articlesDirectory="$OUTPUTDIRECTORY/src/articles"

# Declare a new flag variable holding a number to indicate true or false
areAllFilesCreated=0

# Check if all files and folders were generated successfully
if [ -d "$srcDirectory" ] && \
   [ -f "$indexHTMLFile" ] && \
   [ -f "$stylesCSSFile" ] && \
   [ -d "$articlesDirectory" ] && \
   [ $(find "$articlesDirectory" -maxdepth 1 -type f -name "*.html" | wc -l) -eq "$ARTICLECOUNT" ]; then
    areAllFilesCreated=1;
fi

# Safely produce a JSON object containing the result "areAllFilesCreated" true/false value
# jq will ensure that the value is properly quoted and escaped to produce a valid JSON string
jq -n --arg result "$areAllFilesCreated" '{"are_all_files_created":$result}'
