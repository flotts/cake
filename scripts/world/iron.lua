iron = {}
iron.blocks = {}

function iron:load()
    iron.spr = love.graphics.newImage("/assets/iron.png")
    
    iron:new(0, 15, 31, 1)
    iron:new(-15, 0, 1, 31)
    iron:new(15, 0, 1, 31)
    iron:new(0, -15, 31, 1)
    -- Starting block
    iron:new(0,3, 4, 2)
    iron:new(10,-5, 2, 10)
    iron:new(7, 10, 3, 2)
    iron:new(-9, 10, 3, 4)
    iron:new(-9, -10, 1, 4)
    iron:new(-11, -3, 1, 6)
end

function iron:new(x, y, w, h)
    x = x * 16
    y = y * 16
    w = w * 16
    h = h * 16
    local structure = {}
    structure.body = love.physics.newBody(world.world, x, y)
    structure.shape = love.physics.newRectangleShape(w, h)
    structure.fixture = love.physics.newFixture(structure.body, structure.shape)
    structure.y = y
    structure.x = x
    structure.w = w
    structure.h = h
    structure.fixture:setUserData("iron")
    
    table.insert(self.blocks, structure)
end

function iron:update(dt)

end

function iron:draw()
    -- Tiling solid blocks: 
    for i in ipairs(self.blocks) do
        -- *Start calculates the top right corner of the box
        local xStart = self.blocks[i].x - (self.blocks[i].w / 2)
        local yStart = self.blocks[i].y - (self.blocks[i].h / 2)

        -- These will be used to iterate through the width and height in increments of 16
        local widthRemaining = self.blocks[i].w

        -- We'll subtract 16 from widthRemaining until it's 0
        while widthRemaining > 0 do
            local xVal = xStart + self.blocks[i].w - widthRemaining
            local heightRemaining = self.blocks[i].h

            while heightRemaining > 0 do
                local yVal = yStart + self.blocks[i].h - heightRemaining
                love.graphics.draw(self.spr, xVal, yVal, 0, 1, 1)
                heightRemaining = heightRemaining - 16
            end

            widthRemaining = widthRemaining - 16
        end

        love.graphics.draw(self.spr, xStart, yStart, 0, 1, 1)
    end
end
