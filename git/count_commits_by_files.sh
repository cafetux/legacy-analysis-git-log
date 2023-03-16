#!/bin/bash
cat $1 | grep -v "^\[" | grep -v "^\B" | awk '{arr[$3]++}END{for(a in arr) print a","arr[a]}'

