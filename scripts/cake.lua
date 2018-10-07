cake = {}

-- rotation variable table
cake.rot = {
    rot = 0,         -- Current rotation, handles intermediate values
    snap = 0,          -- Set to 90deg angles
    ing = false,     -- Whether or not the character is undergoing a rotation
    dir = 0
}

-- gravity variable table
cake.grav = {
    dir = {
        x = 0,
        y = 1
    },
    amt = 500
}

-- X and Y coords
cake.x = 0
cake.y = 0
-- X and Y vel
cake.xVel = 0
cake.yVel = 0

-- Walk speed
cake.spd = 150
-- Gravity
cake.weight = 1000

cake.state = "stand"            -- stand, run, jump
cake.isGrounded = false         -- Used to help indicate whether Cake can jump
cake.hasRotated = false

cake.dead = false

-- Variables used to keep track of which way Cake is facing
local mirror = 1                -- -1 for normal, 1 for mirrored
local spriteXTranslate = 0      -- Set to 8 to mirror image (shifting it 16)

local runFrames = {}
local activeRunFrame            -- Stores the actual data of the frame location
local currentRunFrame = 1       -- stores which frame is currently displayed (1-4)

local elapsedTime = 0

function cake:load()
    -- Setting up our collision box:
    self.body = love.physics.newBody(world.world, self.x, self.y, "dynamic")
    self.shape = love.physics.newRectangleShape(16, 16)
    self.fixture = love.physics.newFixture(self.body, self.shape, 5)
    self.fixture:setUserData("cake")
    self.fixture:setFriction(0)
    self.fixture:setRestitution(0.125)

    -- Setting up sprite:
    standSprite = love.graphics.newImage("/assets/cake_standing_1.png")
    jumpSprite = love.graphics.newImage("/assets/cake_jumping_1.png")

    walkSpriteSheet = love.graphics.newImage("/assets/cake_running_1.png")
    runFrames[1] = love.graphics.newQuad(0,0,16,16,walkSpriteSheet:getDimensions())
    runFrames[2] = love.graphics.newQuad(16,0,16,16,walkSpriteSheet:getDimensions())
    runFrames[3] = love.graphics.newQuad(32,0,16,16,walkSpriteSheet:getDimensions())
    runFrames[4] = love.graphics.newQuad(48,0,16,16,walkSpriteSheet:getDimensions())
end

function cake:rotate(direction)
    self.rot.ing = true
    self.hasRotated = true
    if direction == "right" then
        self.rot.dir = 1
    else
        self.rot.dir = -1
    end
    self.rot.start = love.timer.getTime()
end

function cake:keypressed(key)
    if key == "space" and cake.isGrounded then
        if self.grav.dir.x == 0 then
            if self.grav.dir.y > 0 then
                self.body:applyLinearImpulse(0, -350)
            else
                self.body:applyLinearImpulse(0, 350)
            end
        else
            if self.grav.dir.x > 0 then
                self.body:applyLinearImpulse(-350, 0)
            else
                self.body:applyLinearImpulse(350, 0)
            end
        end
        self.isGrounded = false
        self.state = "jump"
    elseif key == "a" then
        if not self.rot.ing and not self.hasRotated then self:rotate("left") end
    elseif key == "d" then
        if not self.rot.ing and not self.hasRotated then self:rotate("right") end
    elseif key == "l" then
        print("grav.dir.x: ", self.grav.dir.x)
        print("grav.dir.y: ", self.grav.dir.y)
        
        print("rot.rot: ", self.rot.rot)
    end
end

function cake:update(dt)
    self.xVel, self.yVel = self.body:getLinearVelocity()

    -- Handling right & left motion:
    if self.rot.ing then
        -- This this is for is you're in the middle of a rotation, because we couldn't figure out a better way to do it
        if love.keyboard.isDown("left") then
            self.body:applyForce(self.spd * self.grav.dir.x, self.spd * self.grav.dir.y)
            mirror = -1
            if (self.isGrounded) then
                self.state = "run"
            end
        elseif love.keyboard.isDown("right") then
            self.body:applyForce(self.spd * self.grav.dir.x, self.spd * self.grav.dir.y)
            mirror = 1
            if (self.isGrounded) then
                self.state = "run"
            end
        end
    else
        if love.keyboard.isDown("left") then
            -- If gravity is either upright or upside down
            if self.grav.dir.x == 0 then
                if self.grav.dir.y > 0 then
                    self.body:setLinearVelocity(-self.spd, self.yVel)
                else
                    self.body:setLinearVelocity(self.spd, self.yVel)
                end
            else -- If gravity is sideways
                if self.grav.dir.x > 0 then
                    self.body:setLinearVelocity(self.xVel, self.spd)
                else
                    self.body:setLinearVelocity(self.xVel, -self.spd)
                end
            end
            mirror = -1
            if (self.isGrounded) then
                self.state = "run"
            end
        elseif love.keyboard.isDown("right") then
            -- If gravity is either upright or upside down
            if self.grav.dir.x == 0 then
                if self.grav.dir.y > 0 then
                    self.body:setLinearVelocity(self.spd, self.yVel)
                else
                    self.body:setLinearVelocity(-self.spd, self.yVel)
                end
            else -- If gravity is sideways
                if self.grav.dir.x > 0 then
                    self.body:setLinearVelocity(self.xVel, -self.spd)
                else
                    self.body:setLinearVelocity(self.xVel, self.spd)
                end
            end
            mirror = 1
            if self.isGrounded then
                self.state = "run"
            end
        else
            if self.grav.dir.x == 0 then
                self.body:setLinearVelocity(0, self.yVel)
            else
                self.body:setLinearVelocity(self.xVel, 0)
            end

            if (self.isGrounded) then 
                self.state = "stand"
            end
        end
    end

    -- Handling rotation:
    if self.rot.ing and love.timer.getTime() - self.rot.start < 0.125 then
        self.rot.rot = self.rot.snap + (((love.timer.getTime() - self.rot.start) * 8) * (math.pi / 2) * self.rot.dir)
    else
        self.rot.rot = self.rot.snap + (math.pi / 2) * self.rot.dir
        self.rot.dir = 0
        self.rot.snap = self.rot.rot

        self.rot.ing = false
    end

    -- Handling gravity:
    self.grav.dir.x = math.floor(math.sin(self.rot.rot) + 0.5)
    self.grav.dir.y = math.floor(math.cos(self.rot.rot) + 0.5)

    world.world:setGravity(self.grav.amt * self.grav.dir.x, self.grav.amt * self.grav.dir.y)

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


    if self.dead then
        self.body:setPosition( 0, 0 )
        self.x = 0
        self.y = 0
        self.dead = false
    end
    
end

function cake:draw()
    -- Iterating through active run frames:
    if (self.state == "stand") then
        love.graphics.draw(standSprite, self.body:getX(), self.body:getY(), -self.rot.rot, mirror, 1, 8, 8)
    elseif (self.state == "run") then
        love.graphics.draw(walkSpriteSheet,activeRunFrame, self.body:getX(), self.body:getY(), -self.rot.rot, mirror, 1, 8, 8)
    elseif (self.state == "jump") then
        love.graphics.draw(jumpSprite, self.body:getX(), self.body:getY(), -self.rot.rot, mirror, 1, 8, 8)
    end
end

function cake:death()
    self.dead = true
end
