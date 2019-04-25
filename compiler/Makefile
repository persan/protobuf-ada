-include Makefile.conf

project:=protoc_ada.gpr

build:protoc_ada.gpr
	${GPRBUILD} -p -P ${project}

uninstall:protoc_ada.gpr
	${GPRINSTALL} --uninstall ${project}

install:protoc_ada.gpr
	@${GPRINSTALL} --uninstall ${project} --prefix=${DESTDIR}${prefix} 2>/dev/null >/dev/null ; true
	${GPRINSTALL} -p -P ${project} --prefix=${DESTDIR}${prefix}

Makefile.conf:Makefile
	@echo "GPRBUILD:=$(shell which gprbuild)" >${@}
	@echo "GPRINSTALL:=$(shell which gprinstall)" >>${@}
	@echo "GPS:=$(shell which gps)" >>${@}

gps:
	${GPS} -P ${project} &
