CC = gcc
CFLAGS = -Wall -O2
LDFLAGS = -lportaudio -lasound

TARGET = et-portaudio
SRC = main.c
VERSION=1.0.0
INSTALL_DIR = /opt/et-portaudio-$(VERSION)/bin

.PHONY: install

all: $(TARGET)

$(TARGET): $(SRC)
	$(CC) $(CFLAGS) -o $(TARGET) $(SRC) $(LDFLAGS)

install: $(TARGET)
	@echo "Installing $(TARGET) to $(INSTALL_DIR)..."
	@mkdir -p $(INSTALL_DIR)
	@cp $(TARGET) $(INSTALL_DIR)/
	@chmod 755 $(INSTALL_DIR)/$(TARGET)
	@echo "Done."

clean:
	rm -f $(TARGET) *.o
