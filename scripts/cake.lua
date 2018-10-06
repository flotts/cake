cake = {}

cake.x = 400
cake.y = 300
cake.xVel = 0
cake.yVel = 0

cake.spd = 100
cake.weight = 1000

function cake:load()
    self.body = love.physics.newBody(world.world, self.x, self.y, "dynamic")
    self.shape = love.physics.newRectangleShape(20, 20)
    self.fixture = love.physics.newFixture(self.body, self.shape, 5)
    self.fixture:setFriction(0.75)

    standSprite = love.graphics.newImage("/assets/cake_standing_1.png")
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
    self.x = self.body:getX()
    self.y = self.body:getY()
    self.xVel, self.yVel = self.body:getLinearVelocity()
    if love.keyboard.isDown("left") then
        self.body:setLinearVelocity(-self.spd, self.yVel)
    elseif love.keyboard.isDown("right") then
        self.body:setLinearVelocity(self.spd, self.yVel)
    else 
        self.body:setLinearVelocity(0, self.yVel)
    end
end

function cake:draw()
    -- love.graphics.setColor(1, 0, 0)
    -- love.graphics.polygon("fill", self.body:getWorldPoints(self.shape:getPoints()))
    love.graphics.draw(standSprite, self.x - 8, self.y - 8)
end
