from libc.stdio cimport FILE

cdef extern from "ogdl.h":

    cdef char* VERSION = "20120120"

    ctypedef int (*readFunction)(int fd)

    cdef int EVENT_FORMAT
    cdef int EVENT_TEXT
    cdef int EVENT_BINARY
    cdef int EVENT_COMMENT

    ctypedef void (*eventHandlerFunction)(void *object, int level, int type, char *data)
    
    ctypedef void (*errorHandlerFunction)(void *object, int errno)

    cdef enum: 
        ERROR_none,
        ERROR_malloc,
        ERROR_maxLevels,
        ERROR_negativeLevels,
        ERROR_nullGraph,
        ERROR_mixedTabsSpaces,
        ERROR_textOverflow1,
        ERROR_textOverflow2,
        ERROR_textOverflow3,
        ERROR_textOverflow4,
        ERROR_textOverflow5,
        ERROR_textOverflow6,
        ERROR_textOverflow7,
        ERROR_textOverflow8,
        ERROR_maxGroups,
        ERROR_negativeGroups,
        ERROR_maxLevels2,
        ERROR_notFound,
        ERROR_realloc,
        ERROR_argumentOutOfRange,
        ERROR_noObject,
        ERROR_argumentIsNull,
        ERROR_max

    cdef struct _Graph:
        char* name
        char* type
        int    size
        int    size_max
        _Graph **nodes

    ctypedef _Graph* Graph

    Graph   Graph_new(char * name)
    void    Graph_free(Graph g)
    Graph   Graph_get             (Graph g, char * path)
    char*   Graph_getString       (Graph g, char * path)
    int     Graph_set             (Graph g, char * path, Graph node)
    Graph   Graph_md              (Graph g, char * path)
    Graph   Graph_getNode         (Graph g, char * name)
    int     Graph_setName         (Graph g, char *s)
    int     Graph_addNode         (Graph g, Graph node)
    Graph   Graph_add             (Graph g, char *name)
    void    Graph_print           (Graph g)
    void    Graph_fprint          (Graph g, FILE *fp, int maxlevel, int nspaces, int mode)
    int     Graph_printString     (const char *s, int indent, int pending_break)
    int     Graph_fprintString    (FILE *fp, const char *s, int indent, int pending_break)
    int     Graph_size            (Graph g)
    Graph   Graph_getByIndex      (Graph g, int index)
    char*   Graph_getNameByIndex  (Graph g, int index)
    char*   Graph_getName         (Graph g)

    char* Path_element(char* path, char* buf)

    DEF LEVELS = 128
    DEF GROUPS = 128
    DEF BUFFER = 65534
    char OGDL_EOS

    cdef struct _OgdlParser:
        char buf[BUFFER]
        int level

        int last_char
        int groups[GROUPS]
        int groupIndex
        int line
        int line_level
        int saved_space
        int saved_newline
        int tabs
        int indentation[LEVELS]
        
        eventHandlerFunction handler
        errorHandlerFunction errorHandler

        void *src
        int  src_index
        int  src_type
        
        Graph *g
        int is_comment

    ctypedef _OgdlParser* OgdlParser

    OgdlParser   OgdlParser_new              ()
    OgdlParser   OgdlParser_reuse            (OgdlParser p)
    OgdlParser   OgdlParser_detachGraph      (OgdlParser p)
    void         OgdlParser_free             (OgdlParser p)
    void         OgdlParser_setHandler       (OgdlParser p, eventHandlerFunction ev)
    int          OgdlParser_parse            (OgdlParser p, FILE * f)
    int          OgdlParser_parseString      (OgdlParser p, char * s)
    void         OgdlParser_graphHandler     (OgdlParser p, int level, int type, char * s)
    void         OgdlParser_printHandler     (OgdlParser p, int level, int type, char * s)
    Graph        Ogdl_load                   (char * fileName)
    void         OgdlParser_error            (OgdlParser p, int n)
    void         OgdlParser_fatal            (OgdlParser p, int n)
    void         OgdlParser_setErrorHandler  (OgdlParser p, errorHandlerFunction h)
    const char * OgdlParser_getErrorMessage  (int n)

    int OGDL_ERROR_TABS_SPACES

    cdef struct _OgdlBinParser:
        char buf[BUFFER]
        int level

        eventHandlerFunction handler
        errorHandlerFunction errorHandler
        
        int  len

        readFunction         read
        int                  readfd
        Graph *g
        
    ctypedef _OgdlBinParser* OgdlBinParser

    OgdlBinParser   OgdlBinParser_new          (readFunction readf, int fd)
    void            OgdlBinParser_free         (OgdlBinParser p)
    Graph           OgdlBinParser_parse        (OgdlBinParser p)
    void            OgdlBinParser_graphHandler (OgdlBinParser p, int level, int type, char *s)

    cdef struct _OgdlLog:
        FILE *f
        OgdlParser p

    ctypedef _OgdlLog* OgdlLog

    OgdlLog        OgdlLog_new      (char *fileName)
    void           OgdlLog_free     (OgdlLog l)
    unsigned long  OgdlLog_add      (OgdlLog l, Graph g)
    Graph          OgdlLog_get      (OgdlLog l, unsigned long offset)
    Graph          OgdlLog_next     (OgdlLog l)
    unsigned long  OgdlLog_position (OgdlLog l)