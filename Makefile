COMP=jbuilder

all:	build

build:
	$(COMP) build

.PHONY:	tests
tests:
	$(COMP) runtest

clean:
	rm -rf _build

deps:
	opam pin add dicecaddy . --no-action --yes --kind=path
	opam install dicecaddy --deps-only
