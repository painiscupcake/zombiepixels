local enemyAI = require 'enemyai'


local Enemies = {}
Enemies.container = {}


function Enemies.newEnemy(x, y)
    local e = {}
    e.position = Vector(x, y)
    e.velocity = Vector()
    e.radius = 10
    e.health = 100
    e.damage = 5
    e.alive = true

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
        e.position = e.position + e.velocity * dt
        Collider.keepInBounds(e)

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
        love.graphics.circle('fill', e.position.x, e.position.y, e.radius)
    end
end


return Enemies