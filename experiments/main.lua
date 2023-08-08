function love.load()
	nudge_cooldown_period = 60

	bg1 = love.graphics.newImage("images/bgloop.png")
	bg2 = love.graphics.newImage("images/bgloop2.png")

	bg1:setWrap("repeat", "repeat")
	bg2:setWrap("repeat", "repeat")
		
	quad = love.graphics.newQuad(0,0, bg1:getWidth(), bg1:getHeight(), bg1)
	quad2 = love.graphics.newQuad(0,0,bg2:getWidth(),bg2:getHeight(), bg2)
	y = 0
	y2 = 0

	player = {}
	player.image = love.graphics.newImage("images/player.png")
	player.x = 225
	player.y = 700
	player.velocity = 250
	player.nudge = 1
	player.cool = 0

	running = true
end

function love.keyreleased(key)
	if key == "space" then
		running = not running
	end

	if key == "escape" then
		love.event.quit()
	end

	if key == "return" and player.cool == 0 then
		if player.nudge == 1 then
			player.nudge = 2.8
			player.cool = nudge_cooldown_period
		end
	end
end

function love.update(dt)
	if running then
		y = y - 80 * dt
		y2 = y2 - 20 * dt

		quad:setViewport(0, y, bg1:getWidth(), bg1:getHeight())
		quad2:setViewport(0,y2, bg2:getWidth(), bg2:getHeight())

		moveVert = love.keyboard.isDown("w") or love.keyboard.isDown("s")
		moveHor = love.keyboard.isDown("a") or love.keyboard.isDown("d")
		
		playerSpeed = player.velocity
		if (moveVert and moveHor) then
			playerSpeed = playerSpeed / math.sqrt(2)
		end

		if love.keyboard.isDown("a") and player.x > 0 then
			player.x = player.x - playerVelocity(dt)
		elseif love.keyboard.isDown("d") and player.x < 418 then
			player.x = player.x + playerVelocity(dt)
		end
		
		if love.keyboard.isDown("w") and player.y > 400 then
			player.y = player.y - playerVelocity(dt)
		elseif love.keyboard.isDown("s") and player.y < 768 then
			player.y = player.y + playerVelocity(dt)
		end
			
		if player.nudge > 1 then
			player.nudge = player.nudge - player.nudge * 0.05
		elseif player.nudge < 1 then
			player.nudge = 1
		end

		if player.cool > 0 then
			player.cool = player.cool - 1
		end
	end
end

function love.draw()
	love.graphics.draw(bg2, quad2, 0, 0, 0)
	love.graphics.draw(bg1, quad, 0, 0, 0)
	love.graphics.draw(player.image, player.x, player.y)
end

function playerVelocity(dt)
	return playerSpeed * dt * player.nudge
end