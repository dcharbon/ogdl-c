# distutils: language_level = 3
# distutils: sources = src/graph.c src/ogdlbin.c src/ogdllog.c src/ogdlparser.c src/path.c

cimport c_ogdl

cdef class Graph:
    cdef c_ogdl.Graph _c_graph

    def __init__(self, name):
        b_name = name.encode("utf-8")
        cdef char* c_name = b_name
        self._c_graph = c_ogdl.Graph_new(c_name)