# ************************************************************************* #
#   Organizacion del Computador II - Trabajo Practico 2                     #
# ************************************************************************* #

CFLAGS64 = -ggdb -Wall -Wno-unused-parameter -Wextra -std=c99 -DD_POSIX_SOURCE -D_GNU_SOURCE -lrt -lpthread -no-pie -pedantic -m64 -O0 -march=native -fno-common 
CFLAGS=$(CFLAGS64)

BUILD_DIR = ../build
BIN = tp2

FILTROS = ColorBordes ImagenFantasma PixeladoDiferencial ReforzarBrillo ImagenFantasma_enteros ImagenFantasma_x4

FILTROS_OBJ = $(addsuffix .o, $(FILTROS)) $(addsuffix _asm.o, $(FILTROS)) $(addsuffix _c.o, $(FILTROS))
LIBS_OBJS   = libbmp.o imagenes.o utils.o
MAIN_OBJS   = tp2.o cli.o 
MAIN_OBJS_CON_PATH = $(addprefix $(BUILD_DIR)/, $(MAIN_OBJS))

OBJS = $(MAIN_OBJS) $(LIBS_OBJS) $(FILTROS_OBJ)
OBJS_CON_PATH = $(addprefix $(BUILD_DIR)/, $(OBJS))

BIN2 = tp2_exp
BIN3 = tp2_exp_multi

MAIN_OBJS2   = tp2_exp.o cli.o
MAIN_OBJS3   = tp2_exp_multi.o cli.o
MAIN_OBJS_CON_PATH2 = $(addprefix $(BUILD_DIR)/, $(MAIN_OBJS2))
MAIN_OBJS_CON_PATH3 = $(addprefix $(BUILD_DIR)/, $(MAIN_OBJS3))

OBJS2 = $(MAIN_OBJS2) $(LIBS_OBJS) $(FILTROS_OBJ)
OBJS3 = $(MAIN_OBJS3) $(LIBS_OBJS) $(FILTROS_OBJ)
OBJS_CON_PATH2 = $(addprefix $(BUILD_DIR)/, $(OBJS2))
OBJS_CON_PATH3 = $(addprefix $(BUILD_DIR)/, $(OBJS3))

.PHONY: all clean FORCE

all: $(BUILD_DIR)/$(BIN) exp exp2

$(BUILD_DIR)/$(BIN): FORCE $(MAIN_OBJS_CON_PATH)
	$(CC) $(CFLAGS) $(OBJS_CON_PATH) -o $@ -lm

exp: $(BIN2)

$(BIN2): $(MAIN_OBJS_CON_PATH2)
	$(CC) $(CFLAGS) $(OBJS_CON_PATH2) -o $@ -lm

exp2: $(BIN3)

$(BIN3): $(MAIN_OBJS_CON_PATH3)
	$(CC) $(CFLAGS) $(OBJS_CON_PATH3) -o $@ -lm

export CFLAGS64
FORCE:
	mkdir -p ../build
	make -C ../helper
	make -C ../filters
	mkdir -p resultados
	make -C filtros

$(BUILD_DIR)/%.o: ../%.c
	$(CC) $(CFLAGS) -c -o $@ $< -lm

$(BUILD_DIR)/%.o: %.c
	$(CC) $(CFLAGS) -c -o $@ $< -lm

clean:
	rm -fr $(BUILD_DIR)/*
	rm -f tp2_exp
	rm -f tp2_exp_multi