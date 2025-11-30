local frontmatter = {}

---@param lines string[]
---@return table
function frontmatter.extract(lines)
  if lines[1] ~= "---" then
    return {}
  end

  for i = 2, #lines do
    if lines[i] == "---" then
      local frontmatter_lines = { unpack(lines, 2, i - 1) }

      local result = {}
      for _, line in ipairs(frontmatter_lines) do
        local key, value = line:match "^%s*(.-)%s*=%s*(.-)%s*$"
        if key and value then
          result[key] = value
        end
      end

      return result
    end
  end

  return {}
end

---@param lines string[]
---@return string[]|nil
function frontmatter.content(lines)
  if lines[1] ~= "---" then
    return lines
  end

  return vim
    .iter(lines)
    :skip(1)
    :skip(function(el)
      return el ~= "---"
    end)
    :skip(1)
    :totable()
end

return frontmatter
