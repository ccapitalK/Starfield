GAME_NAME=Default
FILES:=$(shell find . -not -iwholename '*.git*')
FILES:=$(filter-out .,$(FILES))
FILES:=$(filter-out ./Makefile,$(FILES))
FILES:=$(filter-out ./$(GAME_NAME).zip,$(FILES))
FILES:=$(filter-out ./$(GAME_NAME).love,$(FILES))
FILES:=$(filter-out $(shell find . -name "*.swp"),$(FILES))
FILES:=$(filter-out $(shell find . -name "*.swp"),$(FILES))

$(GAME_NAME).love: $(FILES)
	zip $(GAME_NAME).zip $^
	mv -f $(GAME_NAME).zip $(GAME_NAME).love
