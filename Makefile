ASM= nasm
ASM_FLAGS= -fbin
SRC_DIR= ./src
BIN_DIR= ./bin
SRC= $(wildcard $(SRC_DIR)/*.asm)
NAME= roguelike
VM= qemu-system-x86_64 -drive format=raw,file=$(BIN_DIR)/$(NAME)

.PHONY: all clean

all: $(BIN_DIR)/$(NAME)

$(BIN_DIR)/$(NAME): $(SRC) | $(BIN_DIR)
	$(ASM) $(ASM_FLAGS) -o$(BIN_DIR)/$(NAME) $(SRC_DIR)/game.asm

$(BIN_DIR):
	mkdir $@

clean:
	-rmdir /S /Q $(notdir $(BIN_DIR))

run: $(BIN_DIR)/$(NAME)
	$(VM)
