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

worldTranslation = {
    x = 400,
    y = 300
}

function love.draw()
    love.graphics.translate(worldTranslation.x, worldTranslation.y)
    love.graphics.scale(2)
    love.graphics.rotate(cake.rot.rot)
    love.graphics.translate(-cake.body:getX(), -cake.body:getY())

    world:draw()
    cake:draw()
end
