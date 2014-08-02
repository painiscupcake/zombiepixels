local HC = require 'hardoncollider'


-- module that defines collision responses for hardoncollider
-- also handles shape creation


----------------------------------
-- COLLISION RESPONSE FUNCTIONS --
----------------------------------

-- enemy - enemy case
local function enemy_enemy(dt, s1, s2, pd)
    if s1.type == 'enemy' and s2.type 'enemy' then
        local e1, e2 = s1.owner.entity, s2.owner.entity
        e1:move(pd/2)
        e2:move(-pd/2)
    end
end

-- player - enemy case
local function player_enemy(dt, s1, s2, pd)
    local p,e
    if s1.type == p then
        p = s1
        e = s2
    elseif s2.type == p then
        e = s1
        p = s2
        pd = -pd
    else
        return
    end

    --local pe = p.owner.entity
    local ee = e.owner.entity

    --pe:setPosition(pe:getPosition() - pd/2)
    ee:move(-pd)
end


local function callbackCollide(dt, s1, s2, dx, dy)
    local penDepth = Vector(dx,dy)

    enemy_enemy(dt,s1,s2,penDepth)
    player_enemy(dt,s1,s2,penDepth)
end


local function callbackStop(dt, shape_one, shape_two)

end

----------------------------------

local mt = {}
function mt.__index(t,k)
    local o = rawget(t,k)
    if o then
        return o
    else
        return t.collider[o]
    end
end

local Collider = {}


function Collider.init(cellsize)
    Collider.collider = HC.new(cellsize)--, callbackCollide, callbackStop)
    Collider.collider:setCallbacks(callbackCollide, callbackStop)
    setmetatable(Collider, {__index = Collider.collider})
end


return Collider