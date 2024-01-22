neutral_doom = class({})
LinkLuaModifier("neutral_doom_modifier_passive", "_neutrals/neutral_doom_modifier_passive", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("neutral_doom_modifier_pre", "_neutrals/neutral_doom_modifier_pre", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("neutral_doom_modifier_debuff", "_neutrals/neutral_doom_modifier_debuff", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("neutral_doom_modifier_debuff_status_efx", "_neutrals/neutral_doom_modifier_debuff_status_efx", LUA_MODIFIER_MOTION_NONE)

function neutral_doom:Spawn()
  if not IsServer() then return end

  Timers:CreateTimer((0.2), function()
    if IsServer() then
      self:SetLevel(self:GetMaxLevel())
    end
  end)
end

function neutral_doom:GetIntrinsicModifierName()
	return "neutral_doom_modifier_passive"
end

function neutral_doom:OnAbilityPhaseStart()
  if not IsServer() then return true end

  local target = self:GetCursorTarget()
  AddModifier(target, self, "neutral_doom_modifier_pre", {}, false)

  return true
end

function neutral_doom:OnAbilityPhaseInterrupted()
  if not IsServer() then return end

  local target = self:GetCursorTarget()
  target:RemoveModifierByName("neutral_doom_modifier_pre")
end

function neutral_doom:OnSpellStart()
  if not IsServer() then return end

	local caster = self:GetCaster()
  local target = self:GetCursorTarget()

  if target:TriggerSpellAbsorb(self) then return end

  target:RemoveModifierByName("neutral_doom_modifier_pre")
  AddModifier(target, self, "neutral_doom_modifier_debuff", {duration = self:GetSpecialValueFor("duration")}, true)

  self:PlayEfxStart(target)
end

function neutral_doom:PlayEfxStart(target)
	local string_1 = "particles/items_fx/abyssal_blink_start.vpcf"
	local particle_1 = ParticleManager:CreateParticle(string_1, PATTACH_ABSORIGIN_FOLLOW, target)
	ParticleManager:SetParticleControl(particle_1, 0, target:GetOrigin())
	ParticleManager:ReleaseParticleIndex(particle_1)

  if IsServer() then target:EmitSound("Hero_DoomBringer.InfernalBlade.Target") end
end