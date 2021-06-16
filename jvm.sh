#!/bin/sh

## see threads
top -Hp 47919
## see thread's hex
printf "%x\n" 47954
## see thread's info
jstack -l 47919 | grep -A 100 bb52
