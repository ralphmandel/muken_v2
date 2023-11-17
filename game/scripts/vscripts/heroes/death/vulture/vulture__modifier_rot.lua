vulture__modifier_rot = class({})

function vulture__modifier_rot:IsHidden() return false end
function vulture__modifier_rot:IsPurgable() return false end
function vulture__modifier_rot:GetTexture() return "vulture_rot" end

-- CONSTRUCTORS -----------------------------------------------------------

function vulture__modifier_rot:OnCreated(kv)
  self.caster = self:GetCaster()
  self.parent = self:GetParent()
  self.ability = self:GetAbility()

  local value = self.ability:GetSpecialValueFor("rot_stats")
  AddModifier(self.parent, self.ability, "main_stat_modifier", {str = value, agi = value, int = value, vit = value}, false)

  local interval = 0.5

  self.damageTable = {
    attacker = self.caster,
    victim = self.parent,
    damage = self.ability:GetSpecialValueFor("damage") * interval,
    damage_type = DAMAGE_TYPE_MAGICAL,
    ability = self.ability
  }

  if IsServer() then
    self:SetStackCount(100)
    self:StartIntervalThink(interval)
    self:PlayEfxTick()
  end
end

function vulture__modifier_rot:OnRefresh(kv)

end

function vulture__modifier_rot:OnRemoved()
  RemoveAllModifiersByNameAndAbility(self.parent, "main_stat_modifier", self.ability)
end

-- API FUNCTIONS -----------------------------------------------------------

function vulture__modifier_rot:OnIntervalThink()
  ApplyDamage(self.damageTable)
end

-- UTILS -----------------------------------------------------------

-- EFFECTS -----------------------------------------------------------

function vulture__modifier_rot:PlayEfxTick()
  local string = "particles/vulture/vulture_immortal_arm_rot.vpcf"
  self.effect_cast = ParticleManager:CreateParticle(string, PATTACH_ABSORIGIN_FOLLOW, self.parent)
  self:AddParticle(self.effect_cast, false, false, -1, false, false)
end
-- function vulture__modifier_rot:GetEffectName()
-- 	return ""
-- end

-- function vulture__modifier_rot:GetEffectAttachType()
-- 	return PATTACH_ABSORIGIN_FOLLOW
-- end