#!/bin/bash

# Create an empty hashes.txt file
> hashes.txt

# Iterate through all zip files in the current directory
for file in *.zip; do
  echo "Processing $file..."
  
  # Run zip2john to extract the hashes and append them to hashes.txt
  zip2john "$file" | tee -a hashes.txt
done

echo "Hashes dumped to hashes.txt."

