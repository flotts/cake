cake = {}

-- rotation variable table
cake.rot = {
    rot = 0,                    -- Current rotation, handles intermediate values
    snap = 0,                   -- Set to 90deg angles
    ing = false,                -- Whether or not the character is mid-rotation
    dir = 0,
    dur = 0.25
}

-- gravity variable table
cake.grav = {
    dir = {
        x = 0,
        y = 1
    },
    amt = 500
}

cake.spr = {
    mirror = 1,                 -- 1 for normal, -1 for reversed
    walkFrames = {},
    activeWalkFrame,
    currentWalkFrame = 1
}

-- X and Y coords
cake.x = 0
cake.y = 0

-- X and Y vel
cake.xVel = 0
cake.yVel = 0

cake.spd = 150                  -- Walk speed

cake.state = "stand"            -- stand, run, jump
cake.crouching = false

cake.isGrounded = false         -- Used to help indicate whether Cake can jump
cake.hasRotated = false

cake.dead = false

local elapsedTime = 0

function cake:load()
    -- Setting up our collision box:
    self.body = love.physics.newBody(world.world, self.x, self.y, "dynamic")
    self.body:setFixedRotation(true)
    self.shape = love.physics.newRectangleShape(16, 16)
    self.fixture = love.physics.newFixture(self.body, self.shape, 5)
    self.fixture:setUserData("cake")
    self.fixture:setFriction(0)
    self.fixture:setRestitution(0.2)

    -- Setting up sprites:
    self.spr.stand = love.graphics.newImage("/assets/cake/standing_1.png")
    self.spr.jump = love.graphics.newImage("/assets/cake/jumping_1.png")
    self.spr.crouch = love.graphics.newImage("/assets/cake/crouching_1.png")

    self.spr.walkCycle = love.graphics.newImage("/assets/cake/running_1.png")
    self.spr.walkFrames[1] = love.graphics.newQuad(0,0,16,16,self.spr.walkCycle:getDimensions())
    self.spr.walkFrames[2] = love.graphics.newQuad(16,0,16,16,self.spr.walkCycle:getDimensions())
    self.spr.walkFrames[3] = love.graphics.newQuad(32,0,16,16,self.spr.walkCycle:getDimensions())
    self.spr.walkFrames[4] = love.graphics.newQuad(48,0,16,16,self.spr.walkCycle:getDimensions())
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

function cake:respawn()
    -- todo: add death animation
    self.dead = true
end

function cake:keypressed(key)
    if key == "space" and self.isGrounded then
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
    elseif key == "r" then
        self:respawn()
    end
    
    -- log (for dev)
    if key == "l" then
        print("grav.dir.x: ", self.grav.dir.x)
        print("grav.dir.y: ", self.grav.dir.y)
        print("rot.rot: ", self.rot.rot)
    end
end

function cake:update(dt)
    self.xVel, self.yVel = self.body:getLinearVelocity()

    -- Handling right & left motion:
    if love.keyboard.isDown("left") then
        if self.rot.ing then
            self.body:setLinearVelocity(0, 0)
        else
            -- If gravity is either upright or upside down
            if self.grav.dir.x == 0 then
                if self.grav.dir.y > 0 then
                    self.body:setLinearVelocity(-self.spd, self.yVel)
                else
                    self.body:setLinearVelocity(self.spd, self.yVel)
                end
            -- If gravity is sideways
            else
                if self.grav.dir.x > 0 then
                    self.body:setLinearVelocity(self.xVel, self.spd)
                else
                    self.body:setLinearVelocity(self.xVel, -self.spd)
                end
            end
        end

        self.spr.mirror = -1

        if (self.isGrounded) then
            self.state = "run"
        end
    elseif love.keyboard.isDown("right") then
        if self.rot.ing then
            self.body:setLinearVelocity(0, 0)
        else
            -- If gravity is either upright or upside down
            if self.grav.dir.x == 0 then
                if self.grav.dir.y > 0 then
                    self.body:setLinearVelocity(self.spd, self.yVel)
                else
                    self.body:setLinearVelocity(-self.spd, self.yVel)
                end
            -- If gravity is sideways
            else
                if self.grav.dir.x > 0 then
                    self.body:setLinearVelocity(self.xVel, -self.spd)
                else
                    self.body:setLinearVelocity(self.xVel, self.spd)
                end
            end
        end

        self.spr.mirror = 1

        if self.isGrounded then
            self.state = "run"
        end
    else
        if self.rot.ing then
            self.body:setLinearVelocity(0,  0)
        else
            if self.grav.dir.x == 0 then
                self.body:setLinearVelocity(0, self.yVel)
            else
                self.body:setLinearVelocity(self.xVel, 0)
            end
        end

        if (self.isGrounded) then 
            self.state = "stand"

            if love.keyboard.isDown("down") then
                self.crouching = true
            else
                self.crouching = false
            end
        end
    end

    -- Handling rotation:
    if self.rot.ing and love.timer.getTime() - self.rot.start < self.rot.dur then
        self.rot.rot = self.rot.snap + (((love.timer.getTime() - self.rot.start) * (1 / self.rot.dur)) * (math.pi / 2) * self.rot.dir) * (inOutCubic(love.timer.getTime() - self.rot.start, 0, 1, self.rot.dur) + dt)
    else
        self.rot.rot = self.rot.snap + (math.pi / 2) * self.rot.dir
        self.rot.dir = 0
        self.rot.snap = self.rot.rot

        self.rot.ing = false
    end

    -- Handling gravity (using a floor rounding technique that makes me sad inside):
    self.grav.dir.x = math.floor(math.sin(self.rot.rot) + 0.1)
    self.grav.dir.y = math.floor(math.cos(self.rot.rot) + 0.1)

    world.world:setGravity(self.grav.amt * self.grav.dir.x, self.grav.amt * self.grav.dir.y)

    -- Handling walk frames:
    elapsedTime = elapsedTime + dt

    if(elapsedTime > .1) then
        if(self.spr.currentWalkFrame < 4) then
            self.spr.currentWalkFrame = self.spr.currentWalkFrame + 1
        else
            self.spr.currentWalkFrame = 1
        end
        self.spr.activeWalkFrame = self.spr.walkFrames[self.spr.currentWalkFrame]
        elapsedTime = 0
    end

    if self.dead then
        -- Reset rotation, reset location, reset velocity (& add a little nudge to prevent box2d from acting weird)
        self.rot.snap = 0
        self.body:setPosition(0, 0)
        self.body:setLinearVelocity(0, 1)
        self.dead = false
    end
    
end

function cake:draw()
    -- Iterating through active run frames:
    if (self.state == "stand") then
        if self.crouching then
            love.graphics.draw(self.spr.crouch, self.body:getX(), self.body:getY(), -self.rot.rot, self.spr.mirror, 1, 8, 8)
        else
            love.graphics.draw(self.spr.stand, self.body:getX(), self.body:getY(), -self.rot.rot, self.spr.mirror, 1, 8, 8)
        end
    elseif (self.state == "run") then
        love.graphics.draw(self.spr.walkCycle, self.spr.activeWalkFrame, self.body:getX(), self.body:getY(), -self.rot.rot, self.spr.mirror, 1, 8, 8)
    elseif (self.state == "jump") then
        love.graphics.draw(self.spr.jump, self.body:getX(), self.body:getY(), -self.rot.rot, self.spr.mirror, 1, 8, 8)
    end
end
