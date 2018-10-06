world = {}

-- table for love.physics objects
world.arena = {}

world.gravity = {
    x = 0,
    y = 500
}

function world:load()
    self.world = love.physics.newWorld(self.gravity.x, self.gravity.y)

    world:newArenaStructure("floor", 0, 200, 500, 10)
    world:newArenaStructure("leftWall", -200, 0, 10, 500)
    world:newArenaStructure("rightWall", 200, 0, 10, 500)
    world:newArenaStructure("ceiling", 0, -200, 500, 10)

    -- Loading background image: 
    background = love.graphics.newImage("/assets/wallpaper.png")
end

function world:newArenaStructure(id, x, y, w, h)
    self.arena[id] = {}
    self.arena[id].body = love.physics.newBody(self.world, x, y)
    self.arena[id].shape = love.physics.newRectangleShape(w, h)
    self.arena[id].fixture = love.physics.newFixture(self.arena[id].body, self.arena[id].shape)
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

    love.graphics.polygon("fill", self.arena.floor.body:getWorldPoints(self.arena.floor.shape:getPoints()))
    love.graphics.polygon("fill", self.arena.leftWall.body:getWorldPoints(self.arena.leftWall.shape:getPoints()))
    love.graphics.polygon("fill", self.arena.rightWall.body:getWorldPoints(self.arena.rightWall.shape:getPoints()))
    love.graphics.polygon("fill", self.arena.ceiling.body:getWorldPoints(self.arena.ceiling.shape:getPoints()))

    
end
