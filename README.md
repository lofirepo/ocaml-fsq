[![Build Status](https://travis-ci.org/p2pcollab/ocaml-fsq.svg?branch=master)](https://travis-ci.org/p2pcollab/ocaml-fsq)

# FSQ: Functional Fixed-size Search Queues

FSQ is an OCaml implementation of functional fixed-size search queues.
It is based on [Priority Search Queues](https://github.com/pqwy/psq).

FSQ is distributed under the MPL-2.0 license.

## Installation

``fsq`` can be installed via `opam`:

    opam install fsq

## Building

To build from source, generate documentation, and run tests, use `dune`:

    dune build
    dune build @doc
    dune runtest -f

In addition, the following `Makefile` targets are available
 as a shorthand for the above:

    make all
    make build
    make doc
    make test

## Documentation

The documentation and API reference is generated from the source interfaces.
It can be consulted [online][doc] or via `odig`:

    odig doc fsq

[doc]: https://p2pcollab.github.io/doc/ocaml-fsq/
