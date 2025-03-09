# pewpewpew

Proof of concept of a vertically scrolling shmup in the style of Twin Cobra, 1942, and Raiden. This project was originally started (and abandoned) in [löve](https://love2d.org) and later switched to Godot.

This is not a full game, but an exercise to get experience with Godot. See purpose statement below.

See [itch.io page](https://heavyliftingindustries.itch.io/pewpewpew) for builds (Linux or Windows) or build your own. Latest build in Godot 4.4.

### gameplay

* move (WASD or controller analog left stick)
* shoot (space or controller A (Xbox)/X (PS))
* auto fire - hold shoot

Single level with endless waves of enemies. Waves get progressively more difficult the longer the player survives.

Player gets three lives to attempt for a high score.

### known bugs

None that I know of. There's almost certainly something creeping under the surface that I haven't seen yet.

### limitations

The code is definitely chunky. Approaches improved towards the end, but aren't always reflected in older parts of the codebase. It could definitely be refactored and cleaned up.

Some basic sound and particle effects have been included. Still pending some music before I consider this complete.

### purpose

This project was started immediately after finishing work on [Pong Clone](https://github.com/davidbragg/pong) and was meant to continue building projects to gain experience with 2D game dev using Godot and GDScript. It is not meant to be a fully featured game.

The project was constrained to a two week, part time development schedule. The feature set was deliberately constrained both to meet the schedule and limit focus primarily to game logic. The initial design was limited to exclude sound or level design. Only the minimum of UI or control was implemented.

A subsequent update added basic sound and particle effects. Music is still pending.

### license

The code is MIT.

The assets are CC BY-SA 4.0.
