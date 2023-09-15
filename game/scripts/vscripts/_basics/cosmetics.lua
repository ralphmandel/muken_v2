cosmetics = class ({})
LinkLuaModifier("cosmetics_mod", "_basics/cosmetics_mod", LUA_MODIFIER_MOTION_NONE)

function cosmetics:Spawn()
	self:UpgradeAbility(true)
end

function cosmetics:OnUpgrade()
	if self:GetCaster():IsIllusion() then
		self:LoadCosmetics()
	else
    for team = DOTA_TEAM_CUSTOM_MIN, DOTA_TEAM_CUSTOM_MIN + 3 do
      if self:GetCaster():GetTeamNumber() == team then
        Timers:CreateTimer(team, function()
          self:LoadCosmetics()
        end)
      end
    end
	end
end

-- ADD COSMETICS
	function cosmetics:LoadCosmetics()
    local caster = self:GetCaster()
		self.cosmetic = {}
		self.status_efx_flags = {
			-- [1] = "models/items/rikimaru/riki_scarlet_fox_head/riki_scarlet_fox_head.vmdl",
			-- [2] = "models/items/rikimaru/riki_scarlet_fox_offhand_weapon/riki_scarlet_fox_offhand_weapon.vmdl",
			-- [3] = "models/items/rikimaru/riki_scarlet_fox_weapon/riki_scarlet_fox_weapon.vmdl",
			-- [4] = "models/items/rikimaru/riki_scarlet_fox_shoulder/riki_scarlet_fox_shoulder.vmdl",
			-- [5] = "models/items/rikimaru/riki_scarlet_fox_arms/riki_scarlet_fox_arms.vmdl",
			-- [6] = "models/items/rikimaru/riki_scarlet_fox_tail/riki_scarlet_fox_tail.vmdl"
		}
	
		local cosmetics_data = LoadKeyValues("scripts/vscripts/heroes/"..GetHeroTeam(caster:GetUnitName()).."/"..GetHeroName(caster:GetUnitName()).."/"..GetHeroName(caster:GetUnitName()).."-cosmetics.txt")
		if cosmetics_data ~= nil then self:ApplyCosmetics(cosmetics_data) end
	
		if GetHeroName(caster:GetUnitName()) == "icebreaker" then
			--self:SetStatusEffect(caster, nil, "icebreaker_1_modifier_passive_status_efx", true)
		end

		if GetHeroName(caster:GetUnitName()) == "bloodstained" then
			self:SetStatusEffect(caster, nil, "bloodstained_1_modifier_passive_status_efx", true)
		end
		
		if GetHeroName(caster:GetUnitName()) == "krieger" then
			self:SetStatusEffect(caster, nil, "krieger_1_modifier_passive_status_efx", true)
		end

		self:ChangeTeam(caster:GetTeamNumber())

    if GetHeroName(caster:GetUnitName()) == "templar" then
      if IsServer() then self:PlayEfxHammer() end
		end

    if GetHeroName(caster:GetUnitName()) == "lawbreaker" then
      if IsServer() then self:PlayEfxGuns() end
		end
	end

	function cosmetics:ApplyCosmetics(cosmetics_data)
		local caster = self:GetCaster()
		local index = 0

		for cosmetic, ambients in pairs(cosmetics_data) do
			local unit = caster
			local modifier = caster:FindModifierByName(cosmetic)
			local activity = nil

			if cosmetic == "models/items/slark/hydrakan_latch/mesh/hydrkan_latch_model.vmdl" then
				activity = "latch"
			end

			if modifier == nil then
				index = index + 1
				self.cosmetic[index] = CreateUnitByName("npc_dummy", caster:GetOrigin(), false, nil, nil, caster:GetTeamNumber())
				modifier = self.cosmetic[index]:AddNewModifier(caster, self, "cosmetics_mod", {model = cosmetic, activity = activity})
				unit = self.cosmetic[index]
			end

			if ambients ~= "nil" then
				self:ApplyAmbient(ambients, unit, modifier)
			end
		end
	end

	function cosmetics:ApplyAmbient(ambients, unit, modifier)
		if modifier == nil or ambients == nil or unit == nil then return end

		for ambient, attach in pairs(ambients) do
			if ambient == "material" then
				unit:SetMaterialGroup(tostring(attach))
			else
				modifier:PlayEfxAmbient(ambient, attach)
			end
		end
	end

	function cosmetics:ChangeTeam(team)
		if self.cosmetic == nil then return end
	
		for i = 1, #self.cosmetic, 1 do
			self.cosmetic[i]:SetTeam(team)
		end
	end

-- STATUS EFX / HIDE / APPLY MODIFIERS

	function cosmetics:SetStatusEffect(caster, ability, string, enable)
		if self.cosmetic == nil then return end

		local inflictor = self
		if ability then inflictor = ability end

		for i = 1, #self.cosmetic, 1 do
			if self:CheckFlags(self.cosmetic[i]) then
				if enable == true then
					self.cosmetic[i]:AddNewModifier(caster, inflictor, string, {})
				else
					if ability then
						local mod = self.cosmetic[i]:FindAllModifiersByName(string)
						for _,modifier in pairs(mod) do
							if modifier:GetAbility() then
								if modifier:GetAbility() == ability then modifier:Destroy() end
							else
								self.cosmetic[i]:RemoveModifierByName(string)
							end
						end
					else
						if caster then
							if IsValidEntity(caster) then
								self.cosmetic[i]:RemoveModifierByNameAndCaster(string, caster)
							else
								self.cosmetic[i]:RemoveModifierByName(string)
							end
						else
							self.cosmetic[i]:RemoveModifierByName(string)
						end
					end
				end
			end
		end
	end

	function cosmetics:CheckFlags(cosmetic)
		if cosmetic == nil then return end
		if IsValidEntity(cosmetic) == false then return end
		local mod = cosmetic:FindModifierByName("cosmetics_mod")
		if mod then
			for i = 1, #self.status_efx_flags, 1 do
				if mod.model == self.status_efx_flags[i] then
					return false
				end
			end
		end

		return true
	end

	function cosmetics:HideCosmetic(model, bApply)
		if self.cosmetic == nil then return end

		for i = 1, #self.cosmetic, 1 do
			if self.cosmetic[i]:GetModelName() == model 
			or model == nil then
				if bApply then
					self.cosmetic[i]:FindModifierByName("cosmetics_mod"):ChangeHidden(1)
				else
					self.cosmetic[i]:FindModifierByName("cosmetics_mod"):ChangeHidden(-1)
				end
			end
		end
	end

	function cosmetics:AddNewModifier(ability, modifier_name)
		if self.cosmetic == nil then return end

		for i = 1, #self.cosmetic, 1 do
			self.cosmetic[i]:AddNewModifier(self:GetCaster(), ability, modifier_name, {})
		end
	end

	function cosmetics:RemoveModifierByName(ability, modifier_name)
		if self.cosmetic == nil then return end

		for i = 1, #self.cosmetic, 1 do
			if ability == nil then
				self.cosmetic[i]:RemoveModifierByName(modifier_name)
			else
        RemoveAllModifiersByNameAndAbility(self.cosmetic[i], modifier_name, ability)
			end
		end
	end

-- ACTIVITY / GESTURE

	function cosmetics:ChangeCosmeticsActivity(bClear)
		if self.cosmetic == nil then return end

		for i = 1, #self.cosmetic, 1 do
			if bClear then self.cosmetic[i]:ClearActivityModifiers() end
			self.cosmetic[i]:AddActivityModifier(BaseHeroMod(self:GetCaster()).activity)
		end
	end

	function cosmetics:StartCosmeticGesture(model, gesture)
		if self.cosmetic == nil then return end

		for i = 1, #self.cosmetic, 1 do
			if self.cosmetic[i]:GetModelName() == model then
				self.cosmetic[i]:StartGesture(gesture)
			end
		end
	end

	function cosmetics:FadeCosmeticsGesture(model, gesture)
		if self.cosmetic == nil then return end

		for i = 1, #self.cosmetic, 1 do
			if self.cosmetic[i]:GetModelName() == model then
				self.cosmetic[i]:FadeGesture(ACT_DOTA_CHANNEL_ABILITY_3)
			end
		end
	end

-- FIND / MODIFY: COSMETIC / AMBIENT

	function cosmetics:FindModifierByModel(model)
		local cosmetic = self:FindCosmeticByModel(model)
		if cosmetic then return cosmetic:FindModifierByName("cosmetics_mod") end
	end

	function cosmetics:FindCosmeticByModel(model)
		if self.cosmetic == nil then return end
		if model == nil then return end
	
		for i = 1, #self.cosmetic, 1 do
			if self.cosmetic[i]:GetModelName() == model then
				return self.cosmetic[i]
			end
		end
	end

	function cosmetics:GetAmbient(ambient)
		if self.cosmetic == nil then return end

		for i = 1, #self.cosmetic, 1 do
			local mod_cosmetic = self.cosmetic[i]:FindModifierByName("cosmetics_mod")
			if mod_cosmetic then
				for i = #mod_cosmetic.ambient_table, 1, -1 do
					for string, particle in pairs(mod_cosmetic.ambient_table[i]) do
						if ambient == string then
							return particle
						end
					end
				end
			end
		end
	end

	function cosmetics:DestroyAmbient(model, ambient, bDestroyImmediately)
		if self.cosmetic == nil then return end

		if model then
			local mod_cosmetic = self:FindModifierByModel(model)
			if mod_cosmetic then mod_cosmetic:StopAmbientEfx(ambient, bDestroyImmediately) end
		else
			for i = 1, #self.cosmetic, 1 do
				local mod_cosmetic = self.cosmetic[i]:FindModifierByName("cosmetics_mod")
				if mod_cosmetic then mod_cosmetic:StopAmbientEfx(ambient, bDestroyImmediately) end
			end
		end
	end

	function cosmetics:ReloadAmbients(unit, models, bDestroyImmediately)
		self:DestroyAmbient(nil, nil, false)
		for model, ambients in pairs(models) do
			self:ApplyAmbient(ambients, unit, self:FindModifierByModel(model))
		end
	end


  function cosmetics:PlayEfxHammer()
    local caster = self:GetCaster()
    local string = "particles/econ/items/omniknight/hammer_ti6_immortal/omniknight_hammer_ambient.vpcf"
    local particle = ParticleManager:CreateParticle(string, PATTACH_POINT_FOLLOW, caster)
    ParticleManager:SetParticleControl(particle, 0, caster:GetOrigin())
    ParticleManager:SetParticleControlEnt(particle, 0, caster, PATTACH_POINT_FOLLOW, "attach_attack1", Vector(0,0,0), true)
    --self:AddParticle(particle, false, false, -1, false, false)  
  end

  function cosmetics:PlayEfxGuns()
    local caster = self:GetCaster()
    local string = "particles/units/heroes/hero_muerta/muerta_weapon_primary_ambient.vpcf"
    local particle = ParticleManager:CreateParticle(string, PATTACH_POINT_FOLLOW, caster)
    ParticleManager:SetParticleControl(particle, 0, caster:GetOrigin())
    ParticleManager:SetParticleControlEnt(particle, 0, caster, PATTACH_POINT_FOLLOW, "attach_attack1", Vector(0,0,0), true)
    --self:AddParticle(particle, false, false, -1, false, false)  
  end