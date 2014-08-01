local Player = {}
Player.__index = Player


function Player.new(x, y, mass)
    local p = {}
    p.type = 'player'
    p.entity = Entity.newCircle(mass, Vector(x,y), 10)
    p.entity.shape.entity = p  -- used in collision callbacks

    p.alive = true
    p.health = 100
    p.damage = 20

    p.speed = 100

    p.currentWeapon = nil

    return setmetatable(p, Player)
end


function Player:setVelocity(velocity)
    self.velocity = velocity or Vector()
end


function Player:applyVelocity(velocity)
    self.entity.velocity = (self.entity.velocity + velocity):normalized() * self.speed
end

--[[ unused methods
function Player:setPosition(position)
    self.position = position or self.position
end


function Player:move(dposition)
    if dposition then
        self.position = self.position + dposition
    end
end
--]]

function Player:setWeapon(weapon)
    self.currentWeapon = weapon
end


function Player:getWeapon()
    return self.currentWeapon
end


function Player:useWeapon()
    if self.currentWeapon then
        local mx, my = love.mouse.getPosition()
        local wx, wy = camera:toWorld(mx, my)
        self.currentWeapon:shoot(self.position, Vector(mx, my))
    end
end


function Player:reloadWeapon()
    if self.currentWeapon then
        self.currentWeapon:reload()
    end
end


function Player:update(dt)
    self.entity:update()

    if self.health <= 0 then
        self.alive = false
    end

    self.currentWeapon:update(dt)

    local s = 'Player:\npos: %s\nvel: %s\nhp: %.3f\nweapon: %s\n'
    s = s:format(self.entity.position, self.entity.velocity, self.health, self:getWeapon().name)
    console:log(s)
end


function Player:draw()
    -- to be changed
    local x, y = self.entity.position:unpack()
    love.graphics.circle('fill', x, y, self.entity.shape.radius)
end


return Player