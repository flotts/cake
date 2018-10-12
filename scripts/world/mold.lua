mold = {}
mold.molds = {}

mold.spr = {                 -- 1 for normal, -1 for reversed
    droolFrames = {},            -- stores image sources 
    activeDroolFrame,            -- stores current quad source
    currentDroolFrame = 1        -- stores integer indicating which frame we're on
}

mold.handSpeed = .2

local elapsedTime = 0           -- Used for the animation

function mold:load()
    -- Loading in sprites:
    mold.spr.droolSheet = love.graphics.newImage("/assets/mold_body_1.png")
    self.spr.droolFrames[1] = love.graphics.newQuad(0,0,16,16,self.spr.droolSheet:getDimensions())
    self.spr.droolFrames[2] = love.graphics.newQuad(16,0,16,16,self.spr.droolSheet:getDimensions())
    self.spr.droolFrames[3] = love.graphics.newQuad(32,0,16,16,self.spr.droolSheet:getDimensions())
    self.spr.droolFrames[4] = love.graphics.newQuad(48,0,16,16,self.spr.droolSheet:getDimensions())

    self.spr.hand = love.graphics.newImage("/assets/mold_hand.png")

    -- Initializing activeDroolFrame
    self.spr.activeDroolFrame = self.spr.droolFrames[self.spr.currentDroolFrame]

    mold:new(4,1,0)
end

function mold:new(x, y, rot)
    x = x * 16
    y = y * 16
    w = 16
    h = 16
    local structure = {}
    structure.body = love.physics.newBody(world.world, x, y)
    structure.shape = love.physics.newRectangleShape(w, h)
    structure.fixture = love.physics.newFixture(structure.body, structure.shape)
    structure.fixture:setUserData("spike")
    structure.y = y
    structure.x = x
    structure.width = w
    structure.height = h
    structure.rot = -rot * (math.pi / 2)

    -- loading in the current Mold's hand
    structure.hand = {}
    structure.hand.x = x - 16       -- Note the hand will appear in front of the new mold
        -- TODO: Make all this work with different rotations
    structure.hand.y = y
    structure.hand.body = love.physics.newBody(world.world, structure.hand.x, structure.hand.y)
    structure.hand.shape = love.physics.newRectangleShape(w, h)
    structure.hand.fixture = love.physics.newFixture(structure.hand.body, structure.hand.shape)
    structure.hand.fixture:setUserData("spike")
    structure.hand.rot = -rot * (math.pi / 2)



    table.insert(self.molds, structure)
end

function mold:update(dt)
    -- Handling drool frames:
    elapsedTime = elapsedTime + dt
    if(elapsedTime > .2) then
        if(self.spr.currentDroolFrame < 4) then
            self.spr.currentDroolFrame = self.spr.currentDroolFrame + 1
        else
            self.spr.currentDroolFrame = 1
        end
        self.spr.activeDroolFrame = self.spr.droolFrames[self.spr.currentDroolFrame]
        elapsedTime = 0
    end

    -- Moving hand towards Cake
    for i in ipairs(self.molds) do
        -- Checking if we should shift the hand negative or positive .1 in the x direction
            -- For example, We only want to move increase the hand's X if:
            --          1. The player has a higher X than the hand
            --          2. The hand won't be going further than 32 units away from its body
        -- TODO: This could probably use cleaned up
        if (cake.x > self.molds[i].hand.x) and (self.molds[i].hand.x < mold.molds[i].x + 32) then
            self.molds[i].hand.x = self.molds[i].hand.x + self.handSpeed
        elseif (cake.x < self.molds[i].hand.x) and (self.molds[i].hand.x > mold.molds[i].x - 32) then
            self.molds[i].hand.x = self.molds[i].hand.x - self.handSpeed
        end
        if (cake.y > self.molds[i].hand.y) and (self.molds[i].hand.y < mold.molds[i].y + 32) then
            self.molds[i].hand.y = self.molds[i].hand.y + self.handSpeed
        elseif (cake.y < self.molds[i].hand.y) and (self.molds[i].hand.y > mold.molds[i].y - 32) then
            self.molds[i].hand.y = self.molds[i].hand.y - self.handSpeed
        end
    end
end

function mold:draw()
    
    for i in ipairs(self.molds) do
        local xVal = mold.molds[i].x
        local yVal = mold.molds[i].y 
        local rot = mold.molds[i].rot
        local hand = mold.molds[i].hand
        love.graphics.draw(self.spr.droolSheet, self.spr.activeDroolFrame, xVal, yVal, rot, 1, 1, 8, 8)
        love.graphics.draw(self.spr.hand, hand.x, hand.y, hand.rot, 1, 1, 8, 8)
    end
end
