#!/bin/bash

# Check if the user provided an input string
if [ $# -eq 0 ]; then
    echo "Usage: $0 <input_string>"
    exit 1
fi

# Store the input string in a variable
input_string="$1"

# Create or overwrite the foo.scad file with the input string
echo "$input_string" > foo.scad
# Run the openscad command
openscad --export-format asciistl -o - -q foo.scad
