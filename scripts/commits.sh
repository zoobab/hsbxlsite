#!/usr/bin/env bash

# Usage: commits.sh content data/commits

mkdir -p $2

find $1 -name "*.md" | while read line; do
    line=$(printf %q "$line")
    log=$(git log --pretty=format:'{%n  "commit": "%H",%n  "author": "%aN <%aE>",%n  "date": "%ad",%n  "message": "%f"%n},' $@ "$line" | perl -pe 'BEGIN{print "["}; END{print "]\n"}' | perl -pe 's/},]/}]/');
    line=${line#"$1"};
    path=$(dirname "${line}");
    filename=$(basename "${line}")
    mkdir -p "$2/$path";
    echo $log > "$2/$(eval "echo $path")/$(eval "echo $filename").json";
done


