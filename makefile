.PHONY: all build test

CMD=nvim --clean -u ./lua/minit.lua

test:
	@$(CMD) --headless -c "lua MiniTest.run()"


build-parser:
	@cargo build --release
	@ln -sf $(CURDIR)/target/release/libolexsmir_xyz.so $(CURDIR)/lua/liblego.so

build: build-parser
	@$(CMD) -l ./lua/build.lua

dev:
	@watchexec --watch posts --watch lua --exts lua,md -- "make build" &
	@bunx http-server ./build -p 8080
