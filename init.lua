dofile(minetest.get_modpath("mobs").."/api.lua")

mobs:register_monster("mobs:dirt_monster", {
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
	drop = "default:dirt",
	drop_count = 3,
	armor = 3,
	drawtype = "front",
	water_damage = 1,
	lava_damage = 5,
})
mobs:register_spawn("mobs:dirt_monster", {"default:dirt_with_grass"}, 3, -1, 5000, 5)

mobs:register_monster("mobs:stone_monster", {
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
	drop = "default:mossycobble",
	drop_count = 3,
	light_resistant = true,
	armor = 2,
	drawtype = "front",
	water_damage = 0,
	lava_damage = 0,
})
mobs:register_spawn("mobs:stone_monster", {"default:stone"}, 3, -1, 5000, 5)


mobs:register_monster("mobs:sand_monster", {
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
	drop = "default:sand",
	drop_count = 3,
	light_resistant = true,
	armor = 3,
	drawtype = "front",
	water_damage = 3,
	lava_damage = 1,
})
mobs:register_spawn("mobs:sand_monster", {"default:desert_sand"}, 20, -1, 5000, 5)

mobs:register_animal("mobs:sheep", {
	hp_max = 5,
	collisionbox = {-0.6, -0.625, -0.6, 0.6, 0.625, 0.6},
	visual = "upright_sprite",
	visual_size = {x=2, y=1.25},
	textures = {"mobs_sheep.png", "mobs_sheep.png"},
	makes_footstep_sound = true,
	walk_velocity = 1,
	drop = "mobs:meat_raw",
	drop_count = 2,
	drawtype = "side",
	water_damage = 1,
	lava_damage = 5,
	
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
mobs:register_spawn("mobs:sheep", {"default:dirt_with_grass"}, 20, 8, 5000, 3)

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

mobs:register_animal("mobs:rat", {
	hp_max = 1,
	collisionbox = {-0.25, -0.175, -0.25, 0.25, 0.1, 0.25},
	visual = "upright_sprite",
	visual_size = {x=0.7, y=0.35},
	textures = {"mobs_rat.png", "mobs_rat.png"},
	makes_footstep_sound = false,
	walk_velocity = 1,
	drop = "",
	drop_count = 0,
	drawtype = "side",
	water_damage = 0,
	lava_damage = 1,
	
	on_rightclick = function(self, clicker)
		if clicker:is_player() and clicker:get_inventory() then
			clicker:get_inventory():add_item("main", "mobs:rat")
			self.object:remove()
		end
	end,
})
mobs:register_spawn("mobs:rat", {"default:dirt_with_grass", "default:stone"}, 20, -1, 5000, 1)

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

mobs:register_monster("mobs:oerkki", {
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
	drop = "",
	drop_count = 0,
	armor = 3,
	drawtype = "front",
	light_resistant = true,
	water_damage = 1,
	lava_damage = 1,
})
mobs:register_spawn("mobs:oerkki", {"default:stone"}, 2, -1, 5000, 5)
