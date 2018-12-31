-include Makefile.conf

project:=protobuff.gpr

ifeq ("${prefix}","")
	prefix:=$(shell dirname $(shell dirname $(shell which gnatls)))
endif

all: build test

build:
	${MAKE} -C compiler ${@}
	${GPRBUILD} -p -P ${project}

configure:
	${MAKE} -C compiler ${@}

install:
	@set +e ; ${GPRINSTALL} --uninstall ${project} 2>/dev/null >/dev/null ; true
	${GPRINSTALL} -p -P ${project} --prefix=${destdir}${prefix}
	${MAKE} -C compiler ${@}

uninstall:
	${GPRINSTALL} --uninstall ${project}

gps:
	@${GPS} -P ${project} & 
#	@${MAKE} -C compiler ${@}


Makefile.conf:Makefile
	@echo "GPS:=$(shell which gps)" >${@}
	@echo "GPRBUILD:=$(shell which gprbuild)" >>${@}
	@echo "GPRINSTALL:=$(shell which gprinstall)" >>${@}
	@echo "export PATH:=${CURDIR}/compiler/bin:${PATH}" >>${@}
	@echo "export GPR_PROJECT_PATH:=${CURDIR}" >>${@}

env:
	@bash
