-- hardoncollider's shape wrapper, relies on variable
-- Collider which is an instance of HardonCollider
--
-- makes all shape methods callable with vectors
-- also adds mass, position and velocity
-- entities are updated with entity:update(dt)
-- using with entityupdater system is recommended


local function newEntity(mass, position, velocity)
    local e = {}
    e.mass = mass or 1
    e.position = position or Vector()
    e.velocity = velocity or Vector()
    return e
end


local Entity = {}
function Entity.__index(t, k)
    local o = rawget(t, k)
    if o then
        return o
    else
        o = rawget(Entity, k)
        if o then
            return o
        else
            return t.shape[k]
        end
    end
end

------------------------
-- CREATION FUNCTIONS --
------------------------

function Entity.newPolygon(mass, position, points)
    -- takes points array in format: {x1,y1,x2,y2, ... ,xn,yn}
    -- points are local
    local o = newEntity(mass, position)

    local shape = Collider:addPolygon(unpack(points))
    shape:moveTo(o.position:unpack())
    o.shape = shape

    return setmetatable(o, Entity)
end


function Entity.newRectangle(mass, position, width, height)
    -- position argument is the center of rectangle
    local o = newEntity(mass, position)

    local p = o.position
    local ulc = p - Vector(width/2, height/2)    -- upper left corner
    local shape = Collider:addRectangle(ulc.x, ulc.y, width, height)
    o.shape = shape

    return setmetatable(o, Entity)
end


function Entity.newCircle(mass, position, radius)
    local o = newEntity(mass, position)

    local p = o.position
    local shape = Collider:addCircle(p.x, p.y, radius)
    shape.radius = radius
    o.shape = shape

    return setmetatable(o, Entity)
end


function Entity.newPoint(mass, position)
    local o = newEntity(mass, position)

    local p = o.position
    local shape = Collider:addPoint(p.x, p.y)
    o.shape = shape

    return setmetatable(o, Entity)
end

-----------------------------------
-- SHAPE FUNCTIONS USING VECTORS --
-----------------------------------

function Entity:contains(region)
    return self.shape:contains(region:unpack())
end


function Entity:intersectsRay(v1, v2)
    return self.shape:contains(v1:unpack(), v2:unpack())
end


function Entity:move(dpos)
    if dpos then
        self.pos = self.pos + dpos
        self.shape:move(dpos:unpack())
    end
end


function Entity:moveTo(pos)
    self.pos = self.pos + pos
    self.shape:moveTo(pos:unpack())
end


function Entity:rotate(angle, pos)
    -- pos defaults to center if omitted
    self.shape:rotate(angle, pos:unpack())
end


function Entity:support(dpos)
    return Vector(self.shape:support(dpos:unpack()))
end

-----------------------------------

function Entity:update(dt)
    self.pos = self.pos + self.velocity * dt
end


-- sets e.markedForRemoval flag to true
-- so that EntityUpdater will remove it from it's list
-- also removes entity's shape from Collider's list
function Entity:markForRemoval()
    self.markedForRemoval = true
    Collider:remove(self.shape)
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
    return self.position
end


function Entity:setVelocity(vel)
    self.velocity = vel or self.velocity
end


function Entity:getVelocity()
    return self.velocity()
end


function Entity:applyVelocity(dvel)
    self.velocity = self.velocity + (dvel or Vector())
end


function Entity:applyImpulse(impulse)
    self.velocity = self.velocity + (impulse or Vector()) / self.mass
end


return Entity