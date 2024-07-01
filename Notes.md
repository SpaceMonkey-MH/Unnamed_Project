- I think it is better to stick with 1920*1080 with a stretch scale of 1 for the viewport,
	because the other options (making it small and scaling, or stretching) are not satisfying.
	This makes everything very zoomed out but it is ok.

- 2023/12/06:
	The animations are set up, but there is a lot of dupplication in the code. It's not a big deal.

- 2023/12/08:
	I created a new level of State scripts so that the jump variables aren't shared by all States.
	Can Move is useless for now.

- 2023/12/10:
	I have to make a choice between letting the player cancel the landing animation
	to jump again or not. I think it is better if he can do it.

- 2023/12/11:
	get_global_mouse_position() is a funtion of CanvasItem, so it can't be used directly by
	a simple Node, I had to find a workaround. Another solution could be to change the type of the StateMachine
	parts form Node to Node2D. The firing part is working, but the bullets are moving the player, so I had to
	change the collision mask/layer, I don't know how this will work out but it seems to be a hassle.
	The attack component seems useless.

- 2023/12/17:
	For the melee attack, it seems difficult to rotate or flip the player so that it hits on the left,
	I think I'm going to have the attack all around the player. The problem of having a big square
	CollisionShape2D is that it detects the player as well, so I go for a ring of 4 different shapes.
	It actually doesn't work xd. Whatever (the hitbox detects the player as well, will have to exclude the player
	from the check). Something will have to be done for the animation.
	I think the components aren't done correctly, like the HBC needs a reference to the HB, but doesn't use it.

- 2023/12/18:
	Trying to make an explosion for Weapon3. The solution I'm implementing is to add an Area2D with
	a CollisionShape2D to every enemy so that the exploding bullet can detect them. (2023/12/21) Apparently it
	might work with toggling the monitoring of an Area2D and await keyword. Idk.

- 2023/12/20:
	The HitBoxComponent seems useless, I'll keep it in the files just in case but I'll remove it's use
	from the actual game.

- 2024/06/26:
	Having a weird error, that doesn't lead to a piece of code: 
	":E 0:00:18:0410   emit_signalp: Error calling from signal 'body_entered' to callable: 
	'Area2D(area_of_effect.gd)::_on_body_entered': Method not found.
	<C++ Source>   core/object/object.cpp:1082 @ emit_signalp()"
	It seems to be caused when a rocket (Weapon 3) hits a target. Idk.
	I think I fixed it now, it was because I commented a script but not all the references (cf commit).

- 2024/07/01:
	Currently, when the rocket (bullet_3) of weapon_3 hits a target while the player is in range
	of the explosion, it damages only the main target, not in an AoE, because when the algorithm
	finds the Player it returns. Leaving it as is would be nonsensical, so I see three solutions:
		- Take the return off, thus correcting (should be) the issue but making it so that the player
		can damage themselves, and possibly raisng additional issues because the player health might not
		be ready for the damaging yet.
		- Try to work around the issue, and to find a way to do nothing in the loop if this is a player. Wait,
		can't I just put everything in an if statement ?
		- Do both, but putting it in the difficulty settings or something, like "allow self damaging".
	I think I'll try the third option. Aftermaths : IT WORKS! For some reason I had almost all the parts
	I needed, now I "just" need to connect it to the options. LoL.
