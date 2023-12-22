strider_2_modifier_spin = class({})

function strider_2_modifier_spin:IsHidden() return true end
function strider_2_modifier_spin:IsPurgable() return false end

-- CONSTRUCTORS -----------------------------------------------------------

function strider_2_modifier_spin:OnCreated(kv)
  self.caster = self:GetCaster()
  self.parent = self:GetParent()
  self.ability = self:GetAbility()
  self.aggro = nil

  if IsServer() then
    if kv.aggro then self.aggro = EntIndexToHScript(kv.aggro) end
    self.parent:Hold()

    if GetHeroName(self.parent) == "trickster" then
      self.caster:StartGestureWithPlaybackRate(ACT_DOTA_CAST_ABILITY_4_END, 1.7)
    else
      self.caster:StartGesture(ACT_DOTA_OVERRIDE_ABILITY_1)
    end

    self.radius = self.ability:GetAOERadius()
    self:PlayEfxStart()
    self:StartIntervalThink(0.1)
  end
end

function strider_2_modifier_spin:OnRefresh(kv)
end

function strider_2_modifier_spin:OnRemoved()
  if self.aggro then
    if IsValidEntity(self.aggro) then
      self.parent:MoveToTargetToAttack(self.aggro)
    end
  end

  if GetHeroName(self.parent) == "trickster" then
    self.caster:FadeGesture(ACT_DOTA_CAST_ABILITY_4_END)
  else
    self.caster:FadeGesture(ACT_DOTA_OVERRIDE_ABILITY_1)
  end
end

-- API FUNCTIONS -----------------------------------------------------------

function strider_2_modifier_spin:CheckState()
	local state = {
		[MODIFIER_STATE_IGNORING_MOVE_ORDERS] = true
	}

  return state
end

function strider_2_modifier_spin:OnIntervalThink()
  local critical_damage = MainStats(self.parent, "STR"):GetCriticalDamage() + self.ability:GetSpecialValueFor("special_crit_damage")

  local enemies = FindUnitsInRadius(
    self.caster:GetTeamNumber(), self.parent:GetOrigin(), nil, self.radius,
    self.ability:GetAbilityTargetTeam(), self.ability:GetAbilityTargetType(),
    self.ability:GetAbilityTargetFlags(), 0, false
  )

  for _,enemy in pairs(enemies) do
    RemoveAllModifiersByNameAndAbility(enemy, "_modifier_bleeding", self.ability)

    AddModifier(enemy, self.ability, "_modifier_bleeding", {
      duration = self.ability:GetSpecialValueFor("bleeding_duration")
    }, true)

    if self.ability:GetSpecialValueFor("special_crit_damage") > 0 then
      MainStats(self.parent, "STR"):SetForceCrit(100, critical_damage)
    end

    self:PlayEfxHit(enemy)
    self.parent:PerformAttack(enemy, false, true, true, true, false, false, true)
  end

	if IsServer() then self:StartIntervalThink(-1) end
end

-- UTILS -----------------------------------------------------------

-- EFFECTS -----------------------------------------------------------

function strider_2_modifier_spin:PlayEfxStart()
	local particle_cast = "particles/strider/spin/strider_bloodchaser.vpcf"
	local effect_cast = ParticleManager:CreateParticle(particle_cast, PATTACH_ABSORIGIN_FOLLOW, self.parent)
  ParticleManager:SetParticleControl(effect_cast, 1, Vector(self.radius, 0, 0))
	self:AddParticle(effect_cast, false, false, -1, false, false)
	ParticleManager:ReleaseParticleIndex(effect_cast)

	if IsServer() then self.parent:EmitSound("DOTA_Item.AbyssalBlade.Activate") end
end

function strider_2_modifier_spin:PlayEfxHit(target)
	local particle_cast = "particles/units/heroes/hero_juggernaut/juggernaut_blade_fury_tgt.vpcf"
	local effect_cast = ParticleManager:CreateParticle(particle_cast, PATTACH_ABSORIGIN_FOLLOW, target)
	ParticleManager:ReleaseParticleIndex(effect_cast)
end
