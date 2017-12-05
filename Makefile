COMP=jbuilder

build:
	$(COMP) build

deps:
	opam pin add dicecaddy . --no-action --yes --kind=path
	opam install dicecaddy --deps-only
