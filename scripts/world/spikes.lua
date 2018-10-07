spikes = {}
spikes.allSpikes = {}

function spikes:load()
    spikes.spr = love.graphics.newImage("/assets/spikes.png")

    spikes:new(4, 5, 0)
    spikes:new(5, 4, 1)
    spikes:new(5, 14, 2)
    spikes:new(-2, -3, 2)
    -- love.graphics.draw(spikes.spr, 200, 200, 0, 1, 1)
end

function spikes:new(x, y, rot)
    x = x * 16
    y = y * 16
    w = 1 * 16
    h = 1 * 16
    local myStruct = {}
    myStruct.body = love.physics.newBody(world.world, x, y)
    myStruct.shape = love.physics.newRectangleShape(w, h)
    myStruct.fixture = love.physics.newFixture(myStruct.body, myStruct.shape)
    myStruct.y = y
    myStruct.x = x
    myStruct.width = w
    myStruct.height = h
    myStruct.rot = -rot * (math.pi / 2)
    myStruct.fixture:setUserData("spike")

    table.insert(self.allSpikes, myStruct)
end

function spikes:update(dt)

end

function spikes:draw()
    
    for i in ipairs(self.allSpikes) do
        local xVal = spikes.allSpikes[i].x
        local yVal = spikes.allSpikes[i].y 
        local rot = spikes.allSpikes[i].rot
        love.graphics.draw(spikes.spr, xVal, yVal, rot, 1, 1, 8, 8)
    end
end
