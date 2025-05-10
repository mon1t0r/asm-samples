CC:=nasm
LD:=ld
CFLAGS:=-f elf32 -g -F dwarf
LDFLAGS:=-m elf_i386

TARGET:=arg_cmp

LOCAL_LIBS:=

SRCDIR:=src
OBJDIR:=obj

SRCS:=$(wildcard $(SRCDIR)/*.asm) $(wildcard $(SRCDIR)/*/*.asm)
OBJS:=$(SRCS:$(SRCDIR)/%.asm=$(OBJDIR)/%.o)

rm:=rm -rf
mkdir:=mkdir -p

.PHONY: all clean $(LOCAL_LIBS)

all: $(TARGET)

$(TARGET): $(OBJS) $(LOCAL_LIBS)
	$(LD) $(LDFLAGS) -o $@ $^

$(OBJDIR)/%.o : $(SRCDIR)/%.asm
	@$(mkdir) $(@D)
	$(CC) $(CFLAGS) -o $@ $^

$(LOCAL_LIBS):
	$(MAKE) -C $(dir $@) $(notdir $@)

clean:
	@$(rm) $(OBJDIR) $(TARGET)

