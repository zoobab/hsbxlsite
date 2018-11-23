#!/usr/bin/env bash

# Usage: ./scripts/commits.sh content data/commits

echo "generating git logs"

mkdir -p $2

find $1 -name "*.md" | while read line; do
    contentline=${line#"$1/"};
    filename=$(echo -n $contentline | md5sum | cut -f 1 -d " ");
    log=$(git log --pretty=format:'{%n  "commit": "%H",%n  "author": "%aN",%n  "commit_date": "%ci",%n  "message": "%f"%n},' "$line" | perl -pe 'BEGIN{print "["}; END{print "]\n"}' | perl -pe 's/},]/}]/');
     echo $log > "$2/$filename.json";
done


