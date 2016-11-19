Star = {}
width = 1366
height = 768
startZ = 5000
maxX = width*2
maxY = height*2
FOV  = 90
FOVr = (FOV*math.pi)/180
velocity = 10
minSize = 25
sizeRange = 50

Stars = {num = 300}

function randomDist() -- returns random number in [-1,1]
    local res = 20
    local rnd = love.math.random()*2-1
    local sign = 1
    if rnd < 0 then
        sign = -1
    end
    rnd = rnd * sign
    return sign * math.exp(rnd*math.log(res))/res
end

function Star:setPos() -- set stars position at end of renderZone
    self.x  = (love.math.random()*2-1)*maxX
    self.y  = (love.math.random()*2-1)*maxY
    self.z  = startZ
    self.s  = minSize + love.math.random()*sizeRange
    --self.vx = _vx * maxSpeed
    --self.vy = _vy * maxSpeed
end

function Star:new() --create star object
    star = {
        x = 0,
        y = 0, 
        z = 0,
        s = 0
    }
    self.__index = self
    return setmetatable(star, self)
end

function Star:move() -- simply move the star closer to the viewer
    self.z = self.z - velocity
end

--[[ The stars position is calculated as so
--    |-.    
--  y |  -.  
--    x____3 
--
--      z   
--]]

function Star:render()
    local sx, sy
    --Calculate the actual position on screen
    --We are treating FOV is 'horizontal FOV'
    sx = ( width/2) + (math.atan(self.x/self.z)/FOVr)*width
    sy = (height/2) + (math.atan(self.y/self.z)/FOVr)*width
    --Calculate size in similar manner
    local size = (math.atan(self.s/self.z)/FOVr)*self.s

    if  sx >=  width or sx <= 0 or
        sy >= height or sy <= 0 then
        self:setPos()
    end
    love.graphics.circle(
        "fill",
        sx,
        sy,
        math.max(1,size)
    )
end

function love.load()
    love.window.setMode(width, height, {})
    love.window.setTitle("Starfield")
    for i = 1, Stars.num do
        Stars[i] = Star:new()
        Stars[i]:setPos()
        Stars[i].z = love.math.random()*startZ
    end
end

function love.update()
    for i = 1, Stars.num do
        Stars[i]:move()
    end
end

function love.draw()
    for i = 1, Stars.num do
        Stars[i]:render()
    end
    love.graphics.print("Velocity: " .. velocity .. " u/s", 0, 0)
end

function love.keypressed(key, scancode, isrepeat)
    if isrepeat == false then
        if key == "up" then
            velocity = math.min(50,velocity+2)
        elseif key == "down" then
            velocity = math.max(2,velocity-2)
        end
    end
end
