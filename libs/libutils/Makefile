# Assembler configuration
CC:=nasm
CFLAGS:=-Iinc/ -f elf32

# ar configuration
AR:=ar
ARFLAGS:=rcs

# Target file name
TARGET:=libutils.a

# Source and object files configuration
SRCDIR:=src
OBJDIR:=obj

SRCS:=$(wildcard $(SRCDIR)/*.asm) $(wildcard $(SRCDIR)/*/*.asm)
OBJS:=$(SRCS:$(SRCDIR)/%.asm=$(OBJDIR)/%.o)

# Debug configuration
DBGDIR:=debug
DBGTARGET:=$(DBGDIR)/$(TARGET)
DBGOBJS:=$(addprefix $(DBGDIR)/, $(OBJS))
DBGCFLAGS =-g -F dwarf

# Release configuration
RELDIR:=release
RELTARGET:=$(RELDIR)/$(TARGET)
RELOBJS:=$(addprefix $(RELDIR)/, $(OBJS))
RELCFLAGS:=

# Utility commands
rm:=rm -rf
mkdir:=mkdir -p

.PHONY: all clean debug release

all: release

# Release rules
release: $(RELTARGET)

$(RELTARGET): $(RELOBJS)
	$(AR) $(ARFLAGS) -o $@ $^

$(RELDIR)/$(OBJDIR)/%.o : $(SRCDIR)/%.asm
	@$(mkdir) $(@D)
	$(CC) $(CFLAGS) $(RELCFLAGS) -o $@ $^

# Debug rules
debug: $(DBGTARGET)

$(DBGTARGET): $(DBGOBJS)
	$(AR) $(ARFLAGS) -o $@ $^

$(DBGDIR)/$(OBJDIR)/%.o : $(SRCDIR)/%.asm
	@$(mkdir) $(@D)
	$(CC) $(CFLAGS) $(DBGCFLAGS) -o $@ $^

# Other rules
clean:
	@$(rm) $(DBGDIR) $(RELDIR)

