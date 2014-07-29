local newOverloadObject = require 'fnoverload'


local Vector = {}
Vector.__index = Vector
setmetatable(Vector, {__call = function (_, ...) return Vector.new(...) end})


local abs   = math.abs
local sqrt  = math.sqrt
local sin   = math.sin
local cos   = math.cos
local atan2 = math.atan2
local acos  = math.acos



local function validate2(a, b)
    if getmetatable(a) ~= Vector or getmetatable(b) ~= Vector then
        error('Unsupported operand')
    end
end


local function validate1(a)
    if getmetatable(a) ~= Vector then
        error('Unsupported operand')
    end
end




function Vector.new(x, y)
    return setmetatable({x = x or 0, y = y or 0}, Vector)
end


function Vector.fromAngle(a)
    return setmetatable({x = cos(a), y = sin(a)}, Vector)
end



function Vector:__unm()
    return Vector(-self.x, -self.y)
end


-- overloaded addition
Vector.__add = newOverloadObject()

function Vector.__add.table.table(a, b)
    validate2(a, b)
    return Vector(a.x + b.x, a.y + b.y)
end


function Vector.__add.table.number(v, n)
    validate1(v)
    return Vector(v.x + n, v.y + n)
end


function Vector.__add.number.table(n, v)
    validate1(v)
    return Vector(n + v.x, n + v.y)
end


-- overloaded subtraction
Vector.__sub = newOverloadObject()
function Vector.__sub.table.table(a, b)
    validate2(a, b)
    return Vector(a.x - b.x, a.y - b.y)
end


function Vector.__sub.table.number(v, n)
    validate1(v)
    return Vector(v.x - n, v.y - n)
end


-- overloaded multiplication
Vector.__mul = newOverloadObject()
function Vector.__mul.table.table(a, b)
    validate2(a, b)
    return Vector(a.x * b.x, a.y * b.y)
end


function Vector.__mul.table.number(v, n)
    validate1(v)
    return Vector(v.x * n, v.y * n)
end


function Vector.__mul.number.table(n, v)
    validate1(v)
    return Vector(n * v.x, n * v.y)
end


-- overloaded division
Vector.__div = newOverloadObject()
function Vector.__div.table.table(a, b)
    validate2(a, b)
    return Vector(a.x / b.x, a.y / b.y)
end


function Vector.__div.table.number(v, n)
    validate1(v)
    return Vector(v.x / n, v.y / n)
end



function Vector.dot(a, b)
    validate2(a, b)
    return a.x * b.x + a.y * b.y
end



function Vector.__eq(a, b)
    validate2(a, b)
    return a.x == b.x and a.y == b.y
end



function Vector:__tostring()
    return string.format('(%.3f, %.3f)', tostring(self.x), tostring(self.y))
end


function Vector:unpack() -- for whatever reason doesn't work with love.graphics.draw and others
    return self.x, self.y
end


function Vector:length()
    return sqrt(self.x^2 + self.y^2)
end


function Vector:abs()
    return Vector( abs(self.x), abs(self.y) )
end


function Vector:getSign()
    return Vector(self.x / abs(self.x), self.y / abs(self.y))
end


function Vector:normalize()
    l = self:length()
    return Vector(self.x / l, self.y / l)
end


function Vector:rotate(angle)
    local c, s = cos(angle), sin(angle)
    local x = self.x * c - self.y * s
    local y = self.x * s + self.y * c
    return Vector(x, y)
end


function Vector:getAngle()
    local a = atan2(self.y, self.x)
    if a < 0 then
        return a + math.pi * 2
    end
    return a
end


function Vector.angleBetween(a, b)
    validate2(a, b)
    return acos(Vector.dot(a, b))
end



function Vector:invertX()
    return Vector(-self.x, self.y)
end


function Vector:invertY()
    return Vector(self.x, -self.y)
end



-- mirroring against normal
function Vector:mirror(normal)
    return self - 2 * normal * Vector.dot(normal, self)
end


function Vector:perpendicular()
    return Vector(-self.y, self.x)
end


-- projection on a plane
function Vector:project(plane)
    local k = Vector.dot(self, plane) / Vector.dot(plane, plane)
    return self:mul(k)
end


return Vector