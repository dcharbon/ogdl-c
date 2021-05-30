# distutils: language_level = 3
# distutils: sources = src/graph.c src/ogdlbin.c src/ogdllog.c src/ogdlparser.c src/path.c

cimport c_ogdl
from libc.stdlib cimport free
from libc.stdio cimport FILE, fopen, fclose


cdef char* c_str(pystr):
    cdef char* c_str = NULL
    if pystr is not None:
        b_str = pystr.encode("utf-8")
        c_str = b_str
    return c_str


cdef class Graph:
    cdef c_ogdl.Graph _c_graph
    _should_free = False

    def __cinit__(self, name=None):
        cdef char* c_name = NULL
        if name is not None:
            self._c_graph = c_ogdl.Graph_new(c_str(name))
            self._should_free = True

    def __dealloc__(self):
        if self._should_free:
            c_ogdl.Graph_free(self._c_graph)

    def get(self, path):
        cdef c_ogdl.Graph result = c_ogdl.Graph_get(self._c_graph, c_str(path))
        if result != NULL:
            subgraph = Graph()
            subgraph._c_graph = result
            return subgraph
        return None

    def get_string(self, path):
        cdef char* result = c_ogdl.Graph_getString(self._c_graph, c_str(path))
        if result != NULL:
            return result.decode("utf-8")
        return None

    def set_node(self, path, Graph node):
        cdef int result = c_ogdl.Graph_set(self._c_graph, c_str(path), node._c_graph)
        return result

    def md(self, path):
        b_path = path.encode("utf-8")
        cdef char* c_path = b_path
        cdef c_ogdl.Graph result = c_ogdl.Graph_md(self._c_graph, c_str(path))
        if result != NULL:
            subgraph = Graph()
            subgraph._c_graph = result
            return subgraph
        return None

    def get_node(self, name):
        cdef c_ogdl.Graph node = c_ogdl.Graph_getNode(self._c_graph, c_str(name))
        if node != NULL:
            subgraph = Graph()
            subgraph._c_graph = node
            return subgraph
        return None

    def set_name(self, name):
        return c_ogdl.Graph_setName(self._c_graph, c_str(name))

    def add_node(self, Graph node):
        return c_ogdl.Graph_addNode(self._c_graph, node._c_graph)

    def add(self, name):
        cdef c_ogdl.Graph node = c_ogdl.Graph_add(self._c_graph, c_str(name))
        subgraph = Graph()
        subgraph._c_graph = node
        return subgraph

    @property
    def size(self):
        return c_ogdl.Graph_size(self._c_graph)

    def __getitem__(self, index):
        cdef int c_index = index
        cdef c_ogdl.Graph item = c_ogdl.Graph_getByIndex(self._c_graph, c_index)
        if item == NULL:
            return None
        subgraph = Graph()
        subgraph._c_graph = item
        return subgraph

    def __str__(self):
        return self.to_string(0)

    def to_string(self, indent):
        ret = ""
        newline = ""
        if indent > 0:
            indent_str = "  " * indent
            ret = indent_str + self.name
            newline = "\n"
        for i in range(0, self.size):
            subgraph = self[i]
            ret = ret + newline + subgraph.to_string(indent + 1)
            newline = "\n"
        return ret

    @property
    def name(self):
        return c_ogdl.Graph_getName(self._c_graph).decode("utf-8")


def load(filename):
    cdef c_ogdl.OgdlParser parser
    cdef c_ogdl.Graph graph
    cdef FILE* file

    file = fopen(c_str(filename), "r")
    if file == NULL:
        raise FileNotFoundError(filename)

    parser = c_ogdl.OgdlParser_new()
    if parser == NULL:
        raise Exception("Failed to create OGDL parser!")

    c_ogdl.OgdlParser_parse(parser, file)

    fclose(file)

    if parser[0].g != NULL:
        graph = parser[0].g[0]
        free(parser[0].g)
    free(parser)

    result_graph = Graph()
    result_graph._c_graph = graph
    return result_graph

def parse(graph_str):
    cdef c_ogdl.OgdlParser parser = c_ogdl.OgdlParser_new()
    if parser == NULL:
        raise Exception("Failed to create OGDL parser!")

    c_ogdl.OgdlParser_parseString(parser, c_str(graph_str))

    if parser[0].g != NULL:
        graph = parser[0].g[0]
        free(parser[0].g)
    free(parser)

    result_graph = Graph()
    result_graph._c_graph = graph
    return result_graph