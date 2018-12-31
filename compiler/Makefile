-include Makefile.conf

project:=protoc_ada.gpr
PROTOC:=$(shell which protoc)

build:protoc_ada.gpr
	${GPRBUILD} -p -P ${project}

uninstall:protoc_ada.gpr
	${GPRINSTALL} --uninstall ${project}

install:protoc_ada.gpr
	@${GPRINSTALL} --uninstall ${project} --prefix=${destdir}${prefix} 2>/dev/null >/dev/null ; true
	${GPRINSTALL} -p -P ${project} --prefix=${destdir}${prefix}

Makefile.conf:Makefile
	@echo "GPRBUILD:=$(shell which gprbuild)" >${@}
	@echo "GPRINSTALL:=$(shell which gprinstall)" >>${@}
	@echo "GPS:=$(shell which gps)" >>${@}

gps:
	${GPS} -P ${project} & 

protoc_ada.gpr:protoc_ada.gpr.in ${PROTOC} Makefile 
	sed "s-@_LIBDIR_@-$$(dirname $$(find  $$(dirname $$(dirname ${PROTOC})) -name libprotobuf.so))-" ${@}.in >${@}
