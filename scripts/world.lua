world = {}

-- table for love.physics objects
world.arena = {}

world.gravity = {
    x = 0,
    y = 500
}

function world:load()
    self.world = love.physics.newWorld(self.gravity.x, self.gravity.y)

    world:newArenaStructure(0, 200, 500, 16)
    world:newArenaStructure(-200, 0, 16, 500)
    world:newArenaStructure(200, 0, 16, 500)
    world:newArenaStructure(0, -200, 500, 16)

    -- Loading images: 
    background = love.graphics.newImage("/assets/wallpaper.png")
    blockSprite = love.graphics.newImage("/assets/iron_block.png")
end

-- To use this function, blocks' height and width should be divisible by 16!!
function world:newArenaStructure(x, y, w, h)
    local myStruct = {}
    myStruct.body = love.physics.newBody(self.world, x, y)
    myStruct.shape = love.physics.newRectangleShape(w, h)
    myStruct.fixture = love.physics.newFixture(myStruct.body, myStruct.shape)
    myStruct.y = y
    myStruct.x = x
    myStruct.width = w
    myStruct.height = h
    table.insert(self.arena, myStruct)
end

function world:update(dt)
    self.world:update(dt)
end

function world:draw()
    -- Tiling background wallpaper:
    for i = 0, love.graphics.getWidth() / background:getWidth() do
        for j = 0, love.graphics.getHeight() / background:getHeight() do
            love.graphics.draw(background, (i * background:getWidth()) - worldTranslation.x, (j * background:getHeight()) - worldTranslation.y)
        end
    end

    for i in ipairs(self.arena) do
        love.graphics.polygon("fill", self.arena[i].body:getWorldPoints(self.arena[i].shape:getPoints()))
        local xStart = self.arena[i].x - (self.arena[i].width / 2)
        local yStart = self.arena[i].y - (self.arena[i].height / 2)
        local widthRemaining = self.arena[i].width
        local heightRemaining = self.arena[i].height

        -- while a[i] do
        --     print(a[i])
        --     i = i + 1
        -- end

        love.graphics.draw(blockSprite, xStart, yStart, 0, 1, 1)
    end
    
end
