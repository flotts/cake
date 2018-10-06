require "scripts/world"
require "scripts/cake"

function love.load()
    world:load()
    cake:load()
end

function love.keypressed(key)
    cake:keyPressed(key)
end

function love.update(dt)
    world:update(dt)
    cake:update(dt)
end

function love.draw()
    love.graphics.translate(400, 300)
    world:draw()
    cake:draw()
end
