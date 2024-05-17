SRC_DIR= ./src
BIN_DIR= ./bin
SRC:= $(filter-out $(SRC_DIR)/init.asm, $(wildcard $(SRC_DIR)/*.asm))
BIN_NAME= roguelike.bin
EMULATOR= qemu-system-x86_64 -drive format=raw,file=

all:
	$(MAKE) $(BIN_DIR)/$(BIN_NAME)

$(BIN_DIR)/$(BIN_NAME): $(patsubst %.asm,%.bin,$(SRC)) $(BIN_DIR)
	nasm -f bin -o$(BIN_DIR)/$(BIN_NAME) $(SRC_DIR)/init.asm

%.bin: %.asm
	nasm -f bin -o$(addprefix $(BIN_DIR)/,$(notdir $@)) $<

$(BIN_DIR): 
	mkdir $@

run: $(BIN_DIR)/$(BIN_NAME)
	$(EMULATOR)$<