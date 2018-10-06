world = {}

-- table for love.physics objects
world.arena = {}

world.gravity = {
    x = 0,
    y = 500
}

function world:load()
    self.world = love.physics.newWorld(self.gravity.x, self.gravity.y)

    -- platform
    world:newArenaStructure("floor", 0, 200, 500, 10)
    world:newArenaStructure("leftWall", -200, 0, 10, 500)
    world:newArenaStructure("rightWall", 200, 0, 10, 500)
    world:newArenaStructure("ceiling", 0, -200, 500, 10)
end

function world:newArenaStructure(id, x, y, w, h)
    self.arena.id = {}
    self.arena.id.body = love.physics.newBody(self.world, x, y)
    self.arena.id.shape = love.physics.newRectangleShape(w, h)
    self.arena.id.fixture = love.physics.newFixture(self.arena.id.body, self.arena.id.shape)
end

function world:update(dt)
    self.world:update(dt)
end

function world:draw()
    for _, body in pairs(self.world:getBodies()) do
        for _, fixture in pairs(body:getFixtures()) do
            local shape = fixture:getShape()
            love.graphics.polygon("fill", body:getWorldPoints(shape:getPoints()))
        end
    end
end
