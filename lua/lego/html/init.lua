local a = require "lego.html.attribute"
local html = {}

---@alias lego.HtmlNode lego._HtmlNote|string

---@class lego._HtmlNote
---@field tag string
---@field attributes lego.HtmlAttribute[]
---@field children lego._HtmlNote[]

---@param tag string
---@param attributes lego.HtmlAttribute[]
---@param children lego.HtmlNode[]
---@return lego.HtmlNode
function html.el(tag, attributes, children)
  local attrs = {}
  for _, attr_table in ipairs(attributes or {}) do
    for k, v in pairs(attr_table) do
      attrs[k] = v
    end
  end

  return {
    tag = tag,
    attributes = attrs,
    children = children or {},
  }
end

---@param text string
---@return lego.HtmlNode
function html.text(text)
  return text
end

---@param html_str string
---@return lego.HtmlNode
function html.raw(html_str)
  return html_str
end

---@param txts string[]
---@return string[]
function html.tt(txts)
  local tt = vim
    .iter(txts)
    :map(function(txt)
      return { txt, " " }
    end)
    :flatten()
    :totable()

  if tt[#tt] == " " then
    table.remove(tt, #tt)
  end

  return tt
end

local _self_closing_tags = {
  area = {},
  base = {},
  br = {},
  col = {},
  embed = {},
  hr = {},
  img = {},
  input = {},
  -- link = {}, -- ignored because it needed for rss
  meta = {},
  source = {},
  track = {},
  wbr = {},
}

---@param node lego.HtmlNode
---@return string
function html.render(node)
  if type(node) == "string" then
    return node
  elseif type(node) == "table" and node.tag then
    local attr_keys = {}
    for k in pairs(node.attributes or {}) do
      table.insert(attr_keys, k)
    end
    table.sort(attr_keys)

    local attrs_str = ""
    for _, v in pairs(attr_keys) do
      attrs_str = attrs_str .. string.format(' %s="%s"', v, node.attributes[v])
    end

    if _self_closing_tags[node.tag] then
      return string.format("<%s%s>", node.tag, attrs_str)
    end

    local children_str = ""
    for _, child in ipairs(node.children or {}) do
      children_str = children_str .. html.render(child)
    end

    return string.format("<%s%s>%s</%s>", node.tag, attrs_str, children_str, node.tag)
  end
  return ""
end

function html.render_page(node)
  return "<!DOCTYPE html>" .. html.render(node)
end

-- --- COMMON ELEMENTS
-- stylua: ignore start

---@param attributes lego.HtmlAttribute[]
---@param children lego.HtmlNode[]
function html.div(attributes, children) return html.el("div", attributes, children) end

---@param attributes lego.HtmlAttribute[]
---@param children lego.HtmlNode[]
function html.main(attributes, children) return html.el("main", attributes, children) end

---@param attributes lego.HtmlAttribute[]
function html.meta(attributes) return html.el("meta", attributes, {}) end

---@param attributes lego.HtmlAttribute[]
---@param children lego.HtmlNode[]
function html.span(attributes, children) return html.el("span", attributes, children) end

---@param attributes lego.HtmlAttribute[]
---@param children lego.HtmlNode[]
function html.p(attributes, children) return html.el("p", attributes, children) end

---@param attributes lego.HtmlAttribute[]
---@param children lego.HtmlNode[]
function html.a(attributes, children) return html.el("a", attributes, children) end

---@param attributes lego.HtmlAttribute[]
---@param children lego.HtmlNode[]
function html.ul(attributes, children) return html.el("ul", attributes, children) end

---@param attributes lego.HtmlAttribute[]
---@param children lego.HtmlNode[]
function html.li(attributes, children) return html.el("li", attributes, children) end

---@param attributes lego.HtmlAttribute[]
---@param children lego.HtmlNode[]
function html.title(attributes, children) return html.el("title", attributes, children) end

---@param attributes lego.HtmlAttribute[]
function html.link(attributes) return html.el("link", attributes, {}) end

---@param attributes lego.HtmlAttribute[]
---@param children lego.HtmlNode[]
function html.h1(attributes, children) return html.el("h1", attributes, children) end

---@param attributes lego.HtmlAttribute[]
---@param children lego.HtmlNode[]
function html.h2(attributes, children) return html.el("h2", attributes, children) end

---@param attributes lego.HtmlAttribute[]
---@param children lego.HtmlNode[]
function html.nav(attributes, children) return html.el("nav", attributes, children) end

function html.br() return html.el("br", {}, {}) end

---@param datetime string
function html.time(datetime)
  return html.el("time",
    { a.attr("datetime", datetime) },
    { html.text(datetime)})
end

-- stylua: ignore end

return html
