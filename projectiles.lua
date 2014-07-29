local Projectiles = {}
Projectiles.playerContainer = {}
Projectiles.enemyContainer = {}


function Projectiles.newProjectile(projectileType, position, velocity, maxTravelDistance, damage)
    -- projectile types: 'player', 'enemy'

    local p = {}
    p.position = position
    p.velocity = velocity
    p.distance = maxTravelDistance  -- distance left to travel
    p.radius = 1
    p.damage = damage
    p.alive = true

    p.color = {255,127,0}

    p.tracer = Tracer.new(position, position, velocity:length()/100, {255,255,0})

    if projectileType == 'player' then
        table.insert(Projectiles.playerContainer, p)
    elseif projectileType == 'enemy' then
        table.insert(Projectiles.enemyContainer, p)
    else
        error('Invalid projectile type!')
    end
end


local function updateProjectile(p, dt)
    -- update projectile position
    displacement = p.velocity * dt
    p.position = p.position + displacement
    p.distance = p.distance - displacement:length()

    -- update tracer end position
    p.tracer:updatePos(p.position)

    if not Collider.isInBounds(p) then
        p.alive = false
    end

    if p.distance <= 0 then
        p.alive = false
    end

    -- filter out "dead" projectiles - 
    -- those with expired lifespan
    -- or collided with something etc.
    if p.alive then
        return p
    end
end


function Projectiles.update(dt)
    -- update player projectiles
    local newPlayerContainer = {}
    for _, p in ipairs(Projectiles.playerContainer) do
        p = updateProjectile(p, dt)
        if p then
            table.insert(newPlayerContainer, p)
        end
    end
    Projectiles.playerContainer = newPlayerContainer


    -- update enemy projectiles
    local newEnemyContainer = {}
    for _, p in ipairs(Projectiles.enemyContainer) do
        p = updateProjectile(p, dt)
        if p then
            table.insert(newEnemyContainer, p)
        end
    end
    Projectiles.enemyContainer = newEnemyContainer


    console:log(('Projectiles:\nplayer amt: %i\nenemy amt: %i\n'):format(#Projectiles.playerContainer, #Projectiles.enemyContainer))
end


function Projectiles.draw()
    -- draw player projectiles
    for _, p in ipairs(Projectiles.playerContainer) do
        p.tracer:draw()
        love.graphics.setColor(p.color)
        love.graphics.circle('fill', p.position.x, p.position.y, p.radius)
    end

    -- draw enemy projectiles
    for _, p in ipairs(Projectiles.enemyContainer) do
        p.tracer:draw()
        love.graphics.setColor(p.color)
        love.graphics.circle('fill', p.position.x, p.position.y, p.radius)
    end
end


return Projectiles