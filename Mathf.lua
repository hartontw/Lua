
local Mathf = {}

Mathf.PI = math.pi
Mathf.TAU = 2*Mathf.PI
Mathf.Deg2Rad = Mathf.TAU / 360
Mathf.Epsilon = 1E-12
Mathf.Infinity = math.huge
Mathf.NegativeInfinity = -math.huge
Mathf.Rad2Deg = 360 / Mathf.TAU

local pot, fact = {}, {}

function Mathf.Abs(x)
  return math.abs(x)
end

function Mathf.Acos(x)
  return math.acos(x)
end

function Mathf.Approximately(a, b, e)
  e = e or Mathf.Epsilon
  return a + e > b and a - e < b
end

function Mathf.Asin(x)
  return math.asin(x)
end

function Mathf.Atan(x)
  return math.atan(x)
end

function Mathf.Atan2(y, x)
  return math.atan2(y, x)
end

function Mathf.Ceil(x)
  return math.ceil(x)
end

function Mathf.Clamp(v, min, max)
  v = Mathf.Max(v, min)
  v = Mathf.Min(v, max)
  return v
end

function Mathf.Clamp01(v)
  return Mathf.Clamp(v, 0, 1)
end

function Mathf.ClosestPowerOfTwo(v)
  if v < 0 then
    return Mathf.NegativeInfinity
  end    
  
  local dist = Mathf.Abs(v-1)
  local exp = 0 
  local sign = v < 1 and -1 or 1
  
  while true do    
    local p = Mathf.Pow2(exp)
    
    local d = Mathf.Abs(p-v)
    
    local limit = sign < 0 and p <= v or p >= v
    
    if limit then
      if d > dist then
        exp = exp - sign
        return Mathf.Pow2(exp), exp
      else
        return p, exp
      end      
    end
    
    exp = exp + sign
    dist = d
  end
end

function Mathf.Cos(x)
  return math.cos(x)
end

function Mathf.Cosh(x)
  return math.cosh(x)
end

function Mathf.DeltaAngle(current, target)
  current = math.rad(current); target = math.rad(target)
  return math.deg(Mathf.Atan2(Mathf.Sin(target-current), Mathf.Cos(target-current)))
end

function Mathf.Exp(x)
  return math.exp(x)
end

function Mathf.Fact(x)
  if x < 0 then
    return nil
  end
  
  x = Mathf.Floor(x)
  
  if x <= 1 then
    return 1
  end
  
  if fact[x] then
    return fact[x]
  end
  
  fact[x] = x * Mathf.Fact(x-1)
  
  return fact[x]     
end

function Mathf.Floor(x)
  return math.floor(x)
end

function Mathf.Fmod(x, y)
  return math.fmod(x,y)
end

function Mathf.Frexp(x)
  return math.frexp(x)
end

function Mathf.InverseLerp(a, b, v)
  local ilu = Mathf.InverseLerpUnclamped(a, b, v)
  return Mathf.Clamp01(ilu)
end

function Mathf.InverseLerpUnclamped(a, b, v)
  local d = b-a
  return d ~= 0 and (v-a) / d or a
end

function Mathf.IsPowerOfTwo(v)
  if v < 0 then
    return false
  end
  return Mathf.ClosestPowerOfTwo(v) == v
end

function Mathf.Ldexp(m, e)
  return math.ldexp(m,e)
end

function Mathf.Lerp(a, b, t)
  return Mathf.LerpUnclamped(a, b, Mathf.Clamp01(t))
end

function Mathf.LerpUnclamped(a, b, t)
  return a + (b-a) * t
end

function Mathf.Log(x)
  return math.log(x)
end

function Mathf.Log10(x)
  return math.log10(x)
end

function Mathf.Max(...)
  return math.max(...)
end

function Mathf.Min(...)
  return math.min(...)
end

function Mathf.Modf(x) 
  return math.modf(x)
end

function Mathf.MoveTowards(current, target, maxDelta)
  local d = target - current
  local s = Mathf.Sign(d)
  d = Mathf.Min(Mathf.Abs(d), maxDelta)
  local n = current + d * s 
  return s > 0 and n > target or s < 0 and n < target and target or n 
end

function Mathf.MoveTowardsAngle(current, target, maxDelta)
  local d = Mathf.DeltaAngle(current, target)
  local s = Mathf.Sign(d)
  d = Mathf.Min(Mathf.Abs(d), maxDelta)  
  local n = current + d * s
  return s > 0 and n > target or s < 0 and n < target and target or n
end

function Mathf.NextPowerOfTwo(v)
  local n, e = Mathf.ClosestPowerOfTwo(v)
  return n < v and Mathf.Pow2(e+1) or n  
end

function Mathf.PingPong(t, length)
  local l = 2 * length
  local c = t % l
  return 0 <= c and c < length and c or l - c 
end

function Mathf.Pow(x, y)
  return math.pow(x,y)
end

function Mathf.Pow2(e)
  if not pot[e] then
    pot[e] = 2^e
  end
  return pot[e]
end

function Mathf.Round(x, n)
  n = n or 0
  for i=1, n do x = x * 10 end  
  local d = x - Mathf.Floor(x)
  x = x - d
  d = d < 0.5 and 0 or 1
  x = x + d
  for i=1, n do x = x / 10 end
  return x
end

function Mathf.Sign(x)
  if x < 0 then
    return -1
  end
  return 1
end

function Mathf.Sin(x)
  return math.sin(x)
end

function Mathf.Sinh(x)
  return math.sinh(x)
end

function Mathf.Sqrt(x)
  return math.sqrt(x)
end

function Mathf.Tan(x)
  return math.tan(x)
end

function Mathf.Tanh(x)
  return math.tanh(x)
end

function Mathf.ToDeg(x)
  return math.deg(x)
end

function Mathf.ToRad(x)
  return math.rad(x)
end

return Mathf