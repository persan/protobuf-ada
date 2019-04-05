#!/usr/bin/env python3
import subprocess
import os
from os.path import *
import shutil

protoc=shutil.which("protoc")
if not protoc:
	sys.stderr.write("No protoc found on path please install protoc")
	sys.exit(1)

root=dirname(dirname(protoc))
for _root, dirs, files  in os.walk(root):
	for f in files:
		if f == "libprotobuf.so":
			libdir=_root
		elif f == "dynamic_message.h" and "google/protobuf" in _root:
			includedir=dirname(dirname(_root))

with open("protoc_ada.gpr.in") as inf:
	buffer=inf.read()
	buffer = buffer % {"libdir": libdir,
	                   "includedir": includedir}
with open("protoc_ada.gpr","w") as outf:
	outf.write(buffer)
