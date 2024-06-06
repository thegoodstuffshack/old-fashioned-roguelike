ASM= nasm
ASM_FLAGS= -fbin
SRC_DIR= ./src
BIN_DIR= ./bin
BIN= $(SRC_DIR)/map.asm
SRC= $(filter-out $(BIN),$(wildcard $(SRC_DIR)/*.asm) $(wildcard $(SRC_DIR)/enemies/*.asm))
NAME= roguelike
VM= qemu-system-x86_64 -drive format=raw,file=$(BIN_DIR)/$(NAME)

.PHONY: all clean

all: $(BIN_DIR)/$(NAME)

$(BIN_DIR)/$(NAME): $(SRC) $(BIN_DIR)/map.bin | $(BIN_DIR)
	$(ASM) $(ASM_FLAGS) -o$@ $(SRC_DIR)/game.asm

$(BIN_DIR)/map.bin: $(SRC_DIR)/map.asm
	$(ASM) $(ASM_FLAGS) -o$@ $<

$(BIN_DIR):
	mkdir $@

clean:
	-rmdir /S /Q $(notdir $(BIN_DIR))

run: $(BIN_DIR)/$(NAME)
	$(VM)
