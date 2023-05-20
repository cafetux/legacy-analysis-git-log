#!/bin/bash

cat $1 | sed 's/\(\[[a-z0-9]*\]\) \([a-zA-Z0-9]*\) \([a-zA-Z0-9]*\)* /\1 \2-\3 /g'| sed 's/\(\[[a-z0-9]*\]\) \([a-zA-Z0-9-]*\) \([a-zA-Z0-9]*\)* /\1 \2-\3 /g' >git_historique_fixed_names.log
