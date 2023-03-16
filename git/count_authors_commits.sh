#!/bin/bash
cat $1  | grep '^\[' | awk '{arr[$2]++}END{for (a in arr) print a, arr[a]}'
