spike = {}
spike.spikes = {}

function spike:load()
    spike.spr = love.graphics.newImage("/assets/spike.png")
    
    spike:new(4, 5, 0)
    spike:new(5, 4, 1)
    spike:new(5, 14, 2)
    spike:new(-2, -3, 2)
end

function spike:new(x, y, rot)
    x = x * 16
    y = y * 16
    w = 16
    h = 16
    local structure = {}
    structure.body = love.physics.newBody(world.world, x, y)
    structure.shape = love.physics.newRectangleShape(w, h)
    structure.fixture = love.physics.newFixture(structure.body, structure.shape)
    structure.y = y
    structure.x = x
    structure.width = w
    structure.height = h
    structure.rot = -rot * (math.pi / 2)
    structure.fixture:setUserData("spike")

    table.insert(self.spikes, structure)
end

function spike:update(dt)

end

function spike:draw()
    
    for i in ipairs(self.spikes) do
        local xVal = spike.spikes[i].x
        local yVal = spike.spikes[i].y 
        local rot = spike.spikes[i].rot
        love.graphics.draw(spike.spr, xVal, yVal, rot, 1, 1, 8, 8)
    end
end
