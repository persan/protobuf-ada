#!/bin/bash
ls */src/*.proto | cut -f 1 -d / | while read i  ; do
	make -C $i 2>&1 | tee $i/compile.log
done
