# pewpewpew

Proof of concept of a vertically scrolling shmup in the style of games like Twin Cobra, 1942, and Raiden. This project was originally started (and abandoned) in [löve](https://love2d.org) but switched into Godot.

This is not a full game, but an exercise to get experience with Godot. See purpose statement below.

### gameplay

* move (WASD or controller analog left stick)
* shoot (space or controller A (Xbox)/X (PS))

Single level with endless waves of enemies. Waves get progressively more difficult the longer the player survives.

Player gets three lives to attempt for a high score.

### known bugs

None currently, though the game is very limited and there's likely something creeping under the surface that I haven't seen yet.

### limitations

The code is definitely chunky. Approaches improved towards the end, but aren't always reflected in old parts of the code. It could definitely be refactored and cleaned up, but this is as far as I'm taking this project.

Some simple UI clean up, sounds, music, and simple death animations would go a long way to cleaning up the presentation/experience.

### purpose

This project was started immediately after the [Pong Clone](https://github.com/davidbragg/pong) and was meant to continue building projects to gain experience with 2D game dev using Godot and GDScript. It is not meant to be a fully featured game.

The project was constrained to a two week, part time development schedule. The feature set was deliberately constrained both to meet the schedule and limit focus primarily to game logic. There is no sound, no level design, the UI is barebones, and only the minimum of control is implemented.

