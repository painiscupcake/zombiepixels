local Collider = {}


function Collider.setBounds(xmin, xmax, ymin, ymax)
    Collider.bounds = {xmin,xmax,ymin,ymax}
end


-- checks if an object is in bounds and corrects its position if necessary
function Collider.keepInBounds(o)
    if Collider.bounds then
        local r = o.radius
        local xmin,xmax,ymin,ymax = unpack(Collider.bounds)
        local x,y = o.position:unpack()

        -- x axis
        if x <= xmin + r then x = xmin + r end
        if x >= xmax - r then x = xmax - r end

        -- y axis
        if y <= ymin + r then y = ymin + r end
        if y >= ymax - r then y = ymax - r end

        -- update position
        o.position.x = x
        o.position.y = y
    end
end


-- checks whether an object is in bounds and returns an appropriate boolean value
function Collider.isInBounds(o)
    if Collider.bounds then
        local r = o.radius
        local xmin,xmax,ymin,ymax = unpack(Collider.bounds)
        local x,y = o.position:unpack()

        -- x axis
        if x <= xmin + r or x >= xmax - r then return false end

        -- y axis
        if y <= ymin + r or y >= ymax + r then return false end

        return true
    else
        return true
    end
end


-- little function that checks if two circles are touching
-- takes 2 objects with fields: position (vector), radius (number)
local function areTouching(a, b)
    if (a.position - b.position):len() <= a.radius + b.radius then
        return true
    else
        return false
    end
end


-- takes two circles and, assuming they are colliding, separates then
-- they separate evenly
-- non-colliding circles only
local function separateEnemies(a, b)
    local diffvec = b.position - a.position
    if diffvec:len() > 0 then
        local dp = diffvec:normalized()
        local dpmag = ((a.radius + b.radius) - diffvec:len()) / 2

        a.position = a.position - dp * dpmag / 2
        b.position = b.position + dp * dpmag / 2
    end
end


-- same as above
-- however, first arg stays in place and second arg is pushed away from first
local function separatePlayerAndEnemy(p, e)
    local diffvec = e.position - p.position
    if diffvec:len() > 0 then
        local dp = diffvec:normalized()
        local dpmag = ((p.radius + e.radius) - diffvec:len()) / 2

        e.position = e.position + dp * dpmag
    end
end


-- this function is tied on global variables such as
-- player, enemies, projectiles
-- this function checks collisions between:
--  enemy projectiles and players
--  player projectiles and enemies
--  players and enemies (melee) (must change the way this works)
--  enemies and enemies (just collision)
function Collider.resolveCollisions(dt)
    -- enemy projectiles and player
    for _, p in ipairs(projectiles.enemyContainer) do
        if areTouching(p, player) then
            player.health = player.health - p.damage
            p.alive = false
        end
    end

    -- player projectiles and enemies
    for _, p in ipairs(projectiles.playerContainer) do
        for _, e in ipairs(enemies.container) do
            if areTouching(p, e) then
                e.health = e.health - p.damage
                p.alive = false
            end
        end
    end

    -- player and enemies (melee)
    for _, e in ipairs(enemies.container) do
        if areTouching(player, e) then
            separatePlayerAndEnemy(player, e)
            player.health = player.health - e.damage * dt
            e.health = e.health - player.damage * dt
        end
    end

    -- enemies and enemies
    for _, a in ipairs(enemies.container) do
        for _, b in ipairs(enemies.container) do
            if a ~= b and areTouching(a, b) then
                separateEnemies(a, b)
            end
        end
    end
end


return Collider