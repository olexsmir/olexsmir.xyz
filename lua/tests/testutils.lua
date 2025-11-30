---@class testutils
local testutils = {}

local minit_path = vim.fn.expand "%:p:h" .. "minit.lua"

---@param mod string Module name for which to create a nested test set.
---@return MiniTest.child child
---@return table T
---@return table mod_name
function testutils.setup(mod)
  local child = MiniTest.new_child_neovim()
  local T = MiniTest.new_set {
    hooks = {
      post_once = child.stop,
      pre_case = function()
        child.restart { "-u", minit_path }
      end,
    },
  }

  T[mod] = MiniTest.new_set {}
  return child, T, T[mod]
end

---@generic T
---@param a T
---@param b T
function testutils.eq(a, b)
  return MiniTest.expect.equality(a, b)
end

---@param msg? string
function testutils.skip(msg)
  MiniTest.skip(msg)
end

return testutils
