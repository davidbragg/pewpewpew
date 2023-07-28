function love.load()
	-- love.window.setMode(450, 800)
end

function love.update()
	if love.keyboard.isDown("escape") then
		love.event.quit()
	end
end

function love.draw()

end
