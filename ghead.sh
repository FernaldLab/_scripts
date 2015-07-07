#!/bin/bash
str="ls | "
for var in "$@"
do
	str=${str}"grep "$var" | "
done
eval ${str:0:${#str}-2} | awk '{print "echo "$1"; head "$1""}' | bash