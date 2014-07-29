local json = require 'dkjson'


-- this code loads all weapons listed in weaponlist.txt and returns weapon database

-- keys that are available in json:

    -- clipSize       - max ammo in clip
    -- damageRange    - table, min and max bullet damage
    -- reloadTime     - seconds, how long it takes to reload a weapon
    -- fireDelay      - delay between shots
    -- travelDistance - how far bullets travel
    -- velocityRange  - min and max bullet velocity

    -- bulletsPerShot   - how many bullets spawn per shot

    -- minSpread        - min bullet spread (deg)
    -- maxSpread        - max bullet spread (deg)
    -- spreadIncrease   - how much bullet spread increases with each shot (deg)
    -- spreadDecrease   - how much bullet spread decreases per second (deg)


WeaponParamsReference = {
    'clipSize',
    'damageRange',
    'reloadTime',
    'fireDelay',
    'travelDistance',
    'velocityRange',
    'bulletsPerShot',
    'minSpread',
    'maxSpread',
    'spreadIncrease',
    'spreadDecrease'
}


local function correctWeaponParams(t, reference)
    -- takes a table with weapon params
    -- checks if all keys are present
    -- on success, returns true
    -- on failure, returns false, error string



    local errstr = '\t%s\n'
    local errcount = 0

    local errors = 'Missing keys:\n'
    for _, k in ipairs(reference) do
        if not t[k] then
            errors = errors .. errstr:format(k)
            errcount = errcount + 1
        end
    end

    if errcount > 0 then
        errors = errors .. ('Total: %i\n'):format(errcount)
        return false, errors
    else
        return true
    end
end


local WeaponList = {}
local weaponNameList = {}
local fileContents, size = love.filesystem.read('weaponlist/weaponlist.txt')

print(('Reading weaponlist.txt: %i bytes read.'):format(size))

if not fileContents then
    error('No weaponlist.txt present!')
end

-- read weapon list to determine which files to load
for weaponName in fileContents:gmatch('[^\n]+') do
    -- load weapon file and read it into string
    local filepath = 'weaponlist/' .. weaponName .. '.json'
    local ws, size = love.filesystem.read(filepath)
    print(('Reading %s: %i bytes.'):format(filepath, size))

    if ws then
        -- decode string and add the weapon to the weapon list
        local weaponParams, _, jsonerr = json.decode(ws)
        local correctTable, keyserr = correctWeaponParams(weaponParams, WeaponParamsReference)

        -- handle errors
        if jsonerr then
            print(jsonerr)

        elseif not correctTable then
            print(weaponName .. ':\n' .. keyserr)

        else
            local wfac = WeaponFactory.newWeaponFactory(weaponParams)
            WeaponList[weaponName] = wfac
        end
    else
        print("No such file 'pistol.json' exists!")
    end
end


return WeaponList