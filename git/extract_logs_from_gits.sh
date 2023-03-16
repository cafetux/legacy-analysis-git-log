#!/bin/bash

git log --pretty=format:'[%h] %an %ad %s' --date=short --numstat > ../git_stats.log
