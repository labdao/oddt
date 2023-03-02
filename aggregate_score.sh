#!/bin/bash

# Create an empty JSONL file
echo "" > scores.jsonl

# Loop through all SDF files in the directory
for file in *.sdf; do
    # Get the name of the file without the extension
    filename=$(basename -- "$file")
    #filename="${filename%.*}"

    # Extract the scores from the SDF file using regex
    rfscore_v1=$(grep -A 1 '<rfscore_v1>' "$file" | tail -n 1 | sed 's/.*>\([^<]*\)<.*/\1/')
    rfscore_v2=$(grep -A 1 '<rfscore_v2>' "$file" | tail -n 1 | sed 's/.*>\([^<]*\)<.*/\1/')
    rfscore_v3=$(grep -A 1 '<rfscore_v3>' "$file" | tail -n 1 | sed 's/.*>\([^<]*\)<.*/\1/')
    nnscore=$(grep -A 1 '<nnscore>' "$file" | tail -n 1 | sed 's/.*>\([^<]*\)<.*/\1/')


    # Write the scores to the JSONL file
    echo "{\"file\": \"$filename\", \"rfscore_v1\": \"$rfscore_v1\", \"rfscore_v2\": \"$rfscore_v2\", \"rfscore_v3\": \"$rfscore_v3\", \"nnscore\": \"$nnscore\"}" >> scores.jsonl
done

#tail -n +1 scores.jsonl > scores.jsonl

