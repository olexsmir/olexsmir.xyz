local a = require "lego.html.attribute"
local c = require "blog.config"
local h = require "lego.html"
local pages = {}

local function themeSwitcherScript()
  local s = [[
    const root = document.documentElement;
    root.dataset.theme = localStorage.theme || 'dark';
    document.getElementById('theme-toggle').onclick = () => {
      root.dataset.theme = root.dataset.theme === 'dark' ? 'light' : 'dark';
      localStorage.theme = root.dataset.theme;
    };
  ]]
  s = s:gsub("  ", "")
  s = vim.split(s, "\n") ---@diagnostic disable-line: cast-local-type
  s = table.concat(s, "")
  return h.el("script", {}, { h.text(s) })
end

---@param o {title:string, desc:string, has_code:boolean, body:lego.HtmlNode[]}
---@return lego.HtmlNode
local function with_page(o)
  return h.el("html", { a.attr("lang", "en") }, {
    h.el("head", {}, {
      h.title({}, { h.text(o.title) }),
      h.meta { a.attr("charset", "utf-8") },
      h.meta {
        a.attr("name", "viewport"),
        a.attr("content", "width=device-width, initial-scale=1.0, viewport-fit=cover"),
      },
      h.link {
        a.attr("rel", "alternate"),
        a.attr("type", "application/atom+xml"),
        a.attr("title", c.feed.subtitle),
        a.href(c.feed.url),
      },
      h.link { a.attr("rel", "stylesheet"), a.href "style.css" },
      o.has_code and h.link { a.attr("rel", "stylesheet"), a.href "chroma.css" } or {},
      h.link { a.attr("rel", "icon"), a.href "favicon.svg" },
      h.meta { a.attr("name", "description"), a.attr("content", o.desc) },
      h.meta { a.attr("property", "og:description"), a.attr("content", o.desc) },
      h.meta { a.attr("property", "og:site_name"), a.attr("content", o.title) },
      h.meta { a.attr("property", "og:title"), a.attr("content", o.title) },
      h.meta { a.attr("property", "og:type"), a.attr("content", "website") },
    }),
    h.el("body", { a.class "home" }, {
      -- h.el("header", {}, {
      --   h.nav({}, {
      --     h.p({}, {
      --       h.a({ a.class "visual-hidden", a.href "#main" }, { "Skip to content" }),
      --       h.a({ a.href "/" }, { h.text "home" }),
      --       h.a({ a.href "/posts" }, { h.text "posts" }),
      --       h.a({ a.href "/feed.xml" }, { h.text "feed" }),
      --       h.el("button", { a.id "theme-toggle" }, { h.text "🌓" }),
      --     }),
      --   }),
      -- }),
      h.main({ a.id "main" }, o.body),
      themeSwitcherScript(),
    }),
  })
end

function pages.home()
  return with_page {
    title = "olexsmir.xyz",
    desc = "olexsmir.xyz home page",
    body = {
      h.h2({}, { "TODO make the site" }),
    },
  }
end

function pages.not_found()
  return with_page {
    title = "Not found",
    desc = "Page you're looking for, not found",
    body = {
      h.h1({}, { h.text "There's nothing here!" }),
      h.p({}, {
        h.text "Go pack to the ",
        h.a({ a.href "/" }, { h.text "home page" }),
      }),
    },
  }
end

function pages.gopkg(name, repo, branch)
  local gomod = c.cname .. "/" .. name
  local go_import = gomod .. " git " .. repo
  local go_source = table.concat({
    gomod,
    repo,
    repo .. "/tree/" .. branch .. "{/dir}",
    repo .. "/blob/" .. branch .. "{/dir}/{file}#L{line}",
  }, " ")

  return h.el("html", {}, {
    h.el("head", {}, {
      h.meta { a.attr("name", "go-import"), a.attr("content", go_import) },
      h.meta { a.attr("name", "go-source"), a.attr("content", go_source) },
    }),
    h.el("body", {}, {
      h.p({}, { "Source: ", h.a({ a.href(repo) }, { repo }) }),
      h.el("code", {}, { "$ go get " .. gomod }),
    }),
  })
end

return pages
