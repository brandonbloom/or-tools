# ---------- JavaScript support using SWIG ----------
.PHONY: help_javascript # Generate list of JavaScript targets with descriptions.
help_javascript:
	@echo Use one of the following JavaScript targets:
ifeq ($(SYSTEM),win)
	@$(GREP) "^.PHONY: .* #" $(CURDIR)/makefiles/Makefile.javascript.mk | $(SED) "s/\.PHONY: \(.*\) # \(.*\)/\1\t\2/"
	@echo off & echo(
else
	@$(GREP) "^.PHONY: .* #" $(CURDIR)/makefiles/Makefile.javascript.mk | $(SED) "s/\.PHONY: \(.*\) # \(.*\)/\1\t\2/" | expand -t24
	@echo
endif

GYP_OUT_DIR = build/Release

SWIG_JAVASCRIPT_ENGINE = node
OR_TOOLS_NODE_PATH = $(GYP_OUT_DIR)$(CPSEP)$(LIB_DIR)$(CPSEP)$(OR_ROOT_FULL)$Sdependencies$Ssources$Sprotobuf-$(PROTOBUF_TAG)$Spython

# Check for required build tools
JAVASCRIPT_COMPILER ?= node
NODE_GYP ?= node-gyp
ifeq ($(SYSTEM),win)
ifneq ($(WINDOWS_PATH_TO_JAVASCRIPT),)
JAVASCRIPT_EXECUTABLE := $(WINDOWS_PATH_TO_JAVASCRIPT)\$(JAVASCRIPT_COMPILER)
else
JAVASCRIPT_EXECUTABLE := $(shell $(WHICH) $(JAVASCRIPT_COMPILER) 2>nul)
endif
SET_NODE_PATH = set NODE_PATH=$(OR_TOOLS_NODE_PATH) &&
else # UNIX
JAVASCRIPT_EXECUTABLE := $(shell which $(JAVASCRIPT_COMPILER))
SET_NODE_PATH = NODE_PATH=$(OR_TOOLS_NODE_PATH)
endif

# All libraries and dependecies
# XXX PYALGORITHMS_LIBS = $(LIB_DIR)/_pywrapknapsack_solver.$(SWIG_PYTHON_LIB_SUFFIX)
# XXX PYGRAPH_LIBS = $(LIB_DIR)/_pywrapgraph.$(SWIG_PYTHON_LIB_SUFFIX)
# XXX PYCP_LIBS = $(LIB_DIR)/_pywrapcp.$(SWIG_PYTHON_LIB_SUFFIX)
JSLP_LIBS = $(GYP_OUT_DIR)/ortools/linear_solver.node
# XXX PYSAT_LIBS = $(LIB_DIR)/_pywrapsat.$(SWIG_PYTHON_LIB_SUFFIX)
# XXX PYDATA_LIBS = $(LIB_DIR)/_pywraprcpsp.$(SWIG_PYTHON_LIB_SUFFIX)
# XXX PYSORTED_INTERVAL_LIST_LIBS = $(LIB_DIR)/_sorted_interval_list.$(SWIG_PYTHON_LIB_SUFFIX)
JAVASCRIPT_OR_TOOLS_LIBS = \
 $(GEN_DIR)/ortools/index.js \
 $(JSALGORITHMS_LIBS) \
 $(JSGRAPH_LIBS) \
 $(JSCP_LIBS) \
 $(JSLP_LIBS) \
 $(JSSAT_LIBS) \
 $(JSDATA_LIBS) \
 $(JSSORTED_INTERVAL_LIST_LIBS)

# Main target
.PHONY: javascript # Build JavaScript OR-Tools.
.PHONY: check_javascript # Quick check only running JavaScript OR-Tools samples.
.PHONY: test_javascript # Run all JavaScript OR-Tools test targets.
ifneq ($(JAVASCRIPT_EXECUTABLE),)
javascript: $(JAVASCRIPT_OR_TOOLS_LIBS)
check_javascript: check_javascript_pimpl
test_javascript: test_javascript_pimpl
BUILT_LANGUAGES +=, JavaScript
else
javascript:
	@echo JAVASCRIPT_EXECUTABLE = "${JAVASCRIPT_EXECUTABLE}"
	$(warning Cannot find '$(JAVASCRIPT_COMPILER)' command which is needed for build. Please make sure it is installed and in system path.)
check_javascript: javascript
test_javascript: javascript
endif

# XXX PROTOBUF_PYTHON_DESC = dependencies/sources/protobuf-$(PROTOBUF_TAG)/python/google/protobuf/descriptor_pb2.py
# XXX $(PROTOBUF_PYTHON_DESC): \
# XXX dependencies/sources/protobuf-$(PROTOBUF_TAG)/python/setup.py
# XXX ifeq ($(SYSTEM),win)
# XXX 	copy dependencies$Sinstall$Sbin$Sprotoc.exe dependencies$Ssources$Sprotobuf-$(PROTOBUF_TAG)$Ssrc
# XXX 	cd dependencies$Ssources$Sprotobuf-$(PROTOBUF_TAG)$Spython && \
# XXX  "$(PYTHON_EXECUTABLE)" setup.py build
# XXX endif
# XXX ifeq ($(PLATFORM),LINUX)
# XXX 	cd dependencies$Ssources$Sprotobuf-$(PROTOBUF_TAG)$Spython && \
# XXX  LD_LIBRARY_PATH="$(UNIX_PROTOBUF_DIR)/lib64":"$(UNIX_PROTOBUF_DIR)/lib":$(LD_LIBRARY_PATH) \
# XXX  PROTOC=$(PROTOC_BINARY) \
# XXX  "$(PYTHON_EXECUTABLE)" setup.py build
# XXX endif
# XXX ifeq ($(PLATFORM),MACOSX)
# XXX 	cd dependencies$Ssources$Sprotobuf-$(PROTOBUF_TAG)$Spython && \
# XXX  DYLD_LIBRARY_PATH="$(UNIX_PROTOBUF_DIR)/lib":$(DYLD_LIBRARY_PATH) \
# XXX  PROTOC=$(PROTOC_BINARY) \
# XXX  "$(PYTHON_EXECUTABLE)" setup.py build
# XXX endif
# XXX 
$(GEN_DIR)/ortools/index.js: | $(GEN_DIR)/ortools
	$(COPY) ortools$Sindex.js $(GEN_PATH)$Sortools$Sindex.js
# XXX 
# XXX #######################
# XXX ##  Python Wrappers  ##
# XXX #######################
# XXX # pywrapknapsack_solver
# XXX ifeq ($(PLATFORM),MACOSX)
# XXX PYALGORITHMS_LDFLAGS = -install_name @rpath/_pywrapknapsack_solver.$(SWIG_PYTHON_LIB_SUFFIX) #
# XXX endif
# XXX 
# XXX $(GEN_DIR)/ortools/algorithms/pywrapknapsack_solver.py: \
# XXX  $(SRC_DIR)/ortools/base/base.i \
# XXX  $(SRC_DIR)/ortools/util/python/vector.i \
# XXX  $(SRC_DIR)/ortools/algorithms/python/knapsack_solver.i \
# XXX  $(SRC_DIR)/ortools/algorithms/knapsack_solver.h \
# XXX  $(PROTOBUF_PYTHON_DESC) \
# XXX  | $(GEN_DIR)/ortools/algorithms
# XXX 	$(SWIG_BINARY) $(SWIG_INC) -I$(INC_DIR) -c++ -python $(SWIG_PYTHON3_FLAG) $(SWIG_PY_DOXYGEN) \
# XXX  -o $(GEN_PATH)$Sortools$Salgorithms$Sknapsack_solver_python_wrap.cc \
# XXX  -module pywrapknapsack_solver \
# XXX  ortools$Salgorithms$Spython$Sknapsack_solver.i
# XXX 
# XXX $(GEN_DIR)/ortools/algorithms/knapsack_solver_python_wrap.cc: \
# XXX  $(GEN_DIR)/ortools/algorithms/pywrapknapsack_solver.py
# XXX 
# XXX $(OBJ_DIR)/swig/knapsack_solver_python_wrap.$O: \
# XXX  $(GEN_DIR)/ortools/algorithms/knapsack_solver_python_wrap.cc \
# XXX  $(ALGORITHMS_DEPS) \
# XXX  | $(OBJ_DIR)/swig
# XXX 	$(CCC) $(CFLAGS) $(PYTHON_INC) $(PYTHON3_CFLAGS) \
# XXX  -c $(GEN_PATH)$Sortools$Salgorithms$Sknapsack_solver_python_wrap.cc \
# XXX  $(OBJ_OUT)$(OBJ_DIR)$Sswig$Sknapsack_solver_python_wrap.$O
# XXX 
# XXX $(PYALGORITHMS_LIBS): $(OBJ_DIR)/swig/knapsack_solver_python_wrap.$O $(OR_TOOLS_LIBS)
# XXX 	$(DYNAMIC_LD) \
# XXX  $(PYALGORITHMS_LDFLAGS) \
# XXX  $(LD_OUT)$(LIB_DIR)$S_pywrapknapsack_solver.$(SWIG_PYTHON_LIB_SUFFIX) \
# XXX  $(OBJ_DIR)$Sswig$Sknapsack_solver_python_wrap.$O \
# XXX  $(OR_TOOLS_LNK) \
# XXX  $(SYS_LNK) \
# XXX  $(PYTHON_LNK) \
# XXX  $(PYTHON_LDFLAGS)
# XXX ifeq ($(SYSTEM),win)
# XXX 	copy $(LIB_DIR)$S_pywrapknapsack_solver.$(SWIG_PYTHON_LIB_SUFFIX) $(GEN_PATH)\\ortools\\algorithms\\_pywrapknapsack_solver.pyd
# XXX else
# XXX 	cp $(PYALGORITHMS_LIBS) $(GEN_PATH)/ortools/algorithms
# XXX endif
# XXX 
# XXX # pywrapgraph
# XXX ifeq ($(PLATFORM),MACOSX)
# XXX PYGRAPH_LDFLAGS = -install_name @rpath/_pywrapgraph.$(SWIG_PYTHON_LIB_SUFFIX) #
# XXX endif
# XXX 
# XXX $(GEN_DIR)/ortools/graph/pywrapgraph.py: \
# XXX  $(SRC_DIR)/ortools/base/base.i \
# XXX  $(SRC_DIR)/ortools/util/python/vector.i \
# XXX  $(SRC_DIR)/ortools/graph/python/graph.i \
# XXX  $(SRC_DIR)/ortools/graph/min_cost_flow.h \
# XXX  $(SRC_DIR)/ortools/graph/max_flow.h \
# XXX  $(SRC_DIR)/ortools/graph/ebert_graph.h \
# XXX  $(SRC_DIR)/ortools/graph/shortestpaths.h \
# XXX  $(PROTOBUF_PYTHON_DESC) \
# XXX  | $(GEN_DIR)/ortools/graph
# XXX 	$(SWIG_BINARY) $(SWIG_INC) -I$(INC_DIR) -c++ -python $(SWIG_PYTHON3_FLAG) \
# XXX  -o $(GEN_PATH)$Sortools$Sgraph$Sgraph_python_wrap.cc \
# XXX  -module pywrapgraph \
# XXX  ortools$Sgraph$Spython$Sgraph.i
# XXX 
# XXX $(GEN_DIR)/ortools/graph/graph_python_wrap.cc: \
# XXX  $(GEN_DIR)/ortools/graph/pywrapgraph.py
# XXX 
# XXX $(OBJ_DIR)/swig/graph_python_wrap.$O: \
# XXX  $(GEN_DIR)/ortools/graph/graph_python_wrap.cc \
# XXX  $(GRAPH_DEPS) \
# XXX  | $(OBJ_DIR)/swig
# XXX 	$(CCC) $(CFLAGS) $(PYTHON_INC) $(PYTHON3_CFLAGS) \
# XXX  -c $(GEN_PATH)/ortools/graph/graph_python_wrap.cc \
# XXX  $(OBJ_OUT)$(OBJ_DIR)$Sswig$Sgraph_python_wrap.$O
# XXX 
# XXX $(PYGRAPH_LIBS): $(OBJ_DIR)/swig/graph_python_wrap.$O $(OR_TOOLS_LIBS)
# XXX 	$(DYNAMIC_LD) \
# XXX  $(PYGRAPH_LDFLAGS) \
# XXX  $(LD_OUT)$(LIB_DIR)$S_pywrapgraph.$(SWIG_PYTHON_LIB_SUFFIX) \
# XXX  $(OBJ_DIR)$Sswig$Sgraph_python_wrap.$O \
# XXX  $(OR_TOOLS_LNK) \
# XXX  $(SYS_LNK) \
# XXX  $(PYTHON_LNK) \
# XXX  $(PYTHON_LDFLAGS)
# XXX ifeq ($(SYSTEM),win)
# XXX 	copy $(LIB_DIR)$S_pywrapgraph.$(SWIG_PYTHON_LIB_SUFFIX) $(GEN_PATH)\\ortools\\graph\\_pywrapgraph.pyd
# XXX else
# XXX 	cp $(PYGRAPH_LIBS) $(GEN_PATH)/ortools/graph
# XXX endif
# XXX 
# XXX # pywrapcp
# XXX ifeq ($(PLATFORM),MACOSX)
# XXX PYCP_LDFLAGS = -install_name @rpath/_pywrapcp.$(SWIG_PYTHON_LIB_SUFFIX) #
# XXX endif
# XXX 
# XXX $(GEN_DIR)/ortools/constraint_solver/search_limit_pb2.py: \
# XXX  $(SRC_DIR)/ortools/constraint_solver/search_limit.proto \
# XXX  $(PROTOBUF_PYTHON_DESC) \
# XXX  | $(GEN_DIR)/ortools/constraint_solver
# XXX 	$(PROTOC) --proto_path=$(INC_DIR) --python_out=$(GEN_PATH) $(MYPY_OUT) \
# XXX  $(SRC_DIR)$Sortools$Sconstraint_solver$Ssearch_limit.proto
# XXX 
# XXX $(GEN_DIR)/ortools/constraint_solver/assignment_pb2.py: \
# XXX  $(SRC_DIR)/ortools/constraint_solver/assignment.proto \
# XXX  $(PROTOBUF_PYTHON_DESC) \
# XXX  | $(GEN_DIR)/ortools/constraint_solver
# XXX 	$(PROTOC) --proto_path=$(INC_DIR) --python_out=$(GEN_PATH) $(MYPY_OUT) \
# XXX  $(SRC_DIR)$Sortools$Sconstraint_solver$Sassignment.proto
# XXX 
# XXX $(GEN_DIR)/ortools/constraint_solver/solver_parameters_pb2.py: \
# XXX  $(SRC_DIR)/ortools/constraint_solver/solver_parameters.proto \
# XXX  $(PROTOBUF_PYTHON_DESC) \
# XXX  | $(GEN_DIR)/ortools/constraint_solver
# XXX 	$(PROTOC) --proto_path=$(INC_DIR) --python_out=$(GEN_PATH) $(MYPY_OUT) \
# XXX  $(SRC_DIR)$Sortools$Sconstraint_solver$Ssolver_parameters.proto
# XXX 
# XXX $(GEN_DIR)/ortools/constraint_solver/routing_enums_pb2.py: \
# XXX  $(SRC_DIR)/ortools/constraint_solver/routing_enums.proto \
# XXX  $(PROTOBUF_PYTHON_DESC) \
# XXX  | $(GEN_DIR)/ortools/constraint_solver
# XXX 	$(PROTOC) --proto_path=$(INC_DIR) --python_out=$(GEN_PATH) $(MYPY_OUT) \
# XXX  $(SRC_DIR)$Sortools$Sconstraint_solver$Srouting_enums.proto
# XXX 
# XXX $(GEN_DIR)/ortools/constraint_solver/routing_parameters_pb2.py: \
# XXX  $(SRC_DIR)/ortools/constraint_solver/routing_parameters.proto \
# XXX  $(GEN_DIR)/ortools/constraint_solver/solver_parameters_pb2.py \
# XXX  $(GEN_DIR)/ortools/constraint_solver/routing_enums_pb2.py \
# XXX  $(PROTOBUF_PYTHON_DESC) \
# XXX  | $(GEN_DIR)/ortools/constraint_solver
# XXX 	$(PROTOC) --proto_path=$(INC_DIR) --python_out=$(GEN_PATH) $(MYPY_OUT) \
# XXX  $(SRC_DIR)$Sortools$Sconstraint_solver$Srouting_parameters.proto
# XXX 
# XXX $(GEN_DIR)/ortools/constraint_solver/pywrapcp.py: \
# XXX  $(SRC_DIR)/ortools/base/base.i \
# XXX  $(SRC_DIR)/ortools/util/python/vector.i \
# XXX  $(SRC_DIR)/ortools/constraint_solver/python/constraint_solver.i \
# XXX  $(SRC_DIR)/ortools/constraint_solver/python/routing.i \
# XXX  $(SRC_DIR)/ortools/constraint_solver/constraint_solver.h \
# XXX  $(SRC_DIR)/ortools/constraint_solver/constraint_solveri.h \
# XXX  $(GEN_DIR)/ortools/constraint_solver/assignment_pb2.py \
# XXX  $(GEN_DIR)/ortools/constraint_solver/routing_enums_pb2.py \
# XXX  $(GEN_DIR)/ortools/constraint_solver/routing_parameters_pb2.py \
# XXX  $(GEN_DIR)/ortools/constraint_solver/search_limit_pb2.py \
# XXX  $(GEN_DIR)/ortools/constraint_solver/solver_parameters_pb2.py \
# XXX  $(GEN_DIR)/ortools/constraint_solver/assignment.pb.h \
# XXX  $(GEN_DIR)/ortools/constraint_solver/search_limit.pb.h \
# XXX  $(CP_LIB_OBJS) \
# XXX  $(PROTOBUF_PYTHON_DESC) \
# XXX  | $(GEN_DIR)/ortools/constraint_solver
# XXX 	$(SWIG_BINARY) $(SWIG_INC) -I$(INC_DIR) -c++ -python -nofastunpack $(SWIG_PYTHON3_FLAG) $(SWIG_PY_DOXYGEN) \
# XXX  -o $(GEN_PATH)$Sortools$Sconstraint_solver$Sconstraint_solver_python_wrap.cc \
# XXX  -module pywrapcp \
# XXX  $(SRC_DIR)/ortools/constraint_solver$Spython$Srouting.i
# XXX 	$(SED) -i -e 's/< long long >/< int64 >/g' \
# XXX  $(GEN_PATH)$Sortools$Sconstraint_solver$Sconstraint_solver_python_wrap.cc
# XXX 	$(SED) -i -e 's/< long long,long long >/< int64, int64 >/g' \
# XXX  $(GEN_PATH)$Sortools$Sconstraint_solver$Sconstraint_solver_python_wrap.cc
# XXX 	$(SED) -i -e 's/< long long,std::allocator/< int64, std::allocator/g' \
# XXX  $(GEN_PATH)$Sortools$Sconstraint_solver$Sconstraint_solver_python_wrap.cc
# XXX 	$(SED) -i -e 's/,long long,/,int64,/g' \
# XXX  $(GEN_PATH)$Sortools$Sconstraint_solver$Sconstraint_solver_python_wrap.cc
# XXX 
# XXX $(GEN_DIR)/ortools/constraint_solver/constraint_solver_python_wrap.cc: \
# XXX  $(GEN_DIR)/ortools/constraint_solver/pywrapcp.py
# XXX 
# XXX $(OBJ_DIR)/swig/constraint_solver_python_wrap.$O: \
# XXX  $(GEN_DIR)/ortools/constraint_solver/constraint_solver_python_wrap.cc \
# XXX  $(CP_DEPS) \
# XXX  | $(OBJ_DIR)/swig
# XXX 	$(CCC) $(CFLAGS) $(PYTHON_INC) $(PYTHON3_CFLAGS) \
# XXX  -c $(GEN_PATH)$Sortools$Sconstraint_solver$Sconstraint_solver_python_wrap.cc \
# XXX  $(OBJ_OUT)$(OBJ_DIR)$Sswig$Sconstraint_solver_python_wrap.$O
# XXX 
# XXX $(PYCP_LIBS): $(OBJ_DIR)/swig/constraint_solver_python_wrap.$O $(OR_TOOLS_LIBS)
# XXX 	$(DYNAMIC_LD) \
# XXX  $(PYCP_LDFLAGS) \
# XXX  $(LD_OUT)$(LIB_DIR)$S_pywrapcp.$(SWIG_PYTHON_LIB_SUFFIX) \
# XXX  $(OBJ_DIR)$Sswig$Sconstraint_solver_python_wrap.$O \
# XXX  $(OR_TOOLS_LNK) \
# XXX  $(SYS_LNK) \
# XXX  $(PYTHON_LNK) \
# XXX  $(PYTHON_LDFLAGS)
# XXX ifeq ($(SYSTEM),win)
# XXX 	copy $(LIB_DIR)$S_pywrapcp.$(SWIG_PYTHON_LIB_SUFFIX) $(GEN_PATH)\\ortools\\constraint_solver\\_pywrapcp.pyd
# XXX else
# XXX 	cp $(PYCP_LIBS) $(GEN_PATH)/ortools/constraint_solver
# XXX endif

# jswraplp
ifeq ($(PLATFORM),MACOSX)
JSLP_LDFLAGS = -install_name @rpath/_jswraplp.node
endif

# XXX $(GEN_DIR)/ortools/util/optional_boolean_pb2.py: \
# XXX  $(SRC_DIR)/ortools/util/optional_boolean.proto \
# XXX  $(PROTOBUF_PYTHON_DESC) \
# XXX  | $(GEN_DIR)/ortools/util
# XXX 	$(PROTOC) --proto_path=$(INC_DIR) --python_out=$(GEN_PATH) $(MYPY_OUT) \
# XXX  $(SRC_DIR)/ortools/util/optional_boolean.proto
# XXX 
# XXX $(GEN_DIR)/ortools/linear_solver/linear_solver_pb2.py: \
# XXX  $(SRC_DIR)/ortools/linear_solver/linear_solver.proto \
# XXX  $(GEN_DIR)/ortools/util/optional_boolean_pb2.py \
# XXX  $(PROTOBUF_PYTHON_DESC) \
# XXX  | $(GEN_DIR)/ortools/linear_solver
# XXX 	$(PROTOC) --proto_path=$(INC_DIR) --python_out=$(GEN_PATH) $(MYPY_OUT) \
# XXX  $(SRC_DIR)/ortools/linear_solver/linear_solver.proto

# XXX $(GEN_DIR)/ortools/linear_solver/pywraplp.py: \
# XXX  $(SRC_DIR)/ortools/base/base.i \
# XXX  $(SRC_DIR)/ortools/util/python/vector.i \
# XXX  $(SRC_DIR)/ortools/linear_solver/python/linear_solver.i \
# XXX  $(SRC_DIR)/ortools/linear_solver/linear_solver.h \
# XXX  $(GEN_DIR)/ortools/linear_solver/linear_solver.pb.h \
# XXX  $(GEN_DIR)/ortools/linear_solver/linear_solver_pb2.py \
# XXX  $(PROTOBUF_PYTHON_DESC) \
# XXX  | $(GEN_DIR)/ortools/linear_solver
# XXX 	$(SWIG_BINARY) $(SWIG_INC) -I$(INC_DIR) -c++ -python $(SWIG_PYTHON3_FLAG) $(SWIG_PY_DOXYGEN) \
# XXX  -o $(GEN_PATH)$Sortools$Slinear_solver$Slinear_solver_python_wrap.cc \
# XXX  -module pywraplp \
# XXX  $(SRC_DIR)/ortools/linear_solver$Spython$Slinear_solver.i
# ^^^ modeled on
$(GEN_DIR)/ortools/linear_solver/index.js: \
 $(SRC_DIR)/ortools/base/base.i \
 $(SRC_DIR)/ortools/linear_solver/javascript/linear_solver.i \
 $(SRC_DIR)/ortools/linear_solver/linear_solver.h \
 $(GEN_DIR)/ortools/linear_solver/linear_solver.pb.h \
 | $(GEN_DIR)/ortools/linear_solver
	$(SWIG_BINARY) -v $(SWIG_INC) -I$(INC_DIR) -c++ -javascript -$(SWIG_JAVASCRIPT_ENGINE) \
 -o $(GEN_PATH)$Sortools$Slinear_solver$Slinear_solver_javascript_wrap.cc \
 -module jswraplp \
 $(SRC_DIR)/ortools/linear_solver$Sjavascript$Slinear_solver.i

$(GEN_DIR)/ortools/linear_solver/linear_solver_javascript_wrap.cc: \
 $(GEN_DIR)/ortools/linear_solver/index.js

$(OBJ_DIR)/swig/linear_solver_javascript_wrap.$O: \
	$(CCC) $(CFLAGS) $(JAVASCRIPT_INC) \
 -c $(GEN_PATH)$Sortools$Slinear_solver$Slinear_solver_javascript_wrap.cc \
 $(OBJ_OUT)$(OBJ_DIR)$Sswig$Slinear_solver_javascript_wrap.$O

$(JSLP_LIBS): \
 $(OBJ_DIR)/swig/linear_solver_python_wrap.$O \
 $(OR_TOOLS_LIBS) \
 $(GEN_DIR)/ortools/linear_solver/linear_solver_javascript_wrap.cc \
 $(LP_DEPS) \
 | $(OBJ_DIR)/swig
	$(NODE_GYP) configure build linear_solver

# XXX # pywrapsat
# XXX ifeq ($(PLATFORM),MACOSX)
# XXX PYSAT_LDFLAGS = -install_name @rpath/_pywrapsat.$(SWIG_PYTHON_LIB_SUFFIX) #
# XXX endif
# XXX 
# XXX $(GEN_DIR)/ortools/sat/cp_model_pb2.py: \
# XXX  $(SRC_DIR)/ortools/sat/cp_model.proto \
# XXX  $(PROTOBUF_PYTHON_DESC) \
# XXX  | $(GEN_DIR)/ortools/sat
# XXX 	$(PROTOC) --proto_path=$(INC_DIR) --python_out=$(GEN_PATH) $(MYPY_OUT) \
# XXX  $(SRC_DIR)/ortools/sat/cp_model.proto
# XXX 
# XXX $(GEN_DIR)/ortools/sat/sat_parameters_pb2.py: \
# XXX  $(SRC_DIR)/ortools/sat/sat_parameters.proto \
# XXX  $(PROTOBUF_PYTHON_DESC) \
# XXX  | $(GEN_DIR)/ortools/sat
# XXX 	$(PROTOC) --proto_path=$(INC_DIR) --python_out=$(GEN_PATH) $(MYPY_OUT) \
# XXX  $(SRC_DIR)/ortools/sat/sat_parameters.proto
# XXX 
# XXX $(GEN_DIR)/ortools/sat/pywrapsat.py: \
# XXX  $(SRC_DIR)/ortools/base/base.i \
# XXX  $(SRC_DIR)/ortools/util/python/vector.i \
# XXX  $(SRC_DIR)/ortools/sat/python/sat.i \
# XXX  $(GEN_DIR)/ortools/sat/cp_model_pb2.py \
# XXX  $(GEN_DIR)/ortools/sat/sat_parameters_pb2.py \
# XXX  $(SAT_DEPS) \
# XXX  $(PROTOBUF_PYTHON_DESC) \
# XXX  | $(GEN_DIR)/ortools/sat
# XXX 	$(SWIG_BINARY) $(SWIG_INC) -I$(INC_DIR) -c++ -python $(SWIG_PYTHON3_FLAG) \
# XXX  -o $(GEN_PATH)$Sortools$Ssat$Ssat_python_wrap.cc \
# XXX  -module pywrapsat \
# XXX  $(SRC_DIR)/ortools/sat$Spython$Ssat.i
# XXX 
# XXX $(GEN_DIR)/ortools/sat/sat_python_wrap.cc: \
# XXX  $(GEN_DIR)/ortools/sat/pywrapsat.py
# XXX 
# XXX $(OBJ_DIR)/swig/sat_python_wrap.$O: \
# XXX  $(GEN_DIR)/ortools/sat/sat_python_wrap.cc \
# XXX  $(SAT_DEPS) \
# XXX  | $(OBJ_DIR)/swig
# XXX 	$(CCC) $(CFLAGS) $(PYTHON_INC) $(PYTHON3_CFLAGS) \
# XXX  -c $(GEN_PATH)$Sortools$Ssat$Ssat_python_wrap.cc \
# XXX  $(OBJ_OUT)$(OBJ_DIR)$Sswig$Ssat_python_wrap.$O
# XXX 
# XXX $(PYSAT_LIBS): $(OBJ_DIR)/swig/sat_python_wrap.$O $(OR_TOOLS_LIBS)
# XXX 	$(DYNAMIC_LD) \
# XXX  $(PYSAT_LDFLAGS) \
# XXX  $(LD_OUT)$(LIB_DIR)$S_pywrapsat.$(SWIG_PYTHON_LIB_SUFFIX) \
# XXX  $(OBJ_DIR)$Sswig$Ssat_python_wrap.$O \
# XXX  $(OR_TOOLS_LNK) \
# XXX  $(SYS_LNK) \
# XXX  $(PYTHON_LNK) \
# XXX  $(PYTHON_LDFLAGS)
# XXX ifeq ($(SYSTEM),win)
# XXX 	copy $(LIB_DIR)$S_pywrapsat.$(SWIG_PYTHON_LIB_SUFFIX) $(GEN_PATH)\\ortools\\sat\\_pywrapsat.pyd
# XXX else
# XXX 	cp $(PYSAT_LIBS) $(GEN_PATH)/ortools/sat
# XXX endif
# XXX 
# XXX # pywraprcpsp
# XXX ifeq ($(PLATFORM),MACOSX)
# XXX PYRCPSP_LDFLAGS = -install_name @rpath/_pywraprcpsp.$(SWIG_PYTHON_LIB_SUFFIX) #
# XXX endif
# XXX 
# XXX $(GEN_DIR)/ortools/data/rcpsp_pb2.py: \
# XXX  $(SRC_DIR)/ortools/data/rcpsp.proto \
# XXX  $(PROTOBUF_PYTHON_DESC) \
# XXX  | $(GEN_DIR)/ortools/data
# XXX 	$(PROTOC) --proto_path=$(INC_DIR) --python_out=$(GEN_PATH) $(MYPY_OUT) \
# XXX  $(SRC_DIR)/ortools/data/rcpsp.proto
# XXX 
# XXX $(GEN_DIR)/ortools/data/pywraprcpsp.py: \
# XXX  $(SRC_DIR)/ortools/data/rcpsp_parser.h \
# XXX  $(SRC_DIR)/ortools/base/base.i \
# XXX  $(SRC_DIR)/ortools/data/python/rcpsp.i \
# XXX  $(GEN_DIR)/ortools/data/rcpsp_pb2.py \
# XXX  $(DATA_DEPS) \
# XXX  $(PROTOBUF_PYTHON_DESC) \
# XXX  | $(GEN_DIR)/ortools/data
# XXX 	$(SWIG_BINARY) $(SWIG_INC) -I$(INC_DIR) -c++ -python $(SWIG_PYTHON3_FLAG) \
# XXX  -o $(GEN_PATH)$Sortools$Sdata$Srcpsp_python_wrap.cc \
# XXX  -module pywraprcpsp \
# XXX  $(SRC_DIR)/ortools/data$Spython$Srcpsp.i
# XXX 
# XXX $(GEN_DIR)/ortools/data/rcpsp_python_wrap.cc: \
# XXX  $(GEN_DIR)/ortools/data/pywraprcpsp.py
# XXX 
# XXX $(OBJ_DIR)/swig/rcpsp_python_wrap.$O: \
# XXX  $(GEN_DIR)/ortools/data/rcpsp_python_wrap.cc \
# XXX  $(DATA_DEPS) \
# XXX  | $(OBJ_DIR)/swig
# XXX 	$(CCC) $(CFLAGS) $(PYTHON_INC) $(PYTHON3_CFLAGS) \
# XXX  -c $(GEN_PATH)$Sortools$Sdata$Srcpsp_python_wrap.cc \
# XXX  $(OBJ_OUT)$(OBJ_DIR)$Sswig$Srcpsp_python_wrap.$O
# XXX 
# XXX $(PYDATA_LIBS): $(OBJ_DIR)/swig/rcpsp_python_wrap.$O $(OR_TOOLS_LIBS)
# XXX 	$(DYNAMIC_LD) \
# XXX  $(PYRCPSP_LDFLAGS) \
# XXX  $(LD_OUT)$(LIB_DIR)$S_pywraprcpsp.$(SWIG_PYTHON_LIB_SUFFIX) \
# XXX  $(OBJ_DIR)$Sswig$Srcpsp_python_wrap.$O \
# XXX  $(OR_TOOLS_LNK) \
# XXX  $(SYS_LNK) \
# XXX  $(PYTHON_LNK) \
# XXX  $(PYTHON_LDFLAGS)
# XXX ifeq ($(SYSTEM),win)
# XXX 	copy $(LIB_DIR)$S_pywraprcpsp.$(SWIG_PYTHON_LIB_SUFFIX) $(GEN_PATH)\\ortools\\data\\_pywraprcpsp.pyd
# XXX else
# XXX 	cp $(PYDATA_LIBS) $(GEN_PATH)/ortools/data
# XXX endif
# XXX 
# XXX # sorted_interval_list
# XXX ifeq ($(PLATFORM),MACOSX)
# XXX PYSORTED_INTERVAL_LIST_LDFLAGS = -install_name @rpath/_sorted_interval_list.$(SWIG_PYTHON_LIB_SUFFIX) #
# XXX endif
# XXX 
# XXX $(GEN_DIR)/ortools/util/sorted_interval_list.py: \
# XXX  $(SRC_DIR)/ortools/util/sorted_interval_list.h \
# XXX  $(SRC_DIR)/ortools/base/base.i \
# XXX  $(SRC_DIR)/ortools/util/python/vector.i \
# XXX  $(SRC_DIR)/ortools/util/python/sorted_interval_list.i \
# XXX  $(UTIL_DEPS) \
# XXX  | $(GEN_DIR)/ortools/util
# XXX 	$(SWIG_BINARY) $(SWIG_INC) -I$(INC_DIR) -c++ -python $(SWIG_PY_DOXYGEN) $(SWIG_PYTHON3_FLAG) \
# XXX  -o $(GEN_PATH)$Sortools$Sutil$Ssorted_interval_list_python_wrap.cc \
# XXX  -module sorted_interval_list \
# XXX  $(SRC_DIR)$Sortools$Sutil$Spython$Ssorted_interval_list.i
# XXX 	$(SED) -i -e 's/< long long >/< int64 >/g' \
# XXX  $(GEN_PATH)$Sortools$Sutil$Ssorted_interval_list_python_wrap.cc
# XXX 
# XXX $(GEN_DIR)/ortools/util/sorted_interval_list_python_wrap.cc: \
# XXX  $(GEN_DIR)/ortools/util/sorted_interval_list.py
# XXX 
# XXX $(OBJ_DIR)/swig/sorted_interval_list_python_wrap.$O: \
# XXX  $(GEN_DIR)/ortools/util/sorted_interval_list_python_wrap.cc \
# XXX  $(UTIL_DEPS) \
# XXX  | $(OBJ_DIR)/swig
# XXX 	$(CCC) $(CFLAGS) $(PYTHON_INC) $(PYTHON3_CFLAGS) \
# XXX  -c $(GEN_PATH)$Sortools$Sutil$Ssorted_interval_list_python_wrap.cc \
# XXX  $(OBJ_OUT)$(OBJ_DIR)$Sswig$Ssorted_interval_list_python_wrap.$O
# XXX 
# XXX $(PYSORTED_INTERVAL_LIST_LIBS): $(OBJ_DIR)/swig/sorted_interval_list_python_wrap.$O $(OR_TOOLS_LIBS)
# XXX 	$(DYNAMIC_LD) \
# XXX  $(PYSORTED_INTERVAL_LIST_LDFLAGS) \
# XXX  $(LD_OUT)$(LIB_DIR)$S_sorted_interval_list.$(SWIG_PYTHON_LIB_SUFFIX) \
# XXX  $(OBJ_DIR)$Sswig$Ssorted_interval_list_python_wrap.$O \
# XXX  $(OR_TOOLS_LNK) \
# XXX  $(SYS_LNK) \
# XXX  $(PYTHON_LNK) \
# XXX  $(PYTHON_LDFLAGS)
# XXX ifeq ($(SYSTEM),win)
# XXX 	copy $(LIB_DIR)$S_sorted_interval_list.$(SWIG_PYTHON_LIB_SUFFIX) $(GEN_PATH)\\ortools\\util\\_sorted_interval_list.pyd
# XXX else
# XXX 	cp $(PYSORTED_INTERVAL_LIST_LIBS) $(GEN_PATH)/ortools/util
# XXX endif

#######################
##  JavaScript SOURCE  ##
#######################
ifeq ($(SOURCE_SUFFIX),.js) # Those rules will be used if SOURCE contains a .js file
.PHONY: build # Build a JavaScript program.
build: $(SOURCE) $(JAVASCRIPT_OR_TOOLS_LIBS) ;

.PHONY: run # Run a Python program.
run: build
	$(SET_NODE_PATH) "$(JAVASCRIPT_EXECUTABLE)" $(SOURCE_PATH) $(ARGS)
endif

###############################
##  JavaScript Examples/Samples  ##
###############################
.PHONY: test_javascript_algorithms_samples # Run all JavaScript Algorithms Samples (located in ortools/algorithms/samples)
test_javascript_algorithms_samples:
	# TODO $(MAKE) run SOURCE=ortools/algorithms/samples/knapsack.js
	# TODO $(MAKE) run SOURCE=ortools/algorithms/samples/simple_knapsack_program.js

.PHONY: test_javascript_constraint_solver_samples # Run all JavaScript CP Samples (located in ortools/constraint_solver/samples)
test_javascript_constraint_solver_samples:
	# TODO $(MAKE) run SOURCE=ortools/constraint_solver/samples/simple_cp_program.js
	# TODO $(MAKE) run SOURCE=ortools/constraint_solver/samples/simple_routing_program.js
	# TODO $(MAKE) run SOURCE=ortools/constraint_solver/samples/tsp.js
	# TODO $(MAKE) run SOURCE=ortools/constraint_solver/samples/tsp_cities.js
	# TODO $(MAKE) run SOURCE=ortools/constraint_solver/samples/tsp_circuit_board.js
	# TODO $(MAKE) run SOURCE=ortools/constraint_solver/samples/tsp_distance_matrix.js
	# TODO $(MAKE) run SOURCE=ortools/constraint_solver/samples/vrp.js
	# TODO $(MAKE) run SOURCE=ortools/constraint_solver/samples/vrp_capacity.js
	# TODO $(MAKE) run SOURCE=ortools/constraint_solver/samples/vrp_drop_nodes.js
	# TODO $(MAKE) run SOURCE=ortools/constraint_solver/samples/vrp_global_span.js
	# TODO $(MAKE) run SOURCE=ortools/constraint_solver/samples/vrp_initial_routes.js
	# TODO $(MAKE) run SOURCE=ortools/constraint_solver/samples/vrp_pickup_delivery.js
	# TODO $(MAKE) run SOURCE=ortools/constraint_solver/samples/vrp_pickup_delivery_fifo.js
	# TODO $(MAKE) run SOURCE=ortools/constraint_solver/samples/vrp_pickup_delivery_lifo.js
	# TODO $(MAKE) run SOURCE=ortools/constraint_solver/samples/vrp_resources.js
	# TODO $(MAKE) run SOURCE=ortools/constraint_solver/samples/vrp_starts_ends.js
	# TODO $(MAKE) run SOURCE=ortools/constraint_solver/samples/vrp_time_windows.js
	# TODO $(MAKE) run SOURCE=ortools/constraint_solver/samples/vrp_with_time_limit.js
	# TODO $(MAKE) run SOURCE=ortools/constraint_solver/samples/vrpgs.js
	# TODO $(MAKE) run SOURCE=ortools/constraint_solver/samples/cvrp.js
	# TODO $(MAKE) run SOURCE=ortools/constraint_solver/samples/cvrp_reload.js
	# TODO $(MAKE) run SOURCE=ortools/constraint_solver/samples/cvrptw.js
	# TODO $(MAKE) run SOURCE=ortools/constraint_solver/samples/cvrptw_break.js

.PHONY: test_javascript_graph_samples # Run all JavaScript Graph Samples (located in ortools/graph/samples)
test_javascript_graph_samples:
	# TODO $(MAKE) run SOURCE=ortools/graph/samples/simple_max_flow_program.js
	# TODO $(MAKE) run SOURCE=ortools/graph/samples/simple_min_cost_flow_program.js

.PHONY: test_javascript_linear_solver_samples # Run all JavaScript LP Samples (located in ortools/linear_solver/samples)
test_javascript_linear_solver_samples:
	# TODO $(MAKE) run SOURCE=ortools/linear_solver/samples/simple_lp_program.js
	# TODO $(MAKE) run SOURCE=ortools/linear_solver/samples/simple_mip_program.js
	# TODO $(MAKE) run SOURCE=ortools/linear_solver/samples/linear_programming_example.js
	# TODO $(MAKE) run SOURCE=ortools/linear_solver/samples/integer_programming_example.js

.PHONY: test_javascript_sat_samples # Run all JavaScript Sat Samples (located in ortools/sat/samples)
test_javascript_sat_samples:
	# TODO $(MAKE) run SOURCE=ortools/sat/samples/binpacking_problem_sat
	# TODO $(MAKE) run SOURCE=ortools/sat/samples/bool_or_sample_sat
	# TODO $(MAKE) run SOURCE=ortools/sat/samples/channeling_sample_sat
	# TODO $(MAKE) run SOURCE=ortools/sat/samples/cp_is_fun_sat
	# TODO $(MAKE) run SOURCE=ortools/sat/samples/earliness_tardiness_cost_sample_sat
	# TODO $(MAKE) run SOURCE=ortools/sat/samples/interval_sample_sat
	# TODO $(MAKE) run SOURCE=ortools/sat/samples/literal_sample_sat
	# TODO $(MAKE) run SOURCE=ortools/sat/samples/minimal_jobshop_sat
	# TODO $(MAKE) run SOURCE=ortools/sat/samples/no_overlap_sample_sat
	# TODO $(MAKE) run SOURCE=ortools/sat/samples/nurses_sat
	# TODO $(MAKE) run SOURCE=ortools/sat/samples/optional_interval_sample_sat
	# TODO $(MAKE) run SOURCE=ortools/sat/samples/rabbits_and_pheasants_sat
	# TODO $(MAKE) run SOURCE=ortools/sat/samples/ranking_sample_sat
	# TODO $(MAKE) run SOURCE=ortools/sat/samples/reified_sample_sat
	# TODO $(MAKE) run SOURCE=ortools/sat/samples/simple_sat_program
	# TODO $(MAKE) run SOURCE=ortools/sat/samples/search_for_all_solutions_sample_sat
	# TODO $(MAKE) run SOURCE=ortools/sat/samples/solve_and_print_intermediate_solutions_sample_sat
	# TODO $(MAKE) run SOURCE=ortools/sat/samples/solve_with_time_limit_sample_sat
	# TODO $(MAKE) run SOURCE=ortools/sat/samples/step_function_sample_sat
	# TODO $(MAKE) run SOURCE=ortools/sat/samples/stop_after_n_solutions_sample_sat

.PHONY: check_javascript_pimpl
check_javascript_pimpl: \
 test_javascript_algorithms_samples \
 test_javascript_constraint_solver_samples \
 test_javascript_graph_samples \
 test_javascript_linear_solver_samples \
 test_javascript_sat_samples

.PHONY: test_javascript_tests # Run all Python Tests (located in examples/tests)
test_javascript_tests:
	# TODO $(MAKE) run SOURCE=examples/tests/lp_test.js
	# TODO $(MAKE) run SOURCE=examples/tests/cp_model_test.js
	# TODO $(MAKE) run SOURCE=examples/tests/sorted_interval_list_test.js
	# TODO $(MAKE) run SOURCE=examples/tests/test_cp_api.js
	# TODO $(MAKE) run SOURCE=examples/tests/test_routing_api.js
	# TODO $(MAKE) run SOURCE=examples/tests/test_lp_api.js
	# TODO $(MAKE) run SOURCE=examples/tests/pywrapcp_test.js
	# TODO $(MAKE) run SOURCE=examples/tests/pywraplp_test.js
	# TODO $(MAKE) run SOURCE=examples/tests/pywraprouting_test.js

.PHONY: test_javascript_contrib # Run all Python Contrib (located in examples/python and examples/contrib)
 test_javascript_contrib:
	# TODO $(MAKE) run SOURCE=examples/contrib/3_jugs_mip.js
	# TODO $(MAKE) run SOURCE=examples/contrib/3_jugs_regular.js
	# TODO $(MAKE) run SOURCE=examples/contrib/alldifferent_except_0.js
	# TODO $(MAKE) run SOURCE=examples/contrib/all_interval.js
	# TODO $(MAKE) run SOURCE=examples/contrib/alphametic.js
	# TODO $(MAKE) run SOURCE=examples/contrib/a_round_of_golf.js
	# TODO $(MAKE) run SOURCE=examples/contrib/assignment6_mip.js
	# TODO $(MAKE) run SOURCE=examples/contrib/assignment.js
	# TODO $(MAKE) run SOURCE=examples/contrib/bacp.js
	# TODO $(MAKE) run SOURCE=examples/contrib/blending.js
	# TODO $(MAKE) run SOURCE=examples/contrib/broken_weights.js
	# TODO $(MAKE) run SOURCE=examples/contrib/bus_schedule.js
	# TODO $(MAKE) run SOURCE=examples/contrib/car.js
	# TODO $(MAKE) run SOURCE=examples/contrib/check_dependencies.js
	# TODO $(MAKE) run SOURCE=examples/contrib/circuit.js
	# TODO $(MAKE) run SOURCE=examples/contrib/coins3.js
	# TODO $(MAKE) run SOURCE=examples/contrib/coins_grid_mip.js
	# TODO $(MAKE) run SOURCE=examples/contrib/coloring_ip.js
	# TODO $(MAKE) run SOURCE=examples/contrib/combinatorial_auction2.js
	# TODO $(MAKE) run SOURCE=examples/contrib/contiguity_regular.js
	# TODO $(MAKE) run SOURCE=examples/contrib/costas_array.js
	# TODO $(MAKE) run SOURCE=examples/contrib/covering_opl.js
	# TODO $(MAKE) run SOURCE=examples/contrib/crew.js
	# TODO $(MAKE) run SOURCE=examples/contrib/crossword2.js
	# TODO $(MAKE) run SOURCE=examples/contrib/crypta.js
	# TODO $(MAKE) run SOURCE=examples/contrib/crypto.js
	# TODO $(MAKE) run SOURCE=examples/contrib/curious_set_of_integers.js
	# TODO $(MAKE) run SOURCE=examples/contrib/debruijn_binary.js
	# TODO $(MAKE) run SOURCE=examples/contrib/diet1_b.js
	# TODO $(MAKE) run SOURCE=examples/contrib/diet1_mip.js
	# TODO $(MAKE) run SOURCE=examples/contrib/diet1.js
	# TODO $(MAKE) run SOURCE=examples/contrib/discrete_tomography.js
	# TODO $(MAKE) run SOURCE=examples/contrib/divisible_by_9_through_1.js
	# TODO $(MAKE) run SOURCE=examples/contrib/dudeney.js
	# TODO $(MAKE) run SOURCE=examples/contrib/einav_puzzle2.js
	# TODO $(MAKE) run SOURCE=examples/contrib/einav_puzzle.js
	# TODO $(MAKE) run SOURCE=examples/contrib/eq10.js
	# TODO $(MAKE) run SOURCE=examples/contrib/eq20.js
	# TODO $(MAKE) run SOURCE=examples/contrib/fill_a_pix.js
	# TODO $(MAKE) run SOURCE=examples/contrib/furniture_moving.js
	# TODO $(MAKE) run SOURCE=examples/contrib/futoshiki.js
	# TODO $(MAKE) run SOURCE=examples/contrib/game_theory_taha.js
	# TODO $(MAKE) run SOURCE=examples/contrib/grocery.js
	# TODO $(MAKE) run SOURCE=examples/contrib/just_forgotten.js
	# TODO $(MAKE) run SOURCE=examples/contrib/kakuro.js
	# TODO $(MAKE) run SOURCE=examples/contrib/kenken2.js
	# TODO $(MAKE) run SOURCE=examples/contrib/killer_sudoku.js
	# TODO $(MAKE) run SOURCE=examples/contrib/knapsack_cp.js
	# TODO $(MAKE) run SOURCE=examples/contrib/knapsack_mip.js
	# TODO $(MAKE) run SOURCE=examples/contrib/labeled_dice.js
	# TODO $(MAKE) run SOURCE=examples/contrib/langford.js
	# TODO $(MAKE) run SOURCE=examples/contrib/least_diff.js
	# TODO $(MAKE) run SOURCE=examples/contrib/least_square.js
	# TODO $(MAKE) run SOURCE=examples/contrib/lectures.js
	# TODO $(MAKE) run SOURCE=examples/contrib/magic_sequence_sat.js
	# TODO $(MAKE) run SOURCE=examples/contrib/magic_square_and_cards.js
	# TODO $(MAKE) run SOURCE=examples/contrib/magic_square_mip.js
	# TODO $(MAKE) run SOURCE=examples/contrib/magic_square.js
	# TODO $(MAKE) run SOURCE=examples/contrib/map.js
	# TODO $(MAKE) run SOURCE=examples/contrib/marathon2.js
	# TODO $(MAKE) run SOURCE=examples/contrib/max_flow_taha.js
	# TODO $(MAKE) run SOURCE=examples/contrib/max_flow_winston1.js
	# TODO $(MAKE) run SOURCE=examples/contrib/minesweeper.js
	# TODO $(MAKE) run SOURCE=examples/contrib/mr_smith.js
	# TODO $(MAKE) run SOURCE=examples/contrib/nonogram_default_search.js
	# TODO $(MAKE) run SOURCE=examples/contrib/nonogram_regular.js
	# TODO $(MAKE) run SOURCE=examples/contrib/nonogram_table2.js
	# TODO $(MAKE) run SOURCE=examples/contrib/nonogram_table.js
	# TODO $(MAKE) run SOURCE=examples/contrib/nqueens2.js
	# TODO $(MAKE) run SOURCE=examples/contrib/nqueens3.js
	# TODO $(MAKE) run SOURCE=examples/contrib/nqueens.js
	# TODO $(MAKE) run SOURCE=examples/contrib/nurse_rostering.js
	# TODO $(MAKE) run SOURCE=examples/contrib/nurses_cp.js
	# TODO $(MAKE) run SOURCE=examples/contrib/olympic.js
	# TODO $(MAKE) run SOURCE=examples/contrib/organize_day.js
	# TODO $(MAKE) run SOURCE=examples/contrib/pandigital_numbers.js
	# TODO $(MAKE) run SOURCE=examples/contrib/photo_problem.js
	# TODO $(MAKE) run SOURCE=examples/contrib/place_number_puzzle.js
	# TODO $(MAKE) run SOURCE=examples/contrib/p_median.js
	# TODO $(MAKE) run SOURCE=examples/contrib/post_office_problem2.js
	# TODO $(MAKE) run SOURCE=examples/contrib/production.js
	# TODO $(MAKE) run SOURCE=examples/contrib/pyls_api.js
	# TODO $(MAKE) run SOURCE=examples/contrib/quasigroup_completion.js
	# TODO $(MAKE) run SOURCE=examples/contrib/regular.js
	# TODO $(MAKE) run SOURCE=examples/contrib/regular_table2.js
	# TODO $(MAKE) run SOURCE=examples/contrib/regular_table.js
	# TODO $(MAKE) run SOURCE=examples/contrib/rogo2.js
	# TODO $(MAKE) run SOURCE=examples/contrib/rostering_with_travel.js
	# TODO $(MAKE) run SOURCE=examples/contrib/safe_cracking.js
	# TODO $(MAKE) run SOURCE=examples/contrib/scheduling_speakers.js
	# TODO $(MAKE) run SOURCE=examples/contrib/secret_santa2.js
	# TODO $(MAKE) run SOURCE=examples/contrib/send_more_money_any_base.js
	# TODO $(MAKE) run SOURCE=examples/contrib/send_most_money.js
	# TODO $(MAKE) run SOURCE=examples/contrib/seseman_b.js
	# TODO $(MAKE) run SOURCE=examples/contrib/seseman.js
	# TODO $(MAKE) run SOURCE=examples/contrib/set_covering2.js
	# TODO $(MAKE) run SOURCE=examples/contrib/set_covering3.js
	# TODO $(MAKE) run SOURCE=examples/contrib/set_covering4.js
	# TODO $(MAKE) run SOURCE=examples/contrib/set_covering_deployment.js
	# TODO $(MAKE) run SOURCE=examples/contrib/set_covering.js
	# TODO $(MAKE) run SOURCE=examples/contrib/set_covering_skiena.js
	# TODO $(MAKE) run SOURCE=examples/contrib/set_partition.js
	# TODO $(MAKE) run SOURCE=examples/contrib/sicherman_dice.js
	# TODO $(MAKE) run SOURCE=examples/contrib/ski_assignment.js
	# TODO $(MAKE) run SOURCE=examples/contrib/slitherlink.js
	# TODO $(MAKE) run SOURCE=examples/contrib/stable_marriage.js
	# TODO $(MAKE) run SOURCE=examples/contrib/steel_lns.js
	# TODO $(MAKE) run SOURCE=examples/contrib/steel.js
	# TODO $(MAKE) run SOURCE=examples/contrib/stigler.js
	# TODO $(MAKE) run SOURCE=examples/contrib/strimko2.js
	# TODO $(MAKE) run SOURCE=examples/contrib/subset_sum.js
	# TODO $(MAKE) run SOURCE=examples/contrib/survo_puzzle.js
	# TODO $(MAKE) run SOURCE=examples/contrib/toNum.js
	# TODO $(MAKE) run SOURCE=examples/contrib/traffic_lights.js
	# TODO $(MAKE) run SOURCE=examples/contrib/volsay2.js
	# TODO $(MAKE) run SOURCE=examples/contrib/volsay3.js
	# TODO $(MAKE) run SOURCE=examples/contrib/volsay.js
	# TODO $(MAKE) run SOURCE=examples/contrib/wedding_optimal_chart.js
	# TODO $(MAKE) run SOURCE=examples/contrib/who_killed_agatha.js
	# TODO $(MAKE) run SOURCE=examples/contrib/xkcd.js
	# TODO $(MAKE) run SOURCE=examples/contrib/young_tableaux.js
	# TODO $(MAKE) run SOURCE=examples/contrib/coins_grid.py ARGS="5 2"
	# TODO $(MAKE) run SOURCE=examples/contrib/hidato.py ARGS="3 3"
	# TODO $(MAKE) run SOURCE=examples/python/cvrptw_plot.js
	# TODO $(MAKE) run SOURCE=examples/contrib/nontransitive_dice.js # error: too long
	# warning: nurse_sat take 18s
	# TODO $(MAKE) run SOURCE=examples/contrib/school_scheduling_sat.js # error: too long
	# TODO $(MAKE) run SOURCE=examples/contrib/secret_santa/.js # error: too long
	# TODO $(MAKE) run SOURCE=examples/contrib/word_square.js # Not working on window since it rely on /usr/share/dict/words

.PHONY: test_javascript_javascript # Build and Run all JavaScript Examples (located in ortools/examples/python)
test_javascript_javascript:
	# TODO $(MAKE) run SOURCE=examples/javascript/appointments.js
	# TODO $(MAKE) run SOURCE=examples/javascript/assignment_sat.js
	# TODO $(MAKE) run SOURCE=examples/javascript/assignment_with_constraints_sat.js
	# TODO $(MAKE) run SOURCE=examples/javascript/balance_group_sat.js
	# TODO $(MAKE) run SOURCE=examples/javascript/chemical_balance_lp.js
	# TODO $(MAKE) run SOURCE=examples/javascript/chemical_balance_sat.js
	# TODO $(MAKE) run SOURCE=examples/javascript/flexible_job_shop_sat.js
	# TODO $(MAKE) run SOURCE=examples/javascript/gate_scheduling_sat.js
	# TODO $(MAKE) run SOURCE=examples/javascript/golomb8.js
	# TODO $(MAKE) run SOURCE=examples/javascript/hidato_sat.js
	# TODO $(MAKE) run SOURCE=examples/javascript/integer_programming.js
	# TODO $(MAKE) run SOURCE=examples/javascript/jobshop_ft06_distance_sat.js
	# TODO $(MAKE) run SOURCE=examples/javascript/jobshop_ft06_sat.js
	# TODO $(MAKE) run SOURCE=examples/javascript/jobshop_with_maintenance_sat.js
	# TODO $(MAKE) run SOURCE=examples/javascript/linear_assignment_api.js
	$(MAKE) run SOURCE=examples/javascript/linear-programming.js
	# TODO $(MAKE) run SOURCE=examples/javascript/magic_sequence_distribute.js
	# TODO $(MAKE) run SOURCE=examples/javascript/nqueens_sat.js
	# TODO $(MAKE) run SOURCE=examples/javascript/pyflow_example.js
	# TODO $(MAKE) run SOURCE=examples/javascript/reallocate_sat.js
	# TODO $(MAKE) run SOURCE=examples/javascript/rcpsp_sat.js
	# TODO $(MAKE) run SOURCE=examples/javascript/single_machine_scheduling_with_setup_release_due_dates_sat.js
	# TODO $(MAKE) run SOURCE=examples/javascript/steel_mill_slab_sat.js
	# TODO $(MAKE) run SOURCE=examples/javascript/stigler_diet.js
	# TODO $(MAKE) run SOURCE=examples/javascript/sudoku_sat.js
	# TODO $(MAKE) run SOURCE=examples/javascript/tasks_and_workers_assignment_sat.js
	# TODO $(MAKE) run SOURCE=examples/javascript/transit_time.js
	# TODO $(MAKE) run SOURCE=examples/javascript/vendor_scheduling_sat.js
	# TODO $(MAKE) run SOURCE=examples/javascript/wedding_optimal_chart_sat.js
	# TODO $(MAKE) run SOURCE=examples/javascript/worker_schedule_sat.js
	# TODO $(MAKE) run SOURCE=examples/javascript/zebra_sat.js
# XXX 	$(MAKE) run SOURCE=examples/python/shift_scheduling_sat.py ARGS="--params max_time_in_seconds:10.0"


.PHONY: test_javascript_pimpl
test_javascript_pimpl: \
 check_javascript_pimpl \
 test_javascript_tests \
 test_javascript_contrib \
 test_javascript_javascript

################
##  Cleaning  ##
################
.PHONY: clean_javascript # Clean JavaScript output from previous build.
clean_javascript:
# XXX 	-$(DEL) $(GEN_PATH)$Sortools$S__init__.py
# XXX 	-$(DEL) ortools$S*.pyc
# XXX 	-$(DELREC) ortools$S__pycache__
# XXX 	-$(DEL) $(GEN_PATH)$Sortools$Salgorithms$S*.py
# XXX 	-$(DEL) $(GEN_PATH)$Sortools$Salgorithms$S*.pyc
# XXX 	-$(DELREC) $(GEN_PATH)$Sortools$Salgorithms$S__pycache__
# XXX 	-$(DEL) ortools$Salgorithms$S*.pyc
# XXX 	-$(DELREC) ortools$Salgorithms$S__pycache__
# XXX 	-$(DEL) $(GEN_PATH)$Sortools$Salgorithms$S*_python_wrap.*
# XXX 	-$(DEL) $(GEN_PATH)$Sortools$Salgorithms$S_pywrap*
# XXX 	-$(DEL) $(GEN_PATH)$Sortools$Sgraph$S*.py
# XXX 	-$(DEL) $(GEN_PATH)$Sortools$Sgraph$S*.pyc
# XXX 	-$(DELREC) $(GEN_PATH)$Sortools$Sgraph$S__pycache__
# XXX 	-$(DEL) ortools$Sgraph$S*.pyc
# XXX 	-$(DELREC) ortools$Sgraph$S__pycache__
# XXX 	-$(DEL) $(GEN_PATH)$Sortools$Sgraph$S*_python_wrap.*
# XXX 	-$(DEL) $(GEN_PATH)$Sortools$Sgraph$S_pywrap*
# XXX 	-$(DEL) $(GEN_PATH)$Sortools$Sconstraint_solver$S*.py
# XXX 	-$(DEL) $(GEN_PATH)$Sortools$Sconstraint_solver$S*.pyc
# XXX 	-$(DELREC) $(GEN_PATH)$Sortools$Sconstraint_solver$S__pycache__
# XXX 	-$(DEL) ortools$Sconstraint_solver$S*.pyc
# XXX 	-$(DELREC) ortools$Sconstraint_solver$S__pycache__
# XXX 	-$(DEL) $(GEN_PATH)$Sortools$Sconstraint_solver$S*_python_wrap.*
# XXX 	-$(DEL) $(GEN_PATH)$Sortools$Sconstraint_solver$S_pywrap*
# XXX 	-$(DEL) $(GEN_PATH)$Sortools$Slinear_solver$S*.py
# XXX 	-$(DEL) $(GEN_PATH)$Sortools$Slinear_solver$S*.pyc
# XXX 	-$(DELREC) $(GEN_PATH)$Sortools$Slinear_solver$S__pycache__
# XXX 	-$(DEL) ortools$Slinear_solver$S*.pyc
# XXX 	-$(DELREC) ortools$Slinear_solver$S__pycache__
# XXX 	-$(DEL) $(GEN_PATH)$Sortools$Slinear_solver$S*_python_wrap.*
# XXX 	-$(DEL) $(GEN_PATH)$Sortools$Slinear_solver$S_pywrap*
# XXX 	-$(DEL) $(GEN_PATH)$Sortools$Ssat$S*.py
# XXX 	-$(DEL) $(GEN_PATH)$Sortools$Ssat$S*.pyc
# XXX 	-$(DELREC) $(GEN_PATH)$Sortools$Ssat$S__pycache__
# XXX 	-$(DEL) ortools$Ssat$S*.pyc
# XXX 	-$(DELREC) ortools$Ssat$S__pycache__
# XXX 	-$(DEL) ortools$Ssat$Spython$S*.pyc
# XXX 	-$(DELREC) ortools$Ssat$Spython$S__pycache__
# XXX 	-$(DEL) $(GEN_PATH)$Sortools$Ssat$S*_python_wrap.*
# XXX 	-$(DEL) $(GEN_PATH)$Sortools$Ssat$S_pywrap*
# XXX 	-$(DEL) $(GEN_PATH)$Sortools$Sdata$S*.py
# XXX 	-$(DEL) $(GEN_PATH)$Sortools$Sdata$S*.pyc
# XXX 	-$(DELREC) $(GEN_PATH)$Sortools$Sdata$S__pycache__
# XXX 	-$(DEL) ortools$Sdata$S*.pyc
# XXX 	-$(DELREC) ortools$Sdata$S__pycache__
# XXX 	-$(DEL) $(GEN_PATH)$Sortools$Sdata$S*_python_wrap.*
# XXX 	-$(DEL) $(GEN_PATH)$Sortools$Sdata$S_pywrap*
# XXX 	-$(DEL) $(GEN_PATH)$Sortools$Sutil$S*.py
# XXX 	-$(DEL) $(GEN_PATH)$Sortools$Sutil$S*.pyc
# XXX 	-$(DELREC) $(GEN_PATH)$Sortools$Sutil$S__pycache__
# XXX 	-$(DEL) ortools$Sutil$S*.pyc
# XXX 	-$(DELREC) ortools$Sutil$S__pycache__
# XXX 	-$(DEL) $(GEN_PATH)$Sortools$Sutil$S*_python_wrap.*
# XXX 	-$(DEL) $(GEN_PATH)$Sortools$Sutil$S_*
# XXX 	-$(DEL) $(LIB_DIR)$S_*.$(SWIG_PYTHON_LIB_SUFFIX)
# XXX 	-$(DEL) $(OBJ_DIR)$Sswig$S*python_wrap.$O
# XXX 	-$(DELREC) temp_python*
# XXX 
# XXX #####################
# XXX ##  Pypi artifact  ##
# XXX #####################
# XXX PYPI_ARCHIVE_TEMP_DIR = temp_python$(PYTHON_VERSION)
# XXX 
# XXX # PEP 513 auditwheel repair overwrite rpath to $ORIGIN/<ortools_root>/.libs
# XXX # We need to copy all dynamic libs here
# XXX ifneq ($(SYSTEM),win)
# XXX PYPI_ARCHIVE_LIBS = $(PYPI_ARCHIVE_TEMP_DIR)/ortools/ortools/.libs
# XXX endif
# XXX 
# XXX MISSING_PYPI_FILES = \
# XXX  $(PYPI_ARCHIVE_TEMP_DIR)/ortools/setup.py \
# XXX  $(PYPI_ARCHIVE_TEMP_DIR)/ortools/README.txt \
# XXX  $(PYPI_ARCHIVE_TEMP_DIR)/ortools/LICENSE-2.0.txt \
# XXX  $(PYPI_ARCHIVE_TEMP_DIR)/ortools/ortools/__init__.py \
# XXX  $(PYPI_ARCHIVE_TEMP_DIR)/ortools/ortools/algorithms \
# XXX  $(PYPI_ARCHIVE_TEMP_DIR)/ortools/ortools/graph \
# XXX  $(PYPI_ARCHIVE_TEMP_DIR)/ortools/ortools/constraint_solver \
# XXX  $(PYPI_ARCHIVE_TEMP_DIR)/ortools/ortools/linear_solver \
# XXX  $(PYPI_ARCHIVE_TEMP_DIR)/ortools/ortools/sat \
# XXX  $(PYPI_ARCHIVE_TEMP_DIR)/ortools/ortools/data \
# XXX  $(PYPI_ARCHIVE_TEMP_DIR)/ortools/ortools/util \
# XXX  $(PYPI_ARCHIVE_LIBS)
# XXX 
# XXX $(PYPI_ARCHIVE_TEMP_DIR):
# XXX 	-$(MKDIR) $(PYPI_ARCHIVE_TEMP_DIR)
# XXX 
# XXX $(PYPI_ARCHIVE_TEMP_DIR)/ortools: | $(PYPI_ARCHIVE_TEMP_DIR)
# XXX 	-$(MKDIR) $(PYPI_ARCHIVE_TEMP_DIR)$Sortools
# XXX 
# XXX $(PYPI_ARCHIVE_TEMP_DIR)/ortools/ortools: | $(PYPI_ARCHIVE_TEMP_DIR)/ortools
# XXX 	-$(MKDIR) $(PYPI_ARCHIVE_TEMP_DIR)$Sortools$Sortools
# XXX 
# XXX $(PYPI_ARCHIVE_TEMP_DIR)/ortools/README.txt: tools/README.pypi | $(PYPI_ARCHIVE_TEMP_DIR)/ortools
# XXX 	$(COPY) tools$SREADME.pypi $(PYPI_ARCHIVE_TEMP_DIR)$Sortools$SREADME.txt
# XXX 
# XXX $(PYPI_ARCHIVE_TEMP_DIR)/ortools/LICENSE-2.0.txt: LICENSE-2.0.txt | $(PYPI_ARCHIVE_TEMP_DIR)/ortools
# XXX 	$(COPY) LICENSE-2.0.txt $(PYPI_ARCHIVE_TEMP_DIR)$Sortools
# XXX 
# XXX PYTHON_SETUP_DEPS=
# XXX ifeq ($(UNIX_GFLAGS_DIR),$(OR_TOOLS_TOP)/dependencies/install)
# XXX   ifeq ($(PLATFORM),MACOSX)
# XXX     PYTHON_SETUP_DEPS += , 'libgflags.2.2.$L'
# XXX   endif
# XXX   ifeq ($(PLATFORM),LINUX)
# XXX     PYTHON_SETUP_DEPS += , 'libgflags.$L.2.2'
# XXX   endif
# XXX endif
# XXX ifeq ($(UNIX_GLOG_DIR),$(OR_TOOLS_TOP)/dependencies/install)
# XXX   ifeq ($(PLATFORM),MACOSX)
# XXX     PYTHON_SETUP_DEPS += , 'libglog.0.4.0.$L'
# XXX   endif
# XXX   ifeq ($(PLATFORM),LINUX)
# XXX     PYTHON_SETUP_DEPS += , 'libglog.$L.0.4.0'
# XXX   endif
# XXX endif
# XXX ifeq ($(UNIX_PROTOBUF_DIR),$(OR_TOOLS_TOP)/dependencies/install)
# XXX   ifeq ($(PLATFORM),MACOSX)
# XXX     PYTHON_SETUP_DEPS += , 'libprotobuf.3.7.1.0.$L'
# XXX   endif
# XXX   ifeq ($(PLATFORM),LINUX)
# XXX     PYTHON_SETUP_DEPS += , 'libprotobuf.$L.3.7.1.0'
# XXX   endif
# XXX endif
# XXX ifeq ($(UNIX_ABSL_DIR),$(OR_TOOLS_TOP)/dependencies/install)
# XXX   ifeq ($(PLATFORM),MACOSX)
# XXX     PYTHON_SETUP_DEPS += , 'libabsl_*'
# XXX   endif
# XXX   ifeq ($(PLATFORM),LINUX)
# XXX     PYTHON_SETUP_DEPS += , 'libabsl_*'
# XXX   endif
# XXX endif
# XXX ifeq ($(UNIX_CBC_DIR),$(OR_TOOLS_TOP)/dependencies/install)
# XXX   ifeq ($(PLATFORM),MACOSX)
# XXX     PYTHON_SETUP_DEPS += , 'libCbcSolver.3.$L'
# XXX     PYTHON_SETUP_DEPS += , 'libCbc.3.$L'
# XXX     PYTHON_SETUP_DEPS += , 'libOsiCbc.3.$L'
# XXX     PYTHON_SETUP_DEPS += , 'libCgl.1.$L'
# XXX     PYTHON_SETUP_DEPS += , 'libClpSolver.1.$L'
# XXX     PYTHON_SETUP_DEPS += , 'libClp.1.$L'
# XXX     PYTHON_SETUP_DEPS += , 'libOsiClp.1.$L'
# XXX     PYTHON_SETUP_DEPS += , 'libOsi.1.$L'
# XXX     PYTHON_SETUP_DEPS += , 'libCoinUtils.3.$L'
# XXX   endif
# XXX   ifeq ($(PLATFORM),LINUX)
# XXX     PYTHON_SETUP_DEPS += , 'libCbcSolver.$L.3'
# XXX     PYTHON_SETUP_DEPS += , 'libCbc.$L.3'
# XXX     PYTHON_SETUP_DEPS += , 'libOsiCbc.$L.3'
# XXX     PYTHON_SETUP_DEPS += , 'libCgl.$L.1'
# XXX     PYTHON_SETUP_DEPS += , 'libClpSolver.$L.1'
# XXX     PYTHON_SETUP_DEPS += , 'libClp.$L.1'
# XXX     PYTHON_SETUP_DEPS += , 'libOsiClp.$L.1'
# XXX     PYTHON_SETUP_DEPS += , 'libOsi.$L.1'
# XXX     PYTHON_SETUP_DEPS += , 'libCoinUtils.$L.3'
# XXX   endif
# XXX endif
# XXX 
# XXX ifndef PRE_RELEASE
# XXX OR_TOOLS_PYTHON_VERSION := $(OR_TOOLS_VERSION)
# XXX else
# XXX OR_TOOLS_PYTHON_VERSION := $(OR_TOOLS_MAJOR).$(OR_TOOLS_MINOR)b$(GIT_REVISION)
# XXX endif
# XXX 
# XXX 
# XXX $(PYPI_ARCHIVE_TEMP_DIR)/ortools/setup.py: tools/setup.py | $(PYPI_ARCHIVE_TEMP_DIR)/ortools
# XXX 	$(COPY) tools$Ssetup.py $(PYPI_ARCHIVE_TEMP_DIR)$Sortools
# XXX 	$(SED) -i -e 's/ORTOOLS_PYTHON_VERSION/ortools$(PYPI_OS)/' $(PYPI_ARCHIVE_TEMP_DIR)$Sortools$Ssetup.py
# XXX 	$(SED) -i -e 's/VVVV/$(OR_TOOLS_PYTHON_VERSION)/' $(PYPI_ARCHIVE_TEMP_DIR)$Sortools$Ssetup.py
# XXX 	$(SED) -i -e 's/PROTOBUF_TAG/$(PROTOBUF_TAG)/' $(PYPI_ARCHIVE_TEMP_DIR)$Sortools$Ssetup.py
# XXX ifeq ($(SYSTEM),win)
# XXX 	$(SED) -i -e 's/\.dll/\.pyd/' $(PYPI_ARCHIVE_TEMP_DIR)/ortools/setup.py
# XXX 	$(SED) -i -e '/DELETEWIN/d' $(PYPI_ARCHIVE_TEMP_DIR)/ortools/setup.py
# XXX 	$(SED) -i -e 's/DELETEUNIX/          /g' $(PYPI_ARCHIVE_TEMP_DIR)/ortools/setup.py
# XXX 	-del $(PYPI_ARCHIVE_TEMP_DIR)\ortools\setup.py-e
# XXX else
# XXX 	$(SED) -i -e 's/\.dll/\.so/' $(PYPI_ARCHIVE_TEMP_DIR)/ortools/setup.py
# XXX 	$(SED) -i -e 's/DELETEWIN //g' $(PYPI_ARCHIVE_TEMP_DIR)/ortools/setup.py
# XXX 	$(SED) -i -e '/DELETEUNIX/d' $(PYPI_ARCHIVE_TEMP_DIR)/ortools/setup.py
# XXX 	$(SED) -i -e 's/DLL/$L/g' $(PYPI_ARCHIVE_TEMP_DIR)/ortools/setup.py
# XXX 	$(SED) -i -e "s/DDDD/$(PYTHON_SETUP_DEPS)/g" $(PYPI_ARCHIVE_TEMP_DIR)/ortools/setup.py
# XXX endif
# XXX 
# XXX $(PYPI_ARCHIVE_TEMP_DIR)/ortools/ortools/__init__.py: \
# XXX 	$(GEN_DIR)/ortools/__init__.py | $(PYPI_ARCHIVE_TEMP_DIR)/ortools/ortools
# XXX 	$(COPY) $(GEN_PATH)$Sortools$S__init__.py $(PYPI_ARCHIVE_TEMP_DIR)$Sortools$Sortools$S__init__.py
# XXX ifeq ($(SYSTEM),win)
# XXX 	echo __version__ = "$(OR_TOOLS_PYTHON_VERSION)" >> \
# XXX  $(PYPI_ARCHIVE_TEMP_DIR)$Sortools$Sortools$S__init__.py
# XXX else
# XXX 	echo "__version__ = \"$(OR_TOOLS_PYTHON_VERSION)\"" >> \
# XXX  $(PYPI_ARCHIVE_TEMP_DIR)$Sortools$Sortools$S__init__.py
# XXX endif
# XXX 
# XXX $(PYPI_ARCHIVE_TEMP_DIR)/ortools/ortools/algorithms: $(PYALGORITHMS_LIBS) | $(PYPI_ARCHIVE_TEMP_DIR)/ortools/ortools
# XXX 	-$(DELREC) $(PYPI_ARCHIVE_TEMP_DIR)$Sortools$Sortools$Salgorithms
# XXX 	-$(MKDIR) $(PYPI_ARCHIVE_TEMP_DIR)$Sortools$Sortools$Salgorithms
# XXX 	$(TOUCH) $(PYPI_ARCHIVE_TEMP_DIR)$Sortools$Sortools$Salgorithms$S__init__.py
# XXX 	$(COPY) $(GEN_PATH)$Sortools$Salgorithms$Spywrapknapsack_solver.py* $(PYPI_ARCHIVE_TEMP_DIR)$Sortools$Sortools$Salgorithms
# XXX 	$(COPY) $(GEN_PATH)$Sortools$Salgorithms$S_pywrapknapsack_solver.* $(PYPI_ARCHIVE_TEMP_DIR)$Sortools$Sortools$Salgorithms
# XXX 
# XXX $(PYPI_ARCHIVE_TEMP_DIR)/ortools/ortools/graph: $(PYGRAPH_LIBS) | $(PYPI_ARCHIVE_TEMP_DIR)/ortools/ortools
# XXX 	-$(DELREC) $(PYPI_ARCHIVE_TEMP_DIR)$Sortools$Sortools$Sgraph
# XXX 	-$(MKDIR) $(PYPI_ARCHIVE_TEMP_DIR)$Sortools$Sortools$Sgraph
# XXX 	$(TOUCH) $(PYPI_ARCHIVE_TEMP_DIR)$Sortools$Sortools$Sgraph$S__init__.py
# XXX 	$(COPY) $(GEN_PATH)$Sortools$Sgraph$Spywrapgraph.py $(PYPI_ARCHIVE_TEMP_DIR)$Sortools$Sortools$Sgraph
# XXX 	$(COPY) $(GEN_PATH)$Sortools$Sgraph$S_pywrapgraph.* $(PYPI_ARCHIVE_TEMP_DIR)$Sortools$Sortools$Sgraph
# XXX 
# XXX $(PYPI_ARCHIVE_TEMP_DIR)/ortools/ortools/constraint_solver: $(PYCP_LIBS) | $(PYPI_ARCHIVE_TEMP_DIR)/ortools/ortools
# XXX 	-$(DELREC) $(PYPI_ARCHIVE_TEMP_DIR)$Sortools$Sortools$Sconstraint_solver
# XXX 	-$(MKDIR) $(PYPI_ARCHIVE_TEMP_DIR)$Sortools$Sortools$Sconstraint_solver
# XXX 	$(TOUCH) $(PYPI_ARCHIVE_TEMP_DIR)$Sortools$Sortools$Sconstraint_solver$S__init__.py
# XXX 	$(COPY) $(GEN_PATH)$Sortools$Sconstraint_solver$S*.py* $(PYPI_ARCHIVE_TEMP_DIR)$Sortools$Sortools$Sconstraint_solver
# XXX 	$(COPY) $(GEN_PATH)$Sortools$Sconstraint_solver$S_pywrapcp.* $(PYPI_ARCHIVE_TEMP_DIR)$Sortools$Sortools$Sconstraint_solver
# XXX 
# XXX $(PYPI_ARCHIVE_TEMP_DIR)/ortools/ortools/linear_solver: $(PYLP_LIBS) | $(PYPI_ARCHIVE_TEMP_DIR)/ortools/ortools
# XXX 	-$(DELREC) $(PYPI_ARCHIVE_TEMP_DIR)$Sortools$Sortools$Slinear_solver
# XXX 	-$(MKDIR) $(PYPI_ARCHIVE_TEMP_DIR)$Sortools$Sortools$Slinear_solver
# XXX 	$(TOUCH) $(PYPI_ARCHIVE_TEMP_DIR)$Sortools$Sortools$Slinear_solver$S__init__.py
# XXX 	$(COPY) ortools$Slinear_solver$S*.py $(PYPI_ARCHIVE_TEMP_DIR)$Sortools$Sortools$Slinear_solver
# XXX 	$(COPY) $(GEN_PATH)$Sortools$Slinear_solver$S*.py* $(PYPI_ARCHIVE_TEMP_DIR)$Sortools$Sortools$Slinear_solver
# XXX 	$(COPY) $(GEN_PATH)$Sortools$Slinear_solver$S_pywraplp.* $(PYPI_ARCHIVE_TEMP_DIR)$Sortools$Sortools$Slinear_solver
# XXX 
# XXX $(PYPI_ARCHIVE_TEMP_DIR)/ortools/ortools/sat: $(PYSAT_LIBS) | $(PYPI_ARCHIVE_TEMP_DIR)/ortools/ortools
# XXX 	-$(DELREC) $(PYPI_ARCHIVE_TEMP_DIR)$Sortools$Sortools$Ssat
# XXX 	-$(MKDIR) $(PYPI_ARCHIVE_TEMP_DIR)$Sortools$Sortools$Ssat
# XXX 	$(TOUCH) $(PYPI_ARCHIVE_TEMP_DIR)$Sortools$Sortools$Ssat$S__init__.py
# XXX 	$(COPY) ortools$Ssat$Sdoc$S*.md $(PYPI_ARCHIVE_TEMP_DIR)$Sortools$Sortools$Ssat
# XXX 	$(COPY) ortools$Ssat$S*.py $(PYPI_ARCHIVE_TEMP_DIR)$Sortools$Sortools$Ssat
# XXX 	$(COPY) $(GEN_PATH)$Sortools$Ssat$S*.py* $(PYPI_ARCHIVE_TEMP_DIR)$Sortools$Sortools$Ssat
# XXX 	$(COPY) $(GEN_PATH)$Sortools$Ssat$S_pywrapsat.* $(PYPI_ARCHIVE_TEMP_DIR)$Sortools$Sortools$Ssat
# XXX 	-$(MKDIR) $(PYPI_ARCHIVE_TEMP_DIR)$Sortools$Sortools$Ssat$Spython
# XXX 	$(COPY) ortools$Ssat$Spython$S*.py $(PYPI_ARCHIVE_TEMP_DIR)$Sortools$Sortools$Ssat$Spython
# XXX 
# XXX $(PYPI_ARCHIVE_TEMP_DIR)/ortools/ortools/data: $(PYDATA_LIBS) | $(PYPI_ARCHIVE_TEMP_DIR)/ortools/ortools
# XXX 	-$(DELREC) $(PYPI_ARCHIVE_TEMP_DIR)$Sortools$Sortools$Sdata
# XXX 	-$(MKDIR) $(PYPI_ARCHIVE_TEMP_DIR)$Sortools$Sortools$Sdata
# XXX 	$(TOUCH) $(PYPI_ARCHIVE_TEMP_DIR)$Sortools$Sortools$Sdata$S__init__.py
# XXX 	$(COPY) $(GEN_PATH)$Sortools$Sdata$S*.py* $(PYPI_ARCHIVE_TEMP_DIR)$Sortools$Sortools$Sdata
# XXX 	$(COPY) $(GEN_PATH)$Sortools$Sdata$S_pywraprcpsp.* $(PYPI_ARCHIVE_TEMP_DIR)$Sortools$Sortools$Sdata
# XXX 
# XXX $(PYPI_ARCHIVE_TEMP_DIR)/ortools/ortools/util: $(PYSORTED_INTERVAL_LIST_LIBS) | $(PYPI_ARCHIVE_TEMP_DIR)/ortools/ortools
# XXX 	-$(DELREC) $(PYPI_ARCHIVE_TEMP_DIR)$Sortools$Sortools$Sutil
# XXX 	-$(MKDIR) $(PYPI_ARCHIVE_TEMP_DIR)$Sortools$Sortools$Sutil
# XXX 	$(TOUCH) $(PYPI_ARCHIVE_TEMP_DIR)$Sortools$Sortools$Sutil$S__init__.py
# XXX 	$(COPY) $(GEN_PATH)$Sortools$Sutil$S*.py* $(PYPI_ARCHIVE_TEMP_DIR)$Sortools$Sortools$Sutil
# XXX 	$(COPY) $(GEN_PATH)$Sortools$Sutil$S_sorted_interval_list.* $(PYPI_ARCHIVE_TEMP_DIR)$Sortools$Sortools$Sutil
# XXX 
# XXX $(PYPI_ARCHIVE_TEMP_DIR)/ortools/ortools/.libs: | $(PYPI_ARCHIVE_TEMP_DIR)/ortools/ortools
# XXX 	-$(DELREC) $(PYPI_ARCHIVE_TEMP_DIR)$Sortools$Sortools$S.libs
# XXX 	-$(MKDIR) $(PYPI_ARCHIVE_TEMP_DIR)$Sortools$Sortools$S.libs
# XXX 
# XXX ifneq ($(PYTHON_EXECUTABLE),)
# XXX .PHONY: python_package # Create Python "ortools" wheel package
# XXX .PHONY: pypi_archive
# XXX python_package pypi_archive: $(OR_TOOLS_LIBS) python $(MISSING_PYPI_FILES)
# XXX ifneq ($(SYSTEM),win)
# XXX 	cp $(OR_TOOLS_LIBS) $(PYPI_ARCHIVE_TEMP_DIR)/ortools/ortools/.libs
# XXX endif
# XXX ifeq ($(UNIX_GFLAGS_DIR),$(OR_TOOLS_TOP)/dependencies/install)
# XXX 	$(COPYREC) dependencies$Sinstall$Slib*$Slibgflags* $(PYPI_ARCHIVE_TEMP_DIR)$Sortools$Sortools$S.libs
# XXX endif
# XXX ifeq ($(UNIX_GLOG_DIR),$(OR_TOOLS_TOP)/dependencies/install)
# XXX 	$(COPYREC) dependencies$Sinstall$Slib*$Slibglog* $(PYPI_ARCHIVE_TEMP_DIR)$Sortools$Sortools$S.libs
# XXX endif
# XXX ifeq ($(UNIX_PROTOBUF_DIR),$(OR_TOOLS_TOP)/dependencies/install)
# XXX 	$(COPYREC) $(subst /,$S,$(_PROTOBUF_LIB_DIR))libproto* $(PYPI_ARCHIVE_TEMP_DIR)$Sortools$Sortools$S.libs
# XXX endif
# XXX ifeq ($(UNIX_ABSL_DIR),$(OR_TOOLS_TOP)/dependencies/install)
# XXX 	-$(COPYREC) $(subst /,$S,$(_ABSL_LIB_DIR))$Slibabsl* $(PYPI_ARCHIVE_TEMP_DIR)$Sortools$Sortools$S.libs
# XXX endif
# XXX ifeq ($(UNIX_CBC_DIR),$(OR_TOOLS_TOP)/dependencies/install)
# XXX 	$(COPYREC) dependencies$Sinstall$Slib*$SlibCbc* $(PYPI_ARCHIVE_TEMP_DIR)$Sortools$Sortools$S.libs
# XXX 	$(COPYREC) dependencies$Sinstall$Slib*$SlibCgl* $(PYPI_ARCHIVE_TEMP_DIR)$Sortools$Sortools$S.libs
# XXX 	$(COPYREC) dependencies$Sinstall$Slib*$SlibClp* $(PYPI_ARCHIVE_TEMP_DIR)$Sortools$Sortools$S.libs
# XXX 	$(COPYREC) dependencies$Sinstall$Slib*$SlibOsi* $(PYPI_ARCHIVE_TEMP_DIR)$Sortools$Sortools$S.libs
# XXX 	$(COPYREC) dependencies$Sinstall$Slib*$SlibCoinUtils* $(PYPI_ARCHIVE_TEMP_DIR)$Sortools$Sortools$S.libs
# XXX endif
# XXX 	cd $(PYPI_ARCHIVE_TEMP_DIR)$Sortools && "$(PYTHON_EXECUTABLE)" setup.py bdist_wheel
# XXX 
# XXX .PHONY: test_python_package # Test Python "ortools" wheel package
# XXX .PHONY: test_pypi_archive
# XXX test_python_package test_pypi_archive: python_package
# XXX 	-$(DELREC) $(PYPI_ARCHIVE_TEMP_DIR)$Svenv
# XXX 	$(PYTHON_EXECUTABLE) -m virtualenv $(PYPI_ARCHIVE_TEMP_DIR)$Svenv
# XXX 	$(COPY) test.py.in $(PYPI_ARCHIVE_TEMP_DIR)$Svenv$Stest.py
# XXX ifneq ($(SYSTEM),win)
# XXX 	$(PYPI_ARCHIVE_TEMP_DIR)/venv/bin/python -m pip install $(PYPI_ARCHIVE_TEMP_DIR)/ortools/dist/*.whl
# XXX 	$(PYPI_ARCHIVE_TEMP_DIR)/venv/bin/python $(PYPI_ARCHIVE_TEMP_DIR)/venv/test.py
# XXX else
# XXX # wildcar not working on windows:  i.e. `pip install *.whl`:
# XXX # *.whl is not a valid wheel filename.
# XXX 	$(PYPI_ARCHIVE_TEMP_DIR)\venv\Scripts\python -m pip install --find-links=$(PYPI_ARCHIVE_TEMP_DIR)\ortools\dist ortools
# XXX 	$(PYPI_ARCHIVE_TEMP_DIR)\venv\Scripts\python $(PYPI_ARCHIVE_TEMP_DIR)\venv\test.py
# XXX endif
# XXX endif # ifneq ($(PYTHON_EXECUTABLE),)
# XXX 
# XXX .PHONY: install_python # Install Python OR-Tools on the host system
# XXX install_python: pypi_archive
# XXX 	cd "$(PYPI_ARCHIVE_TEMP_DIR)$Sortools" && "$(PYTHON_EXECUTABLE)" setup.py install --user
# XXX 
# XXX .PHONY: uninstall_python # Uninstall Python OR-Tools from the host system
# XXX uninstall_python:
# XXX 	"$(PYTHON_EXECUTABLE)" -m pip uninstall ortools
# XXX 
# XXX TEMP_PYTHON_DIR=temp_python
# XXX 
# XXX .PHONY: python_examples_archive # Build stand-alone Python examples archive file for redistribution.
# XXX python_examples_archive:
# XXX 	-$(DELREC) $(TEMP_PYTHON_DIR)
# XXX 	-$(MKDIR) $(TEMP_PYTHON_DIR)
# XXX 	-$(MKDIR) $(TEMP_PYTHON_DIR)$Sortools_examples
# XXX 	-$(MKDIR) $(TEMP_PYTHON_DIR)$Sortools_examples$Sexamples
# XXX 	-$(MKDIR) $(TEMP_PYTHON_DIR)$Sortools_examples$Sexamples$Spython
# XXX 	-$(MKDIR) $(TEMP_PYTHON_DIR)$Sortools_examples$Sexamples$Snotebook
# XXX 	-$(MKDIR) $(TEMP_PYTHON_DIR)$Sortools_examples$Sexamples$Sdata
# XXX 	-$(COPY) $(PYTHON_EX_PATH)$S*.py $(TEMP_PYTHON_DIR)$Sortools_examples$Sexamples$Spython
# XXX 	-$(COPY) ortools$Salgorithms$Ssamples$S*.py $(TEMP_PYTHON_DIR)$Sortools_examples$Sexamples$Spython
# XXX 	-$(COPY) ortools$Sgraph$Ssamples$S*.py $(TEMP_PYTHON_DIR)$Sortools_examples$Sexamples$Spython
# XXX 	-$(COPY) ortools$Slinear_solver$Ssamples$S*.py $(TEMP_PYTHON_DIR)$Sortools_examples$Sexamples$Spython
# XXX 	-$(COPY) ortools$Srouting$Ssamples$S*.py $(TEMP_PYTHON_DIR)$Sortools_examples$Sexamples$Spython
# XXX 	-$(COPY) ortools$Ssat$Ssamples$S*.py $(TEMP_PYTHON_DIR)$Sortools_examples$Sexamples$Spython
# XXX 	-$(COPY) examples$Snotebook$S*.ipynb $(TEMP_PYTHON_DIR)$Sortools_examples$Sexamples$Snotebook
# XXX 	-$(COPY) examples$Snotebook$S*.md $(TEMP_PYTHON_DIR)$Sortools_examples$Sexamples$Snotebook
# XXX 	-$(COPY) tools$SREADME.examples.python $(TEMP_PYTHON_DIR)$Sortools_examples$SREADME.md
# XXX 	$(COPY) LICENSE-2.0.txt $(TEMP_PYTHON_DIR)$Sortools_examples
# XXX ifeq ($(SYSTEM),win)
# XXX 	cd $(TEMP_PYTHON_DIR)\ortools_examples \
# XXX  && ..\..\$(TAR) -C ..\.. -c -v \
# XXX  --exclude *svn* --exclude *roadef* --exclude *vector_packing* \
# XXX  examples\data | ..\..\$(TAR) xvm
# XXX 	cd $(TEMP_PYTHON_DIR) \
# XXX  && ..\$(ZIP) \
# XXX  -r ..\or-tools_python_examples_v$(OR_TOOLS_VERSION).zip \
# XXX  ortools_examples
# XXX else
# XXX 	cd $(TEMP_PYTHON_DIR)/ortools_examples \
# XXX  && tar -C ../.. -c -v \
# XXX  --exclude *svn* --exclude *roadef* --exclude *vector_packing* \
# XXX  examples/data | tar xvm
# XXX 	cd $(TEMP_PYTHON_DIR) \
# XXX  && tar -c -v -z --no-same-owner \
# XXX  -f ../or-tools_python_examples$(PYPI_OS)_v$(OR_TOOLS_VERSION).tar.gz \
# XXX  ortools_examples
# XXX endif
# XXX 	-$(DELREC) $(TEMP_PYTHON_DIR)

#############
##  DEBUG  ##
#############
.PHONY: detect_javascript # Show variables used to build JavaScript OR-Tools.
detect_javascript:
	@echo Relevant info for the JavaScript build:
ifeq ($(SYSTEM),win)
	@echo WINDOWS_PATH_TO_JAVASCRIPT = "$(WINDOWS_PATH_TO_JAVASCRIPT)"
else
	@echo UNIX_PYTHON_VER = "$(UNIX_PYTHON_VER)"
endif
	@echo JAVASCRIPT_COMPILER = $(JAVASCRIPT_COMPILER)
	@echo JAVASCRIPT_EXECUTABLE = "$(JAVASCRIPT_EXECUTABLE)"
	@echo PYTHON_INC = $(PYTHON_INC)
	@echo PYTHON_LNK = $(PYTHON_LNK)
	@echo PYTHON_LDFLAGS = $(PYTHON_LDFLAGS)
	@echo SWIG_BINARY = $(SWIG_BINARY)
	@echo SWIG_INC = $(SWIG_INC)
	@echo SWIG_PY_DOXYGEN = $(SWIG_PY_DOXYGEN)
	@echo SET_NODE_PATH = "$(SET_NODE_PATH)"
ifeq ($(SYSTEM),win)
	@echo off & echo(
else
	@echo
endif
