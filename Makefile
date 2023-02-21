.PHONY: clean
.PHONY: debug
.PHONY: default
.PHONY: release
.PHONY: .build
.PHONY: .configure

# ----- Environment ----------------------------------------------------------------
NPROC = $(shell grep -c processor /proc/cpuinfo)
OUTPUT_DIR ?= $(CURDIR)/_build
CMAKE_DIR = $(OUTPUT_DIR)/cmake

ifneq ($(shell hash ninja 2>&1),)
$(error ERROR: Ninja build system not found. Please install ninja. apt-get install ninja-build)
endif

# ----- Params ----------------------------------------------------------------
app ?= all
args ?=
CMAKE_SIZE ?= size
# -----------------------------------------------------------------------------
NLOHMANN_JSON_BUILD_DEMOS ?= ON

# ----- Flags -----------------------------------------------------------------
ifeq ($(VERBOSE), 1)
cmakeflags += -DCMAKE_VERBOSE_MAKEFILE=TRUE
else
MAKEFLAGS += --silent
endif

CMAKEFLAGS ?=
cmakecommonflags += ${CMAKEFLAGS}
cmakecommonflags += -GNinja
cmakecommonflags += $(if $(value CMAKE_BUILD_TYPE),-DCMAKE_BUILD_TYPE=$(CMAKE_BUILD_TYPE))

cmakeoptions += -DNLOHMANN_JSON_BUILD_DEMOS=$(NLOHMANN_JSON_BUILD_DEMOS)

cmakeflags += ${cmakecommonflags}
cmakeflags += -DCMAKE_RUNTIME_OUTPUT_DIRECTORY=$(OUTPUT_DIR) -DCMAKE_SIZE=$(CMAKE_SIZE)
cmakeflags += ${cmakeoptions}
cmakebuild += nice cmake --build
cmakebuildflags += --parallel $(NPROC)

# ----- Targets ---------------------------------------------------------------
default: debug

release: CMAKE_BUILD_TYPE = Release
release: .build

debug: CMAKE_BUILD_TYPE = Debug
debug: .build

clean:
	rm -rf $(OUTPUT_DIR)

.build: | .configure .build_${app}

.configure:
	cmake -S $(CURDIR) -B $(CMAKE_DIR) $(cmakeflags)

.build_%:
	${cmakebuild} $(CMAKE_DIR) --target $* ${cmakebuildflags}
