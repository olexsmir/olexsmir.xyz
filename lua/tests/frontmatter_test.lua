local t = require "tests.testutils"
local _, T, frontmatter = t.setup "frontmatter"

local f = require "lego.frontmatter"

frontmatter["should extract from frontmatter"] = function()
  local input = {
    "---",
    "title=The title",
    "link=test",
    "---",
    "the content is here",
  }

  t.eq(f.extract(input), {
    title = "The title",
    link = "test",
  })
end

frontmatter["support options with spaces"] = function()
  local input = {
    "---",
    "title = The title",
    "link one = some long thing here",
    "---",
    "the content is here",
  }

  t.eq(f.extract(input), {
    title = "The title",
    ["link one"] = "some long thing here",
  })
end

frontmatter["should return {} if there's no frontmatter"] = function()
  local input = {
    "there's no frontmatter",
    "just text",
  }

  t.eq(f.extract(input), {})
end

frontmatter["should return empty list if frontmatter is empty"] = function()
  local input = {
    "---",
    "---",
    "there's no frontmatter",
    "just text",
  }

  t.eq(f.extract(input), {})
end

frontmatter["should extract content"] = function()
  local input = {
    "---",
    "title = The title",
    "link one = some long thing here",
    "---",
    "the content is here",
    "",
    "something",
  }

  t.eq(f.content(input), {
    "the content is here",
    "",
    "something",
  })
end

frontmatter["should extract content with no frontmatter"] = function()
  local input = {
    "the content is here",
    "",
    "something",
  }

  t.eq(f.content(input), {
    "the content is here",
    "",
    "something",
  })
end

return T
