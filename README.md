OGDL README
-----------

Introduction
------------

OGDL ("Ordered Graph Data Language") is a structured textual format that
represents information in the form of graphs, where the nodes are strings
and the arcs or edges are spaces or indentation.

The OGDL package consists of the "libogdl" C library and following tools:
  - gpath     (Graph path resolver for OGDL streams)
  - xml2ogdl  (XML to OGDL converter)
  - tindent   (simple indentation tool)

More info at our website: http://ogdl.org
Mailinglist: http://lists.sourceforge.net/lists/listinfo/ogdl-core

Installation
------------
[Unpack the zip or tgz file and change to the main directory.]

[The file xml2ogdl.c needs the expat include file and library installed,
usually found in the expat-devel package.] 

To configure build:

    mkdir build
    cd build
    cmake .. [use -DCMAKE_INSTALL_PREFIX=/usr/local or similar to change location.]

Then build:

    make
    make install

To build the OGDL API documentation (needs doxygen):

    make doc

