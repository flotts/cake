cake = {}

cake.x = 0
cake.y = 0

cake.spd = 1000

function cake:load()
    self.body = love.physics.newBody(world.world, self.x, self.y, "dynamic")
    self.shape = love.physics.newRectangleShape(20, 20)
    self.fixture = love.physics.newFixture(self.body, self.shape, 5)
    self.fixture:setFriction(0.75)
end

function cake:keyPressed(key)
    if key == "space" then
        self.body:applyLinearImpulse(0, -500)
    elseif key == "a" then
        self:rotate("left")
    elseif key == "d" then
        self:rotate("right")
    end
end

function cake:update(dt)
    if love.keyboard.isDown("left") then
        self.body:applyForce(-self.spd, 0)
    elseif love.keyboard.isDown("right") then
        self.body:applyForce(self.spd, 0)
    end
end

function cake:draw()

end
