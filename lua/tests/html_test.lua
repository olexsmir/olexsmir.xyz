local t = require "tests.testutils"
local _, T, html = t.setup "html"

local a = require "lego.html.attribute"
local h = require "lego.html"

html["simple html"] = function()
  local node = h.el("div", {}, { h.text "hello" })

  t.eq(h.render(node), "<div>hello</div>")
end

html["simple html with attrs"] = function()
  local node = h.div({ a.attr("class", "some classes") }, { h.text "string" })
  t.eq(h.render(node), [[<div class="some classes">string</div>]])
end

html["self-closing tag"] = function()
  local node = h.el("img", { a.attr("src", "image.png"), a.attr("alt", "Alt text") }, {})
  t.eq(h.render(node), [[<img alt="Alt text" src="image.png">]])
end

html["nested html"] = function()
  local node = h.div({ a.class "container" }, {
    h.el("h1", {}, { h.text "Title" }),
    h.p({}, { h.text "Paragraph" }),
  })

  t.eq(h.render(node), [[<div class="container"><h1>Title</h1><p>Paragraph</p></div>]])
end

html["even more nested html"] = function()
  local node = h.div({ a.class "container" }, {
    h.el("h1", {}, { h.text "Title" }),
    h.div({}, {
      h.p({}, {
        h.text "text",
        h.a({ a.href "google.com" }, { h.text "google" }),
      }),
    }),
  })

  t.eq(
    h.render(node),
    [[<div class="container"><h1>Title</h1><div><p>text<a href="google.com">google</a></p></div></div>]]
  )
end

html["simple page"] = function()
  local node = h.el("html", { a.attr("lang", "en") }, {
    h.el("head", {}, {
      h.el("title", {}, { h.text "My Page" }),
    }),
    h.el("body", {}, {
      h.el("h1", {}, { h.text "Welcome" }),
      h.p({}, { h.text "This is a basic HTML page." }),
    }),
  })

  t.eq(
    h.render_page(node),
    [[<!DOCTYPE html><html lang="en"><head><title>My Page</title></head><body><h1>Welcome</h1><p>This is a basic HTML page.</p></body></html>]]
  )
end

html["row html can be 'embedded'"] = function()
  local node = h.el("html", {}, {
    h.el("head", {}, { h.el("title", {}, {
      h.text "My Page",
    }) }),
    h.el("body", {}, {
      h.raw "<row-element some-kind-of-tag>",
    }),
  })

  t.eq(
    h.render(node),
    "<html><head><title>My Page</title></head><body><row-element some-kind-of-tag></body></html>"
  )
end

return T
