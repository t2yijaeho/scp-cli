#!/bin/bash

# Check if the correct number of arguments was provided
if [ $# -ne 2 ]; then
  echo "Usage: $0 <number of files> <file size in MB>"
  exit 1
fi

# Set the number of files to be generated and the size of each file
num_files=$1
file_size=$2  # Size in MB

# Calculate the padding based on the number of files
padding=${#num_files}

# Function to handle SIGCHLD signal
function on_sigchld() {
  echo -n "."
}

# Set the trap
trap on_sigchld SIGCHLD

# Loop from 1 to num_files using seq with padded output
for i in $(seq -f "%0${padding}g" 1 $num_files); do
  filename="file$i"

  # Check if the file already exists
  if [ ! -e "$filename" ]; then
    # Generate a file of random data with dd into a file
    # if=/dev/urandom - Input file is urandom for random data
    # of=file$i - Output file name
    # bs=1M - Block size is 1MB
    # count=$file_size - Write blocks
    dd if=/dev/urandom of="$filename" bs=1M count=$file_size status=none &
  else
    echo "File $filename already exists. Skipping."
  fi
done

# Wait for all background processes to finish
wait
echo -e "\nAll files have been generated."
