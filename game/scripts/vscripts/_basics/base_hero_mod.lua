base_hero_mod = class ({})

function base_hero_mod:IsHidden() return true end
function base_hero_mod:IsPurgable() return false end

-- CONSTRUCTORS -----------------------------------------------------------

function base_hero_mod:OnCreated(kv)
	self.caster = self:GetCaster()
  self.parent = self:GetParent()
  self.ability = self:GetAbility()

  if not IsServer() then return end

  self:LoadData()
  self:StartIntervalThink(0.5)
  self:SetHasCustomTransmitterData(true)

  self.data_props = {
    buff_amp = 0,
    debuff_amp = 0,
    physical_damage = 0,
    magical_damage = 0,
    holy_damage = 0,
    heal_power = 0,
    luck = 0,
    power_boots_state = 1
  }
end

function base_hero_mod:OnRefresh(kv)
end

function base_hero_mod:AddCustomTransmitterData()
  return {
    data_props = self.data_props
  }
end

function base_hero_mod:HandleCustomTransmitterData(data)
	self.data_props = data.data_props
end

-- API FUNCTIONS -----------------------------------------------------------

function base_hero_mod:DeclareFunctions()
	local funcs = {
    MODIFIER_PROPERTY_OVERRIDE_ABILITY_SPECIAL,
		MODIFIER_PROPERTY_OVERRIDE_ABILITY_SPECIAL_VALUE,
		MODIFIER_EVENT_ON_TAKEDAMAGE,
		MODIFIER_PROPERTY_PRE_ATTACK,
		MODIFIER_EVENT_ON_ATTACK,
		MODIFIER_EVENT_ON_ATTACK_LANDED,
		MODIFIER_PROPERTY_TRANSLATE_ATTACK_SOUND,
		MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS
	}

	return funcs
end

function base_hero_mod:GetModifierOverrideAbilitySpecial(keys)
	local caster = self:GetCaster()
	local ability = keys.ability
	local value_name = keys.ability_special_value
	local value_level = keys.ability_special_level

	if ability:GetAbilityName() == "item_rare_iron_shield" then
		if value_name == "block_chance" then return 1 end
	end

  if ability:GetAbilityName() == "item_rare_cloak_evasion" then
		if value_name == "invi_chance" then return 1 end
		if value_name == "invi_duration" then return 1 end
	end

  if ability:GetAbilityName() == "item_rare_wizard_garb" then
		if value_name == "mana_gain" then return 1 end
	end

  if ability:GetAbilityName() == "item_rare_healing_mail" then
		if value_name == "heal" then return 1 end
	end

  if ability:GetAbilityName() == "item_epic_dark_shield" then
		if value_name == "chance" then return 1 end
	end

  if ability:GetAbilityName() == "item_epic_holy_mail" then
		if value_name == "damage" then return 1 end
	end

  if ability:GetAbilityName() == "item_epic_fire_mail" then
		if value_name == "damage" then return 1 end
	end

  if ability:GetAbilityName() == "item_epic_spectral_armor" then
		if value_name == "duration" then return 1 end
	end

  if ability:GetAbilityName() == "item_rare_power_boots" then
		if value_name == "state" then return 1 end
	end

  if ability:GetAbilityName() == "item_rare_nature_ring" then
		if value_name == "heal" then return 1 end
	end

	return 0
end

function base_hero_mod:GetModifierOverrideAbilitySpecialValue(keys)
	local caster = self:GetCaster()
	local ability = keys.ability
	local value_name = keys.ability_special_value
	local value_level = keys.ability_special_level
	local ability_level = ability:GetLevel()
	if ability_level < 1 then ability_level = 1 end

  local mana_mult = (1 + ((ability_level - 1) * 0.1))

	if ability:GetAbilityName() == "item_rare_iron_shield" then
		if value_name == "block_chance" then return self:CalcLuck(25) end
	end

  if ability:GetAbilityName() == "item_rare_cloak_evasion" then
		if value_name == "invi_chance" then return self:CalcLuck(40) end
		if value_name == "invi_duration" then return 2 * self:GetBuffAmp() end
	end

  if ability:GetAbilityName() == "item_rare_wizard_garb" then
		if value_name == "mana_gain" then return math.floor(10 * self:GetHealPower()) end
	end

  if ability:GetAbilityName() == "item_rare_healing_mail" then
		if value_name == "heal" then return math.floor(15 * self:GetHealPower()) end
	end

  if ability:GetAbilityName() == "item_epic_dark_shield" then
		if value_name == "chance" then return self:CalcLuck(10) end
	end

  if ability:GetAbilityName() == "item_epic_holy_mail" then
		if value_name == "damage" then return 50 * self:GetHolyDamageAmp() end
	end

  if ability:GetAbilityName() == "item_epic_fire_mail" then
		if value_name == "damage" then return 30 * self:GetMagicalDamageAmp() end
	end

  if ability:GetAbilityName() == "item_epic_spectral_armor" then
		if value_name == "duration" then return 10 * self:GetBuffAmp() end
	end

  if ability:GetAbilityName() == "item_rare_power_boots" then
		if value_name == "state" then return self.data_props["power_boots_state"] end
	end

  if ability:GetAbilityName() == "item_rare_nature_ring" then
		if value_name == "heal" then return 300 * self:GetHealPower() end
	end

	return 0
end

function base_hero_mod:OnTakeDamage(keys)
  if self.parent:IsHero() == false then return end
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

function base_hero_mod:OnIntervalThink()
  if not IsServer() then return end

  if self.parent:IsControllableByAnyPlayer() then
		local player = self:GetCaster():GetPlayerOwner()
		if (not player) then return end

    CustomGameEventManager:Send_ServerToPlayer(player, "unit_info_request_from_lua", {})
  end
end

-- UTILS -----------------------------------------------------------

function base_hero_mod:LoadData()
  local data = self.ability.hero_data.model
  self.hero_name = self.caster:GetHeroName()
  self.hero_team = self.caster:GetHeroTeam()

  self.pre_attack_sound = self.ability.hero_data.sound.pre_attack
	--if self.hero_name == "icebreaker" then self.pre_attack_sound = "hero_bloodseeker.PreAttack" end
	--if self.hero_name == "krieger" then self.pre_attack_sound = "Krieger.Pre.Attack" end

	self.attack_sound = self.ability.hero_data.sound.attack_start
	--if self.hero_name == "dasdingo" then self.attack_sound = "Hero_ShadowShaman.Attack" end
  --if self.hero_name == "lawbreaker" then self.attack_sound = "Hero_Muerta.Attack" end
	--if self.hero_name == "druid" then self.attack_sound = "Hero_Furion.Attack" end
	--if self.hero_name == "hunter" then self.attack_sound = "Hero_Sniper.MKG_attack" end

	self.attack_landed_sound = self.ability.hero_data.sound.attack_landed
	--if self.hero_name == "icebreaker" then self.attack_landed_sound = "Hero_Riki.Attack" end
	--if self.hero_name == "bocuse" then self.attack_landed_sound = "Hero_Pudge.Attack" end
	--if self.hero_name == "baldur" then self.attack_landed_sound = "Hero_Bristleback.Attack" end
	--if self.hero_name == "ancient" then self.attack_landed_sound = "Hero_ElderTitan.Attack" end
	--if self.hero_name == "hunter" then self.attack_landed_sound = "Hero_Sniper.MKG_impact" end
	--if self.hero_name == "trickster" then self.attack_landed_sound = "Trickster.Hit" end
	--if self.hero_name == "krieger" then self.attack_landed_sound = "krieger.Attack" end

	Timers:CreateTimer((0.5), function()
		self.activity = self.ability.hero_data.model.activity
		--if self.hero_name == "icebreaker" then self.activity = "shinobi_tail" end
		--if self.hero_name == "dasdingo" then self.activity = "fall20" end
		--if self.hero_name == "bocuse" then self.activity = "trapper" end
		--if self.hero_name == "ancient" then self.activity = "et_2021" end
		--if self.hero_name == "hunter" then self.activity = "MGC" end
    --if self.hero_name == "druid" then self.activity = "when_nature_attacks" end
	end)

	Timers:CreateTimer((0.1), function()
		if self.parent then
			if IsValidEntity(self.parent) then
        self.model_scale = data.scale
        self.parent.hp_offset = data.hp_offset
        self.parent:SetModelScale(data.scale)
        self.parent:SetHealthBarOffsetOverride(data.hp_offset)
        self.parent:SetMaterialGroup(data.material_group)

        --if self.hero_name == "bocuse" then self:SetScale(1.15, 230, "1") end
        --if self.hero_name == "hunter" then self:SetScale(1, 200, "1") end
				--if self.hero_name == "ancient" then self:SetScale(1.07, 250, "") end

        -- SHIELD EFX
        -- if GetHeroName(self.parent) == "lawbreaker" then size = 185 end
        -- if GetHeroName(self.parent) == "bocuse" then size = 210 end
        -- if GetHeroName(self.parent) == "vulture" then size = 250 end

        -- if GetHeroName(self.parent) == "dasdingo" then size = 175 end
        -- if GetHeroName(self.parent) == "druid" then size = 185 end
        -- if GetHeroName(self.parent) == "hunter" then size = 165 end

        -- if GetHeroName(self.parent) == "icebreaker" then size = 155 end

        -- if GetHeroName(self.parent) == "ancient" then size = 250 end
        -- if GetHeroName(self.parent) == "baldur" then size = 175 end
			end
		end
	end)

  if self.hero_name == "shadow" then
		--self:PlayEfxAmbient("particles/econ/items/phantom_assassin/phantom_assassin_arcana_elder_smith/pa_arcana_elder_ambient.vpcf", "attach_hitloc")
	end
end

function base_hero_mod:ChangeActivity(string)
  self.activity = string
end

function base_hero_mod:ChangeSounds(pre_attack, attack, attack_landed)
	if pre_attack then self.pre_attack_sound = pre_attack end
	if attack then self.attack_sound = attack end
	if attack_landed then self.attack_landed_sound = attack_landed end
end

function base_hero_mod:UpdateData(data, value)
	self.data_props[data] = value
  self:SendBuffRefreshToClients()
end

function base_hero_mod:GetBuffAmp()
  return 1 + self.data_props["buff_amp"]
end

function base_hero_mod:GetDebuffAmp()
  return 1 + self.data_props["debuff_amp"]
end

function base_hero_mod:GetPhysicalDamageAmp()
  return self.data_props["physical_damage"] * 0.01
end

function base_hero_mod:GetMagicalDamageAmp()
  return self.data_props["magical_damage"] * 0.01
end

function base_hero_mod:GetHolyDamageAmp()
  return self.data_props["holy_damage"] * 0.01
end

function base_hero_mod:GetHealPower()
  return 1 + self.data_props["heal_power"]
end

function base_hero_mod:CalcLuck(value)
  local result = value * (1 + self.data_props["luck"])
  if result < 0 then result = 0 elseif result > 100 then result = 100 end

  return result
end

-- EFFECTS -----------------------------------------------------------

function base_hero_mod:PlayEfxAmbient(ambient, attach)
	local effect_cast = ParticleManager:CreateParticle(ambient, PATTACH_POINT_FOLLOW, self.parent)
	ParticleManager:SetParticleControl(effect_cast, 0, self.parent:GetOrigin())
	ParticleManager:SetParticleControlEnt(effect_cast, 0, self.parent, PATTACH_POINT_FOLLOW, attach, Vector(0,0,0), true)
	self:AddParticle(effect_cast, false, false, -1, false, false)
end

-- function base_hero_mod:OnIntervalThink()
--     --print("x", self.parent:GetAbsOrigin().x, "| y", self.parent:GetAbsOrigin().y, "| z", self.parent:GetAbsOrigin().z)
-- end

-- function base_hero_mod:OnIntervalThink()
-- 	local message = "x:" .. self.parent:GetOrigin().x .. "; y:" .. self.parent:GetOrigin().y .. "; loc"
-- 	--print(message)
-- end