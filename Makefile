ifeq (,$(VERBOSE))
    MAKEFLAGS:=$(MAKEFLAGS)s
    ECHO=echo
else
    ECHO=@:
endif

TARGETS=awesome
BUILDDIR=build

all: $(TARGETS) ;

$(TARGETS): cmake-build
	ln -s -f $(BUILDDIR)/$@ $@

cmake $(BUILDDIR)/CMakeCache.txt:
	$(ECHO) "Creating build directory and running cmake in it. You can also run CMake directly, if you want."
	$(ECHO)
	mkdir -p $(BUILDDIR)
	$(ECHO) "Running cmake…"
	cd $(BUILDDIR) && cmake $(CMAKE_ARGS) "$(@D)" ..

cmake-build: $(BUILDDIR)/CMakeCache.txt
	$(ECHO) "Building…"
	$(MAKE) -C $(BUILDDIR)

tags:
	git ls-files | xargs ctags

install:
	$(ECHO) "Installing…"
	$(MAKE) -C $(BUILDDIR) install

distclean:
	$(ECHO) -n "Cleaning up build directory…"
	$(RM) -r $(BUILDDIR) $(TARGETS)
	$(ECHO) " done"

%: cmake
	$(ECHO) "Running make $@…"
	$(MAKE) -C $(BUILDDIR) $@

.PHONY: cmake-build cmake install distclean tags
