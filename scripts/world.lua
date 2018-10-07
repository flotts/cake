world = {}

-- table for love.physics objects
world.arena = {
    ironBlocks = {},
    dirtBlocks = {}
}

world.gravity = {
    x = 0,
    y = 500
}

function world:load()
    self.world = love.physics.newWorld(self.gravity.x, self.gravity.y)

    world:newArenaStructure(0, 15, 31, 1)
    world:newArenaStructure(-15, 0, 1, 31)
    world:newArenaStructure(15, 0, 1, 31)
    world:newArenaStructure(0, -15, 31, 1)

    world:newArenaStructure(7, 10, 3, 2)

    world:newBreakableStructure(4, 4)

    -- Loading images: 
    background = love.graphics.newImage("/assets/wallpaper.png")
    ironBlockSprite = love.graphics.newImage("/assets/iron_block.png")
    dirtBlockSprite = love.graphics.newImage("/assets/dirt_block.png")
end

-- To use this function, blocks' height and width should be divisible by 16!!
function world:newArenaStructure(x, y, w, h)
    x = x * 16
    y = y * 16
    w = w * 16
    h = h * 16
    local myStruct = {}
    myStruct.body = love.physics.newBody(self.world, x, y)
    myStruct.shape = love.physics.newRectangleShape(w, h)
    myStruct.fixture = love.physics.newFixture(myStruct.body, myStruct.shape)
    myStruct.y = y
    myStruct.x = x
    myStruct.width = w
    myStruct.height = h
    table.insert(self.arena.ironBlocks, myStruct)
end

function world:newBreakableStructure(x, y)
    x = x * 16
    y = y * 16
    local w = 16
    local h = 16
    local myStruct = {}
    myStruct.body = love.physics.newBody(self.world, x, y)
    myStruct.shape = love.physics.newRectangleShape(w, h)
    myStruct.fixture = love.physics.newFixture(myStruct.body, myStruct.shape)
    myStruct.y = y
    myStruct.x = x
    myStruct.width = w
    myStruct.height = h
    table.insert(self.arena.dirtBlocks, myStruct)
end

function world:update(dt)
    self.world:update(dt)

    -- todo: add breakability to breakable blocks
end

function world:draw()
    -- Tiling background wallpaper:
    for i = 0, love.graphics.getWidth() / background:getWidth() do
        for j = 0, love.graphics.getHeight() / background:getHeight() do
            love.graphics.draw(background, (i * background:getWidth()) - worldTranslation.x, (j * background:getHeight()) - worldTranslation.y)
        end
    end

    -- Tiling solid blocks: 
    for i in ipairs(self.arena.ironBlocks) do
        -- Adding white background, for debugging:
    -- love.graphics.polygon("fill", self.arena[i].body:getWorldPoints(self.arena[i].shape:getPoints()))
        -- xStart calculates the top right corner of the box
        local xStart = self.arena.ironBlocks[i].x - (self.arena.ironBlocks[i].width / 2)
        local yStart = self.arena.ironBlocks[i].y - (self.arena.ironBlocks[i].height / 2)
        -- These will be used to iterate through the width and height in increments of 16
        local widthRemaining = self.arena.ironBlocks[i].width

        -- We'll subtract 16 from widthRemaining until it's 0
        while widthRemaining > 0 do
            local xVal = xStart + self.arena.ironBlocks[i].width - widthRemaining
            local heightRemaining = self.arena.ironBlocks[i].height

            while heightRemaining > 0 do
                local yVal = yStart + self.arena.ironBlocks[i].height - heightRemaining
                love.graphics.draw(ironBlockSprite, xVal, yVal, 0, 1, 1)
                heightRemaining = heightRemaining - 16
            end
            widthRemaining = widthRemaining - 16
        end

        love.graphics.draw(ironBlockSprite, xStart, yStart, 0, 1, 1)
    end
    
    for i in ipairs(self.arena.dirtBlocks) do
        love.graphics.polygon("fill", self.arena.dirtBlocks[i].body:getWorldPoints(self.arena.dirtBlocks[i].shape:getPoints()))
        local xStart = self.arena.dirtBlocks[i].x - (self.arena.dirtBlocks[i].width / 2)
        local yStart = self.arena.dirtBlocks[i].y - (self.arena.dirtBlocks[i].height / 2)
        love.graphics.draw(dirtBlockSprite, xStart, yStart, 0, 1, 1)
    end
end
