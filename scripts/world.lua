-- blocks & entities
require "scripts/world/iron"
require "scripts/world/dirt"
require "scripts/world/spike"
require "scripts/world/bread"
require "scripts/world/mold"

world = {}

function world:load()
    self.world = love.physics.newWorld()
    self.world:setCallbacks(beginContact, endContact, preSolve, postSolve)

    world.bg = love.graphics.newImage("/assets/wallpaper.png")

    iron:load()
    dirt:load()
    spike:load()
    bread:load()
    mold:load()
end

function world:update(dt)
    self.world:update(dt)

    iron:update(dt)
    dirt:update(dt)
    spike:update(dt)
    bread:update(dt)
    mold:update(dt)
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
    mold:draw()
end

-- contact behavior
function beginContact(a, b, coll)

    -- X and Y give a UNIT VECTOR from the first shape to the second
    -- So if a is cake and b is a block below Cake at normal orientation,
    -- X and Y will be (0, -1)
    x, y = coll:getNormal() 
    local aType = a:getUserData()
    local bType = b:getUserData()
    -- text = text.."\n"..a:getUserData().." colliding with "..b:getUserData().." with a vector normal of: "..x..", "..    
    if ((aType == "iron" or aType == "dirt") and bType == "cake") or (aType == "cake" and (bType == "iron" or bType == "dirt")) then
        if (x == -cake.grav.dir.x and y == -cake.grav.dir.y) then
            cake.isGrounded = true
            cake.hasRotated = false
        end
    end
    
    if (aType == "spike" and bType == "cake") or (aType == "cake" and bType == "spike") then
        cake:respawn()
    end

    if (aType == "mold_body" and bType == "cake") then
        if (x == -cake.grav.dir.x and y == -cake.grav.dir.y) then 
            print("SMOOOSH")
        end
    end
end
 
function endContact(a, b, coll)
 
end
 
function preSolve(a, b, coll)
 
end
 
function postSolve(a, b, coll, normalimpulse, tangentimpulse)
 
end
