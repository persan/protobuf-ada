all:
	${MAKE} clean
	gprbuild -p -P test3.gpr -XGENERATE=True
	gprbuild -p -P test3.gpr
clean:
	rm -rf .obj bin src/gen
