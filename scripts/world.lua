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
    for i = 0, (screen.width / self.bg:getWidth() * 2) do
        for j = 0, (screen.height / self.bg:getHeight() * 2) do
            love.graphics.draw(self.bg, (i * self.bg:getWidth()) - screen.width - 20, (j * self.bg:getHeight()) - screen.height)
        end
    end

    iron:draw()
    dirt:draw()
    spike:draw()
    bread:draw()
end

-- contact behavior
function beginContact(a, b, coll)
    x, y = coll:getNormal()
    local aType = a:getUserData()
    local bType = b:getUserData()
    -- text = text.."\n"..a:getUserData().." colliding with "..b:getUserData().." with a vector normal of: "..x..", "..    
    if ((aType == "iron" or aType == "dirt") and bType == "cake") or (aType == "cake" and (bType == "iron" or bType == "dirt")) then
        cake.isGrounded = true
        cake.hasRotated = false
    end
    
    if (aType == "spike" and bType == "cake") or (aType == "cake" and bType == "spike") then
        -- todo: add death animation
        cake:respawn()
    end
end
 
function endContact(a, b, coll)
 
end
 
function preSolve(a, b, coll)
 
end
 
function postSolve(a, b, coll, normalimpulse, tangentimpulse)
 
end
