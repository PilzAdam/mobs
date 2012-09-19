=== MOBS-MOD for MINETEST-C55 ===
by PilzAdam

Inroduction:
This mod adds some basic hostile and friendly mobs to the game.

How to install:
Unzip the archive an place it in minetest-base-directory/mods/minetest/
if you have a windows client or a linux run-in-place client. If you have
a linux system-wide instalation place it in ~/.minetest/mods/minetest/.
If you want to install this mod only in one world create the folder
worldmods/ in your worlddirectory.
For further information or help see:
http://wiki.minetest.com/wiki/Installing_Mods

How to use the mod:
There are 4 hostile mobs that want to kill the player:
- The dirt monster spawns at night on grass and get killed on day when
  its too light.
- The stone monster spawns on stone and is stronger but slower than the
  dirt monster
- The desert monster spawns in deserts and is faster but less strong
  than the dirt monster
- The oerkki is the same as in 0.3. It spawns in realy dark caves and
  is stronger than the dirt monster.
There are also 2 friendly mobs:
- The sheep spawns on grass. You can get wool from it when you rightclick
  it and meat if you kill it. Meat can bee cooked in the furnace to eat it.
- The rat is the same as in 0.3. You can cook it or replace it in the
  world if you catched it with an rightclick.

For developers:
This mod add some functions that you can use in other mods:
1. mobs:register_monster(name, def)
	This adds a monster to Minetest that will attack the player
	"name" is the name of the monster ("[modname]:[monstername]")
	"def" is a table with the following values:
		hp_max: same is in minetest.register_entity()
		physical: same is in minetest.register_entity()
		collisionbox: same is in minetest.register_entity()
		visual: same is in minetest.register_entity()
		visual_size: same is in minetest.register_entity()
		textures: same is in minetest.register_entity()
		makes_footstep_sound: same is in minetest.register_entity()
		view_range: the range in that the monster will see the player
			and follow him
		walk_velocity: the velocity when the monster is walking arround
		run_velocity: the velocity when the monster is attacking a player
		damage: the damage per second
		light_resistant: light wont cause damage on day
		drop: the drop item of the monster
		drop_count: the number of items that are dropped
		armor: the armor (integer)(3=lowest; 1=highest)(fleshy group is used)
		drawtype: "front" or "side"
2. mobs:register_animal(name, def)
	This adds a animal to Minetest that will just walk arround
	"name" is the name of the monster ("[modname]:[animalname]")
	"def" is the same table as in register_monster but without these values:
		-view_range
		-run_velocity
		-damage
		-light_resistant
		-armor
		and it also has the field
		-on_rightclick: its same as in minetest.register_entity()
3. mobs:register_spawn(name, nodes, max_light, min_light)
	This function adds the spawning of an animal (without it the
		registered animals and monster won't spawn!)
	"name" is the name of the animal/monster
	"nodes" is a list of nodenames on that the animal/monster can spawn
	"max_light" is the maximum of light
	"min_light" is the minimum of light

License:
Sourcecode: WTFPL (see below)
Grahpics: WTFPL (see below)

See also:
http://minetest.net/

         DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
                    Version 2, December 2004

 Copyright (C) 2004 Sam Hocevar <sam@hocevar.net>

 Everyone is permitted to copy and distribute verbatim or modified
 copies of this license document, and changing it is allowed as long
 as the name is changed.

            DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
   TERMS AND CONDITIONS FOR COPYING, DISTRIBUTION AND MODIFICATION

  0. You just DO WHAT THE FUCK YOU WANT TO. 
