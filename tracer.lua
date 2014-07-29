-- little short and colored line that can move in one direction
-- usable for bullet traces
-- draws a line with limited length from startPos to endPos
-- startPos is saved at initialisation
-- endPos is passed to Tracer:updatePos()
-- will not draw line longer than the distance between startPos and endPos

local Tracer = {}
Tracer.__index = Tracer


function Tracer.new(startPos, endPos, length, color)
    local t = {}

    t.startPos = startPos
    t.endPos = endPos

    t.length = length

    t.color = color

    return setmetatable(t, Tracer)
end


function Tracer:updatePos(endPos)
    self.endPos = endPos
end


function Tracer:draw()
    local distance = self.endPos-self.startPos
    local distanceLength = distance:length()
    local localLength = math.min(self.length, distanceLength)

    local startPos = self.startPos + distance:normalize() * (distanceLength - localLength)

    local x1, y1 = startPos:unpack()
    local x2, y2 = self.endPos:unpack()

    love.graphics.setColor(self.color)
    love.graphics.line(x1, y1, x2, y2)
end


return Tracer