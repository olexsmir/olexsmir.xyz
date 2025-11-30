local a = require "lego.html.attribute"
local formatDate = require("lego.date").date
local h = require "lego.html"
local sitemap = {}

---@param opts {url:string, date:string, priority: string}
local function url(opts)
  return h.el("url", {}, {
    h.el("loc", {}, { h.text(opts.url) }),
    h.el("lastmod", {}, { h.text(formatDate(opts.date)) }),
    h.el("priority", {}, { h.text(opts.priority) }),
  })
end

---@param posts lego.Post[]
---@param config {site_url:string}
---@return string
function sitemap.sitemap(posts, config)
  local urls = vim
    .iter(posts)
    ---@param post lego.Post
    :map(function(post)
      return url {
        url = config.site_url .. "/" .. post.meta.slug,
        date = post.meta.date,
        priority = "0.80",
      }
    end)
    :totable()

  return h.render(h.el("urlset", {
    a.attr("xmlns", "http://www.sitemaps.org/schemas/sitemap/0.9"),
    a.attr("xmlns:xhtml", "http://www.w3.org/1999/xhtml"),
  }, {
    url {
      url = config.site_url,
      date = posts[1].meta.date,
      priority = "1.0",
    },
    unpack(urls),
  }))
end

return sitemap
