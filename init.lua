dofile(minetest.get_modpath("mobs").."/api.lua")

mobs:register_mob("mobs:dirt_monster", {
	type = "monster",
	hp_max = 5,
	collisionbox = {-0.4, -1, -0.4, 0.4, 1, 0.4},
	visual = "upright_sprite",
	visual_size = {x=1, y=2},
	textures = {"mobs_dirt_monster.png", "mobs_dirt_monster_back.png"},
	makes_footstep_sound = true,
	view_range = 15,
	walk_velocity = 1,
	run_velocity = 3,
	damage = 2,
	drops = {
		{name = "default:dirt",
		chance = 1,
		min = 3,
		max = 5,},
	},
	armor = 3,
	drawtype = "front",
	water_damage = 1,
	lava_damage = 5,
	light_damage = 2,
	on_rightclick = nil,
	attack_type = "dogfight",
})
mobs:register_spawn("mobs:dirt_monster", {"default:dirt_with_grass"}, 3, -1, 7000, 3)

mobs:register_mob("mobs:stone_monster", {
	type = "monster",
	hp_max = 10,
	collisionbox = {-0.4, -1, -0.4, 0.4, 1, 0.4},
	visual = "upright_sprite",
	visual_size = {x=1, y=2},
	textures = {"mobs_stone_monster.png", "mobs_stone_monster_back.png"},
	makes_footstep_sound = true,
	view_range = 10,
	walk_velocity = 0.5,
	run_velocity = 2,
	damage = 3,
	drops = {
		{name = "default:mossycobble",
		chance = 1,
		min = 3,
		max = 5,},
	},
	light_resistant = true,
	armor = 2,
	drawtype = "front",
	water_damage = 0,
	lava_damage = 0,
	light_damage = 0,
	attack_type = "dogfight",
})
mobs:register_spawn("mobs:stone_monster", {"default:stone"}, 3, -1, 7000, 3)


mobs:register_mob("mobs:sand_monster", {
	type = "monster",
	hp_max = 3,
	collisionbox = {-0.4, -1, -0.4, 0.4, 1, 0.4},
	visual = "upright_sprite",
	visual_size = {x=1, y=2},
	textures = {"mobs_sand_monster.png", "mobs_sand_monster_back.png"},
	makes_footstep_sound = true,
	view_range = 15,
	walk_velocity = 1.5,
	run_velocity = 4,
	damage = 1,
	drops = {
		{name = "default:sand",
		chance = 1,
		min = 3,
		max = 5,},
	},
	light_resistant = true,
	armor = 3,
	drawtype = "front",
	water_damage = 3,
	lava_damage = 1,
	light_damage = 0,
	attack_type = "dogfight",
})
mobs:register_spawn("mobs:sand_monster", {"default:desert_sand"}, 20, -1, 7000, 3)

mobs:register_mob("mobs:sheep", {
	type = "animal",
	hp_max = 5,
	collisionbox = {-0.6, -0.625, -0.6, 0.6, 0.625, 0.6},
	visual = "upright_sprite",
	visual_size = {x=2, y=1.25},
	textures = {"mobs_sheep.png", "mobs_sheep.png"},
	makes_footstep_sound = true,
	walk_velocity = 1,
	armor = 3,
	drops = {
		{name = "mobs:meat_raw",
		chance = 1,
		min = 2,
		max = 3,},
	},
	drawtype = "side",
	water_damage = 1,
	lava_damage = 5,
	light_damage = 0,
	
	on_rightclick = function(self, clicker)
		if self.naked then
			return
		end
		if clicker:get_inventory() then
			self.naked = true,
			clicker:get_inventory():add_item("main", ItemStack("wool:white "..math.random(1,3)))
			self.object:set_properties({
				textures = {"mobs_sheep_naked.png", "mobs_sheep_naked.png"},
			})
		end
	end,
})
mobs:register_spawn("mobs:sheep", {"default:dirt_with_grass"}, 20, 8, 9000, 0)

minetest.register_craftitem("mobs:meat_raw", {
	description = "Raw Meat",
	inventory_image = "mobs_meat_raw.png",
})

minetest.register_craftitem("mobs:meat", {
	description = "Meat",
	inventory_image = "mobs_meat.png",
	on_use = minetest.item_eat(8),
})

minetest.register_craft({
	type = "cooking",
	output = "mobs:meat",
	recipe = "mobs:meat_raw",
	cooktime = 5,
})

mobs:register_mob("mobs:rat", {
	type = "animal",
	hp_max = 1,
	collisionbox = {-0.25, -0.175, -0.25, 0.25, 0.1, 0.25},
	visual = "upright_sprite",
	visual_size = {x=0.7, y=0.35},
	textures = {"mobs_rat.png", "mobs_rat.png"},
	makes_footstep_sound = false,
	walk_velocity = 1,
	armor = 3,
	drops = {},
	drawtype = "side",
	water_damage = 0,
	lava_damage = 1,
	light_damage = 0,
	
	on_rightclick = function(self, clicker)
		if clicker:is_player() and clicker:get_inventory() then
			clicker:get_inventory():add_item("main", "mobs:rat")
			self.object:remove()
		end
	end,
})
mobs:register_spawn("mobs:rat", {"default:dirt_with_grass", "default:stone"}, 20, -1, 7000, 1)

minetest.register_craftitem("mobs:rat", {
	description = "Rat",
	inventory_image = "mobs_rat.png",
	
	on_place = function(itemstack, placer, pointed_thing)
		if pointed_thing.above then
			minetest.env:add_entity(pointed_thing.above, "mobs:rat")
			itemstack:take_item()
		end
		return itemstack
	end,
})
	
minetest.register_craftitem("mobs:rat_cooked", {
	description = "Cooked Rat",
	inventory_image = "mobs_cooked_rat.png",
	
	on_use = minetest.item_eat(3),
})

minetest.register_craft({
	type = "cooking",
	output = "mobs:rat_cooked",
	recipe = "mobs:rat",
	cooktime = 5,
})

mobs:register_mob("mobs:oerkki", {
	type = "monster",
	hp_max = 8,
	collisionbox = {-0.4, -1, -0.4, 0.4, 1, 0.4},
	visual = "upright_sprite",
	visual_size = {x=1, y=2},
	textures = {"mobs_oerkki.png", "mobs_oerkki_back.png"},
	makes_footstep_sound = false,
	view_range = 15,
	walk_velocity = 1,
	run_velocity = 3,
	damage = 4,
	drops = {},
	armor = 3,
	drawtype = "front",
	light_resistant = true,
	water_damage = 1,
	lava_damage = 1,
	light_damage = 0,
	attack_type = "dogfight",
})
mobs:register_spawn("mobs:oerkki", {"default:stone"}, 2, -1, 7000, 3)

mobs:register_mob("mobs:dungeon_master", {
	type = "monster",
	hp_max = 10,
	collisionbox = {-0.8, -1.21875, -0.8, 0.8, 1.21875, 0.8},
	visual = "upright_sprite",
	visual_size = {x=1.875, y=2.4375},
	textures = {"mobs_dungeon_master.png", "mobs_dungeon_master_back.png"},
	makes_footstep_sound = true,
	view_range = 15,
	walk_velocity = 1,
	run_velocity = 3,
	damage = 4,
	drops = {
		{name = "default:mese",
		chance = 100,
		min = 1,
		max = 2,},
	},
	armor = 2,
	drawtype = "front",
	water_damage = 1,
	lava_damage = 1,
	light_damage = 0,
	on_rightclick = nil,
	attack_type = "shoot",
	arrow = "mobs:fireball",
	shoot_interval = 2.5,
})
mobs:register_spawn("mobs:dungeon_master", {"default:stone"}, 2, -1, 7000, 0)

mobs:register_arrow("mobs:fireball", {
	visual = "sprite",
	visual_size = {x=1, y=1},
	--textures = {{name="mobs_fireball.png", animation={type="vertical_frames", aspect_w=16, aspect_h=16, length=0.5}}}, FIXME
	textures = {"mobs_fireball.png"},
	velocity = 5,
	hit_player = function(self, player)
		local s = self.object:getpos()
		local p = player:getpos()
		local vec = {x=s.x-p.x, y=s.y-p.y, z=s.z-p.z}
		player:punch(self.object, 1.0,  {
			full_punch_interval=1.0,
			groupcaps={
				fleshy={times={[1]=1/2, [2]=1/3, [3]=1/4}},
			}
		}, vec)
		local pos = self.object:getpos()
		for dx=-1,1 do
			for dy=-1,1 do
				for dz=-1,1 do
					local p = {x=pos.x+dx, y=pos.y+dy, z=pos.z+dz}
					local n = minetest.env:get_node(pos).name
					if minetest.registered_nodes[n].groups.flammable or math.random(1, 100) <= 30 then
						minetest.env:set_node(p, {name="fire:basic_flame"})
					else
						minetest.env:remove_node(p)
					end
				end
			end
		end
	end,
	hit_node = function(self, pos, node)
		for dx=-1,1 do
			for dy=-2,1 do
				for dz=-1,1 do
					local p = {x=pos.x+dx, y=pos.y+dy, z=pos.z+dz}
					local n = minetest.env:get_node(pos).name
					if minetest.registered_nodes[n].groups.flammable or math.random(1, 100) <= 30 then
						minetest.env:set_node(p, {name="fire:basic_flame"})
					else
						minetest.env:remove_node(p)
					end
				end
			end
		end
	end
})
