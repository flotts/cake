-- blocks & entities
require "scripts/world/iron"
require "scripts/world/dirt"
require "scripts/world/spike"
require "scripts/world/bread"

world = {}

function world:load()
    self.world = love.physics.newWorld()
    self.world:setCallbacks(beginContact, endContact, preSolve, postSolve)

    world.bg = love.graphics.newImage("/assets/wallpaper.png")

    iron:load()
    dirt:load()
    spike:load()
    bread:load()
end

function world:update(dt)
    self.world:update(dt)

    iron:update(dt)
    dirt:update(dt)
    spike:update(dt)
    bread:update(dt)
end

function world:draw()
    -- tiling background wallpaper:
    for i = 0, (love.graphics.getWidth() / self.bg:getWidth() * 2) do
        for j = 0, (love.graphics.getHeight() / self.bg:getHeight() * 2) do
            love.graphics.draw(self.bg, (i * self.bg:getWidth()) - screen.width - 20, (j * self.bg:getHeight()) - screen.height)
        end
    end

    iron:draw()
    dirt:draw()
    spike:draw()
    bread:draw()
end

-- contact functions
function beginContact(a, b, coll)
    x, y = coll:getNormal()
    local aType = a:getUserData()
    local bType = b:getUserData()
    -- text = text.."\n"..a:getUserData().." colliding with "..b:getUserData().." with a vector normal of: "..x..", "..    
    if aType == "iron" and bType == "cake" then
        cake.isGrounded = true
        cake.hasRotated = false
    end
    
    if aType == "cake" and bType == "spike" then 
        cake:respawn()
        print("cake hit a spike!")
    end
end
 
function endContact(a, b, coll)
 
end
 
function preSolve(a, b, coll)
 
end
 
function postSolve(a, b, coll, normalimpulse, tangentimpulse)
 
end
