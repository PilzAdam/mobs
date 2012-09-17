local mobs = {}
function mobs:register_monster(name, def)
	minetest.register_entity(name, {
		hp_max = def.hp_max,
		physical = true,
		collisionbox = def.collisionbox,
		visual = def.visual,
		visual_size = def.visual_size,
		textures = def.textures,
		makes_footstep_sound = def.makes_footstep_sound,
		view_range = def.view_range,
		walk_velocity = def.walk_velocity,
		run_velocity = def.run_velocity,
		damage = def.damage,
		light_resistant = def.light_resistant,
		drop = def.drop,
		drop_count = def.drop_count,
		armor = def.armor,
		
		timer = 0,
		attack = {player=nil, dist=nil},
		state = "stand",
		v_start = false,
		
		
		set_velocity = function(self, v)
			local yaw = self.object:getyaw()
			local x = math.sin(yaw) * -v
			local z = math.cos(yaw) * v
			self.object:setvelocity({x=x, y=self.object:getvelocity().y, z=z})
		end,
		
		get_velocity = function(self)
			local v = self.object:getvelocity()
			return (v.x^2 + v.z^2)^(0.5)
		end,
		
		on_step = function(self, dtime)
			if self.object:getvelocity().y > 0.1 then
				local yaw = self.object:getyaw()
				local x = math.sin(yaw) * -2
				local z = math.cos(yaw) * 2
				self.object:setacceleration({x=x, y=-10, z=z})
			else
				self.object:setacceleration({x=0, y=-10, z=0})
			end
			
			self.timer = self.timer+dtime
			if self.state ~= "attack" then
				if self.timer < 1 then
					return
				end
				self.timer = 0
			end
			
			if not self.light_resistant and minetest.env:get_timeofday() > 0.2 and minetest.env:get_timeofday() < 0.8 and minetest.env:get_node_light(self.object:getpos()) > 3 then
				self.object:punch(self.object, 1.0, {
					full_punch_interval=1.0,
					groupcaps={
						fleshy={times={[3]=1/10}},
					}
				}, nil)
			end
			
			if string.find(minetest.env:get_node(self.object:getpos()).name, "default:water") then
				self.object:punch(self.object, 1.0, {
					full_punch_interval=1.0,
					groupcaps={
						fleshy={times={[3]=1/1}},
					}
				}, nil)
			end
			
			if string.find(minetest.env:get_node(self.object:getpos()).name, "default:lava") then
				self.object:punch(self.object, 1.0, {
					full_punch_interval=1.0,
					groupcaps={
						fleshy={times={[3]=1/2}},
					}
				}, nil)
			end
			
			for _,player in pairs(minetest.get_connected_players()) do
				local s = self.object:getpos()
				local p = player:getpos()
				local dist = ((p.x-s.x)^2 + (p.y-s.y)^2 + (p.z-s.z)^2)^0.5
				if dist < self.view_range then
					if self.attack.dist then
						if self.attack.dist < dist then
							self.state = "attack"
							self.attack.player = player
							self.attack.dist = dist
						end
					else
						self.state = "attack"
						self.attack.player = player
						self.attack.dist = dist
					end
				end
			end
			
			if self.state == "stand" then
				if math.random(1, 2) == 1 then
					self.object:setyaw(self.object:getyaw()+((math.random(0,360)-180)/180*math.pi))
				end
				if math.random(1, 100) <= 50 then
					self.set_velocity(self, self.walk_velocity)
					self.state = "walk"
				end
			elseif self.state == "walk" then
				if math.random(1, 100) <= 30 then
					self.object:setyaw(self.object:getyaw()+((math.random(0,360)-180)/180*math.pi))
					self.set_velocity(self, self.get_velocity(self))
				end
				if math.random(1, 100) <= 10 then
					self.set_velocity(self, 0)
					self.state = "stand"
				end
				if self.get_velocity(self) <= 0.5 and self.object:getvelocity().y == 0 then
					local v = self.object:getvelocity()
					v.y = 5
					self.object:setvelocity(v)
				end
			elseif self.state == "attack" then
				local s = self.object:getpos()
				local p = self.attack.player:getpos()
				local dist = ((p.x-s.x)^2 + (p.y-s.y)^2 + (p.z-s.z)^2)^0.5
				if dist > self.view_range or self.attack.player:get_hp() <= 0 then
					self.state = "stand"
					self.v_start = false
					self.set_velocity(self, 0)
					self.attack = {player=nil, dist=nil}
					return
				else
					self.attack.dist = dist
				end
				
				local vec = {x=p.x-s.x, y=p.y-s.y, z=p.z-s.z}
				local yaw = math.atan(vec.z/vec.x)+math.pi/2
				if p.x > s.x then
					yaw = yaw+math.pi
				end
				self.object:setyaw(yaw)
				if self.attack.dist > 2 then
					if not self.v_start then
						self.v_start = true
						self.set_velocity(self, self.run_velocity)
					else
						if self.get_velocity(self) <= 0.5 and self.object:getvelocity().y == 0 then
							local v = self.object:getvelocity()
							v.y = 5
							self.object:setvelocity(v)
						end
						self.set_velocity(self, self.run_velocity)
					end
				else
					self.set_velocity(self, 0)
					self.v_start = false
					if self.timer > 1 then
						self.timer = 0
						local d1 = 10
						local d2 = 10
						local d3 = 10
						if self.damage > 0 then
							d3 = 1/self.damage
						end
						if self.damage > 1 then
							d2 = 1/(self.damage-1)
						end
						if self.damage > 2 then
							d1 = 1/(self.damage-2)
						end
						self.attack.player:punch(self.object, 1.0,  {
							full_punch_interval=1.0,
							groupcaps={
								fleshy={times={[1]=d1, [2]=d2, [3]=d3}},
							}
						}, vec)
					end
				end
			end
		end,
		
		on_activate = function(self, staticdata)
			self.object:set_armor_groups({fleshy=self.armor})
			self.object:setacceleration({x=0, y=-10, z=0})
			self.state = "stand"
			self.object:setvelocity({x=0, y=self.object:getvelocity().y, z=0})
			self.object:setyaw(math.random(1, 360)/180*math.pi)
		end,
		
		on_punch = function(self, hitter)
			if self.object:get_hp() <= 0 then
				if hitter and hitter:is_player() and hitter:get_inventory() then
					for i=1,math.random(0,2)-1+self.drop_count do
						hitter:get_inventory():add_item("main", ItemStack(self.drop))
					end
				else
					for i=1,math.random(0,2)-1+self.drop_count do
						local obj = minetest.env:add_item(self.object:getpos(), self.drop)
						if obj then
							obj:get_luaentity().collect = true
							local x = math.random(1, 5)
							if math.random(1,2) == 1 then
								x = -x
							end
							local z = math.random(1, 5)
							if math.random(1,2) == 1 then
								z = -z
							end
							obj:setvelocity({x=1/x, y=obj:getvelocity().y, z=1/z})
						end
					end
				end
			end
		end,
		
	})
end

function mobs:register_animal(name, def)
	minetest.register_entity(name, {
		hp_max = def.hp_max,
		physical = true,
		collisionbox = def.collisionbox,
		visual = def.visual,
		visual_size = def.visual_size,
		textures = def.textures,
		makes_footstep_sound = def.makes_footstep_sound,
		walk_velocity = def.walk_velocity,
		drop = def.drop,
		on_rightclick = def.on_rightclick,
		drop_count = def.drop_count,
		
		timer = 0,
		state = "stand",
		
		
		set_velocity = function(self, v)
			local yaw = self.object:getyaw()
			yaw = yaw+(math.pi/2)
			local x = math.sin(yaw) * -v
			local z = math.cos(yaw) * v
			self.object:setvelocity({x=x, y=self.object:getvelocity().y, z=z})
		end,
		
		get_velocity = function(self)
			local v = self.object:getvelocity()
			return (v.x^2 + v.z^2)^(0.5)
		end,
		
		on_step = function(self, dtime)
			if self.object:getvelocity().y > 0.1 then
				local yaw = self.object:getyaw()
				yaw = yaw+(math.pi/2)
				local x = math.sin(yaw) * -2
				local z = math.cos(yaw) * 2
				self.object:setacceleration({x=x, y=-10, z=z})
			else
				self.object:setacceleration({x=0, y=-10, z=0})
			end
			
			self.timer = self.timer+dtime
			if self.timer < 1 then
				return
			end
			self.timer = 0
			
			if string.find(minetest.env:get_node(self.object:getpos()).name, "default:lava") then
				self.object:punch(self.object, 1.0, {
					full_punch_interval=1.0,
					groupcaps={
						fleshy={times={[3]=1/2}},
					}
				}, nil)
			end
			
			if self.state == "stand" then
				if math.random(1, 2) == 1 then
					self.object:setyaw(self.object:getyaw()+((math.random(0,360)-180)/180*math.pi))
				end
				if math.random(1, 100) <= 50 then
					self.set_velocity(self, self.walk_velocity)
					self.state = "walk"
				end
			elseif self.state == "walk" then
				if math.random(1, 100) <= 30 then
					self.object:setyaw(self.object:getyaw()+((math.random(0,360)-180)/180*math.pi))
					self.set_velocity(self, self.get_velocity(self))
				end
				if math.random(1, 100) <= 10 then
					self.set_velocity(self, 0)
					self.state = "stand"
				end
				if self.get_velocity(self) <= 0.5 and self.object:getvelocity().y == 0 then
					local v = self.object:getvelocity()
					v.y = 5
					self.object:setvelocity(v)
				end
			end
		end,
		
		on_activate = function(self, staticdata)
			self.object:set_armor_groups({fleshy=3})
			self.object:setacceleration({x=0, y=-10, z=0})
			self.state = "stand"
			self.object:setvelocity({x=0, y=self.object:getvelocity().y, z=0})
			self.object:setyaw(math.random(1, 360)/180*math.pi)
		end,
		
		on_punch = function(self, hitter)
			if self.object:get_hp() <= 0 then
				if hitter and hitter:is_player() and hitter:get_inventory() then
					for i=1,math.random(0,2)-1+self.drop_count do
						hitter:get_inventory():add_item("main", ItemStack(self.drop))
					end
				else
					for i=1,math.random(0,2)-1+self.drop_count do
						local obj = minetest.env:add_item(self.object:getpos(), self.drop)
						if obj then
							obj:get_luaentity().collect = true
							local x = math.random(1, 5)
							if math.random(1,2) == 1 then
								x = -x
							end
							local z = math.random(1, 5)
							if math.random(1,2) == 1 then
								z = -z
							end
							obj:setvelocity({x=1/x, y=obj:getvelocity().y, z=1/z})
						end
					end
				end
			end
		end,
		
	})
end

function mobs:register_spawn(name, nodes, max_light)
	minetest.register_abm({
	nodenames = nodes,
	neighbors = nodes,
	interval = 60,
	chance = 5000,
	action = function(pos, node)
		pos.y = pos.y+1
		if not minetest.env:get_node_light(pos) then
			return
		end
		if minetest.env:get_node_light(pos) > max_light then
			return
		end
		if minetest.env:get_node(pos).name ~= "air" then
			return
		end
		pos.y = pos.y+1
		if minetest.env:get_node(pos).name ~= "air" then
			return
		end
		
		local count = 0
		for _,obj in pairs(minetest.env:get_objects_inside_radius(pos, 50)) do
			if obj:is_player() then
				return
			elseif obj:get_luaentity().name == name then
				count = count+1
			end
		end
		if count > 5 then
			return
		end
		
		--minetest.chat_send_all("[mobs] Add "..name.." at "..minetest.pos_to_string(pos))
		minetest.env:add_entity(pos, name)
	end
})
end

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
})
mobs:register_spawn("mobs:dirt_monster", {"default:dirt_with_grass"}, 3)

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
})
mobs:register_spawn("mobs:stone_monster", {"default:stone"}, 3)


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
})
mobs:register_spawn("mobs:sand_monster", {"default:desert_sand"}, 20)

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
mobs:register_spawn("mobs:sheep", {"default:dirt_with_grass"}, 20)

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
