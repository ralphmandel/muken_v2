base_hero_mod = class ({})

function base_hero_mod:IsHidden() return true end
function base_hero_mod:IsPurgable() return false end

-----------------------------------------------------------

function base_hero_mod:OnCreated(kv)
	self.caster = self:GetCaster()
  self.parent = self:GetParent()
  self.ability = self:GetAbility()

  if IsServer() then
    self.hero_name = GetHeroName(self:GetCaster())
    self.hero_team = GetHeroTeam(self:GetCaster())
  
    self:LoadActivity()
    self:LoadModel()
    self:LoadSounds()

    self:StartIntervalThink(0.5)
  end
end

function base_hero_mod:OnRefresh(kv)
end

function base_hero_mod:OnIntervalThink()
  if self.parent:IsControllableByAnyPlayer() then
		local player = self:GetCaster():GetPlayerOwner()
		if (not player) then return end

    CustomGameEventManager:Send_ServerToPlayer(player, "unit_info_request_from_lua", {})
  end
end

------------------------------------------------------------

function base_hero_mod:DeclareFunctions()
	local funcs = {
    -- MODIFIER_PROPERTY_OVERRIDE_ABILITY_SPECIAL,
		-- MODIFIER_PROPERTY_OVERRIDE_ABILITY_SPECIAL_VALUE,
    -- MODIFIER_PROPERTY_MANACOST_PERCENTAGE,
		MODIFIER_EVENT_ON_TAKEDAMAGE,
		MODIFIER_PROPERTY_PRE_ATTACK,
		MODIFIER_EVENT_ON_ATTACK,
		MODIFIER_EVENT_ON_ATTACK_LANDED,
		MODIFIER_PROPERTY_TRANSLATE_ATTACK_SOUND,
		MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS
	}

	return funcs
end

-- function base_hero_mod:GetModifierPercentageManacost(keys)
--   if keys.ability:GetAbilityName() == "ancient_u__fissure" then return 0 end
--   if self:GetParent():IsHero() == false then return 0 end
--   return 100 - (100 / (self:GetAbility():GetLevel() * 0.5))
-- end

function base_hero_mod:OnTakeDamage(keys)
	if self.parent:IsIllusion() then return end
	if keys.unit ~= self.parent then return end
	local tp = self.parent:FindItemInInventory("item_tp")
	if tp then tp:StartCooldown(5) end
end

function base_hero_mod:GetModifierPreAttack(keys)
	if keys.attacker ~= self.parent then return end
	if IsServer() then self.parent:EmitSound(self.pre_attack_sound) end
end

function base_hero_mod:OnAttack(keys)
	if keys.attacker ~= self.parent then return end
	if IsServer() then self.parent:EmitSound(self.attack_sound) end
end

function base_hero_mod:OnAttackLanded(keys)  
	if keys.attacker ~= self.parent then return end
	if IsServer() then keys.target:EmitSound(self.attack_landed_sound) end
end

function base_hero_mod:GetAttackSound(keys)
  return ""
end

function base_hero_mod:GetActivityTranslationModifiers()
  return self.activity
end

function base_hero_mod:ChangeActivity(string)
  self.activity = string
end

function base_hero_mod:ChangeSounds(pre_attack, attack, attack_landed)
	if pre_attack then self.pre_attack_sound = pre_attack end
	if attack then self.attack_sound = attack end
	if attack_landed then self.attack_landed_sound = attack_landed end
end

function base_hero_mod:LoadActivity()
	Timers:CreateTimer((0.5), function()
		self.activity = ""
		if self.hero_name == "genuine" then self.activity = "ti6" end
		if self.hero_name == "icebreaker" then self.activity = "shinobi_tail" end
		if self.hero_name == "dasdingo" then self.activity = "fall20" end
		if self.hero_name == "bocuse" then self.activity = "trapper" end
		if self.hero_name == "ancient" then self.activity = "et_2021" end
		if self.hero_name == "fleaman" then self.activity = "latch" end
		if self.hero_name == "hunter" then self.activity = "MGC" end
		if self.hero_name == "templar" then self.activity = "ti8_taunt" end
		if self.hero_name == "strider" then self.activity = "ti8" end
    --if self.hero_name == "druid" then self.activity = "when_nature_attacks" end
	end)
end

function base_hero_mod:LoadModel()
	if self.hero_name == "shadow" then
		--self:PlayEfxAmbient("particles/econ/items/phantom_assassin/phantom_assassin_arcana_elder_smith/pa_arcana_elder_ambient.vpcf", "attach_hitloc")
	end

	Timers:CreateTimer((0.1), function()
		if self.parent then
			if IsValidEntity(self.parent) then
        if self.hero_name == "templar" then
					self.model_scale = 1.2
          self.parent.hp_offset = 240
          self.parent:SetModelScale(self.model_scale)
					self.parent:SetHealthBarOffsetOverride(self.parent.hp_offset)
				end
				if self.hero_name == "ancient" then
					self.model_scale = 1.07
          self.parent.hp_offset = 250
					self.parent:SetModelScale(self.model_scale)
					self.parent:SetHealthBarOffsetOverride(self.parent.hp_offset)
				end
        if self.hero_name == "paladin" then
					self.model_scale = 1
          self.parent.hp_offset = 200
					self.parent:SetModelScale(self.model_scale)
					self.parent:SetHealthBarOffsetOverride(self.parent.hp_offset)
				end
        if self.hero_name == "fleaman" then
					self.model_scale = 1
          self.parent.hp_offset = 200
					self.parent:SetModelScale(self.model_scale)
					self.parent:SetHealthBarOffsetOverride(self.parent.hp_offset)
				end
        if self.hero_name == "lawbreaker" then
					self.model_scale = 1
          self.parent.hp_offset = 200
					self.parent:SetModelScale(self.model_scale)
					self.parent:SetHealthBarOffsetOverride(self.parent.hp_offset)
				end
        if self.hero_name == "bloodstained" then
					self.model_scale = 1
          self.parent.hp_offset = 200
					self.parent:SetModelScale(self.model_scale)
					self.parent:SetHealthBarOffsetOverride(self.parent.hp_offset)
				end
        if self.hero_name == "trickster" then
					self.model_scale = 1
          self.parent.hp_offset = 200
					self.parent:SetModelScale(self.model_scale)
					self.parent:SetHealthBarOffsetOverride(self.parent.hp_offset)
				end
        if self.hero_name == "strider" then
					self.model_scale = 1
          self.parent.hp_offset = 200
					self.parent:SetModelScale(self.model_scale)
					self.parent:SetHealthBarOffsetOverride(self.parent.hp_offset)
				end


				if self.hero_name == "bocuse" then
					self.model_scale = 1.15
          self.parent.hp_offset = 230
          self.parent:SetModelScale(self.model_scale)
					self.parent:SetHealthBarOffsetOverride(self.parent.hp_offset)
					self.parent:SetMaterialGroup("1")
				end

				if self.hero_name == "baldur" then
					self.model_scale = 1
          self.parent.hp_offset = 200
					self.parent:SetModelScale(self.model_scale)
					self.parent:SetHealthBarOffsetOverride(self.parent.hp_offset)
				end
        if self.hero_name == "hunter" then
					self.parent:SetMaterialGroup("1")
				end
				if self.hero_name == "vulture" then
					self.model_scale = 1.0
          self.parent.hp_offset = 200
          self.parent:SetModelScale(self.model_scale)
					self.parent:SetHealthBarOffsetOverride(self.parent.hp_offset)
				end
			end
		end
	end)
end

function base_hero_mod:LoadSounds()
	self.pre_attack_sound = ""
	if self.hero_name == "icebreaker" then self.pre_attack_sound = "hero_bloodseeker.PreAttack" end
  if self.hero_name == "paladin" then self.pre_attack_sound = "Hero_Dawnbreaker.PreAttack" end
	if self.hero_name == "bloodstained" then self.pre_attack_sound = "Hero_Nightstalker.PreAttack" end
	-- if self.hero_name == "krieger" then self.pre_attack_sound = "Krieger.Pre.Attack" end

	self.attack_sound = ""
	if self.hero_name == "genuine" then self.attack_sound = "Hero_DrowRanger.Attack" end
	if self.hero_name == "dasdingo" then self.attack_sound = "Hero_ShadowShaman.Attack" end
  if self.hero_name == "lawbreaker" then self.attack_sound = "Hero_Muerta.Attack" end
	if self.hero_name == "druid" then self.attack_sound = "Hero_Furion.Attack" end
	if self.hero_name == "hunter" then self.attack_sound = "Hero_Sniper.MKG_attack" end

	self.attack_landed_sound = ""
	if self.hero_name == "icebreaker" then self.attack_landed_sound = "Hero_Riki.Attack" end
	if self.hero_name == "paladin" then self.attack_landed_sound = "Hero_Dawnbreaker.Attack" end
	if self.hero_name == "bocuse" then self.attack_landed_sound = "Hero_Pudge.Attack" end
	if self.hero_name == "bloodstained" then self.attack_landed_sound = "Hero_Nightstalker.Attack" end
	if self.hero_name == "fleaman" then self.attack_landed_sound = "Hero_Slark.Attack" end
	if self.hero_name == "baldur" then self.attack_landed_sound = "Hero_Bristleback.Attack" end
	if self.hero_name == "ancient" then self.attack_landed_sound = "Hero_ElderTitan.Attack" end
	if self.hero_name == "hunter" then self.attack_landed_sound = "Hero_Sniper.MKG_impact" end
	if self.hero_name == "templar" then self.attack_landed_sound = "Hero_Omniknight.Attack" end
	if self.hero_name == "trickster" then self.attack_landed_sound = "Trickster.Hit" end
	if self.hero_name == "strider" then self.attack_landed_sound = "Hero_Juggernaut.Attack" end
	

	-- if self.hero_name == "krieger" then self.attack_landed_sound = "krieger.Attack" end
end

-----------------------------------------------------------

function base_hero_mod:PlayEfxAmbient(ambient, attach)
	local effect_cast = ParticleManager:CreateParticle(ambient, PATTACH_POINT_FOLLOW, self.parent)
	ParticleManager:SetParticleControl(effect_cast, 0, self.parent:GetOrigin())
	ParticleManager:SetParticleControlEnt(effect_cast, 0, self.parent, PATTACH_POINT_FOLLOW, attach, Vector(0,0,0), true)
	self:AddParticle(effect_cast, false, false, -1, false, false)
end

-- function base_hero_mod:OnIntervalThink()
--     print("x", self.parent:GetAbsOrigin().x, "| y", self.parent:GetAbsOrigin().y, "| z", self.parent:GetAbsOrigin().z)
-- end

-- function base_hero_mod:OnIntervalThink()
-- 	local message = "x:" .. self.parent:GetOrigin().x .. "; y:" .. self.parent:GetOrigin().y .. "; loc"
-- 	print(message)
-- end