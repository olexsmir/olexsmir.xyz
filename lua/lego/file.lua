local file = {}
local _writes = {}

function file.report_duplicates()
  local freq = {}
  local duplicates = {}

  for _, v in ipairs(_writes) do
    freq[v] = (freq[v] or 0) + 1
  end

  for value, count in pairs(freq) do
    if count > 1 then
      duplicates[#duplicates + 1] = value
    end
  end

  if #duplicates > 0 then
    vim.print("duplicates " .. vim.inspect(duplicates))
  end
end

---@alias lego.FilePath string|string[]

---@param p lego.FilePath
---@return string
function file.to_path(p)
  if type(p) == "table" then
    return vim.fs.joinpath(unpack(p))
  end
  return p
end

---@param path lego.FilePath
---@return string[]
function file.list_dir(path)
  return vim.fn.readdir(file.to_path(path))
end

---@param path lego.FilePath
function file.read(path)
  return vim.fn.readfile(file.to_path(path))
end

---@param path lego.FilePath
---@param content string
function file.write(path, content)
  path = file.to_path(path)
  table.insert(_writes, path)

  vim.print("writing " .. path)
  vim.fn.writefile(vim.split(content, "\n", { plain = true }), path)
end

---@param path lego.FilePath
function file.rm(path)
  path = file.to_path(path)
  vim.print("deleting " .. path)
  vim.fs.rm(path, { force = true, recursive = true })
end

---@param path string
function file.mkdir(path)
  vim.fn.mkdir(file.to_path(path), "p")
end

---@param path string
function file.is_dir(path)
  local build_dir_stats = vim.uv.fs_stat(file.to_path(path))
  return not build_dir_stats or build_dir_stats.type == "directory"
end

---@param from string
---@param to string
function file.copy_dir(from, to)
  from = file.to_path(from)
  to = file.to_path(to)
  vim.print("copying " .. to)

  file.mkdir(to)
  for _, f in ipairs(vim.fn.readdir(from)) do
    vim.uv.fs_copyfile(vim.fs.joinpath(from, f), vim.fs.joinpath(to, f))
  end
end

return file
