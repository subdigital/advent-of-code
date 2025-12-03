#!/usr/bin/env bash
#MISE description="Creates a new day folder structure based on the daily-template"
#USAGE arg <day> help="The day number"

set -e

if [ -z "$usage_day" ]; then
    echo "must pass a day" && exit 1
fi

day="$(printf "%02d" $1)"
echo "Creating $day..."
cargo generate -f -n "Day$day"         \
    --path daily-template           \
    --define module-name="Day$day"  \
    --define day=$day
