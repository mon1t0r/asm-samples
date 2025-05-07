CC:=nasm
AR:=ar
CFLAGS:=-f elf32 -g -F dwarf
ARFLAGS:=rcs

TARGET:=libutils.a

SRCDIR:=src
OBJDIR:=obj

SRCS:=$(wildcard $(SRCDIR)/*.asm) $(wildcard $(SRCDIR)/*/*.asm)
OBJS:=$(SRCS:$(SRCDIR)/%.asm=$(OBJDIR)/%.o)

rm:=rm -rf
mkdir:=mkdir -p

.PHONY: all clean

all: $(TARGET)

$(TARGET): $(OBJS)
	$(AR) $(ARFLAGS) -o $@ $^

$(OBJDIR)/%.o : $(SRCDIR)/%.asm
	@$(mkdir) $(@D)
	$(CC) $(CFLAGS) -o $@ $^

clean:
	@$(rm) $(OBJDIR) $(TARGET)

