DAFNY          ?= $(HOME)/dafny/Scripts/dafny
FLAGS_VERIFY   ?= --verification-time-limit 30 --log-format text
FLAGS_BUILD    ?=

SRC_DIR        := src
SRC_FILES      := $(wildcard $(SRC_DIR)/*.dfy)

VER_DIR        := results/verification
VER_LOG        := $(VER_DIR)/verify.log

BLD_DIR        := results/build
BLD_LOG        := $(BLD_DIR)/build.log
EXE_CONSTRUCT  := $(BLD_DIR)/Test_Construct
EXE_RECONSTR   := $(BLD_DIR)/Test_Reconstruct

.PHONY: all verify build clean
all: verify

verify: $(VER_LOG)

build:  $(EXE_CONSTRUCT) $(EXE_RECONSTR)

clean: clean-verification clean-build

clean-verification:
	@rm $(VER_LOG)

$(VER_LOG): $(SRC_FILES) | $(VER_DIR)
	@$(DAFNY) verify $(FLAGS_VERIFY) $(SRC_FILES) 2>&1 | tee $@

$(VER_DIR):
	@mkdir -p $@

COMMON_SOURCES = src/Common.dfy src/QuotientGraph.dfy

$(EXE_CONSTRUCT): src/Test_Construct.dfy $(COMMON_SOURCES) | $(BLD_DIR)
	@$(DAFNY) build $(FLAGS_BUILD) $^ -o $@ 2>&1 | tee $(BLD_LOG)

$(EXE_RECONSTR): src/Test_Reconstruct.dfy $(COMMON_SOURCES) | $(BLD_DIR)
	@$(DAFNY) build $(FLAGS_BUILD) $^ -o $@ 2>&1 | tee -a $(BLD_LOG)

$(BLD_DIR):
	@mkdir -p $@

clean-build:
	@rm -rf $(BLD_DIR)/*
