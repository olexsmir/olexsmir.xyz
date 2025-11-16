local a = require "lego.html.attribute"
local c = require "blog.config"
local h = require "lego.html"
local pages = {}

local function themeSwitcherScript()
  local s = [[
    const root = document.documentElement;
    root.dataset.theme = localStorage.theme || 'light';
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

---@param o {title:string, desc:string, has_code:boolean, body:lego.HtmlNote[]}
---@return lego.HtmlNote
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
      h.link { a.attr("rel", "icon"), a.href "assets/favicon.svg" },
      h.meta { a.attr("name", "description"), a.attr("content", o.desc) },
      h.meta { a.attr("property", "og:description"), a.attr("content", o.desc) },
      h.meta { a.attr("property", "og:site_name"), a.attr("content", o.title) },
      h.meta { a.attr("property", "og:title"), a.attr("content", o.title) },
      h.meta { a.attr("property", "og:type"), a.attr("content", "website") },
    }),
    h.el("body", { a.class "home" }, {
      h.el("header", {}, {
        h.nav({}, {
          h.p({}, {
            h.a({ a.href "/" }, { h.text "home" }),
            h.a({ a.href "/posts" }, { h.text "posts" }),
            h.a({ a.href "https://github.com/olexsmir" }, { h.text "github" }),
            h.a({ a.href "/feed.xml" }, { h.text "feed" }),
            h.el("button", { a.id "theme-toggle" }, { h.text "🌓" }),
          }),
        }),
        h.a({ a.class "title", a.href "/" }, {
          h.h1({}, { h.text(c.title) }),
        }),
      }),
      o.body,
      themeSwitcherScript(),
    }),
  })
end

---@param o {name:string, repo:string}
function pages.with_gopkg(o)
  local path = c.cname .. "/" .. o.name
  local goi = path .. " git " .. o.repo
  local gos = table.concat({
    path,
    o.repo,
    o.repo .. "/tree/master{/dir}",
    o.repo .. "/blob/master{/dir}/{file}#L{line}",
  }, " ")

  return h.el("html", {}, {
    h.el("head", {
      a.attr("xmlns", "http://www.w3.org/1999/xhtml"),
      a.attr("xml:lang", "en"),
      a.attr("lang", "en"),
    }, {
      h.meta { a.attr("http-equiv", "content-type"), a.attr("content", "text/html; charset=utf-8") },
      h.meta { a.attr("http-equiv", "refresh"), a.attr("content", "0; url=" .. o.repo) },
      h.meta { a.attr("name", "go-import"), a.attr("content", goi) },
      h.meta { a.attr("name", "go-source"), a.attr("content", gos) },
    }),
    h.el("body", {}, { h.text "Redirecting to the forge..." }),
  })
end

function pages.home()
  return with_page {
    title = "olexsmir.xyz",
    desc = "olexsmir.xyz home page",
    body = h.main({}, {
      h.p({}, {
        h.text "Hi, and welcome to my blog.",
        h.br(),
        h.text "I'm a gopher from Ukraine 🇺🇦, still don't know how to exit from vim.",
      }),
      h.p({}, {
        h.text "If you want to reach me, you can mail me at: ",
        h.a({ a.href("mailto:" .. c.email) }, {
          h.el("i", {}, { h.text(c.email) }),
        }),
        h.text ".",
      }),
    }),
  }
end

function pages.not_found()
  return with_page {
    title = "Not found",
    desc = "Page you're looking for, not found",
    body = h.main({}, {
      h.h1({}, { h.text "There's nothing here!" }),
      h.p({}, {
        h.text "Go pack to the ",
        h.a({ a.href "/" }, { h.text "home page" }),
      }),
    }),
  }
end

---@param posts lego.Post[]
function pages.posts(posts)
  return with_page {
    title = "All olexsmir's posts",
    desc = "List of all blog posts on the lego.",
    body = h.main({}, {
      h.p({}, { h.text "It ain't much, but it's honest work." }),
      h.ul(
        { a.class "blog-posts" },
        vim
          .iter(posts)
          :filter(function(post)
            return not post.hidden
          end)
          :map(function(post)
            return h.li({ a.href(post.meta.slug) }, {
              h.span({}, {
                h.el("i", {}, { h.time(post.meta.date) }),
              }),
              h.a({ a.href(post.meta.slug) }, { h.text(post.meta.title) }),
            })
          end)
          :totable()
      ),
    }),
  }
end

---@param post lego.Post
function pages.post(post)
  return with_page {
    title = post.meta.title,
    desc = "Blog post titled: " .. post.meta.title,
    has_code = post.content:match "code" ~= nil,
    body = h.main({}, {
      h.div({ a.class "blog-title" }, {
        h.h1({}, { h.text(post.meta.title) }),
        h.p({}, { h.time(post.meta.date) }),
      }),
      h.raw(post.content),
    }),
  }
end

return pages
