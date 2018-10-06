require "scripts/world"
require "scripts/cake"

function love.load()
    love.graphics.setDefaultFilter("nearest")
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
    love.graphics.scale(2)

    love.graphics.translate(-cake.body:getX(), -cake.body:getY())
    love.graphics.rotate(cake.rot.rot)

    love.graphics.print(cake.rot.rot)

    world:draw()

    cake:draw()
end
