ASM= nasm
ASM_FLAGS= -fbin
SRC_DIR= ./src
BIN_DIR= ./bin
SRC:= $(filter-out $(SRC_DIR)/init.asm, $(wildcard $(SRC_DIR)/*.asm))
BIN_FILES= $(patsubst $(SRC_DIR)%,$(BIN_DIR)%,$(patsubst %.asm,%.bin,$(SRC)))
BIN_NAME= roguelike
VM= qemu-system-x86_64 -drive format=raw,file=$(BIN_DIR)/$(BIN_NAME)


all: $(BIN_DIR)/$(BIN_NAME)


$(BIN_DIR)/$(BIN_NAME): $(BIN_FILES) $(SRC_DIR)/init.asm | $(BIN_DIR)
	$(ASM) $(ASM_FLAG) -o$(BIN_DIR)/$(BIN_NAME) $(SRC_DIR)/init.asm

$(BIN_DIR)/%.bin: $(SRC_DIR)/%.asm | $(BIN_DIR)
	$(ASM) $(ASM_FLAG) -o$(addprefix $(BIN_DIR)/,$(notdir $@)) $<

$(BIN_DIR):
	mkdir $@

run: all
	$(VM)
	