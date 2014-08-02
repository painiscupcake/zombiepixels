-- mass, velocity and shape container
-- shape contains position

local Entity = {}


--local mt = {__index=Entity}
local mt = {}
function mt.__index(t,k)
    local o = rawget(t,k)
    if o then
        return o
    else
        local o = Entity[k]
        if o then
            return o
        else
            local o = t.shape[k]
            if o then
                return o
            else
                error('No such key ' .. k .. '!')
            end
        end
    end
end


-- CREATION FUNCTIONS

function Entity.newPolygon(mass, ...)
    local e = {}
    e.shape = Collider:addPolygon(...)
    e.mass = mass
    e.velocity = Vector()
    return setmetatable(e, mt)
end

function Entity.newRectangle(mass, ...)
    local e = {}
    e.shape = Collider:addRectangle(...)
    e.mass = mass
    e.velocity = Vector()
    return setmetatable(e, mt)
end

function Entity.newCircle(mass, ...)
    local e = {}
    e.shape = Collider:addCircle(...)
    e.mass = mass
    e.velocity = Vector()
    return setmetatable(e, mt)
end

function Entity.newPoint(mass, ...)
    local e = {}
    e.shape = Collider:addPoint(...)
    e.mass = mass
    e.velocity = Vector()
    return setmetatable(e, mt)
end

---------------------

-- SHAPE FUNCTION REDEFINITIONS

function Entity:contains(region)
    return self.shape:contains(region:unpack())
end


function Entity:intersectsRay(v1, v2)
    return self.shape:contains(v1:unpack(), v2:unpack())
end


function Entity:move(dpos)
    self.shape:move(dpos:unpack())
end


function Entity:moveTo(pos)
    self.shape:moveTo(pos:unpack())
end


function Entity:scale(s)
    self.shape:scale(s)
end


function Entity:rotate(angle, pos)
    -- pos defaults to center if omitted
    self.shape:rotate(angle, pos:unpack())
end


function Entity:setRotation(angle, pos)
    -- pos defaults to center if omitted
    self.shape:setRotation(angle, pos:unpack())
end

--[[
function Entity:center()
    return self.shape:center()
end
--]]

function Entity:rotation()
    return self.shape:rotation()
end


function Entity:outcircle()
    return self.shape:outcircle()
end


function Entity:bbox()
    return self.shape:bbox()
end


function Entity:support(dpos)
    return Vector(self.shape:support(dpos:unpack()))
end


function Entity:collidesWith(other)
    return self.shape:collidesWith(other)
end


function Entity:neighbors()
    return self.shape:neighbors()
end

-------------------------------


function Entity:update(dt)
    self:move(self.velocity * dt)
end


function Entity:setMass(mass)
    if mass <= 0 then
        error('Mass cannot be negative or equal to zero.')
    end
    self.mass = mass or self.mass
end


function Entity:getMass()
    return self.mass
end


function Entity:setPosition(pos)
    self:moveTo(pos)
end


function Entity:getPosition()
    return Vector(self:center())
end


function Entity:setVelocity(vel)
    self.velocity = vel or self.velocity
end


function Entity:getVelocity()
    return self.velocity
end


function Entity:applyVelocity(dvel)
    self.velocity = self.velocity + (dvel or Vector())
end


function Entity:limitVelocity(speed)
    self.velocity = self.velocity:normalize_inplace() * speed
end


function Entity:applyImpulse(impulse)
    self.velocity = self.velocity + (impulse or Vector()) / self.mass
end


return Entity