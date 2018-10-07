spikes = {}
spikes.allSpikes = {}

function spikes:load()
    spikesSprite = love.graphics.newImage("/assets/spikes.png")

    spikes:newSpikes(5, 5, 1)
    -- love.graphics.draw(spikesSprite, 200, 200, 0, 1, 1)
end

function spikes:update(dt)

end

function spikes:draw()
    
    for i in ipairs(self.allSpikes) do
        local xVal = spikes.allSpikes[i].x - (spikes.allSpikes[i].width / 2)
        local yVal = spikes.allSpikes[i].y - (spikes.allSpikes[i].height / 2)
        love.graphics.draw(spikesSprite, xVal, yVal, 0, 1, 1)
    end
end

function spikes:newSpikes(x, y, rot)
    x = x * 16
    y = y * 16
    w = 1 * 16
    h = 0.5 * 16
    local myStruct = {}
    myStruct.body = love.physics.newBody(world.world, x, y)
    myStruct.shape = love.physics.newRectangleShape(w, h)
    myStruct.fixture = love.physics.newFixture(myStruct.body, myStruct.shape)
    myStruct.y = y
    myStruct.x = x
    myStruct.width = w
    myStruct.height = h
    myStruct.fixture:setUserData("spike")

    table.insert(self.allSpikes, myStruct)
end