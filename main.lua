require "scripts/world"
require "scripts/cake"

function love.load()
    world:load()
    cake:load()
end

function love.update(dt)
    world:update(dt)
    cake:update(dt)
end

function love.draw()
    love.graphics.translate()
    world:draw()
    cake:draw()
end
