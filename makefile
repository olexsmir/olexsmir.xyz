.PHONY: all build build-parser test

CMD=nvim --clean -u ./lua/minit.lua

test:
	@TEST=true $(CMD) --headless -c "lua MiniTest.run()"

build-parser:
	@cd go; go build -buildmode=c-shared -o liblego.so

build:
	@$(CMD) --headless +"lua require'blog'.build()" +q

dev:
	@watchexec --watch posts --watch lua --exts lua,md -- "make build" &
	@bunx http-server ./build -p 8080
