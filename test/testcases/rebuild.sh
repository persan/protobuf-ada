#!/bin/bash
rm */src/gen/* -f

ls */src/*.proto | sort -u | cut -f 1 -d / | while read i  ; do
	make -C $i 2>&1 | tee $i/compile.log
done
