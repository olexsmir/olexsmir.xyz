local css = require "lego.css"
local file = require "lego.file"
local html = require "lego.html"
local liblego = require "liblego"
local post = require "lego.post"
local rss = require "lego.rss"
local sitemap = require "lego.sitemap"

local c = require "blog.config"
local pages = require "blog.pages"
local styles = require "blog.styles"
local blog = {}

local function write(fpath, data)
  file.write({ c.build.output, fpath }, data)
end

local function write_page(fpath, node)
  write(fpath, html.render_page(node))
end

local function write_gopkg(name, repo, branch)
  branch = branch or "main"
  write(name .. ".html", html.render_page(pages.gopkg(name, repo, branch)))
end

function blog.build()
  --- clean up
  if file.is_dir(c.build.output) then
    file.rm(c.build.output)
  end
  file.mkdir(c.build.output)
  file.copy_dir(c.build.assets, vim.fs.joinpath(c.build.output, c.build.assets))

  -- write the pages
  ---@type lego.Post[]
  local posts = vim
    .iter(file.list_dir(c.build.posts))
    :map(function(fname)
      return post.read_file { c.build.posts, fname }
    end)
    :totable()
  post.sort_by_date(posts)

  write("CNAME", c.cname)
  write("chroma.css", liblego.get_css(c.build.chroma_theme))
  write("sitemap.xml", sitemap.sitemap(posts, { site_url = c.url }))
  write("style.css", css.style(styles))
  write_page("404.html", pages.not_found())
  write_page("index.html", pages.home(posts))
  write_page("posts.html", pages.posts(posts))

  write_gopkg("json2go", "https://github.com/olexsmir/json2go")

  -- stylua: ignore
  write("feed.xml", rss.rss(posts, {
    email = c.email,
    name = c.name,
    title = c.title,
    subtitle = c.feed.subtitle;
    feed_url = c.feed.url,
    home_url = c.url,
  }))

  for _, p in pairs(posts) do
    local phtml = html.render_page(pages.post(p))
    write(p.meta.slug .. ".html", phtml)
  end

  file.report_duplicates()
end

return blog
