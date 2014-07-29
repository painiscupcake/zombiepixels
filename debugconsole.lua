local Console = {}
Console.__index = Console


function Console.new()
    local c = {}
    c.messages = {}
    c.font = love.graphics.newFont(12)
    c.color = {200,200,200}

    return setmetatable(c, Console)
end


--[[
function Console.load()
    Console.font = love.graphics.newFont(12)
    Console.color = {200,200,200}
end
--]]


function Console:log(message)
    table.insert(self.messages, message)
end


function Console:clear()
    self.messages = {}
end


local function countLines(s)
    local count = 1
    for i in s:gmatch('\n') do count = count + 1 end
    return count
end


function Console:print()
    -- save current font and color
    local tmpfont = love.graphics.getFont()
    local tmpcolor = {love.graphics.getColor()}

    -- use font and color specific for console
    love.graphics.setFont(self.font)
    love.graphics.setColor(self.color)

    -- print messages
    local y = 0
    local fontHeight = self.font:getHeight()
    for _, message in ipairs(self.messages) do
        love.graphics.print(message, 0, y)
        y = y + fontHeight * countLines(message)
    end

    -- clear messages
    self:clear()

    -- restore original font and color
    love.graphics.setFont(tmpfont)
    love.graphics.setColor(tmpcolor)
end


return Console