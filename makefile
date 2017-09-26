COMP=jbuilder

build:
	$(COMP) build

deps:
	echo "Switching to current OCAML Version..."
	opam switch 4.05.0
	echo "Installing Required Packages..."
	opam install jbuilder containers postgresql lwt cohttp cohttp-lwt ounit
