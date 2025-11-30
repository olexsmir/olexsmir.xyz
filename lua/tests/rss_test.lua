local t = require "tests.testutils"
local _, T, rss = t.setup "rss"

local r = require "lego.rss"

rss["should escape html"] = function()
  local input = "<p>Hello <a>world</a></p>"

  t.eq(r.escape_html(input), "&lt;p&gt;Hello &lt;a&gt;world&lt;/a&gt;&lt;/p&gt;")
end

return T
