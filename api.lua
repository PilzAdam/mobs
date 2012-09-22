mobs = {}
function mobs:register_mob(name, def)
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
		light_damage = def.light_damage,
		water_damage = def.water_damage,
		lava_damage = def.lava_damage,
		drops = def.drops,
		armor = def.armor,
		drawtype = def.drawtype,
		on_rightclick = def.on_rightclick,
		type = def.type,
		attack_type = def.attack_type,
		arrow = def.arrow,
		shoot_interval = def.shoot_interval,
		sounds = def.sounds,
		
		timer = 0,
		attack = {player=nil, dist=nil},
		state = "stand",
		v_start = false,
		old_y = nil,
		
		
		set_velocity = function(self, v)
			local yaw = self.object:getyaw()
			if self.drawtype == "side" then
				yaw = yaw+(math.pi/2)
			end
			local x = math.sin(yaw) * -v
			local z = math.cos(yaw) * v
			self.object:setvelocity({x=x, y=self.object:getvelocity().y, z=z})
		end,
		
		get_velocity = function(self)
			local v = self.object:getvelocity()
			return (v.x^2 + v.z^2)^(0.5)
		end,
		
		on_step = function(self, dtime)
			if self.type == "monster" and minetest.setting_getbool("only_peaceful_mobs") then
				self.object:remove()
			end
			
			if self.object:getvelocity().y > 0.1 then
				local yaw = self.object:getyaw()
				if self.drawtype == "side" then
					yaw = yaw+(math.pi/2)
				end
				local x = math.sin(yaw) * -2
				local z = math.cos(yaw) * 2
				self.object:setacceleration({x=x, y=-10, z=z})
			else
				self.object:setacceleration({x=0, y=-10, z=0})
			end
			
			if self.object:getvelocity().y == 0 then
				if not self.old_y then
					self.old_y = self.object:getpos().y
				else
					local d = self.old_y - self.object:getpos().y
					if d > 5 then
						local damage = d-5
						self.object:punch(self.object, 1.0, {
							full_punch_interval=1.0,
							groupcaps={
								fleshy={times={[self.armor]=1/damage}},
							}
						}, nil)
					end
					self.old_y = self.object:getpos().y
				end
			end
			
			self.timer = self.timer+dtime
			if self.state ~= "attack" then
				if self.timer < 1 then
					return
				end
				self.timer = 0
			end
			
			if self.sounds and self.sounds.random and math.random(1, 100) <= 10 then
				minetest.sound_play(self.sounds.random, {object = self.object})
			end
			
			local do_env_damage = function(self)
				if self.light_damage and self.light_damage ~= 0 and self.object:getpos().y>0 and minetest.env:get_node_light(self.object:getpos()) > 3 then
					self.object:punch(self.object, 1.0, {
						full_punch_interval=1.0,
						groupcaps={
							fleshy={times={[self.armor]=1/self.light_damage}},
						}
					}, nil)
				end
				
				if self.water_damage and self.water_damage ~= 0 and string.find(minetest.env:get_node(self.object:getpos()).name, "default:water") then
					self.object:punch(self.object, 1.0, {
						full_punch_interval=1.0,
						groupcaps={
							fleshy={times={[self.armor]=1/self.water_damage}},
						}
					}, nil)
				end
				
				if self.lava_damage and self.lava_damage ~= 0 and string.find(minetest.env:get_node(self.object:getpos()).name, "default:lava") then
					self.object:punch(self.object, 1.0, {
						full_punch_interval=1.0,
						groupcaps={
							fleshy={times={[self.armor]=1/self.lava_damage}},
						}
					}, nil)
				end
			end
			
			if self.state == "attack" and self.timer > 1 then
				do_env_damage(self)
			elseif self.state ~= "attack" then
				do_env_damage(self)
			end
			
			if self.type == "monster" then
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
			elseif self.state == "attack" and self.attack_type == "dogfight" then
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
				if self.drawtype == "side" then
					yaw = yaw+(math.pi/2)
				end
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
						if self.sounds and self.sounds.attack then
							minetest.sound_play(self.sounds.attack, {object = self.object})
						end
						self.attack.player:punch(self.object, 1.0,  {
							full_punch_interval=1.0,
							groupcaps={
								fleshy={times={[1]=d1, [2]=d2, [3]=d3}},
							}
						}, vec)
					end
				end
			elseif self.state == "attack" and self.attack_type == "shoot" then
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
				if self.drawtype == "side" then
					yaw = yaw+(math.pi/2)
				end
				if p.x > s.x then
					yaw = yaw+math.pi
				end
				self.object:setyaw(yaw)
				self.set_velocity(self, 0)
				
				if self.timer > self.shoot_interval and math.random(1, 100) <= 60 then
					self.timer = 0
					
					if self.sounds and self.sounds.attack then
						minetest.sound_play(self.sounds.attack, {object = self.object})
					end
					
					local obj = minetest.env:add_entity(self.object:getpos(), self.arrow)
					local amount = (vec.x^2+vec.y^2+vec.z^2)^0.5
					local v = obj:get_luaentity().velocity
					vec.y = vec.y+1
					vec.x = vec.x*v/amount
					vec.y = vec.y*v/amount
					vec.z = vec.z*v/amount
					obj:setvelocity(vec)
				end
			end
		end,
		
		on_activate = function(self, staticdata)
			self.object:set_armor_groups({fleshy=self.armor})
			self.object:setacceleration({x=0, y=-10, z=0})
			self.state = "stand"
			self.object:setvelocity({x=0, y=self.object:getvelocity().y, z=0})
			self.object:setyaw(math.random(1, 360)/180*math.pi)
			if self.type == "monster" and minetest.setting_getbool("only_peaceful_mobs") then
				self.object:remove()
			end
		end,
		
		on_punch = function(self, hitter)
			if self.object:get_hp() <= 0 then
				if hitter and hitter:is_player() and hitter:get_inventory() then
					for _,drop in ipairs(self.drops) do
						if math.random(1, drop.chance) == 1 then
							hitter:get_inventory():add_item("main", ItemStack(drop.name.." "..math.random(drop.min, drop.max)))
						end
					end
				else
					for _,drop in ipairs(self.drops) do
						if math.random(1, drop.chance) == 1 then
							for i=1,math.random(drop.min, drop.max) do
								local obj = minetest.env:add_item(self.object:getpos(), drop.name)
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
				end
			end
		end,
		
	})
end

function mobs:register_spawn(name, nodes, max_light, min_light, chance, mobs_per_30_block_radius, max_height)
	minetest.register_abm({
	nodenames = nodes,
	neighbors = nodes,
	interval = 30,
	chance = chance,
	action = function(pos, node)
		pos.y = pos.y+1
		if not minetest.env:get_node_light(pos) then
			return
		end
		if minetest.env:get_node_light(pos) > max_light then
			return
		end
		if minetest.env:get_node_light(pos) < min_light then
			return
		end
		if pos.y > max_height then
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
		for _,obj in pairs(minetest.env:get_objects_inside_radius(pos, 30)) do
			if obj:is_player() then
				return
			elseif obj:get_luaentity().name == name then
				count = count+1
			end
		end
		if count > mobs_per_30_block_radius then
			return
		end
		
		if minetest.setting_getbool("display_mob_spawn") then
			minetest.chat_send_all("[mobs] Add "..name.." at "..minetest.pos_to_string(pos))
		end
		minetest.env:add_entity(pos, name)
	end
})
end

function mobs:register_arrow(name, def)
	minetest.register_entity(name, {
		physical = false,
		visual = def.visual,
		visual_size = def.visual_size,
		textures = def.textures,
		velocity = def.velocity,
		hit_player = def.hit_player,
		hit_node = def.hit_node,
		
		on_step = function(self, dtime)
			local pos = self.object:getpos()
			if minetest.env:get_node(self.object:getpos()).name ~= "air" then
				self.hit_node(self, pos, node)
				self.object:remove()
				return
			end
			pos.y = pos.y-1
			for _,player in pairs(minetest.env:get_objects_inside_radius(pos, 1)) do
				if player:is_player() then
					self.hit_player(self, player)
					self.object:remove()
					return
				end
			end
		end
	})
end
