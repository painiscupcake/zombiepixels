local Weapon = {}
Weapon.__index = Weapon


function Weapon.new(wielder, wielderType, weaponParams)
    -- private method, custom weapon must redefine this

    -- takes a table with these keys:

        -- clipSize         - max ammo in clip
        -- damageRange      - table, min and max bullet damage
        -- reloadTime       - seconds, how long it takes to reload a weapon
        -- fireDelay        - delay between shots
        -- travelDistance   - how far bullets travel
        -- velocityRange    - min and max bullet velocity

        -- bulletsPerShot   - how many bullets spawn per shot

        -- minSpread        - min bullet spread (deg)
        -- spreadIncrease   - how much bullet spread increases with each shot (deg)
        -- spreadDecrease   - how much bullet spread decreases per second (deg)
        -- maxSpread        - max bullet spread (deg)

    local w = {}
    w.__index = w

    w.name = weaponParams.name

    -- a link to wielder object and it's faction/type
    w.wielder = wielder
    w.wielderType = wielderType

    -- full clip
    w.maxClip = weaponParams.clipSize
    w.currentClip = w.maxClip

    -- weapon reloading values
    w.reloadTime = weaponParams.reloadTime
    w.reloadCooldown = 0
    w.reloading = false

    -- bullet spread parameters (degrees)
    w.minSpread = weaponParams.minSpread
    w.maxSpread = weaponParams.maxSpread
    w.spreadIncrease = weaponParams.spreadIncrease
    w.spreadDecrease = weaponParams.spreadDecrease
    w.currentSpread = 0

    -- fire rate is a delay (seconds) between each bullet
    w.fireDelay = weaponParams.fireDelay
    w.fireCooldown = 0

    -- random damage for each bullet
    w.damageRange = weaponParams.damageRange

    -- bullets per shot
    w.bulletsPerShot = weaponParams.bulletsPerShot

    -- random velocity for each bullet
    w.velocityRange = weaponParams.velocityRange

    -- how far bullets travel
    w.travelDistance = weaponParams.travelDistance

    -- this variable allows usage of high fire rates
    -- if fire delay is lower than delay between frames
    -- this variable is multiplied by bulletsPerShot
    -- and used as an amount of bullets to spawn during shoot function call
    w.bulletsPerFrame = 1

    return setmetatable(w, Weapon)
end


function Weapon:canShoot()
    if self.fireCooldown > 0 or self.reloading or self.currentClip == 0 then
        return false
    else
        return true
    end
end


function Weapon:shoot(pos, target)
    -- kind of private method, handles delaying and ammo
    -- it must be called by a custom weapon's method 'shoot'

    if self:canShoot() then

        -- set params for bullet spawning
        local LOSDir = (target - pos):normalized()   -- LOS - line of sight
        local LOSAngle = LOSDir:getAngle()

        -- decrease ammo in clip
        local bulletsToShoot = math.min(self.bulletsPerFrame, self.bulletsPerFrame+self.currentClip-self.bulletsPerFrame)
        self.currentClip = self.currentClip - bulletsToShoot

        for i = 1, self.bulletsPerShot * bulletsToShoot do
            -- generate random angle for current bullet
            -- shotAngleOffset < [-self.currentSpread/2, +self.currentSpread/2]
            local shotAngleOffset = love.math.random() * self.currentSpread - self.currentSpread / 2
            local shotAngle = LOSAngle + (shotAngleOffset / 180 * math.pi)  -- convert from deg to rad
            local shotDir = Vector.new(math.cos(shotAngle), math.sin(shotAngle))

            local scalarVel = love.math.random(unpack(self.velocityRange))
            local bulletVelocity = shotDir * scalarVel

            -- spawn bullet
            projectiles.newProjectile(
                self.wielderType,
                pos,
                bulletVelocity,
                self.travelDistance,
                love.math.random(unpack(self.damageRange))
            )

        end

        -- delay next shot
        self.fireCooldown = self.fireCooldown + self.fireDelay

        -- increase bullet spread
        self.currentSpread = self.currentSpread + self.spreadIncrease

    elseif self.currentClip == 0 then
        -- if current clip is empty, reload
        self:reload()
    end
end


function Weapon:reload()
    if not self.reloading and self.currentClip < self.maxClip then
        self.reloading = true
        self.reloadCooldown = self.reloadTime
    end
end


function Weapon:getReloadTimeLeft() -- visualize reloading with this
    return self.reloadCooldown
end


function Weapon:update(dt)
    -- update cooldown values
    self.fireCooldown = math.max(self.fireCooldown - dt, 0)
    self.reloadCooldown = math.max(self.reloadCooldown - dt, 0)

    -- update bullets per frame variable
    self.bulletsPerFrame = math.floor(dt / self.fireDelay)
    if self.bulletsPerFrame == 0 then self.bulletsPerFrame = 1 end

    -- handle reloading finish
    if self.reloading and self.reloadCooldown == 0 then
        self.currentClip = self.maxClip
        self.reloading = false
    end

    -- update bullet spread values
    self.currentSpread = math.min(self.currentSpread, self.maxSpread)
    self.currentSpread = self.currentSpread - self.spreadDecrease * dt
    self.currentSpread = math.max(self.currentSpread, self.minSpread)

    -- log string
    local s = 
        'Player Weapon:\n'..
        'fireCooldown: %.2f\n'..
        'bulletsPerFrame: %i\n'..
        'reloadCooldown: %.2f\n'..
        'reloading: %s\n'..
        'currentClip: %i\n'..
        'currentSpread: %.2f <= %.2f <= %.2f\n'
    s = s:format(self.fireCooldown, self.bulletsPerFrame, self.reloadCooldown, tostring(self.reloading),
                 self.currentClip, self.minSpread, self.currentSpread, self.maxSpread)
    console:log(s)
end


local WeaponFactory = {}
WeaponFactory.__index = WeaponFactory


function WeaponFactory.newWeaponFactory(weaponParams)
    local wf = {}
    wf.weaponParams = weaponParams

    return setmetatable(wf, WeaponFactory)
end


function WeaponFactory:new(wielder, wielderType)
    return Weapon.new(wielder, wielderType, self.weaponParams)
end


return WeaponFactory