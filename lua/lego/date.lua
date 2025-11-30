local date = {}

---@param d string
---@return string
function date.date(d)
  return d .. "T00:00:00+02:00"
end

return date
