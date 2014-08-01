Vector  = require 'hump.vector'
Class   = require 'hump.class'

Collider    = require 'collider'

Entity          = require 'entity'
EntityUpdater   = require 'entityupdater'

Player              = require 'player'
Enemies             = require 'enemies'
ProjectileLibrary   = require 'projectile_library'
WeaponLibrary       = require 'weapon_library'

Camera  = require 'gamera'
Tracer  = require 'tracer'

Console    = require 'debugconsole'


DEBUG = true


function love.load()
    METER = 64  -- useful for scaling while drawing
    Collider.init(METER)
    -- everything below in this function is temporary

    -- some variables
    windowWidth, windowHeight = love.window.getDimensions()

    -- get console
    console = Console.new()

    -- set camera
    camera = Camera.new(0,0,windowWidth,windowHeight)


    -- create player and set axis speeds
    player = Player.new(windowWidth/2, windowHeight/2)
    playerXVelocity = Vector(100, 0)
    playerYVelocity = Vector(0, 100)

    -- create some Enemies
    Enemies.createEnemies(10)

    --EntityUpdater.addEntity(player)
end


function love.update(dt)
    console:log(('FPS: %i'):format(love.timer.getFPS()))

    Collider:update(dt)

    --EntityUpdater.update(dt)
    player:update(dt)

    if love.mouse.isDown('l') then
        player:useWeapon()
    end

    Enemies.update(dt)
    --Projectiles.update(dt)
end


function love.keypressed(key)
    if key == 'escape' then
        love.event.push('quit')
    end

    if key == '`' then
        DEBUG = not DEBUG
    end

    if key == 'r' then
        player:reloadWeapon()
    end

    if key == 'n' then
        Enemies.createEnemies(10)
    end


    -- player controls:
    if key == 'w' then
        player:applyVelocity(-playerYVelocity)
    elseif key == 's' then
        player:applyVelocity(playerYVelocity)
    end

    if key == 'a' then
        player:applyVelocity(-playerXVelocity)
    elseif key == 'd' then
        player:applyVelocity(playerXVelocity)
    end
end


function love.keyreleased(key)
    -- player controls:
    if key == 'w' then
        player:applyVelocity(playerYVelocity)
    elseif key == 's' then
        player:applyVelocity(-playerYVelocity)
    end

    if key == 'a' then
        player:applyVelocity(playerXVelocity)
    elseif key == 'd' then
        player:applyVelocity(-playerXVelocity)
    end
end


function love.mousepressed(x, y, button)

end


function love.draw()
    -- draw player
    love.graphics.setColor(255,255,255)
    player:draw()

    -- draw Enemies
    love.graphics.setColor(0,175,0)
    Enemies.draw()

    -- draw Projectiles
    --Projectiles.draw()


    if DEBUG then
        console:print()
    end
end