local t = require "tests.testutils"
local _, T, file = t.setup "filee"

local f = require "lego.file"

file["to_path"] = function()
  t.eq(f.to_path "spec/fixture.md", "spec/fixture.md")
  t.eq(f.to_path { "spec", "fixture.md" }, "spec/fixture.md")
end

return T
