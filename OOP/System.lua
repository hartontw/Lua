
_G.dataTypes = {["string"] = "", ["number"] = 0, ["boolean"] = false, ["table"] = {}, ["function"] = nil, ["userdata"] = nil, ["thread"] = nil,}

--BOOL
function _G.isString(o)
  return type(o) == "string"
end

function _G.isNumber(o)
  return type(o) == "number"
end

function _G.isBoolean(o)
  return type(o) == "boolean"
end

function _G.isTable(o)
  return type(o) == "table"
end

function _G.isFunction(o)
  return type(o) == "function"
end

function _G.isUserData(o)
  return type(o) == "userdata"
end

function _G.isThread(o)
  return type(o) == "thread"
end

function _G.isBaseType(o)
  return o ~= nil and (isString(o) or isNumber(o) or isBoolean(o))
end

function _G.isType(o, ...)
  for _, t in ipairs(arg) do
    if typeof(o) == t then
      return true
    end
  end
  return false
end

function _G.isObject(o)
  return hasFields(o, "public", "protected", "private")
end

function _G.hasFields(o, ...)
  if not isTable(o) then
    return false
  end
  
  for _, v in ipairs(arg) do
    if not o[v] then
      return false
    end
  end
  
  return true
end

--GET
function _G.typeof(o)
  if isObject(o) then
    return o:GetType()
  end
  return type(o)
end

function _G.defaultValue(o)
  local t = typeof(o)
  if dataTypes[t] then
    return dataTypes[t]
  elseif isObject(o) then
    return o:new()
  end
  return nil
end

--SET
function _G.initString(o, d)
  d = d or ""
  return isString(o) and o or d
end

function _G.initNumber(o, d)
  d = d or 0
  return isNumber(o) and o or d
end

function _G.initBoolean(o, d)
  d = d or false
  return isBoolean(o) and o or d
end

function _G.initTable(o, d)
  d = d or {}
  return isTable(o) and o or d
end