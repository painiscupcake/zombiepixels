Vector          = require 'vec'
Collider        = require 'collisions'
Player          = require 'player'
enemies         = require 'enemies'
projectiles     = require 'projectiles'
Camera          = require 'gamera'
WeaponFactory   = require 'weapons'
WeaponList      = require 'weaponlist'
Tracer          = require 'tracer'

Console         = require 'debugconsole'

-- set some new handy global functions
require 'stdext'


DEBUG = true


function love.load()
    -- this function contents are temporary

    -- some variables
    windowWidth, windowHeight = love.window.getDimensions()

    -- set world bounds
    Collider.setBounds(0, windowWidth, 0, windowHeight)

    -- get console
    console = Console.new()

    -- set camera
    camera = Camera.new(0,0,windowWidth,windowHeight)


    -- player hotbar [1-9]
    playerHotbar = {}
    playerHotbar[1] = WeaponList['pistol']:new(player, 'player')
    playerHotbar[2] = WeaponList['shotgun']:new(player, 'player')
    playerHotbar[3] = WeaponList['sawnoffshotgun']:new(player, 'player')
    playerHotbar[4] = WeaponList['minigun']:new(player, 'player')
    playerHotbar[5] = WeaponList['opwallofbullets']:new(player, 'player')


    -- create player and set axis speeds
    player = Player.new(windowWidth/2, windowHeight/2)
    player:setWeapon(playerHotbar[1])
    playerXVelocity = Vector(100, 0)
    playerYVelocity = Vector(0, 100)

    -- create some enemies
    enemies.createEnemies(10)
end


function love.update(dt)
    console:log(('FPS: %i'):format(love.timer.getFPS()))

    Collider.resolveCollisions(dt)

    player:update(dt)

    if love.mouse.isDown('l') then
        player:useWeapon()
    end

    enemies.update(dt)
    projectiles.update(dt)
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
        enemies.createEnemies(10)
    end


    -- player hotbar manipulations
    local numkey = tonumber(key)
    if numkey then
        player:setWeapon(playerHotbar[numkey])
    end


    -- player controls:
    if key == 'w' then
        player:addVelocity(-playerYVelocity)
    elseif key == 's' then
        player:addVelocity(playerYVelocity)
    end

    if key == 'a' then
        player:addVelocity(-playerXVelocity)
    elseif key == 'd' then
        player:addVelocity(playerXVelocity)
    end
end


function love.keyreleased(key)
    -- player controls:
    if key == 'w' then
        player:addVelocity(playerYVelocity)
    elseif key == 's' then
        player:addVelocity(-playerYVelocity)
    end

    if key == 'a' then
        player:addVelocity(playerXVelocity)
    elseif key == 'd' then
        player:addVelocity(-playerXVelocity)
    end
end


function love.mousepressed(x, y, button)

end


function love.draw()
    -- draw player
    love.graphics.setColor(255,255,255)
    player:draw()

    -- draw enemies
    love.graphics.setColor(0,175,0)
    enemies.draw()

    -- draw projectiles
    projectiles.draw()


    if DEBUG then
        console:print()
    end
end