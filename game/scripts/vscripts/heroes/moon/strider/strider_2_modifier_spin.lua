strider_2_modifier_spin = class({})

function strider_2_modifier_spin:IsHidden() return true end
function strider_2_modifier_spin:IsPurgable() return false end

-- CONSTRUCTORS -----------------------------------------------------------

function strider_2_modifier_spin:OnCreated(kv)
  self.caster = self:GetCaster()
  self.parent = self:GetParent()
  self.ability = self:GetAbility()

	self.caster:StartGesture(ACT_DOTA_OVERRIDE_ABILITY_1)
  self.radius = self.ability:GetAOERadius()

	if IsServer() then
    self:PlayEfxStart()
    self:StartIntervalThink(0.1)
  end
end

function strider_2_modifier_spin:OnRefresh(kv)
end

function strider_2_modifier_spin:OnRemoved()
	self.caster:FadeGesture(ACT_DOTA_OVERRIDE_ABILITY_1)
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
