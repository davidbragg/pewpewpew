# Friday, July 28, 2023

Tackling from the [to do](../todo.md) list.

## Resize Window to 9:16

First thing, I guess most obviously, is to just set up a basic löve game. Looks like this is the minimum code required to set that up.

```
function love.load()

end

function love.update()

end

function love.draw()

end
```

I think this should just live in a `main.lua` and then I can run `love .` on that folder? 

Yep. That works. Easy enough.

Resizing the window looks like [love.window.setMode](https://love2d.org/wiki/love.window.setMode)

I think 900 x 1600 is a bit bigger that I what I want for right now. I'm fine with hardcoding this to half that.

`love.window.setMode(450, 800)` in the `love.load()` function should get the job done.

This works. I do find it interesting that it loads the default window first and then resizes. I wonder if there's a way to circumvent that. Have it load at that size to begin with.

Neat. Looks like there's a `conf.lua` file that gets run before löve finishes loading. I can put some business in there. [Config Files](https://love2d.org/wiki/Config_Files)

This works even better than setting the window mode. 

``` 
function love.conf(t)
    t.window.title = "pewpewpew"
    t.window.width = 450
    t.window.height = 800
end
```

That's very easy. I should be able to just reuse that conf file with each experiment as I get further into this. 

I expect that keyboard control is going to be an easy feature here. Something baked in. Let's see if I can figure out

## Close on ESC

while I'm here. 

* [love.keyboard.isDown](https://love2d.org/wiki/love.keyboard.isDown)
* [keyConstant](https://love2d.org/wiki/KeyConstant)

Looks like what I want is `love.keyboard.isDown("escape")` and an `if`(?) statement to exit the app? `love.event.quit`? Let's give it a shot. 

Which brings me to the point where I don't know the structure of lua `if` statements.

```
if {a} {op} {b} then
    ...
elseif {a} {op} {b} then
    ...
else
    ...
end
```

This little snippet should get me everything I need.

```
if love.keyboard.isDown("escape") then
    love.event.quit
end
```

Incorrect. Neat.

```
Error: Syntax error: main.lua:8: '=' expected near 'end'

stack traceback:
	[love "boot.lua"]:345: in function <[love "boot.lua"]:341>
	[C]: at 0x7f77c9569dd0
	[C]: in function 'require'
	[love "boot.lua"]:316: in function <[love "boot.lua"]:126>
	[C]: in function 'xpcall'
	[love "boot.lua"]:355: in function <[love "boot.lua"]:348>
	[C]: in function 'xpcall'
```

Am I expecting an implicit eval to `true` to push me through the `if` and that's failing because lua expects a comparison?

Nope. The examples in the wiki are using this structure as well (and probably would have been a faster example than going out to see how lua does `if` statements).

The problem has to be how I'm trying to call the `quit` event then. The trace implies that as well with the issue being identified as an = missing at line 8 (but probably likely line 7 for realsies).

Hah. Just missed putting the parens after the event call. It should have actually been `love.event.quit()`. This is what I get for just trying the function once I see it by name, rather than actually looking at the documentation. 

Everything is working here now.

One thing that bothers me; I'm getting some bullshit at the command line when I run `love .`

```
17:17 $ love .
ioctl (GFEATURE): Broken pipe
ioctl (GFEATURE): Broken pipe
ioctl (GFEATURE): Broken pipe
ioctl (GFEATURE): Broken pipe
ioctl (GFEATURE): Broken pipe
ioctl (GFEATURE): Broken pipe
ioctl (GFEATURE): Broken pipe
ioctl (GFEATURE): Broken pipe
ioctl (GFEATURE): Broken pipe
ioctl (GFEATURE): Invalid argument
ioctl (GFEATURE): Invalid argument
ioctl (GFEATURE): Invalid argument
ioctl (GFEATURE): Invalid argument
ioctl (GFEATURE): Invalid argument
ioctl (GFEATURE): Invalid argument
ioctl (GFEATURE): Broken pipe
ioctl (GFEATURE): Broken pipe
ioctl (GFEATURE): Broken pipe
```

Let's see if we can figure out what's going on here. 

It doesn't happen if I just run `love` by itself. It is happening regardless of where I run `love .` and doesn't seem to matter if there's a project in that folder or not. That implies there's something in the default config to run a project from a directory throwing this. 

I'm not particularly worried about it for this project.

I was going to do separate folders for each of the experiments, but I think just maintaining that history in the commits is fine. Calling it here for this part, committing/pushing my changes.

A ha! Fuck all that noise! I figured out the bullshit from above. I suspected it was just trying to load something, likely a gaming peripheral. Found this line in the configuration documentation.

`t.modules.joystick = false`

Slapped that baby into my `conf.lua` and all the errors went away. Marvelous. Looks like the joystick module is loaded by default. I don't have a joystick connected. Et voila, bullshit.

It'll be worth taking a close look through the configuration options at some point, I'm sure there's some helpful business in there.

## Vertically Scrolling Background

Ultimately, I'd like to get a point where I've got layered backgrounds, moving at different speeds, to give a sense of parallax. The first thing to do is get a single layer scrolling. 

I don't want to build some massive png that scrolls the full length. I don't think that even works in this context, since I don't have the concept of a level. It may technically start somewhere, but I don't have an ending yet. That implies that my best solution may be an infinitely looping background. 

The screen is currently 800 pixels high. I could use two instances of the same image. As soon as one scrolls off the bottom of the screen it jumps back up to the top again. That's a good enough proof of concept. I think I should be able to scroll the image just by changing the x,y location in the `love.draw()` function.

But first, I need to know how to load the image in the window.

[love.graphics.newImage](https://love2d.org/wiki/love.graphics.newImage)

```
function love.load()
    background = love.graphics.newImage("images/bgloop.png")
end

function love.draw()
    love.graphics.draw(background, 0, 0)
end
```
Threw together a quick image in Krita (wrap around mode is teh business). Giving that a shot to see if it loads appropriately. And it does. Super.

Let's get that `y` co-ordinate doing something.

Adding `bgY = 0` to the load function, setting the y value to `bgY` in the draw function, and incrementing the value in the update function with `bgY = bgY + 5`. And that works just fine. 

I'm not going to want to do separate values like this for things. I'll need to look into a better way to manage the values. Treat the background like an object with parameters. Is that even valid for lua? I guess I'll find out.

Created a second instance (`background2`) and offset it's y value by `bgY - 800`. This gives me a seamless tile. That's not the solution for an infite seamless tile, but it proves out that seamless tiling will work this way. 

Also, delta time! I think I like something like `bgY = bgY + 50 * dt` better than the way I had it. 

Yes. Objects are exactly a thing.

```
background = {}
background.image = love.graphics.newImage("images/bgloop.png")
background.y = 0
```

Updating supporting code to this works just fine. I'm still running out eventually. I need to make it _infinite_. 

I'll need to make the second instance of the background hold it's own y value, instead of following the y value of the first instance. Then I'll need a check where `y > 800` then `y = y - 1600`. That should keep things from getting desynced.

I suspect that I need something larger than my screen height to ensure I don't get any hiccups in the tiling.

It's a little janky. Here's where I'm at, since I know this is going to get refactored.

```
function love.load()
	bgImage = love.graphics.newImage("images/bgloop.png")
	bgSpeed = 50

	background1 = {}
	background1.image = bgImage
	background1.y = 0
	
	background2 = {}
	background2.image = bgImage
	background2.y = -800
end

function love.update(dt)
	if love.keyboard.isDown("escape") then
		love.event.quit()
	end

	background1.y = background1.y + bgSpeed * dt
	background2.y = background2.y + bgSpeed * dt

	if background1.y > 800 then
		background1.y = background1.y - 1600
	end
	if background2.y > 800 then
		background2.y = background2.y - 1600
	end
end

function love.draw()
	love.graphics.draw(background1.image, 0, background1.y)
	love.graphics.draw(background2.image, 0, background2.y)
end
```
I am getting a little stutter at the top of the image that I should be able to fix by making the image slightly larger so that it can take up the entire screen and a little bit. 

I don't want to create background images. This should be a function that returns an object that I can cram into an array. Likewise on updating the y values and drawing the image to screen.

Before I get there, I've found another potential solution that uses a `quad` and `.setWrap`. Going to give that a shot and see how it works.

For what I'm trying to do, this is actually a pretty interesting solution. I'm just not sure I understand it entirely.

```
function love.load()
	bgImage = love.graphics.newImage("images/bgloop.png")
	bgImage:setWrap("repeat", "repeat")
	quad = love.graphics.newQuad(0, 0, bgImage:getWidth(), bgImage:getHeight(), bgImage:getWidth(), bgImage:getHeight())
	y = 0
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
		y = y - 150 * dt
		quad:setViewport(0, y, bgImage:getWidth(), bgImage:getHeight())
	end
end

function love.draw()
	love.graphics.draw(bgImage, quad, 0, 0, 0)
end
```

Let's walk through what's new/unclear for me.

`bgImage:setWrap("repeat", "repeat")`

Seems obvious what's going on here, but I'd rather know than assume. 

[Texture:setWrap](https://love2d.org/wiki/Texture:setWrap)

This is just to set how a texture repeats when drawn within a Quad. In this case we're setting both the horizontal and vertical repeat.

`quad = love.graphics.newQuad(0, 0, bgImage:getWidth(), bgImage:getHeight(), bgImage:getWidth(), gbImage:getHeight())`

[love.graphics.newQuad](https://love2d.org/wiki/love.graphics.newQuad)

The first width and height are for the Quad in the Texture. The second are the size of the texture. But it looks like there's a simpler signature available since 11.0.

`quad = love.graphics.newQuad(0,0, bgImage:getWidth(), bgImage:getHeight(), bgImage)`

That makes more sense, you're just feeding it the image and getting the width and height without having to feed it in. I like it. 

`quad:setViewport(0, y, bgImage:getWidth(), bgImage:getHeight())`

[Quad:setViewport](https://love2d.org/wiki/Quad:setViewport)

Works essentially like a texture offset. This could potential be used to move through sprite sheets, I suspect. Though there are probably better ways to do that. 

`love.graphics.draw(bgImage, quad, 0, 0, 0)`

[love.graphics.draw](https://love2d.org/wiki/love.graphics.draw)

The signature here is `(drawableObject, Quade, xPos, yPos, orientationRadians)`.

Got it. Cool. I think I've solved what I intended to do here. Let's see if we can stack some backgrounds with transparency.

As expected, pretty easy. The default background is black (at least on my system) and will render transparency in pngs as expected. If the draw order is correct, draw the lowest object first, then things will layer appropriately. All you need to do is offset the viewports at different speeds and you get a little bit of parallax. Neat. 

This seems like a good point to stop with this and move on to the next piece. There's definitely some refactoring available to clean this up, but this isn't that step in the process.