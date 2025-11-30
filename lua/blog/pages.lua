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
            h.a({ a.class "visual-hidden", a.href "#main" }, { "Skip to content" }),
            h.a({ a.href "/" }, { h.text "home" }),
            h.a({ a.href "/posts" }, { h.text "posts" }),
            h.a({ a.href "/feed.xml" }, { h.text "feed" }),
            h.el("button", { a.id "theme-toggle" }, { h.text "🌓" }),
          }),
        }),
      }),
      h.main({ a.id "main" }, o.body),
      themeSwitcherScript(),
    }),
  })
end

---@param iter Iter
---@return string|lego._HtmlNote
local function list_posts(iter)
  return h.ul(
    { a.class "blog-posts" },
    iter
      ---@param post lego.Post
      :filter(function(post)
        return not post.hidden
      end)
      ---@param post lego.Post
      :map(function(post)
        return h.li({}, {
          h.span({}, {
            h.el("i", {}, { h.time(post.meta.date) }),
          }),
          h.a({ a.href(post.meta.slug) }, { h.text(post.meta.title) }),
        })
      end)
      :totable()
  )
end

---@param posts lego.Post[]
function pages.home(posts)
  return with_page {
    title = "olexsmir.xyz",
    desc = "olexsmir.xyz home page",
    body = {
      h.h2({}, { "Hi, I'm Olex from Ukraine 🇺🇦" }),
      h.p({}, {
        "Welcome to my corner of the internet. Here I share what I find interesting. ",
        "Hopefully I will maintain the content on this site, not only it’s code.",
      }),
      h.p({}, {
        "Feel free to scroll through the posts below or subscribe to the ",
        h.a({ a.href "/feed.xml" }, { "RSS feed" }),
        " for updates. ",
        "And if you want to say hi, mail me at ",
        h.a({ a.href("mailto:" .. c.email) }, { c.email }),
        " or message me on ",
        h.a({ a.href "https://t.me/olexsmir" }, { "telegram" }),
        " if that's your cup of tea.",
      }),
      h.p({}, {
        "If you’re curious what I’m up to, check out ",
        h.a({ a.href "/now" }, { "now" }),
        " page, or look through ",
        h.a({ a.href "https://github.com/olexsmir" }, { "github" }),
        " or ",
        h.a({ a.href "https://tangled.org/olexsmir.xyz" }, { "tangled" }),
        " accounts.",
      }),
      h.div({ a.class "recent-posts" }, {
        list_posts(vim.iter(posts):take(7)),
      }),
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

---@param posts lego.Post[]
function pages.posts(posts)
  return with_page {
    title = "All olexsmir's posts",
    desc = "List of all blog posts on the lego.",
    body = { list_posts(vim.iter(posts)) },
  }
end

---@param post lego.Post
function pages.post(post)
  return with_page {
    title = post.meta.title,
    desc = "Blog post titled: " .. post.meta.title,
    has_code = post.content:match "code" ~= nil,
    body = {
      h.div({ a.class "blog-title" }, {
        h.h1({}, { h.text(post.meta.title) }),
        h.p({}, { h.time(post.meta.date) }),
      }),
      h.raw(post.content),
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
