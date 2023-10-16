#!/bin/bash

# Valid options
valid_components=("INGESTOR" "JOINER" "WRANGLER" "VALIDATOR")
valid_scales=("MID" "HIGH" "LOW")
valid_views=("Auction" "Bid")
valid_count_regex='^[0-9]$' 

# Function to validate input
validate_input() {
  local input="$1"
  shift
  local valid_options=("$@")

  for option in "${valid_options[@]}"; do
    if [ "$input" == "$option" ]; then
      return 0 
    fi
  done

  return 1 
}

read -p "Enter Component Name [INGESTOR/JOINER/WRANGLER/VALIDATOR]: " component
read -p "Enter Scale [MID/HIGH/LOW]: " scale
read -p "Enter View [Auction/Bid]: " view
read -p "Enter Count [single digit number]: " count

# Validate user inputs
if ! validate_input "$component" "${valid_components[@]}"; then
  echo "Invalid Component Name. Please choose from the provided options."
  exit 1
fi

if ! validate_input "$scale" "${valid_scales[@]}"; then
  echo "Invalid Scale. Please choose from the provided options."
  exit 1
fi

if ! validate_input "$view" "${valid_views[@]}"; then
  echo "Invalid View. Please choose from the provided options."
  exit 1
fi

if ! [[ $count =~ $valid_count_regex ]]; then
  echo "Invalid Count. Please enter a single digit number."
  exit 1
fi

# Create the new line
new_line="$view ; $scale ; $component ; ETL ; vdopia-etl= $count"

# Replace the first line 
sed -i "1s/.*/$new_line/" sig.conf

echo "File updated successfully!"
