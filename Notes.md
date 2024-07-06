# - __Unknown date:__
	I think it is better to stick with 1920*1080 with a stretch scale of 1 for the viewport,
	because the other options (making it small and scaling, or stretching) are not satisfying.
	This makes everything very zoomed out but it is ok.

# - __2023/12/06:__
	The animations are set up, but there is a lot of dupplication in the code. It's not a big deal.

# - __2023/12/08:__
	I created a new level of State scripts so that the jump variables aren't shared by all States.
	Can Move is useless for now.

# - __2023/12/10:__
	I have to make a choice between letting the player cancel the landing animation
	to jump again or not. I think it is better if he can do it.

# - __2023/12/11:__
	get_global_mouse_position() is a funtion of CanvasItem, so it can't be used directly by
	a simple Node, I had to find a workaround. Another solution could be to change the type of the StateMachine
	parts form Node to Node2D. The firing part is working, but the bullets are moving the player, so I had to
	change the collision mask/layer, I don't know how this will work out but it seems to be a hassle.
	The attack component seems useless.

# - __2023/12/17:__
	For the melee attack, it seems difficult to rotate or flip the player so that it hits on the left,
	I think I'm going to have the attack all around the player. The problem of having a big square
	CollisionShape2D is that it detects the player as well, so I go for a ring of 4 different shapes.
	It actually doesn't work xd. Whatever (the hitbox detects the player as well, will have to exclude the player
	from the check). Something will have to be done for the animation.
	I think the components aren't done correctly, like the HBC needs a reference to the HB, but doesn't use it.

# - __2023/12/18:__
	Trying to make an explosion for Weapon3. The solution I'm implementing is to add an Area2D with
	a CollisionShape2D to every enemy so that the exploding bullet can detect them. (2023/12/21) Apparently it
	might work with toggling the monitoring of an Area2D and await keyword. Idk.

# - __2023/12/20:__
	The HitBoxComponent seems useless, I'll keep it in the files just in case but I'll remove it's use
	from the actual game.

# - __2024/06/26:__
	Having a weird error, that doesn't lead to a piece of code: 
	":E 0:00:18:0410   emit_signalp: Error calling from signal 'body_entered' to callable: 
	'Area2D(area_of_effect.gd)::_on_body_entered': Method not found.
	<C++ Source>   core/object/object.cpp:1082 @ emit_signalp()"
	It seems to be caused when a rocket (Weapon 3) hits a target. Idk.
	I think I fixed it now, it was because I commented a script but not all the references (cf commit).

# - __2024/07/01:__
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
# - __2024/07/03:__
	I need to correct the fact that the damage label (health_changed_label) does not appear when on the killing
	blow on the concerned scene, probably because the main node is queue-freed when it dies. I think I should
	try and make it so that the label and the manager can exist without its parent node, ergo a way to find them
	a new parent. Actually it's not how it seems to be working, idk. Actually, the manager is stand alone but
	the label is a child of the enemy/player node. Maybe I could circonvate (?) this by adding an obligatory 
	animation at death. Nah, this is not it, the character can still be damaged after being dead, I need to
	deactivate it somehow.
	Need to also stop the health from going under 0, should be fixed by making the character un-affected by
	environment.
	There is still the option of not making the label a child of the character, but that won't leave an easy
	possibility for the death animation, apart from creating a new sprite on the location, but then it wouldn't
	move. Idk.
	I need to find a way to make the deactivate_node() function do its thing inside the class script and not
	the extended scripts.
	What I have done currently, is that the enemy's hitbox is disabled when it dies, so it falls through the map.
	I kinda like it. It raises the issue of the z axis for the enemies: currently, they are at the front, so we can
	see them when they fall; if I was to put them in the back, we wouldn't I think see them through the ground,
	that would require a script to change the z order during runtime. I don't know what is best.
	## __IMPORTANT NOTE:__ THE Area2D AND THE CollisionShape2D ATTACHED TO THE ENEMIES ARE IMPORTANT FOR BULLET 3.
# - __2024/07/04:__
	I'm trying to make the falling dead bodies disappear when out of the screen, but I just stumbled upon a weird
	bug: killing with the melee weapon does not make the body fall. Hum...
	There is an error when the enemy is killed by the melee weapon, but not if it is killed by another weapon.
	The error says to defer the hit_box.disabled = true set instead, but then they fall in none of the cases.
	I'm gonna commit so I can see what I doing.
	Maybe clearing the error would solve the issue?
	__Error:__
		E 0:00:04:0551   character_class.gd:48 @ deactivate_node(): Can't change this state while flushing queries.
		Use call_deferred() or set_deferred() to change monitoring state instead.
		  <C++ Error>    Condition "body->get_space() && flushing_queries" is true.
		  <C++ Source>   servers/physics_2d/godot_physics_server_2d.cpp:654 @ body_set_shape_disabled()
		  <Stack Trace>  character_class.gd:48 @ deactivate_node()
						 character_class.gd:34 @ death()
						 health_component.gd:36 @ damage()
						 melee_weapon.gd:28 @ _on_body_entered()

	It worked, but it is important to note that call_deferred has to be "x.call_deferred("y", args)" and not
	"call_deferred("x.y", args). Stupid fat Hobbit.
	
	Will have to solve the issue of the window size at some point.
	
	Will have to do something about the fact that the player can still move after dying. What about respawn?
	
	Trying to do the disappear trick, not managing to do it in the superclass (yet). I don't think it is
	possible to do it in character_class fully, because I need to somehow connect to the VisibleOnScreenNotifier2D
	and I don't know if it is possible. The middle-of-the-road thing to do is to connect to the signals in each
	subclass, and then call a procedure of the superclass that does the thing. That is what I'm going to do.
# - __2024/07/05:__
	I don't think I'm gonna use HitState in the long run, like I think I should not have a specific state for when
	the enemy is hit, but rather do the hit code in the main script or something, not to affect the behavior.
	Maybe a knockback or a stun, but than can be done otherwise. Keeping it there for now though.
	I think there is something wrong with the variables of player.gd and movement_state.gd, might need to fix that
	later.
	I'm having trouble understanding an issue with move_speed. Maybe it would be better to use character.move_speed
	in the scripts.
	I don't know if it is correct to use the state variable as they are currently. Like it's really ugly when I
	affect them all in the character state machine, but if not I have to call character.x each time (instead of
	just x).
	I'm gonna commit as is, even though the character.move_speed issue is not resolved.
	(the following may be on the wrong day)
	Maybe the move_speed issue is casued by the fact that the character state machine is ready before the
	character class (player and enemy). Not sure.
	## __IMPORTANT NOTE:__
		_ready() is called in the children nodes first, then in the parent node. This is the cause of the above
		issue.
# - __2024/07/06:__
	Changing the map so that the tupid enemies don't fall off of it.
	Changed the viewport and all the shit (Changed the parameters of display, from a 960 * 540 Viewport to
	1920 * 1080, from windowed to fullscreen, stretch mode canvas_item and aspect expand, and from canvas texture
	filter linear to nearest. Basically, the window is bigger, the pixel art is rendered better, and the game is
	not too zoomed in, but maybe this is a mistake, I'm not too sure. Anyway, this can always be changed later
	(it might be necessary, for compatibility with smaller and bigger screens.)). I don't really know what to do
	about that, but the good news is it can always be changed later if need be. Actually this is a bad idea for now,
	I need the small window to debug.
	When using the melee weapon, if you press against enemies and kill them, you can, by advancing, hit an enemy
	farther behind. This means that the AoE stays for longer than it should, I think. Does it need fixing, or is it
	a feature? Technically, an AoE can be extended in time, it is not stupid to think.
	I was trying to solve the issue to move_speed, because it should be different for wander and follow,
	for instance, and I would like to make it a superclass variable, and it should be different for the different
	enemies. Idea: have the speed be randomized, in a range of like speed/2 to speed, idk. That way, it can
	vary during runtime, and it can be fixed in the enemy script.
	Unit tests? Asserts instead.
