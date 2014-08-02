local enemyAI = require 'enemyai'
local Entity = require 'entity'


local Enemies = {}
Enemies.container = {}


function Enemies.newEnemy(x, y, mass)
    local e = {}

    e.type = 'enemy'

    e.entity = Entity.newCircle(mass, x, y, 0.25)
    e.entity.shape.radius = 0.25
    e.entity.shape.owner = e   -- used in collision callbacks

    e.alive = true
    e.health = 100

    e.speed = 2.5

    table.insert(Enemies.container, e)
end


function Enemies.createEnemies(n)
    local x1 = bounds.x1
    local x2 = bounds.x2
    local y1 = bounds.y1
    local y2 = bounds.y2

    for i = 1, n do
        local x = love.math.random(x1, x2)
        local y = love.math.random(y1, y2)
        Enemies.newEnemy(x, y, 80)
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
        e.entity:update(dt)

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
        local x, y = e.entity:getPosition():unpack()
        love.graphics.circle('fill', x, y, e.entity.shape.radius)
    end
end


return Enemies