-- updater system for entities
-- takes entity to add it to it's own container
-- calls entity:update(dt) on every entity in it's list automatically
-- call EntityUpdater.update(dt) every frame to update entities


local EntityUpdater = {}
EntityUpdater.container = {}


function EntityUpdater.addEntity(e)
    table.insert(EntityUpdater, e)
end


function EntityUpdater.update(dt)
    local newContainer = {}
    for _, e in ipairs(EntityUpdater.container) do
        if not e.markedForRemoval then
            e:update(dt)
            table.insert(e, newContainer)
        end
    end

    EntityUpdater.container = newContainer
end


return EntityUpdater