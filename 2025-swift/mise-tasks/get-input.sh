#!/usr/bin/env bash
#MISE description="Gets the puzzle input for a day"
#USAGE arg <day> help="The day to fetch"

set -e

if [ -z "$usage_day" ]; then
    echo "must pass a day" && exit 1
fi

if [ -z "$AOC_SESSION_TOKEN" ]; then
    echo "must have a session token" && exit 1
fi

url="https://adventofcode.com/2025/day/$usage_day/input"
path="Day$(printf "%02d" $usage_day)/input.txt"

curl -f -s --cookie "session=$AOC_SESSION_TOKEN" $url -o $path

echo "✨ Day $usage_day puzzle input downloaded to $path"
