local Object = require("Object")

local Struct = {}

function Struct.new()
  local base = Object.new()
  local struct = class.extend("Struct", base)
  
  function struct:ToString()
    local ts = {}
    for k, v in pairs(self) do
        if isBaseType(v) then
          table.insert(ts, tostring(k)..": "..tostring(v))
        end
    end
    return table.concat(ts, ", ")
  end
  
  function struct.public.protected_set:Equals(o)
    if typeof(self) ~= typeof(o) then
      return false
    end    
    
    for k, v in pairs(self.public) do
      if isBaseType(v) or isType(v, "Struct") then
        if o[k] == nil or v ~= o[k] then
          return false
        end
      end
    end
    
    return true
  end

  return class.init(struct)
end

return Struct