all:
	gprbuild -p -P @_TEMPLATE_@.gpr -XGENERATE=True
	gprbuild -p -P @_TEMPLATE_@.gpr
	bin/main

clean:
	rm -rf .obj bin src/gen

