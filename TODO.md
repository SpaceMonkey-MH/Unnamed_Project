NOT DONE :

- Comment the code.
- Make the explosion of the rockets damage in a matrix.
- Finish the code in hit_state.
- Finish the code for test_moving_enemy, should be a state machine and all the tintouin.
- To do when the options are set up: try to move the self_damage assign in bullet_3.gd to _ready() instead
	(Use a global signal? That would be swag for sure.).
- Handle the part where the characters fall when they die (animation).
- Handle the part where the characters fall when they die (sound).
- Give a brain to the enemies.
- Make it so that you can't shoot when clicking on the UI.
- Add easter eggs, such as a button that screams.
- Add funny descriptions to the weapons.
- Solve window size issue.
- Fix the variables of player.gd and movement_state.gd.
- Solve possible issue: jump animation playing when falling (at beginning).
- Fix the rolling (landing) animation when going backwards.
- Fix the melee weapon AoE bug (cf 2024/07/06)?
- Unit tests? Asserts.
- Make enemies stop between two wanderings.
- Change the z-order of labels so that they are in front of tile map (or change the z-order of the tile map).
- Complete the AttackState script.
- Implement blast of the explosion of rockets and so on, like move the characters when hit.

------------------------------------------------------------------------------------------------------
DONE :

- Fix the issue with the heal popping up when the health is set at the beginning of the game. // DONE.
- Make it so that the double jump animation resets when triple jumping quickly. // DONE.
- Fix the error of AoE in bullet 3. //DONE.
- Fix the AoE of bullet 3 when the player is close to the explosion. // DONE.
- Solve the issue of the player body sprite flip. //DONE.
- Solve the issue where the damage label doesn't show on the killing hit. // DONE.
- Solve the issue where the dead characters can still be hit after their death. //DONE.
- Handle the part where the characters fall when they die (make them disappear when out of the screen). //DONE.
- Make the enemies stackable on each other ? // DONE I think.
- Give legs to the enemies. //DONE.
- Make transitions to AttackState. //DONE.
- Solve the "pressed against wall" glitch. Cf Notes.md (line 175). // DONE (twice).
- Solve the HitState issue when it leaves the state immediatly. // DONE.
