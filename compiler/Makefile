-include Makefile.conf

project:=protoc_ada.gpr

compile:
	${GPRBUILD} -p -P ${project}

uninstall:
	${GPRINSTALL} --uninstall ${project}

install:
	@${GPRINSTALL} --uninstall ${project} --prefix=${destdir}${prefix} 2>/dev/null >/dev/null ; true
	${GPRINSTALL} -p -P ${project} --prefix=${destdir}${prefix}

Makefile.conf:Makefile
	@echo "GPRBUILD:=$(shell which gprbuild)" >${@}
	@echo "GPRINSTALL:=$(shell which gprinstall)" >>${@}
	@echo "GPS:=$(shell which gps)" >>${@}

gps:
	${GPS} -P ${project} & 

configure:
	sed "s-@_LIBDIR_@-$$(dirname $$(find  $$(dirname $$(dirname $$(which protoc))) -name libprotobuf.so))-" protoc_ada.gpr.in >protoc_ada.gpr
