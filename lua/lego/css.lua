local css = {}

---@param str string
---@return string
local function to_kebab_case(str)
  str = str:gsub("_", "-")
  str = str:gsub("([a-z])([A-Z])", "%1-%2"):lower() -- Convert camelCase to kebab-case
  return str
end

---@param value string|number
---@return string
local function value_to_css(value)
  if type(value) == "number" then
    return tostring(value)
  end
  return string.format("%s", value)
end

local function render_properties(properties)
  local parts = {}
  local keys = {}
  for key in pairs(properties) do
    table.insert(keys, key)
  end
  table.sort(keys)

  for _, key in ipairs(keys) do
    local value = properties[key]
    table.insert(parts, string.format("%s:%s", to_kebab_case(key), value_to_css(value)))
  end

  return table.concat(parts, ";")
end

local function flatten_css_rules(rules)
  local all_rules = {}

  local function process_rule(sel, props, prefix)
    local full_sel
    if sel:find "^&" then
      full_sel = prefix .. sel:gsub("^&", "")
    else
      full_sel = prefix and (prefix .. " " .. sel) or sel
    end
    local flat_props = {}
    for k, v in pairs(props) do
      if type(v) == "table" then
        process_rule(k, v, full_sel)
      else
        flat_props[k] = v
      end
    end
    if next(flat_props) then
      all_rules[full_sel] = flat_props
    end
  end

  for sel, props in pairs(rules) do
    process_rule(sel, props, nil)
  end

  return all_rules
end

---@param rules table
---@return string
function css.style(rules)
  local all_rules = flatten_css_rules(rules)

  local selectors = {}
  for s in pairs(all_rules) do
    table.insert(selectors, s)
  end
  table.sort(selectors)

  local rule_parts = {}
  for _, sel in ipairs(selectors) do
    local props = all_rules[sel]
    local props_str = render_properties(props) .. ";"
    table.insert(rule_parts, string.format("%s{%s}", sel, props_str))
  end

  return table.concat(rule_parts, "")
end

return css
