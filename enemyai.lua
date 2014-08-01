local enemyAI = {}


function enemyAI.updateEnemy(e)
    local v = (player.entity.position - e.entity.position):normalized() * 50
    e.velocity = v
end


return enemyAI