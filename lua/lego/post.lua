local file = require "lego.file"
local frontmatter = require "lego.frontmatter"
local liblego = require "liblego"
local post = {}

---@class lego.Post
---@field content string
---@field hidden boolean
---@field hidden_fully boolean
---@field meta lego.PostMeta

---@class lego.PostMeta
---@field title string
---@field date string
---@field slug string
---@field desc string

---@param fpath lego.FilePath
---@return lego.Post
function post.read_file(fpath)
  local p = file.read(fpath)
  local content = table.concat(frontmatter.content(p) or {}, "\n")
  local meta = frontmatter.extract(p)
  assert(meta["title"] ~= nil, (file.to_path(fpath) .. " doesn't have title"))
  assert(meta["date"] ~= nil, (file.to_path(fpath) .. " doesn't have date"))
  assert(meta["slug"] ~= nil, (file.to_path(fpath) .. " doesn't have slug"))

  return {
    meta = meta,
    hidden = meta["hidden"] == "true",
    hidden_fully = meta["hidden"] == "true, true",
    content = liblego.md_to_html(content),
  }
end

---MUTATES THE TABLE
---@param posts lego.Post[]
function post.sort_by_date(posts)
  table.sort(posts, function(a, b)
    return a.meta.date > b.meta.date
  end)
end

return post
