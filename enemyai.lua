local enemyAI = {}


function enemyAI.updateEnemy(e)
    local v = (player.entity:getPosition() - e.entity:getPosition()):normalized() * e.speed
    e.entity:setVelocity(v)
end


return enemyAI