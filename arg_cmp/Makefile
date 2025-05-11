# Assembler configuration
CC:=nasm
CFLAGS:=-f elf32

# Linker configuration
LD:=ld
LDFLAGS:=-m elf_i386

# Local libraries configuration
RELLIBS:=
DBGLIBS:=

# Target file name
TARGET:=arg_len

# Source and object files configuration
SRCDIR:=src
OBJDIR:=obj

SRCS:=$(wildcard $(SRCDIR)/*.asm) $(wildcard $(SRCDIR)/*/*.asm)
OBJS:=$(SRCS:$(SRCDIR)/%.asm=$(OBJDIR)/%.o)

# Release configuration
RELDIR:=release
RELTARGET:=$(RELDIR)/$(TARGET)
RELOBJS:=$(addprefix $(RELDIR)/, $(OBJS))
RELCFLAGS:=

# Debug configuration
DBGDIR:=debug
DBGTARGET:=$(DBGDIR)/$(TARGET)
DBGOBJS:=$(addprefix $(DBGDIR)/, $(OBJS))
DBGCFLAGS:=-g -F dwarf

# Utility commands
rm:=rm -rf
mkdir:=mkdir -p

.PHONY: all clean debug release $(RELLIBS) $(DBGLIBS)

all: release

# Release rules
release: $(RELTARGET)

$(RELTARGET): $(RELOBJS) $(RELLIBS)
	$(LD) $(LDFLAGS) -o $@ $^

$(RELDIR)/$(OBJDIR)/%.o : $(SRCDIR)/%.asm
	@$(mkdir) $(@D)
	$(CC) $(CFLAGS) $(RELCFLAGS) -o $@ $^

# Debug rules
debug: $(DBGTARGET)

$(DBGTARGET): $(DBGOBJS) $(DBGLIBS)
	$(LD) $(LDFLAGS) -o $@ $^

$(DBGDIR)/$(OBJDIR)/%.o : $(SRCDIR)/%.asm
	@$(mkdir) $(@D)
	$(CC) $(CFLAGS) $(DBGCFLAGS) -o $@ $^

# Local libraries rules
$(RELLIBS):
	$(MAKE) -C $(dir $(patsubst %/,%,$(dir $@))) \
		$(addprefix $(notdir $(patsubst %/,%,$(dir $@)))/, $(notdir $@))
$(DBGLIBS):
	$(MAKE) -C $(dir $(patsubst %/,%,$(dir $@))) \
		$(addprefix $(notdir $(patsubst %/,%,$(dir $@)))/, $(notdir $@))

# Other rules
clean:
	@$(rm) $(DBGDIR) $(RELDIR)

