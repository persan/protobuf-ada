-include Makefile.conf


ifeq ("${prefix}","")
	prefix:=$(shell dirname $(shell dirname $(shell which gnatls)))
endif

all: build test

build:
	${MAKE} -C compiler ${@}
	${GPRBUILD} -p -P google-protobuf.gpr

install:
	@set +e ; ${GPRINSTALL} --uninstall google.gpr 2>/dev/null >/dev/null ; true
	@set +e ; ${GPRINSTALL} --uninstall google-protobuf.gpr 2>/dev/null >/dev/null ; true
	${GPRINSTALL} -p -P google.gpr --prefix=${DESTDIR}${prefix}
	${GPRINSTALL} -p -P google-protobuf.gpr --prefix=${DESTDIR}${prefix}
	${MAKE} -C compiler ${@}

uninstall:
	${GPRINSTALL} --uninstall ${project}

gps:
	@${GPS} -P ${project} &


Makefile.conf:Makefile
	@echo "GPS:=$(shell which gps)" >${@}
	@echo "GPRBUILD:=$(shell which gprbuild)" >>${@}
	@echo "GPRINSTALL:=$(shell which gprinstall)" >>${@}
	@echo "export PATH:=${CURDIR}/compiler/bin:${PATH}" >>${@}
	@echo "export GPR_PROJECT_PATH:=${CURDIR}" >>${@}

env:
	@bash

.PHONY: test
test:
	${MAKE} -C test all

clean:
	git clean -xdf
