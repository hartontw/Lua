require "System"

local function tostring(self) return self:ToString() end

local function eq(self, other) return self:Equals(other) end
local function unm(self) return self:Minus() end
local function le(self, other) return self:LessEquals(other) end
local function lt(self, other) return self:LessThan(other) end

local function add(self, other) return self:Addition(other) end
local function sub(self, other) return self:Subtraction(other) end
local function mul(self, other) return self:Multiplication(other) end
local function div(self, other) return self:Division(other) end
local function mod(self, other) return self:Modulo(other) end
local function pow(self, other) return self:Pow(other) end
local function concat(self, other) return self:Concat(other) end

local function classGet(self, k)

  local public = self.public

  if public[k] then
    return public[k]
  end

  for _, p in pairs(public) do
    if isTable(p) and p[k] then
      return p[k]
    end
  end

  local protected = self.protected

  if protected[k] then
    return protected[k]
  end

  for _, p in pairs(protected) do
    if isTable(p) and p[k] then
      return p[k]
    end
  end

  local private = self.private

  if private[k] then
    return private[k]
  end

  for _, p in pairs(private) do
    if isTable(p) and p[k] then
      return p[k]
    end
  end

  error(k.." doesn't exist in "..self:GetType())
  return nil
end

local function classSet(self, k, v)

  local public = self.public

  --print(self:GetType(), k, v, public[k], rawget(public, "ToString"))

  if public[k] then
    public[k] = v; return
  end

  for pk, p in pairs(public) do
    if isTable(p) and p[k] then
      if pk == "readonly" or pk == "private_set" then
        error(k.." can't be accessed due its protection level."); return
      else
        p[k] = v; return
      end
    end
  end

  local protected = self.protected

  if protected[k] then
    protected[k] = v; return
  end

  for pk, p in pairs(protected) do
    if isTable(p) and p[k] then
      if pk == "readonly" or pk == "private_set" then
        error(k.." can't be accessed due its protection level."); return
      else
        p[k] = v; return
      end
    end
  end

  local private = self.private

  if private[k] then
    private[k] = v; return
  end

  for pk, _ in pairs(private) do
    local p = private[pk]
    if isTable(p) and p[k] then
      if pk == "readonly" then
        error(k.." can't be accessed due its protection level."); return
      else
        p[k] = v; return
      end
    end
  end

  error(k.." doesn't exist in "..self:GetType())
  return nil
end

local function objectGet(self, k)

  local public = self.public

  if public[k] then
    return public[k]
  end

  for _, p in pairs(public) do
    if isTable(p) and p[k] then
      return p[k]
    end
  end

  local protected = self.protected

  if protected[k] then
    error(k.." can't be accessed due its protection level."); return nil
  end

  for _, p in pairs(protected) do
    if isTable(p) and p[k] then
      error(k.." can't be accessed due its protection level."); return nil
    end
  end

  local private = self.private

  if private[k] then
    error(k.." can't be accessed due its protection level."); return nil
  end

  for pk, _ in pairs(private) do
    local p = private[pk]
    if isTable(p) and p[k] then
      error(k.." can't be accessed due its protection level."); return nil
    end
  end

  error(k.." doesn't exist in "..self:GetType())
  return nil
end

local function objectSet(self, k, v)

  local public = self.public

  if public[k] then
    public[k] = v; return
  end

  for pk, p in pairs(public) do
    if isTable(p) and p[k] then
      public[pk][k] = v; return
    end
  end

  local protected = self.protected

  if protected[k] then
    error(k.." can't be accessed due its protection level."); return
  end

  for _, p in pairs(protected) do
    if isTable(p) and p[k] then
      error(k.." can't be accessed due its protection level."); return
    end
  end

  local private = self.private

  if private[k] then
    error(k.." can't be accessed due its protection level."); return
  end

  for _, p in pairs(private) do
    if isTable(p) and p[k] then
      error(k.." can't be accessed due its protection level."); return
    end
  end

  error(k.." doesn't exist in "..self:GetType())
  return nil
end

local metaobject = {
__index = objectGet,
__newindex = objectSet,
__tostring = tostring,
__eq = eq,
__unm = unm,
__le = le,
__lt = lt,
__add = add,
__sub = sub,
__mul = mul,
__div = div,
__mod = mod,
__pow = pow,
__concat = concat
}

local metaclass = {
__index = classGet,
__newindex = classSet,
__tostring = tostring,
__eq = eq,
__unm = unm,
__le = le,
__lt = lt,
__add = add,
__sub = sub,
__mul = mul,
__div = div,
__mod = mod,
__pow = pow,
__concat = concat
}

_G.class = {}

_G.class.extend = function(type, self)
  self = self or {}

  local base = getmetatable(self)
  setmetatable(self, nil)

  if not base then
    self.public = {}
    self.public.protected_set = {}
    self.public.private_set = {}
    self.public.readonly = {}

    self.protected = {}
    self.protected.private_set = {}
    self.protected.readonly = {}

    local hex = string.gsub(_G.tostring(self), "table: ", "")
    self.public.readonly.GetHex = function(s) return hex end
  else
    self.private.readonly = nil
    self.private = nil

    self.protected.readonly.base = base
  end

  self.private = {}
  self.private.readonly = {}

  self.public.readonly.GetType = function(s) return type end

  setmetatable(self, metaclass)
  return self
end

_G.class.init = function(self)
--[[
  local newFunc = function(table)
    for k, v in pairs(table) do
      if isFunction(v) then
        table[k] = function(t, ...)
          local mt = getmetatable(t)
          mt.__index=classGet; mt.__newindex=classSet
          local values = {v(t, unpack(arg))}
          mt.__index=objectGet; mt.__newIndex=objectSet
          return unpack(values)
        end
      end
    end
  end

  newFunc(self.public)
  newFunc(self.public.protected_set)
  newFunc(self.public.private_set)
  newFunc(self.public.readonly)
  newFunc(self.protected)
  newFunc(self.protected.private_set)
  newFunc(self.protected.readonly)
  newFunc(self.private)
  newFunc(self.private.readonly)
--]]
  setmetatable(self, metaobject)
  return self
end

local Object = {}

function Object.new()
  local object = class.extend("Object")

  function object.public.readonly:IsType(...)
    for _, v in ipairs(arg) do
      local other = v

      if not isString(v) then
        if not isObject(v) then
          return false
        end
        other = v:GetType()
      end

      local next = self
      while next do
        if next:GetType() == other then
          return true
        end
        next = next.base
      end
    end
    return false
  end

  function object.public.readonly:GetInfo()
    return self:GetType()..": "..self:GetHex()
  end

  function object.public.protected_set:ToString()
    return self:GetInfo()
  end

  function object.public.protected_set:Equals(o)
    return self:GetHex() == o:GetHex()
  end

  function object.protected:__unm() self:error("unm"); return nil; end
  function object.protected:__le(o) self:error("<=", o); return nil; end
  function object.protected:__lt(o) self:error("<", o); return nil; end

  function object.protected:__tostring() return self:ToString() end

  function object.protected:__add(o) self:error("+", o); return nil; end
  function object.protected:__sub(o) self:error("-", o); return nil; end
  function object.protected:__mul(o) self:error("*", o); return nil; end
  function object.protected:__div(o) self:error("/", o); return nil; end
  function object.protected:__mod(o) self:error("%", o); return nil; end
  function object.protected:__pow(o) self:error("^", o); return nil; end
  function object.protected:__concat(o) return self:ToString()..tostring(o) end

  function object.private.readonly:error(op, o)
    if o then
      error(self:GetType().." "..op.." "..typeof(o).." is not implemented.")
    else
      error(self:GetType().." has not "..op.." implemented.")
    end
  end

  function object.public.protected_set:Serialize()
    return Object.Serialize(self)
  end

  return class.init(object)
end

--STATIC
function Object.Serialize(object)
--TODO
end

function Object.Unserialize(string)
--TODO
end

return Object
