local file = require "lego.file"
local frontmatter = require "lego.frontmatter"
local liblego = require "liblego"
local post = {}

---@class lego.Post
---@field content string
---@field hidden boolean
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
  local hidden = meta["hidden"] == "true"
  assert(meta["title"] ~= nil, (file.to_path(fpath) .. " doesn't have title"))
  assert(meta["date"] ~= nil, (file.to_path(fpath) .. " doesn't have date"))
  assert(meta["slug"] ~= nil, (file.to_path(fpath) .. " doesn't have slug"))

  return {
    meta = meta,
    hidden = hidden,
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

---@param posts lego.Post[]
function post.list_duplicates(posts)
  local groups = {}
  for _, p in ipairs(posts) do
    groups[p.meta.slug] = groups[p.meta.slug] or {}
    table.insert(groups[p.meta.slug], p)
  end

  local duplicates = vim
    .iter(groups)
    :filter(function(_, v)
      return #v >= 2
    end)
    :map(function(slug, ps)
      return {
        slug = slug,
        posts = vim
          .iter(ps)
          :map(function(p)
            return { title = p.meta.title, slug = p.meta.slug }
          end)
          :totable(),
      }
    end)
    :totable()

  if #duplicates > 0 then
    vim.print("duplicates " .. vim.inspect(duplicates))
  end
end

return post
