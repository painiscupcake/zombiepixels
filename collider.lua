local HC = require 'hardoncollider'


-- module that defines collision responses for hardoncollider
-- also handles shape creation


----------------------------------
-- COLLISION RESPONSE FUNCTIONS --
----------------------------------

local function callbackCollide(dt, shape_one, shape_two, dx, dy)

end


local function callbackStop(dt, shape_one, shape_two)

end

----------------------------------

local Collider = {}


function Collider.init(cellsize)
    Collider.collider = HC.new(cellsize, callbackCollide, callbackStop)
    setmetatable(Collider, {__index = Collider.collider})
end


function Collider.addPolygon(...)
    return Collider.collider:addPolygon(...)
end


function Collider.addRectangle(...)
    return Collider.collider:addRectangle(...)
end


function Collider.addCircle(...)
    return Collider.collider:addCircle(...)
end


function Collider.addPoint(...)
    return Collider.collider:addPoint(...)
end


return Collider