globals = {}

function globals.load()
    -- screen properties
    screen = {
        width = love.graphics.getWidth(),
        height = love.graphics.getHeight(),
        scale = 3
    }

    -- rotation easing function
    function inOutCubic(t, b, c, d)
        t = t / d * 2
        if t < 1 then
            return c / 2 * t * t * t + b
        else
            t = t - 2
            return c / 2 * (t * t * t + 2) + b
        end
    end
end

function globals.update()
    -- update screen properties for resizing
    screen.width = love.graphics.getWidth()
    screen.height = love.graphics.getHeight()
end
