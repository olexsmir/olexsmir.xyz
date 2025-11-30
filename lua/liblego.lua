local ffi = require "ffi"

ffi.cdef [[
  void free_cstring(char* s);
  char* md_to_html(const char* input);
  char* chroma_css(const char* theme);
]]

local lib = ffi.load "./go/liblego.so"

local M = {}

---@param markdown string
---@return string
function M.md_to_html(markdown)
  local result = lib.md_to_html(markdown)
  local html = ffi.string(result)
  lib.free_cstring(result)
  if html == "" then
    error "failed, good luck"
  end
  return html
end

---@param theme string
---@return string
function M.get_css(theme)
  local result = lib.chroma_css(theme)
  local css = ffi.string(result)
  if css == "" then
    error "failed, good luck"
  end

  css = css:gsub("/%*.-%*/ ", "")
  css = css:gsub("\n$", "")
  return css
end

return M
