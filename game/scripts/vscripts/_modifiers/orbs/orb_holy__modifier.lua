orb_holy__modifier = class({})

function orb_holy__modifier:IsHidden() return false end
function orb_holy__modifier:IsPurgable() return false end
function orb_holy__modifier:RemoveOnDeath() return false end

-- CONSTRUCTORS -----------------------------------------------------------

function orb_holy__modifier:OnCreated(kv)
  self.caster = self:GetCaster()
  self.parent = self:GetParent()
  self.ability = self:GetAbility()

  self.damage_percent = 25
  self.holy_damage = 25

  self.damageTable = {
    attacker = self.caster,
    ability = self.ability,
		damage_type = DAMAGE_TYPE_PURE
  }
end

function orb_holy__modifier:OnRefresh(kv)
end

function orb_holy__modifier:OnRemoved()
end

-- API FUNCTIONS -----------------------------------------------------------

function orb_holy__modifier:DeclareFunctions()
	local funcs = {
    MODIFIER_PROPERTY_BASEDAMAGEOUTGOING_PERCENTAGE,
		MODIFIER_EVENT_ON_ATTACK_LANDED
	}

	return funcs
end

function orb_holy__modifier:GetModifierBaseDamageOutgoing_Percentage(keys)
  return -self.damage_percent
end

function orb_holy__modifier:OnAttackLanded(keys)
  if not IsServer() then return end

	if keys.attacker ~= self.parent then return end

  keys.target:EmitSound("Hero_Wisp.Attack")

  self.damageTable.victim = keys.target
  self.damageTable.damage = self.parent:GetSpellDamage(self.holy_damage, DAMAGE_TYPE_PURE)
  local damage_result = ApplyDamage(self.damageTable)
end

-- UTILS -----------------------------------------------------------

-- EFFECTS -----------------------------------------------------------

function orb_holy__modifier:GetEffectName()
	return "particles/generic/holy_orb_buff/holy_orb_buff.vpcf"
end

function orb_holy__modifier:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end