local a = require "lego.html.attribute"
local formatDate = require("lego.date").date
local h = require "lego.html"
local rss = {}

function rss.escape_html(html)
  local map = {
    ["&"] = "&amp;",
    ["<"] = "&lt;",
    [">"] = "&gt;",
    ['"'] = "&quot;",
    ["'"] = "&#39;",
  }

  html = html:gsub("[%z\1-\8\11-\12\14-\31]", "") -- remove control chars
  return (html:gsub("[&<>\"']", function(c)
    return map[c]
  end))
end

---@param config {feed_url:string, home_url:string, title:string, name:string, email:string, subtitle:string}
---@param posts lego.Post[]
---@return string
function rss.rss(posts, config)
  local entries = vim
    .iter(posts)
    :filter(function(post)
      return not post.hidden_fully
    end)
    :map(function(post)
      return h.el("entry", {}, {
        h.title({}, { h.text(post.meta.title) }),
        h.link { a.href(config.home_url .. "/" .. post.meta.slug) },
        h.el("id", {}, { h.text(config.home_url .. "/" .. post.meta.slug) }),
        h.el("updated", {}, { h.text(formatDate(post.meta.date)) }),
        h.el("content", { a.attr("type", "html") }, { h.raw(rss.escape_html(post.content)) }),
      })
    end)
    :totable()

  return [[<?xml version="1.0" encoding="utf-8"?>]]
    .. h.render(h.el("feed", { a.attr("xmlns", "http://www.w3.org/2005/Atom") }, {
      h.title({}, { h.text(config.title) }),
      h.el("subtitle", {}, { h.text(config.subtitle) }),
      h.el("id", {}, { h.text(config.home_url .. "/") }),
      h.link { a.href(config.home_url), a.attr("rel", "alternate") },
      h.link {
        a.href(config.feed_url),
        a.attr("rel", "self"),
        a.attr("type", "application/atom+xml"),
      },
      h.el("updated", {}, { h.text(formatDate(posts[1].meta.date)) }),
      h.el("author", {}, {
        h.el("name", {}, { h.text(config.name) }),
        h.el("email", {}, { h.text(config.email) }),
      }),
      unpack(entries),
    }))
end

return rss
