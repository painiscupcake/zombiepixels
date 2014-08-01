local enemyAI = require 'enemyai'


local Enemies = {}
Enemies.container = {}


function Enemies.newEnemy(x, y, mass)
    local e = {}
    e.entity = Entity.newCircle(mass, Vector(x,y), 10)
    e.entity.type = 'enemy'
    e.entity.shape.entity = e   -- used in collision callbacks

    e.alive = true
    e.health = 100
    e.damage = 5

    e.currentWeapon = nil

    table.insert(Enemies.container, e)
end


function Enemies.createEnemies(n)
    local windowWidth, windowHeight = love.window.getDimensions()
    for i = 1, n do
        local x = love.math.random(0, windowWidth)
        local y = love.math.random(0, windowHeight)
        Enemies.newEnemy(x, y)
    end
end


function Enemies.behave()
    for _, e in ipairs(Enemies.container) do
        enemyAI.updateEnemy(e)
    end
end


function Enemies.update(dt)
    Enemies.behave()

    -- put updated enemies in new container
    local newContainer = {}
    for _, e in ipairs(Enemies.container) do
        e.entity.position = e.entity.position + e.velocity * dt

        if e.health <= 0 then
            e.alive = false
        end

        -- filter out dead enemies
        if e.alive then
            table.insert(newContainer, e)
        end 
    end

    Enemies.container = newContainer

    console:log(('Enemies:\namount: %i\n'):format(#Enemies.container))
end


function Enemies.draw()
    for _, e in ipairs(Enemies.container) do
        local x, y = e.entity.position:unpack()
        love.graphics.circle('fill', x, y, e.entity.radius)
    end
end


return Enemies