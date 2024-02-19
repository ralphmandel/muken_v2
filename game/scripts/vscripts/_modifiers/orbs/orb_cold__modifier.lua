orb_cold__modifier = class({})

function orb_cold__modifier:IsHidden() return false end
function orb_cold__modifier:IsPurgable() return false end
function orb_cold__modifier:RemoveOnDeath() return false end

-- CONSTRUCTORS -----------------------------------------------------------

function orb_cold__modifier:OnCreated(kv)
  self.caster = self:GetCaster()
  self.parent = self:GetParent()
  self.ability = self:GetAbility()

  self.cold_duration = 1.5

  self.damage_percent = 50
  self.magical_damage = 25
  self.status_mult = 0.05

  self.damageTable = {
    attacker = self.caster,
    ability = self.ability,
		damage_type = DAMAGE_TYPE_MAGICAL
  }

  if not IsServer() then return end

  self.parent:EmitSound("hero_Crystal.attack")
end

function orb_cold__modifier:OnRefresh(kv)
end

function orb_cold__modifier:OnRemoved()
end

-- API FUNCTIONS -----------------------------------------------------------

function orb_cold__modifier:DeclareFunctions()
	local funcs = {
    MODIFIER_PROPERTY_BASEDAMAGEOUTGOING_PERCENTAGE,
		MODIFIER_EVENT_ON_ATTACK_LANDED
	}

	return funcs
end

function orb_cold__modifier:GetModifierBaseDamageOutgoing_Percentage(keys)
  return -self.damage_percent
end

function orb_cold__modifier:OnAttackLanded(keys)
  if not IsServer() then return end

	if keys.attacker ~= self.parent then return end

  self.damageTable.victim = keys.target
  self.damageTable.damage = self.parent:GetSpellDamage(self.magical_damage, DAMAGE_TYPE_MAGICAL)
  local damage_result = ApplyDamage(self.damageTable)

  if self.parent:PassivesDisabled() then return end
  if keys.target == nil then return end
  if IsValidEntity(keys.target) == false then return end
  if keys.target:IsAlive() == false then return end

  keys.target:AddModifier(self.ability, "status_bar_cold", {
    inflictor = self.caster:entindex(),
    status_amount = damage_result * self.status_mult
  })

  local modifiers = keys.target:FindAllModifiersByName("orb_cold_debuff")
  for _, modifier in pairs(modifiers) do
    if modifier:GetAbility() == self.ability then
      modifier:OnRefresh({duration = self.cold_duration})
      return
    end
  end
  
  keys.target:AddModifier(self.ability, "orb_cold_debuff", {duration = self.cold_duration})
end

-- UTILS -----------------------------------------------------------

-- EFFECTS -----------------------------------------------------------

function orb_cold__modifier:GetEffectName()
	return "particles/units/heroes/hero_ancient_apparition/ancient_apparition_chilling_touch_buff.vpcf"
end

function orb_cold__modifier:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end