local enemyAI = {}


function enemyAI.updateEnemy(e)
    local v = (player.position - e.position):normalize() * 50
    e.velocity = v
end


return enemyAI