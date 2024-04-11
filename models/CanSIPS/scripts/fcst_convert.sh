#!/bin/bash

# Check if the correct number of arguments is provided
if [ "$#" -ne 2 ]; then
    echo "Usage: $0 <month> <year>"
    exit 1
fi

# Assign arguments to variables
month=$1
year=$2

# Convert month to lowercase and capitalize the first letter
month=$(echo "$month" | awk '{print tolower(substr($0,1,3))}')
month="${month^}"

# Construct the input and output file names
input_file="../data/grib2/fcst/CANSIPS_prate_fcst_${month}${year}.grib2"
output_file="../data/netcdf4/fcst/CANSIPS_fcst_${month,,}${year}.nc"

# Run the cdo command
cdo -f nc copy "$input_file" "$output_file"

# Exit script
exit 0