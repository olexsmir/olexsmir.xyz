local hattribute = {}

---@class lego.HtmlAttribute
---@field [string] string

---@param attribute string
---@param value string
---@return lego.HtmlAttribute
function hattribute.attr(attribute, value)
  return { [attribute] = value }
end

-- COMMON ATTRIBUTES
-- stylua: ignore start

---@param class string
function hattribute.class(class) return hattribute.attr("class", class) end

---@param link string
function hattribute.href(link) return hattribute.attr("href", link) end

---@param id string
function hattribute.id(id) return hattribute.attr("id", id) end

-- stylua: ignore end

return hattribute
