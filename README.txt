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
See https://github.com/PilzAdam/mobs/wiki

For developers:
This mod add some functions that you can use in other mods:
1. mobs:register_mob(name, def)
	This adds a monster to Minetest that will attack the player
	"name" is the name of the monster ("[modname]:[monstername]")
	"def" is a table with the following values:
		type: the type of the mob ("monster" or "animal")
		hp_max: same is in minetest.register_entity()
		physical: same is in minetest.register_entity()
		collisionbox: same is in minetest.register_entity()
		visual: same is in minetest.register_entity()
		visual_size: same is in minetest.register_entity()
		textures: same is in minetest.register_entity()
		makes_footstep_sound: same is in minetest.register_entity()
		view_range: the range in that the monster will see the player
			and follow him
		walk_velocity: the velocity when the monster is walking around
		run_velocity: the velocity when the monster is attacking a player
		damage: the damage per second
		drops: is list of tables with the following fields:
			name: itemname
			chance: the inverted chance (same as in abm) to get the item
			min: the minimum number of items
			max: the maximum number of items
		armor: the armor (integer)(3=lowest; 1=highest)(fleshy group is used)
		drawtype: "front" or "side"
		water_damage: the damage per second if the mob is in water
		lava_damage: the damage per second if the mob is in lava
		light_damage: the damage per second if the mob is in light
		on_rightclick: its same as in minetest.register_entity()
		attack_type: the attack type of a monster ("dogfight", "shoot",
			maybe somehting like "explode" in the future (creeper))
		arrow: if the attack_type="shoot" needed: the entity name of the arrow
		shoot_interval: the minimum shoot interval
		sounds: this is a table with sounds of the mob
			random: a sound that is played randomly
			attack: a sound that is played when a mob hits a player
2. mobs:register_spawn(name, nodes, max_light, min_light, chance, mobs_per_30_block_radius)
	This function adds the spawning of an animal (without it the
		registered animals and monster won't spawn!)
	"name" is the name of the animal/monster
	"nodes" is a list of nodenames on that the animal/monster can spawn
	"max_light" is the maximum of light
	"min_light" is the minimum of light
	"chance" is same as in register_abm()
	"mobs_per_30_block_radius" is the maximum number of mobs in a 30 block
		radius arround the possible spawning pos
3. mobs:register_arrow(name, def)
	"name" is the name of the arrow
	"def" is a table with the following values:
		visual: same is in minetest.register_entity()
		visual_size: same is in minetest.register_entity()
		textures: same is in minetest.register_entity()
		velocity: the velocity of the arrow
		hit_player: a function that is called when the arrow hits a player
			params: (self, player)
		hit_node: a function that is called when the arrow hits a node
			params: (self, pos, node)

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
