require "scripts/globals"

require "scripts/world"
require "scripts/cake"

function love.load()
    globals.load()

    -- set default texture drawing filter to nearest neighbor
    love.graphics.setDefaultFilter("nearest")

    world:load()
    cake:load()
end

function love.update(dt)
    globals.update()

    world:update(dt)
    cake:update(dt)
end

function love.draw()
    love.graphics.translate(screen.width / 2, screen.height / 2)
    love.graphics.scale(screen.scale)
    love.graphics.rotate(cake.rot.rot)
    love.graphics.translate(-cake.body:getX(), -cake.body:getY())

    world:draw()
    cake:draw()
end

function love.keypressed(key)
    cake:keypressed(key)

    if key == "f" then
        love.window.setFullscreen(not love.window.getFullscreen())
    elseif key == "escape" then
        love.event.quit()
    end
end

function love.wheelmoved(x, y)
    if screen.scale > 2 and y < 0 then
        screen.scale = screen.scale + y
    elseif screen.scale < 10 and y > 0 then
        screen.scale = screen.scale + y
    end
end
