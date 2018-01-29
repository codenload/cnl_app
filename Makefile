# MIT License
#
# Copyright (c) 2018, Pablo Ridolfi - Code 'n Load
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

include /etc/cnl.conf

PROGRAM = cnl_app

INC_PATH = inc base
OUT_PATH = out
OBJ_PATH = $(OUT_PATH)/obj
INC_FILE = wiringPi.h

PROJECT_SRC_FOLDERS = src base

PROJECT_C_FILES = $(wildcard base/*.c) \
                  $(wildcard src/*.c)

PROJECT_OBJ_FILES = $(addprefix $(OBJ_PATH)/,$(notdir $(PROJECT_C_FILES:.c=.o)))

PROJECT_OBJS = $(notdir $(PROJECT_OBJ_FILES))

vpath %.c $(PROJECT_SRC_FOLDERS)
vpath %.o $(OBJ_PATH)

SOURCES = $(wildcard $(SRC_PATH)/*.c)
USER_SOURCES = $(wildcard $(USER_SRC_PATH)/*.c)

ifeq ($(DEBUG),)
CFLAGS := -Wall -fdata-sections -ffunction-sections -std=gnu99
else
CFLAGS := -g3 -Wall -fdata-sections -ffunction-sections -std=gnu99
endif

LFLAGS := -Wl,--gc-sections
LIBS := -lwiringPi -lsystemd -lpthread -lm -lrt -lc -lcrypt

%.o: %.c
	$(CROSS_PREFIX)gcc $(CFLAGS) -c $< -o $(OBJ_PATH)/$@ $(addprefix -I, $(INC_PATH)) $(addprefix -include , $(INC_FILE))
	$(CROSS_PREFIX)gcc $(CFLAGS) $(addprefix -I, $(INC_PATH)) $(addprefix -include , $(INC_FILE)) -c $< -MM > $(OBJ_PATH)/$(@:.o=.d)

all: $(PROGRAM)

-include $(wildcard $(OBJ_PATH)/*.d)

$(PROGRAM): $(PROJECT_OBJS)
	$(CROSS_PREFIX)gcc $(LIBPATH) $(PROJECT_OBJ_FILES) $(LFLAGS) -o $(OUT_PATH)/$(PROGRAM) $(LIBS)
	$(CROSS_PREFIX)size $(OUT_PATH)/$(PROGRAM)
	@echo CNL_APP_PATH:$(CNL_APP_PATH)

update: $(PROGRAM)
	sudo systemctl stop cnl_app.service
	sudo cp $(OUT_PATH)/$(PROGRAM) /usr/bin
	sudo systemctl start cnl_app.service

clean:
	rm -f $(OBJ_PATH)/*.* $(OUT_PATH)/$(PROGRAM)

info:
	@echo PROJECT_C_FILES:$(PROJECT_C_FILES)
	@echo PROJECT_SRC_FOLDERS:$(PROJECT_SRC_FOLDERS)
