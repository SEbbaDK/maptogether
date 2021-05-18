#!/bin/sh
for f in $(find src spec -name "*.cr")
do
    crystal tool format "$f"
    sed 's/  /\t/g' -i "$f"
done

