Vector = require 'vector'

Collider = require 'collider'

Entity = require 'entity'

Player = require 'player'
Enemies = require 'enemies'
--ProjectileLibrary   = require 'projectile_library'
--WeaponLibrary       = require 'weapon_library'

Camera = require 'gamera'

Console = require 'debugconsole'


DEBUG = true


function love.load()
    METER = 64  -- useful for scaling while drawing
    Collider.init(1)
    -- everything below in this function is temporary

    -- set console
    console = Console.new()

    bounds = {
        x1=0, x2=20,
        y1=0, y2=20,
    }

    -- set camera
    camera = Camera.new(bounds.x1, bounds.y1, bounds.x2, bounds.y2)
    camera:setScale(METER/2)

    -- create player
    player = Player.new(bounds.x2/2, bounds.y2/2, 80)
end


function love.update(dt)
    -- player controls
    if love.keyboard.isDown('w') then
        player:moveUp()
    elseif love.keyboard.isDown('s') then
        player:moveDown()
    end

    if love.keyboard.isDown('a') then
        player:moveLeft()
    elseif love.keyboard.isDown('d') then
        player:moveRight()
    end


    console:log(('FPS: %i'):format(love.timer.getFPS()))

    player:update(dt)
    Enemies.update(dt)
    Collider:update(dt)

    camera:setPosition(player.entity:getPosition():unpack())

    love.graphics.setLineWidth(camera:getScale()^-1)
end


function love.keypressed(key)
    if key == 'escape' then
        love.event.push('quit')
    end

    if key == '`' then
        DEBUG = not DEBUG
    end

    if key == 'r' then
        --player:reloadWeapon()
    end

    if key == 'n' then
        Enemies.createEnemies(10)
    end
end


function love.keyreleased(key)

end


function love.mousepressed(x, y, button)

end


local function drawInCamera(x,y,w,h)
    -- draw meter mesh
    love.graphics.setColor(100,100,100)
    local x1 = bounds.x1
    local x2 = bounds.x2
    local y1 = bounds.y1
    local y2 = bounds.y2
    for x = x1, x2 do
        love.graphics.line(x, y1, x, y2)
    end
    for y = y1, y2 do
        love.graphics.line(x1, y, x2, y)
    end


    love.graphics.setColor(255,255,255)
    player:draw()

    love.graphics.setColor(0,127,0)
    Enemies.draw()
end


function love.draw()
    camera:draw(drawInCamera)

    if DEBUG then
        console:print()
    end
end