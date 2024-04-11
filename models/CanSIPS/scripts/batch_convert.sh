#!/bin/bash

# Specify the input folder containing GRIB2 files
input_folder="../data/grib2"

# Specify the output folder for netCDF4 files
output_folder="../data/netcdf4"

# Ensure the output folder exists
mkdir -p "$output_folder"

# Loop through all GRIB2 files in the input folder
for grib_file in "$input_folder"/*.grib2; do
    # Extract filename without extension
    filename=$(basename -- "$grib_file")
    filename_no_ext="${filename%.*}"

    # Convert GRIB2 to netCDF4 using cdo
    cdo -f nc copy "$grib_file" "$output_folder/$filename_no_ext.nc"
done