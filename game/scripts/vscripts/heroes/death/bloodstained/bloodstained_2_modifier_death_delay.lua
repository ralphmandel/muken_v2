bloodstained_2_modifier_death_delay = class({})

function bloodstained_2_modifier_death_delay:IsHidden() return false end
function bloodstained_2_modifier_death_delay:IsPurgable() return false end
function bloodstained_2_modifier_death_delay:GetTexture() return "dasdingo_immortal" end

-- CONSTRUCTORS -----------------------------------------------------------

function bloodstained_2_modifier_death_delay:OnCreated(kv)
  self.caster = self:GetCaster()
  self.parent = self:GetParent()
  self.ability = self:GetAbility()

  if not IsServer() then return end

  self.killer = EntIndexToHScript(kv.killer)
  self.inflictor = EntIndexToHScript(kv.inflictor)

  self.parent:EmitSound("Hero_SkeletonKing.Reincarnate.Ghost")
  self.parent:AddStatusEfx(self.caster, self.ability, "bloodstained_2_modifier_death_delay_status_efx")
end

function bloodstained_2_modifier_death_delay:OnRefresh(kv)
end

function bloodstained_2_modifier_death_delay:OnRemoved()
  if not IsServer() then return end

  if IsValidEntity(self.killer) == false then self.killer = self.caster end
  if IsValidEntity(self.inflictor) == false then self.inflictor = self.ability end

  self.parent:RemoveStatusEfx(self.caster, self.ability, "bloodstained_2_modifier_death_delay_status_efx")

  self.ability.min_hp = 0
  self.parent:Kill(self.inflictor, self.killer)
end

-- API FUNCTIONS -----------------------------------------------------------

-- UTILS -----------------------------------------------------------

-- EFFECTS -----------------------------------------------------------

function bloodstained_2_modifier_death_delay:GetEffectName()
	return "particles/units/heroes/hero_skeletonking/wraith_king_ghosts_ambient.vpcf"
end

function bloodstained_2_modifier_death_delay:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

function bloodstained_2_modifier_death_delay:GetStatusEffectName()
	return "particles/status_fx/status_effect_wraithking_ghosts.vpcf"
end

function bloodstained_2_modifier_death_delay:StatusEffectPriority()
	return 99999999
end