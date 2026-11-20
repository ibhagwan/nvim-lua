nvim ?= nvim

#
# Run under git-bash on Windows (requires: scoop install make git)
#
ifeq ($(OS),Windows_NT)
  ifneq ($(MSYSTEM),)
  else
    BASH_DIR := C:/Users/$(USERNAME)/scoop/apps/git/current/usr/bin
    ifneq ($(shell [ -f "$(BASH_DIR)/bash.exe" ] && echo 1),)
      $(info Using git-bash "$(BASH_DIR)/bash.exe")
      export PATH := $(BASH_DIR):$(PATH)
      SHELL := bash
      .SHELLFLAGS := -c
    endif
  endif
endif

#
# Download the emmylua binaries (emmylua_check + luafmt) from upstream
# if `gh` is available and they are not already on the system PATH.
# Binaries are extracted into .emmylua/ (git-ignored).
#
EMMYLUA_DIR=.emmylua
# Pin the emmylua release tag to download. Set to an empty
# string (EMMYLUA_VERSION=) to fetch the latest release instead.
EMMYLUA_VERSION=0.25.1
# OS arch detection for the emmylua binaries (Darwin/Linux/Windows,
# x64/arm64). Falls back to linux-x64 on unknown platforms; override
# by passing EMMY_CHECK_ASSET=<asset filename> or LUA_FMT_ASSET=<asset
# filename> on the make command line. Windows releases are shipped as
# `.zip` under the `win32-*` asset names.
EMMY_UNAME_S=$(shell uname -s 2>/dev/null)
EMMY_UNAME_M=$(shell uname -m 2>/dev/null)
EMMY_ARCH=$(if $(filter aarch64% arm64%,$(EMMY_UNAME_M)),arm64,x64)
ifeq ($(filter MINGW% MSYS% CYGWIN% Windows_NT,$(EMMY_UNAME_S)),)
  EMMY_OS=$(if $(filter Darwin darwin,$(EMMY_UNAME_S)),darwin,linux)
  EMMY_EXT:=
  EMMY_EXT_ARCHIVE:=.tar.gz
else
  EMMY_OS:=win32
  EMMY_EXT:=.exe
  EMMY_EXT_ARCHIVE:=.zip
endif
# Linux arm64 release assets are published with the "aarch64-glibc.2.17"
# suffix; darwin/win32 use the plain "arm64" suffix.
EMMY_ARCH_ASSET=$(if $(and $(filter linux,$(EMMY_OS)),$(filter arm64,$(EMMY_ARCH))),aarch64-glibc.2.17,$(EMMY_ARCH))
EMMY_CHECK_ASSET=emmylua_check-$(EMMY_OS)-$(EMMY_ARCH_ASSET)$(EMMY_EXT_ARCHIVE)
LUA_FMT_ASSET=luafmt-$(EMMY_OS)-$(EMMY_ARCH_ASSET)$(EMMY_EXT_ARCHIVE)
EMMY_CHECK_BIN=$(EMMYLUA_DIR)/emmylua_check$(EMMY_EXT)
LUA_FMT_BIN=$(EMMYLUA_DIR)/luafmt$(EMMY_EXT)

.PHONY: deps/emmylua
deps/emmylua:
	@mkdir -p $(EMMYLUA_DIR) ; \
	if [ ! -x "$(EMMY_CHECK_BIN)" ] && ! command -v emmylua_check >/dev/null 2>&1; then \
		if ! command -v gh >/dev/null 2>&1; then \
			echo "gh is required to download emmylua_check" >&2 ; \
			exit 1 ; \
		fi ; \
		echo "Downloading emmylua_check $(if $(EMMYLUA_VERSION),v$(EMMYLUA_VERSION),latest) [$(EMMY_CHECK_ASSET)]..." ; \
		gh release download --clobber -R EmmyLuaLs/emmylua-analyzer-rust \
			$(if $(EMMYLUA_VERSION),"$(EMMYLUA_VERSION)") \
			-p "$(EMMY_CHECK_ASSET)" -D $(EMMYLUA_DIR) && \
		case "$(EMMY_CHECK_ASSET)" in \
			*.zip) unzip -o "$(EMMYLUA_DIR)/$(EMMY_CHECK_ASSET)" -d $(EMMYLUA_DIR) 2>/dev/null || \
				powershell -NoProfile -Command "Expand-Archive -Force -LiteralPath '$(EMMYLUA_DIR)/$(EMMY_CHECK_ASSET)' -DestinationPath '$(EMMYLUA_DIR)'" ;; \
			*) tar xzf "$(EMMYLUA_DIR)/$(EMMY_CHECK_ASSET)" -C $(EMMYLUA_DIR) ;; \
		esac && \
		rm -f "$(EMMYLUA_DIR)/$(EMMY_CHECK_ASSET)" ; \
	fi ; \
	if [ ! -x "$(LUA_FMT_BIN)" ] && ! command -v luafmt >/dev/null 2>&1; then \
		if ! command -v gh >/dev/null 2>&1; then \
			echo "gh is required to download luafmt" >&2 ; \
			exit 1 ; \
		fi ; \
		echo "Downloading luafmt $(if $(EMMYLUA_VERSION),v$(EMMYLUA_VERSION),latest) [$(LUA_FMT_ASSET)]..." ; \
		gh release download --clobber -R EmmyLuaLs/emmylua-analyzer-rust \
			$(if $(EMMYLUA_VERSION),"$(EMMYLUA_VERSION)") \
			-p "$(LUA_FMT_ASSET)" -D $(EMMYLUA_DIR) && \
		case "$(LUA_FMT_ASSET)" in \
			*.zip) unzip -o "$(EMMYLUA_DIR)/$(LUA_FMT_ASSET)" -d $(EMMYLUA_DIR) 2>/dev/null || \
				powershell -NoProfile -Command "Expand-Archive -Force -LiteralPath '$(EMMYLUA_DIR)/$(LUA_FMT_ASSET)' -DestinationPath '$(EMMYLUA_DIR)'" ;; \
			*) tar xzf "$(EMMYLUA_DIR)/$(LUA_FMT_ASSET)" -C $(EMMYLUA_DIR) ;; \
		esac && \
		rm -f "$(EMMYLUA_DIR)/$(LUA_FMT_ASSET)" ; \
	fi

.PHONY: lint
lint: emmylua-check

.PHONY: emmylua-check
emmylua-check: | deps/emmylua
	@if [ -x "$(EMMY_CHECK_BIN)" ]; then \
		EMMY="$(EMMY_CHECK_BIN)" ; \
	else \
		EMMY="emmylua_check" ; \
	fi ; \
	VIMRUNTIME="$$($(nvim) --clean --headless +'echo $$VIMRUNTIME' +q 2>&1)" \
		$$EMMY . --ignore '.emmylua/**/*' --warnings-as-errors

# Lua sources formatted by `make fmt` / `make fmtcheck`. Vendored files are
# excluded via `.luafmtignore`.
FMT_DIRS ?= ./lua ./after ./init.lua

# luafmt can produce constructs that LuaJIT accepts but PUC Lua 5.1
# rejects (for example breaking `f("x").y` into `f\n("x")\n.y`).
# Validate formatted sources with a strict Lua 5.1 parser.
LUAC ?= luac
SYNTAX_DIRS ?= $(FMT_DIRS)

.PHONY: syntax-check
syntax-check:
	@command -v $(LUAC) >/dev/null 2>&1 || { \
		echo "$(LUAC) not found" >&2 ; \
		exit 1 ; \
	} ; \
	find $(SYNTAX_DIRS) -name '*.lua' -print0 | xargs -0 -n1 $(LUAC) -p

.PHONY: fmt fmtcheck
fmt: | deps/emmylua
	@if [ -x "$(LUA_FMT_BIN)" ]; then \
		FMT="$(LUA_FMT_BIN)" ; \
	else \
		FMT="luafmt" ; \
	fi ; \
	$$FMT --config .luafmt.toml --write --recursive $(FMT_DIRS) ; \
	rc=$$? ; \
	if [ $$rc -ne 0 ]; then exit $$rc ; fi ; \
	if command -v $(LUAC) >/dev/null 2>&1; then \
		$(MAKE) --no-print-directory syntax-check ; \
	else \
		echo "warning: $(LUAC) not found, skipping syntax check" >&2 ; \
	fi

fmtcheck: | deps/emmylua
	@if [ -x "$(LUA_FMT_BIN)" ]; then \
		FMT="$(LUA_FMT_BIN)" ; \
	else \
		FMT="luafmt" ; \
	fi ; \
	$$FMT --config .luafmt.toml --check --recursive $(FMT_DIRS)
