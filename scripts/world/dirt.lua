dirt = {}
dirt.blocks = {}

-- todo: add breakability to breakable blocks
function dirt:load()
    dirt.spr = love.graphics.newImage("/assets/dirt.png")

    dirt:new(-2, -2)
    dirt:new(4, 4)
    dirt:new(-5, -10)
    dirt:new(5, -9)
    dirt:new(-3, 9)
    dirt:new(12, 3)

    dirt:new(4,2,0)
end

function dirt:new(x, y)
    x = x * 16
    y = y * 16
    w = 16
    h = 16
    local structure = {}
    structure.body = love.physics.newBody(world.world, x, y)
    structure.shape = love.physics.newRectangleShape(w, h)
    structure.fixture = love.physics.newFixture(structure.body, structure.shape)
    structure.y = y
    structure.x = x
    structure.w = w
    structure.h = h
    structure.fixture:setUserData("dirt")

    table.insert(self.blocks, structure)
end

function dirt:update(dt)

end

function dirt:draw()
    for i in ipairs(self.blocks) do
        love.graphics.polygon("fill", self.blocks[i].body:getWorldPoints(self.blocks[i].shape:getPoints()))
        local xStart = self.blocks[i].x - (self.blocks[i].w / 2)
        local yStart = self.blocks[i].y - (self.blocks[i].h / 2)
        love.graphics.draw(self.spr, xStart, yStart, 0, 1, 1)
    end
end
