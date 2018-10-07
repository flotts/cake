require "scripts/globals"

require "scripts/world"
require "scripts/cake"

function love.load()
    screen = {
        width = love.graphics.getWidth(),
        height = love.graphics.getHeight()
    }
    
    love.graphics.setDefaultFilter("nearest")

    world:load()
    cake:load()
end

function love.keypressed(key)
    cake:keypressed(key)

    if key == "f" then
        love.window.setFullscreen(not love.window.getFullscreen())
    elseif key == "escape" then
        love.event.quit()
    end
end

function love.update(dt)
    screen.width = love.graphics.getWidth()
    screen.height = love.graphics.getHeight()

    world:update(dt)
    cake:update(dt)
end

function love.draw()
    love.graphics.translate(screen.width / 2, screen.height / 2)
    love.graphics.scale(2)
    love.graphics.rotate(cake.rot.rot)
    love.graphics.translate(-cake.body:getX(), -cake.body:getY())

    world:draw()
    cake:draw()
end
