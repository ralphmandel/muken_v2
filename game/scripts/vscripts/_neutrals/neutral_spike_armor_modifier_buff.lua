neutral_spike_armor_modifier_buff = class({})

function neutral_spike_armor_modifier_buff:IsHidden() return false end
function neutral_spike_armor_modifier_buff:IsPurgable() return true end

-- CONSTRUCTORS -----------------------------------------------------------

function neutral_spike_armor_modifier_buff:OnCreated(kv)
  self.caster = self:GetCaster()
  self.parent = self:GetParent()
  self.ability = self:GetAbility()

  AddModifier(self.parent, self.ability, "sub_stat_movespeed_percent_increase", {
    value = self.ability:GetSpecialValueFor("ms_percent")
  }, false)

  self.ability:SetActivated(false)
  self.ability:EndCooldown()

  if IsServer() then self.parent:EmitSound("DOTA_Item.BladeMail.Activate") end
end

function neutral_spike_armor_modifier_buff:OnRefresh(kv)
end

function neutral_spike_armor_modifier_buff:OnRemoved()
  RemoveAllModifiersByNameAndAbility(self.parent, "sub_stat_movespeed_percent_increase", self.ability)

  self.ability:SetActivated(true)
  self.ability:StartCooldown(self.ability:GetEffectiveCooldown(self.ability:GetLevel()))
end

-- API FUNCTIONS -----------------------------------------------------------

function neutral_spike_armor_modifier_buff:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_TAKEDAMAGE
	}

	return funcs
end

function neutral_spike_armor_modifier_buff:OnTakeDamage(keys)
  if keys.unit ~= self.parent then return end
  if keys.attacker == nil then return end
	if keys.attacker:IsBaseNPC() == false then return end
  if self.parent:IsHero() == false
  and (keys.attacker:GetTeamNumber() == TIER_TEAMS[RARITY_COMMON] or keys.attacker:GetTeamNumber() >= TIER_TEAMS[RARITY_RARE]) then return end

	local return_percent = self.ability:GetSpecialValueFor("return_percent") * 0.01

	if keys.damage_flags ~= 31 and keys.damage_flags ~= 1040 then
		if IsServer() then keys.attacker:EmitSound("DOTA_Item.BladeMail.Damage") end

    ApplyDamage({
			attacker = self.caster, victim = keys.attacker, ability = self.ability,
			damage = keys.damage * return_percent, damage_type = keys.damage_type,
			damage_flags = 31
		})
	end
end

-- UTILS -----------------------------------------------------------

-- EFFECTS -----------------------------------------------------------

function neutral_spike_armor_modifier_buff:GetEffectName()
	return "particles/items_fx/blademail.vpcf"
end

function neutral_spike_armor_modifier_buff:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end