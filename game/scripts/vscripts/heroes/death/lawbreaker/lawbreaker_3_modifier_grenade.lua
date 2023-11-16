lawbreaker_3_modifier_grenade = class({})

function lawbreaker_3_modifier_grenade:IsHidden() return false end
function lawbreaker_3_modifier_grenade:IsPurgable() return true end

-- CONSTRUCTORS -----------------------------------------------------------

function lawbreaker_3_modifier_grenade:OnCreated(kv)
  self.caster = self:GetCaster()
  self.parent = self:GetParent()
  self.ability = self:GetAbility()
  
  AddModifier(self.parent, self.ability, "sub_stat_modifier", {
    armor = self.ability:GetSpecialValueFor("armor"),
    miss_chance = self.ability:GetSpecialValueFor("miss_chance"),
  }, false)

  if IsServer() then self.parent:EmitSound("Hero_Muerta.DeadShot.Slow") end
end

function lawbreaker_3_modifier_grenade:OnRefresh(kv)
  RemoveSubStats(self.parent, self.ability, {"armor", "miss_chance"})

  AddModifier(self.parent, self.ability, "sub_stat_modifier", {
    armor = self.ability:GetSpecialValueFor("armor"),
    miss_chance = self.ability:GetSpecialValueFor("miss_chance"),
  }, false)

  if IsServer() then self.parent:EmitSound("Hero_Muerta.DeadShot.Slow") end
end

function lawbreaker_3_modifier_grenade:OnRemoved()
  RemoveSubStats(self.parent, self.ability, {"armor", "miss_chance"})
end

-- API FUNCTIONS -----------------------------------------------------------

-- UTILS -----------------------------------------------------------

-- EFFECTS -----------------------------------------------------------

function lawbreaker_3_modifier_grenade:GetEffectName()
	return "particles/lawbreaker/grenade/lawbreaker_grenade_slow.vpcf"
end

function lawbreaker_3_modifier_grenade:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end