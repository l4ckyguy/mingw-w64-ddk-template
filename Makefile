1_DRIVER_NAME = ddk-template
1_OBJECTS = $(1_DRIVER_NAME).o
1_TARGET = $(1_DRIVER_NAME).sys

2_DRIVER_NAME = ddk-template-cplusplus
2_OBJECTS = $(2_DRIVER_NAME).opp
2_TARGET = $(2_DRIVER_NAME).sys

3_DRIVER_NAME = ddk-template-cplusplus-EASTL
3_OBJECTS = $(3_DRIVER_NAME).opp
3_TARGET = $(3_DRIVER_NAME).sys

DPP_ROOT = .
INSTALL = install

ifndef BUILD_NATIVE

all: $(1_TARGET) $(2_TARGET) $(3_TARGET)

include $(DPP_ROOT)/Makefile.inc

%.o: %.c
	$(call BUILD_C_OBJECT,$<,$@)

%.opp: %.cpp
	$(call BUILD_CPP_OBJECT,$<,$@)

# simple C driver
$(1_TARGET): $(1_OBJECTS)
	$(call LINK_C_KERNEL_TARGET,$(1_OBJECTS),$@)

# C++ driver w/ MT
$(2_TARGET): $(2_OBJECTS)
	$(call LINK_CPP_KERNEL_TARGET,$(2_OBJECTS),$@)

# C++ driver w/ EASTL
$(3_TARGET): $(3_OBJECTS)
	$(call LINK_CPP_KERNEL_TARGET,$(3_OBJECTS),$@)

install: all
	$(call INSTALL_EXEC_SIGN,$(1_TARGET))
	$(call INSTALL_EXEC_SIGN,$(2_TARGET))
	$(call INSTALL_EXEC_SIGN,$(3_TARGET))
	$(INSTALL) $(1_DRIVER_NAME).bat $(DESTDIR)
	$(INSTALL) $(2_DRIVER_NAME).bat $(DESTDIR)
	$(INSTALL) $(3_DRIVER_NAME).bat $(DESTDIR)

endif

clean:
	rm -f $(1_OBJECTS) $(1_TARGET) $(1_TARGET).map
	rm -f $(2_OBJECTS) $(2_TARGET) $(2_TARGET).map
	rm -f $(3_OBJECTS) $(3_TARGET) $(3_TARGET).map

#
# Targets for building dependencies e.g. mingw-gcc/g++, STL, etc.
#

ifndef JOBS
JOBS := 4
endif

deps:
	$(MAKE) -C $(DPP_ROOT) -f Makefile.deps WERROR=1 JOBS=$(JOBS) Q=$(Q)
	$(MAKE) -C $(DPP_ROOT) -f Makefile.deps BUILD_NATIVE=1 WERROR=1 JOBS=$(JOBS) Q=$(Q)

deps-distclean:
	$(MAKE) -C $(DPP_ROOT) -f Makefile.deps distclean

deps-clean:
	$(MAKE) -C $(DPP_ROOT) -f Makefile.deps clean

help:
	$(MAKE) -C $(DPP_ROOT) -f Makefile.deps help

.PHONY: all install distclean clean
.DEFAULT_GOAL := all
