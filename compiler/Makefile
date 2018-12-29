-include Makefile.conf


compile:
	${GPRBUILD} -p -P protoc_ada.gpr

uninstall:
	${GPRINSTALL} --uninstall protoc_ada.gpr

install:
	@set +e ; ${GPRINSTALL} --uninstall protoc_ada.gpr 2>/dev/null >/dev/null ; true
	${GPRINSTALL} -p -P protoc_ada.gpr


Makefile.conf:Makefile
	echo "GPRBUILD=$(shell which gprbuild)" >${@}
	echo "GPRINSTALL=$(shell which gprinstall)" >>${@}


configure:
	sed "s-@_LIBDIR_@-$$(dirname $$(find  $$(dirname $$(dirname $$(which protoc))) -name libprotobuf.so))-" protoc_ada.gpr.in >protoc_ada.gpr
