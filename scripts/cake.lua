cake = {}

-- X and Y coords
cake.x = 0
cake.y = 0
-- X and Y vel
cake.xVel = 0
cake.yVel = 0

-- Walk speed
cake.spd = 100
-- Gravity
cake.weight = 1000

cake.state = "stand"            -- stand or run
cake.hasFallen = false          -- Used to help indicate whether Cake can jump

-- Variables used to keep track of which way Cake is facing
local mirror = 1                -- -1 for normal, 1 for mirrored
local spriteXTranslate = -8     -- Set to 8 to mirror image (shifting it 16)

local runFrames = {}
local activeRunFrame            -- Stores the actual data of the frame location
local currentRunFrame = 1       -- stores which frame is currently displayed (1-4)

local elapsedTime = 0

function cake:load()
    -- Setting up our collision box:
    self.body = love.physics.newBody(world.world, self.x, self.y, "dynamic")
    self.shape = love.physics.newRectangleShape(20, 20)
    self.fixture = love.physics.newFixture(self.body, self.shape, 5)
    self.fixture:setFriction(0.75)

    -- setting up sprite:
    standSprite = love.graphics.newImage("/assets/cake_standing_1.png")

    walkSpriteSheet = love.graphics.newImage("/assets/cake_running_1.png")
    runFrames[1] = love.graphics.newQuad(0,0,16,16,walkSpriteSheet:getDimensions())
    runFrames[2] = love.graphics.newQuad(16,0,16,16,walkSpriteSheet:getDimensions())
    runFrames[3] = love.graphics.newQuad(32,0,16,16,walkSpriteSheet:getDimensions())
    runFrames[4] = love.graphics.newQuad(48,0,16,16,walkSpriteSheet:getDimensions())
end

function cake:keyPressed(key)
    if key == "space" and self.yVel <= .01 then
        self.body:applyLinearImpulse(0, -500)
        cake.hasFallen = false
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

    -- Handling right left motion:
    if love.keyboard.isDown("left") then
        self.body:setLinearVelocity(-self.spd, self.yVel)
        mirror = -1
        spriteXTranslate = 8
        self.state = "run"
    elseif love.keyboard.isDown("right") then
        self.body:setLinearVelocity(self.spd, self.yVel)
        mirror = 1
        spriteXTranslate = -8
        self.state = "run"
    else 
        self.body:setLinearVelocity(0, self.yVel)
        self.state = "stand"
    end

    -- Handling walk frames:
    elapsedTime = elapsedTime + dt

    if(elapsedTime > .1) then
        if(currentRunFrame < 4) then
            currentRunFrame = currentRunFrame + 1
        else
            currentRunFrame = 1
        end
        activeRunFrame = runFrames[currentRunFrame]
        elapsedTime = 0
    end
end

function cake:draw()
    -- Iterating through active run frames!!

    if (self.state == "stand") then
        love.graphics.draw(standSprite, self.x + spriteXTranslate, self.y - 8, 0, mirror, 1)
    elseif (self.state == "run") then
        love.graphics.draw(walkSpriteSheet,activeRunFrame, self.x + spriteXTranslate, self.y - 8, 0, mirror, 1)
    end
end
