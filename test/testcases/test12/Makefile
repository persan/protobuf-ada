all:
	${MAKE} clean
	gprbuild -p -P test12.gpr -XGENERATE=True
	gprbuild -p -P test12.gpr
clean:
	rm -rf .obj bin src/gen
