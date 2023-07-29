function love.load()
	bg1 = love.graphics.newImage("images/bgloop.png")
	bg2 = love.graphics.newImage("images/bgloop2.png")

	bg1:setWrap("repeat", "repeat")
	bg2:setWrap("repeat", "repeat")
		
	quad = love.graphics.newQuad(0,0, bg1:getWidth(), bg1:getHeight(), bg1)
	quad2 = love.graphics.newQuad(0,0,bg2:getWidth(),bg2:getHeight(), bg2)
	y = 0
	y2 = 0

	running = true
end

function love.keyreleased(key)
	if key == "space" then
		running = not running
	end

	if key == "escape" then
		love.event.quit()
	end
end

function love.update(dt)
	if running then
		y = y - 80 * dt
		y2 = y2 - 20 * dt

		quad:setViewport(0, y, bg1:getWidth(), bg1:getHeight())
		quad2:setViewport(0,y2, bg2:getWidth(), bg2:getHeight())
	end
end

function love.draw()
	love.graphics.draw(bg2, quad2, 0, 0, 0)
	love.graphics.draw(bg1, quad, 0, 0, 0)
end
