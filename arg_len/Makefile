CC:=nasm
LD:=ld
CFLAGS:=-f elf32
LDFLAGS:=-m elf_i386

TARGET:=arg_len

SRCDIR:=src
OBJDIR:=obj

SRCS:=$(wildcard $(SRCDIR)/*.asm) $(wildcard $(SRCDIR)/*/*.asm)
OBJS:=$(SRCS:$(SRCDIR)/%.asm=$(OBJDIR)/%.o)

rm:=rm -rf
mkdir:=mkdir -p

.PHONY: all clean

all: $(TARGET)

$(TARGET): $(OBJS)
	$(LD) $(LDFLAGS) -o $@ $^

$(OBJDIR)/%.o : $(SRCDIR)/%.asm
	@$(mkdir) $(@D)
	$(CC) $(CFLAGS) -o $@ $^

clean:
	@$(rm) $(OBJDIR) $(TARGET)

