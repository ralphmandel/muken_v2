vulture__modifier_rot = class({})

function vulture__modifier_rot:IsHidden() return false end
function vulture__modifier_rot:IsPurgable() return false end

-- CONSTRUCTORS -----------------------------------------------------------

function vulture__modifier_rot:OnCreated(kv)
  self.caster = self:GetCaster()
  self.parent = self:GetParent()
  self.ability = self:GetAbility()

  local value = self.ability:GetSpecialValueFor("rot_stats")
  AddModifier(self.parent, self.ability, "main_stat_modifier", {str = value, agi = value, int = value, vit = value}, false)

  if IsServer() then
    self:StartIntervalThink(0.5)
  end
end

function vulture__modifier_rot:OnRefresh(kv)

end

function vulture__modifier_rot:OnRemoved()
  RemoveAllModifiersByNameAndAbility(self.parent, "main_stat_modifier", self.ability)
end

-- API FUNCTIONS -----------------------------------------------------------

function vulture__modifier_rot:OnIntervalThink()
  ApplyDamage({
    attacker = self.caster,
    victim = self.parent,
    damage = self.ability:GetSpecialValueFor("damage"),
    damage_type = DAMAGE_TYPE_MAGICAL,
    ability = self.ability
  })
end

-- UTILS -----------------------------------------------------------

-- EFFECTS -----------------------------------------------------------

function vulture__modifier_rot:PlayEfxTick()
 
end
-- function vulture__modifier_rot:GetEffectName()
-- 	return ""
-- end

-- function vulture__modifier_rot:GetEffectAttachType()
-- 	return PATTACH_ABSORIGIN_FOLLOW
-- end