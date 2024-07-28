## - __Unknown date:__
	I think it is better to stick with 1920*1080 with a stretch scale of 1 for the viewport,
	because the other options (making it small and scaling, or stretching) are not satisfying.
	This makes everything very zoomed out but it is ok.

## - __2023/12/06:__
	The animations are set up, but there is a lot of dupplication in the code. It's not a big deal.

# - __2023/12/08:__
	I created a new level of State scripts so that the jump variables aren't shared by all States.
	Can Move is useless for now.

## - __2023/12/10:__
	I have to make a choice between letting the player cancel the landing animation
	to jump again or not. I think it is better if he can do it.

## - __2023/12/11:__
	get_global_mouse_position() is a funtion of CanvasItem, so it can't be used directly by
	a simple Node, I had to find a workaround. Another solution could be to change the type of the StateMachine
	parts form Node to Node2D. The firing part is working, but the bullets are moving the player, so I had to
	change the collision mask/layer, I don't know how this will work out but it seems to be a hassle.
	The attack component seems useless.

## - __2023/12/17:__
	For the melee attack, it seems difficult to rotate or flip the player so that it hits on the left,
	I think I'm going to have the attack all around the player. The problem of having a big square
	CollisionShape2D is that it detects the player as well, so I go for a ring of 4 different shapes.
	It actually doesn't work xd. Whatever (the hitbox detects the player as well, will have to exclude the player
	from the check). Something will have to be done for the animation.
	I think the components aren't done correctly, like the HBC needs a reference to the HB, but doesn't use it.

## - __2023/12/18:__
	Trying to make an explosion for Weapon3. The solution I'm implementing is to add an Area2D with
	a CollisionShape2D to every enemy so that the exploding bullet can detect them. (2023/12/21) Apparently it
	might work with toggling the monitoring of an Area2D and await keyword. Idk.

## - __2023/12/20:__
	The HitBoxComponent seems useless, I'll keep it in the files just in case but I'll remove it's use
	from the actual game.

## - __2024/06/26:__
	Having a weird error, that doesn't lead to a piece of code: 
	":E 0:00:18:0410   emit_signalp: Error calling from signal 'body_entered' to callable: 
	'Area2D(area_of_effect.gd)::_on_body_entered': Method not found.
	<C++ Source>   core/object/object.cpp:1082 @ emit_signalp()"
	It seems to be caused when a rocket (Weapon 3) hits a target. Idk.
	I think I fixed it now, it was because I commented a script but not all the references (cf commit).

## - __2024/07/01:__
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

## - __2024/07/03:__
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
	I kinda like it. It raises the issue of the Z axis for the enemies: currently, they are at the front, so we can
	see them when they fall; if I was to put them in the back, we wouldn't I think see them through the ground,
	that would require a script to change the Z index during runtime. I don't know what is best.
	## __IMPORTANT NOTE:__ THE Area2D AND THE CollisionShape2D ATTACHED TO THE ENEMIES ARE IMPORTANT FOR BULLET 3.

## - __2024/07/04:__
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

## - __2024/07/05:__
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

## - __2024/07/06:__
	Changing the map so that the stupid enemies don't fall off of it.
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

## - __2024/07/07:__
	The max health issue: is there a maximum amount of health? I think yes, because if would be harder to make a
	health bar otherwise. But Maybe I shouldn't make a health bar, I don't know. If so, where is the check?
	In the setter? In the value assignment? Let's try in the setter; that way, it is done each time, no questions
	asked. Seems to be working.
	Also, what to do with this healh setting issue? Like, how to make it so that there is no weird error, nor
	a weird heal pop up at the beginning of the program? I'll try and give arguments to the setter. Or, I could
	assign the value @onready. Let's try that. Seems to be working.
	Should everything be centralized ? For instance, should the max_health be a variable of the character, or
	of the health_component? I just put it in character superclass, seems fine.

## - __2024/07/08:__
	Not sure whether I should put the enemy states variables, such as follow_distance, in the states, so that it is
	as local as possible, or in the main enemy script, so that it is easier to set up.
	About FollowState: I could reset character.velocity.x, but I think it's not that bad if the enemy keeps
	going after changing state, maybe I could transition back to this state after each attack. To be tested.
	I think there is not need for a transition from WanderState to AttackState, as it goes through FollowState
	anyway.
	I think i'm gonna confine myself to one attack (animation, damage, etc) per enemy type. I'm not gonna
	add several state machines to the enemies.
	The Player falls faster than the other characters, this is intended, it adds to the nervosity.
	There is something wrong with the attack state of the enemy: if the player leaves the range, then enters
	it again, the attack resets. I need to find a better way. Also, the attack happens after the leave. Could try
	and stop the timer in on_leave(), but I don't think that solves the issue of the reset. Will have to see.
	Actually, it's "on_exit()", you dumbfuck.
	Yeah, I'm gonna switch Godot versions mid-project, let's see how it goes. Seems fine.
	The stopping the timer or whatnot shit worked! Actually it is more complicated than that, but whatever.

## - __2024/07/09:__
	The enemy take_damage() procedure is not good. I need to handle it with HitState somehow.
	Should I put the x_state variables in superclass to avoid boilerplate code? I think not, because that would
	lead to useless stuff in editor (@export variables).
	I think the enemies sould stop when hit, but I can always change it later.
	At some point, I'm gonna need to figure out a way to avoid glitching when pressed against wall by enemy.
	Maybe by making the enemy and the player stackable? Or by checking if the enemy is angainst the player
	in the enemy script? I prefer the second option, as it allows the player to jump on the enemies.
	I think that technically, I only need to do that check in attack_state, because it is the only state in which
	the enemy could be close enough to the player. It works. I am proud of myself.
	Method overriding.

## - __2024/07/10:__
	First, there is an issue with the "stun" of the enemy (when hit), it doesn't seem to refresh properly.
	Second, maybe I don't need to stun, idk. Guess it would depend on the type of weapon.
	So, the HitState gets entered, and left immediatly. Why? So, when hit again before the end of the "stun",
	the enemy enters some kind of a bugged state where, if the state is WanderState, the enemy is impervious
	to stuns, it does enter HitState, but only for a split second. Solved using interrupt_state() instead of 
	next_state.
	Other issue: the enemy hugs too close, the player can still get stuck against walls. Increasing the margin
	did it. Solved.
	Just had an idea for the direction code: divide distance by abs(distance) (except if 0 ofc). Nah,
	that doesn't work with the margin.
	Issue: the enemy can still attack the player after dying. Solution (?): check the 2D distance for the
	attack, instead of the 1D distance. Other solution: have the attack stop when dead. Maybe cleaner.
	Both worked, gonna keep the second one.

## - __2024/07/11:__
	There is something weird with the melee attack of the player, and thus of the enemy. Will have to solve
	that. Maybe the melee weapon does not need a cooldown?
	Fixed the way the player melee attack works, but there still is the issue of the attack lasting after its end
	(when attacking while moving, the player can attack farther than its range). Is it really an issue? That
	the attack lasts for the whole "animation"? Idk, might cause issues if the cooldown gets longer.
	Fixed it by adding an await timer, but it's not pretty that way, and might lead to issues. Also, moved
	the monitoring set to false to just after the timer and the set to true,
	here because otherwise it collides with a new timer, I think.
	Fixed the melee enemy attack, made it the same way the player's is.

## - __2024/07/12:__
	I think it is time to consider the story, and more generally the global vision for the game.
	I'll go and create a Story.md document.

## - __2024/07/14:__
	(following line 76) I changed the Z index of the labels of the characters, thus making them in front
	of the tile map (the walls and ground), so they can be seen even when the character is close to a wall
	or falling through the ground. I didn't change the index of the tile map, because it had to be in front of
	the characters so that they are behind the grass.
	Change the Z index of the enemies. Done, I actually solved a potential issue where the player was displayed
	behind the grass not because of its set Z index, but because of the load oreder of the level scene. Now,
	all the characters are displayed as behind the grass no matter the order of the scenes in the level. Also,
	this broke line 209, so I fixed it again.
	Check what happens with the attack of the enemy (weird timings). The attack of the enemy seems to come
	only a while after the player entered the range. This is the objective, but it shouldn't be the case
	right now, so it is weird. Like, what I want to do, is a system where there is a pre-attack cooldown and
	a post-attack cooldown (and only the post is running when out of range), so that the enemy can be kited,
	but this is not it. First of all, it shouldn't be in place as of now, and second of all, it doesn't seem
	to be the right thing here, like it is only sometimes that it does it. Weird. Problem for tomorrow me.
	Weird issue: the TME only needs 2 40dmg hits to die, or 5 20dmg, which doesnt make no sense. So, the damage
	is applied twice, but not tot the others, which is strange. So, the issue was that the aoe damage checks
	for overlapping areas, but TME had two: the regular one, and the weapon. The dummies have the regular one,
	and the player has a melee weapon, but the TME has both, so it gets hits twice. I need to check if it is the
	regular one. Solved now.

## - __2024/07/15:__
	(cf line 228) The issue was that the attack_range was different from the radius of the weapon's CollisionShape2D.
	Now, both are linked. But there is a different issue: if the attack_range is longer than the follow_range,
	the enemy starts attacking only after entering the follow_range, and continues after leaving it, which
	feels weird. Two possible solutions: 
		-> Adding state transition from wander to attack. That is clean, but a bit weird. Also, blocks potential
		shenanigans with varying enemy range, don't know yet if it is a big deal.
		-> Link the follow_distance to the attack_range. I don't know what this does.
	I think I'm gonna go with the first option. This is still weird, but less weird.
	Issue with the dist_to_explosion in bullet_3.gd: the distance is taken from the center of the character,
	so big enemies won't be hit as much as small ones, which is bad. Possible solution: try and get the size
	of the enemy. Other lead: try to hit on the edge. Will need help for that one, so I'll save it for later.
	For the first solution, I think I'll go and get the size of the "HitBox" node, and let's hope there's one.
	Leading to another issue: the HitBox can be of many shapes. The easiest one would be circle, as it is
	the same distance everywhere. The rectangle is tougher, beacause the size depends on the direction. Maybe
	I need help.
	Alternative solution: have various damaging circles. I don't think it solves it.
	Solution: Ray-casting? Maybe this could replace the follow_range shit as well. Idk.

## - __2024/07/16:__
	Ray-casting. Idk how many rays to cast, but that's okay. However, I need to make sure that the targets aren't
	hit multiple times. I'm thinking about a list of already hit targets.
	According to my findings, the angle I'm looking for (the rotation angle for the ray-cast, that is to say
	the rate at which the ray-cast will be checking) is (for a ray length of L and a character size (chord) of l):
	theta = arcsin(l / 2 * L).
	(Cf https://www.youtube.com/watch?v=GY43DI8e4jM)
	It is broken for now, but there still is the old code so it is an easy fix. I don't think the code needs
	much more to function. Let me explain: I tried to make the AoE damage depend on the distance from the
	explosion, but it was difficult or impossible by using overlapping areas, so I tried ray-casting.
	It is not working as it should yet, but it is on the right tracks. However, it might not be the
	expected result, as the ray, thus the damage, stops at the first encounter. This might work for a
	different weapon, possibility to be explored. I think I'll do both, in two separate weapons.
	Or, I could try and pierce through the collided characters by cycling ray-cast and adding the found dudes
	to the exception list. I'll keep both just in case.
	Or, or, or, I could leave the ray-casting as is, without evading dupplicate damage, and thus allowing for
	more damage close, less damage far, which is what I wanted from the beginning. Would require balancing though.

## - __2024/07/17:__
	Water? Inverted gravity?
	Achievements? Will be hard.
	I was thinking about the way the levels will work, and maybe I could have one level per weapon other that the
	basic one, accessible in any order wanted, and then when all weapons are unlocked, the final level. That would
	require the ability to have different saves, which is hard, but interesting.
	RayCastingTestCharacter is full broken, but I have the flemme to fix it, for now it is ok, anyway I won't use
	it in the game.
	(cf line 273) Or I could use this technology to make a shotgun. Hum... Both?
	The damaging of the AoE with ray-casting is not consistent. This is concerning.
	Apparently there's this thing called "shape-casting", seems promising.
	Okay, this shit is boring me. i'll try the shape-casting, and if it doesn't work, fuck it, I'll do the
	overlapping areas.
	Or, I could have a fragmentation thing, creating several other projectiles.
	Or I could do a nova, progressively expanding and damaging (creating dictionaries of
	[character_hit : point_hit]).
	I changed the hitbox of the tilemap, it is now less realistic but should not cause head-bumping issues as
	before (it did on the left side of the column).

## - __2024/07/19:__
	It seems like I didn't need to have Area2D to get the overlapping, that could be done on bodies instead. Yay...
	I'm sick of this shit, I'm gonna go with the successive overlapping areas to do the trick. If this doesn't work,
	I don't know what I'm gonna do.
	For the record, the correct formula for the damage was:
		attack.attack_damage = aoe_attack_damage - size / (aoe_size / aoe_attack_damage)
	Now, it is:
		attack.attack_damage = aoe_attack_damage / (aoe_size / prog_index)
	IMPORTANT FOR TOMORROW: What I'm trying to do, is to create the "matrix" damage. For that, I'm iterating
	over aoe_size to create a new CollisionShape2D inside a new Area2D inside the AOEList Node, each time.
	Then, I would iterate again, on the children of AOEList, to get overlapping bodies and then damaging them.
	SHOULD work.

## - __2024/07/20:__
	The player doesn't get queue_free() when out of screen because he doesn't have a VisibleOnScreenNotifier2D node
	attached, unlike the enemies. This is fine for now, but death will have to be dealt with.
	The Aoe finally works! has two issues though: 
		- Only a part of the damage is applied (the outer circles),
		and I fear it is because it only hit enemies which have their center inside the AoE.
		- The damage label thingy doesn't correctly show the damage, as they are all grouped up.
		Will commit nonetheless.

## - __2024/07/21:__
	Fixed the explosion yesterday, but the label was still fucked. Fixed that.
	This works, but the issue might be that it doesn't display heals and damages on the same frame, might have to
	separate the two (like, have two dictionaries?). Will do that later.

## - __2024/07/24:__
	There is something weird with the way the input events are handled in the weapon scripts. I don't remember how
	it works, will have to go down on that.

## - __2024/07/25:__
	When a character dies, it falls through the ground. But, because the character has to be behind the grass,
	it is also behind the ground (else, it would require a second tile map or something; actually, super easy,
	barely an inconvenience).
	I was going for changing the Z-order of the characters at runtime when they die, but it is easier to change
	that of the tile map, as it can be set for each individual tile, therefore can be low for the tile map, and
	high for the grass tiles. Changed the Z-index of the player, don't know why it was at -1, might cause issues
	in the future. Actually, it is weird that the character falls behind the grass but in front of the ground...
	Should also work for the labels.
	Idk. I think I should do both, it doesn't cost much.
	Wait, no, now a part of the player can be seen below the grass during landing animation. I'm gonna go with the
	first solution.
	Still feels kinda weird, the character jumps in front of the grass, but meh.
	For the shotgun, I hesitate between creating small projectiles and using ray-casting to emulate them. I would
	like to use ray-casting, which would be easier for the damage, but it would leave a difficulty for the visual
	part. I think I'll go for the multiple projectiles one.
	Need to decide if sawed-off barrel or pump-action shotgun.

## - __2024/07/28:__
	Finished shotgun.gd, raised a potential issue that the character die instantly, so if they are hit by multiple
	projectiles for more than their health, the remaining projectiles might pass through. Don't know if it's a
	good thing. Also, the health changed manager is kinda lost with this, might display several hits instead of
	one, Idk what to think about that.
