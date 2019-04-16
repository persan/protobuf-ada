#!/bin/bash

for i in */FAIL ; do (
	cd $(dirname $i)
	gps
) ; done
 
