all:
	${MAKE} clean
	@touch FAIL
	gprbuild -p -j0 -XGENERATE=True
	gprbuild -p -j0
	@rm FAIL
clean:
	rm -rf .obj bin src/gen
