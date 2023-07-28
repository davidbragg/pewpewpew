# Friday, July 28, 2023

Tackling this from the [to do](../todo.md) list.

> resize window to 9:16

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
    t.title = "pewpewpew"
    t.window.width = 450
    t.window.height = 800
end
```

That's very easy. I should be able to just reuse that conf file with each experiment as I get further into this. 

I expect that keyboard control is going to be an easy feature here. Something baked in. Let's see if I can figure out

> close on ESC

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

Hah. Just misses putting the parens after the event call. It should have actually been `love.event.quit()`. This is what I get for just trying the function once I see it by name, rather than actually looking at the documentation. 

Everything is working here now.

One thing that bothers me; I'm getting some bullshit at the command line when I run `love .`.

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

It doesn't have if I just run `love` by itself. It is happening regardless of where I run `love .`. It doesn't seem to matter if there's a project in that folder or not. That implies there's something in the loader to run a project from a director throwing this. 

I'm not particularly worried about it for this project.

I was going to do separate folders for each of the experiments, but I think just maintaining that history in the commits is fine. Calling it here for this part, committing/pushing my changes.

A ha! Fuck all that noise! I figured out the bullshit from above. I suspected it was just trying to load something, likely a gaming peripheral. Found this line in the configuration documentation.

`t.modules.joystick = false`

Slapped that baby into my `conf.lua` and all the errors went away. Marvelous. Looks like the joystick module is loaded by default. I don't have a joystick connected. Bullshit.

It'll be worth taking a close looking through the configuration options at some point, I'm sure there's some helpful business in there.
