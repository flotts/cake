cake = {}

cake.x = 400
cake.y = 300

cake.spd = 1000

function cake:load()
    self.body = love.physics.newBody(world.world, self.x, self.y, "dynamic")
    self.shape = love.physics.newRectangleShape(20, 20)
    self.fixture = love.physics.newFixture(self.body, self.shape, 5)
    self.fixture:setFriction(0.75)
end

function cake:update(dt)
    if love.keyboard.isDown("left") then
        self.body:applyForce(-self.spd, 0)
    elseif love.keyboard.isDown("right") then
        self.body:applyForce(self.spd, 0)
    end
end

function cake:draw()
    love.graphics.polygon("fill", self.body:getWorldPoints(self.shape:getPoints()))
end
