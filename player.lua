local Entity = require 'entity'


local Player = {}
local mt = {__index=Player}


function Player.new(x, y, mass)
    local p = {}

    p.type = 'player'

    p.entity = Entity.newCircle(mass, x, y, 0.25)
    p.entity.shape.radius = 0.25

    p.entity.shape.owner = p  -- used in collision callbacks

    p.alive = true
    p.health = 100

    p.speed = 5 --1.4
    p.movedir = Vector()

    return setmetatable(p, mt)
end


function Player:getEntity()
    return self.entity
end


function Player:getShape()
    return self.shape
end


----------------------------------------
function Player:moveUp()
    self.movedir = self.movedir + Vector(0,-1)
end
function Player:moveDown()
    self.movedir = self.movedir + Vector(0,1)
end
function Player:moveLeft()
    self.movedir = self.movedir + Vector(-1,0)
end
function Player:moveRight()
    self.movedir = self.movedir + Vector(1,0)
end
----------------------------------------


function Player:update(dt)
    -- update velocity and position
    local velocity = self.movedir:normalize_inplace() * self.speed
    self.entity:setVelocity(velocity)
    self.movedir = Vector()
    self.entity:update(dt)

    if self.health <= 0 then
        self.alive = false
    end

    -- log to console
    local s = 'Player:\npos: %s\nvel: %s\nhp: %.3f\n'
    s = s:format(self.entity:getPosition(), self.entity:getVelocity(), self.health)
    console:log(s)
end


function Player:draw()
    -- to be changed
    local x, y = self.entity:getPosition():unpack()
    love.graphics.circle('fill', x, y, self.entity.shape.radius)
end


return Player