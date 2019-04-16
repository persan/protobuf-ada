all:
	${MAKE} clean
	@touch FAIL
	gprbuild -p -j0 -XGENERATE=True
	@rm src/gen/google-protobuf.ads
	gprbuild -p -j0
	@rm FAIL

clean:
	rm -rf .obj bin src/gen
