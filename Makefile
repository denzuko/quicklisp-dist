# quicklisp-dist Makefile
# Regenerates systems.txt and releases.txt from git submodules.

DIST_VERSION := $(shell date +%Y-%m-%d)
PACKAGES_DIR := packages

.PHONY: dist update-submodules add-package help

## Default: regenerate dist metadata
dist: systems.txt releases.txt
	@sed -i 's/^version: .*/version: $(DIST_VERSION)/' distinfo.txt
	@echo "[dist] Updated distinfo.txt version to $(DIST_VERSION)"

## Regenerate systems.txt from all .asd files under packages/
systems.txt:
	@echo "# Quicklisp dist system index — denzuko" > $@
	@echo "# Format: release-name  system-file  system-name  [dep ...]" >> $@
	@echo "# Generated: $(DIST_VERSION)" >> $@
	@echo "" >> $@
	@for asd in $(PACKAGES_DIR)/*/*.asd; do \
	  pkg=$$(basename $$(dirname $$asd)); \
	  asdfile=$$(basename $$asd); \
	  sysname=$$(basename $$asd .asd); \
	  echo "$$pkg  $$pkg/$$asdfile  $$sysname" >> $@; \
	done
	@echo "[dist] Regenerated systems.txt ($$(grep -c '^[^#]' $@) systems)"

## Regenerate releases.txt from tagged submodules
releases.txt:
	@echo "# Quicklisp dist release index — denzuko" > $@
	@echo "# Generated: $(DIST_VERSION)" >> $@
	@echo "" >> $@
	@git submodule foreach --quiet '\
	  pkg=$$(basename $$path); \
	  tag=$$(git describe --tags --abbrev=0 2>/dev/null || echo "HEAD"); \
	  url="https://github.com/denzuko/$$pkg/archive/refs/tags/$$tag.tar.gz"; \
	  echo "$$pkg  $$url  0  -  -  $$pkg-$$tag" >> $(CURDIR)/releases.txt'
	@echo "[dist] Regenerated releases.txt"

## Pull latest commits for all submodules
update-submodules:
	git submodule update --remote --merge

## Add a new package submodule
## Usage: make add-package PKG=my-package
add-package:
	@test -n "$(PKG)" || (echo "Usage: make add-package PKG=<repo-name>"; exit 1)
	git submodule add https://github.com/denzuko/$(PKG).git $(PACKAGES_DIR)/$(PKG)
	$(MAKE) dist
	@echo "[dist] Added $(PKG). Commit with:"
	@echo "  git add packages/$(PKG) systems.txt releases.txt distinfo.txt"
	@echo "  git commit -m 'feat: add $(PKG) to dist'"

help:
	@echo "Targets:"
	@echo "  dist              regenerate all metadata"
	@echo "  update-submodules pull latest from all submodule remotes"
	@echo "  add-package PKG=x add new package submodule + regen"
