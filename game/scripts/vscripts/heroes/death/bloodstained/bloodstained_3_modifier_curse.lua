bloodstained_3_modifier_curse = class({})

function bloodstained_3_modifier_curse:IsHidden() return false end
function bloodstained_3_modifier_curse:IsPurgable() return true end
function bloodstained_3_modifier_curse:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end
function bloodstained_3_modifier_curse:RemoveOnDeath() return false end

-- CONSTRUCTORS -----------------------------------------------------------

function bloodstained_3_modifier_curse:OnCreated(kv)
  self.caster = self:GetCaster()
  self.parent = self:GetParent()
  self.ability = self:GetAbility()

  if not IsServer() then return end

	if self.parent ~= self.caster then
    local mod = self.caster:AddModifier(self.ability, self:GetName(), {})
    local mod_ms = self.caster:AddSubStats(self.ability, {speed = self.ability:GetSpecialValueFor("special_ms")})

    if self.ability:GetSpecialValueFor("special_mute") == 1 then
      self.parent:AddModifier(self.ability, "_modifier_mute", {})
    end

    self:SetEndCallback(function(interrupted)
      mod:Destroy()
      mod_ms:Destroy()
    end)
	end

  self:PlayEfxStart()
  self:OnIntervalThink()
end

function bloodstained_3_modifier_curse:OnRefresh(kv)
end

function bloodstained_3_modifier_curse:OnRemoved()
	if self.parent ~= self.caster then
    if self.endCallback then self.endCallback(self.interrupted) end

    self.parent:RemoveAllModifiersByNameAndAbility("_modifier_mute", self.ability)

    if self.parent:IsMagicImmune() == false then
      self.parent:AddSubStats(self.ability, {
        slow_percent = self.ability:GetSpecialValueFor("special_slow_percent"),
        duration = self.ability:GetSpecialValueFor("special_slow_duration"),
        bResist = 1
      })
    end
	end
end

function bloodstained_3_modifier_curse:SetEndCallback(func)
	self.endCallback = func
end

-- API FUNCTIONS -----------------------------------------------------------

function bloodstained_3_modifier_curse:DeclareFunctions()
	local funcs = {
    MODIFIER_EVENT_ON_DEATH,
		MODIFIER_EVENT_ON_TAKEDAMAGE
	}

	return funcs
end

function bloodstained_3_modifier_curse:OnDeath(keys)
  if not IsServer() then return end

  if self.parent == self.caster then return end
  if keys.unit == self.parent or keys.unit == self.caster then
    self:Destroy()
  end
end

function bloodstained_3_modifier_curse:OnTakeDamage(keys)
  if not IsServer() then return end

  if self.parent == self.caster then return end
  if keys.unit ~= self.parent and keys.unit ~= self.caster then return end

  local attacker = self.parent
	local victim = self.caster

  if keys.unit == self.caster then
    attacker = self.caster
    victim = self.parent
  end

	local shared_damage = self.ability:GetSpecialValueFor("shared_damage")
	local damage = (keys.damage * shared_damage * 0.01)

	if keys.damage_flags ~= 31 and keys.damage_flags ~= 1040 then
    ApplyDamage({
      victim = victim, attacker = attacker, damage = damage,
      damage_type = keys.damage_type, ability = self.ability,
      damage_flags = 31
    })
  end
end

function bloodstained_3_modifier_curse:OnIntervalThink()
  if not IsServer() then return end

  if self.parent ~= self.caster then
    AddFOWViewer(self.caster:GetTeamNumber(), self.parent:GetOrigin(), 75, 0.15, true)

    local current_distance = CalcDistanceBetweenEntityOBB(self.caster, self.parent)
    local max_range = self.ability:GetSpecialValueFor("max_range")
    if current_distance > max_range then self:Destroy() end
  end

  self:StartIntervalThink(0.1)
end

-- UTILS -----------------------------------------------------------

-- EFFECTS -----------------------------------------------------------

function bloodstained_3_modifier_curse:PlayEfxStart()
	local particle_cast = "particles/units/heroes/hero_queenofpain/queen_shadow_strike_body.vpcf"
	local effect_cast = ParticleManager:CreateParticle(particle_cast, PATTACH_ABSORIGIN_FOLLOW, self.parent)
	ParticleManager:SetParticleControlEnt(effect_cast, 1, self.parent, PATTACH_ABSORIGIN_FOLLOW, "", Vector(0,0,0), true)

	if self.caster ~= self.parent then
    local particle_cast_2 = "particles/econ/items/grimstroke/gs_fall20_immortal/gs_fall20_immortal_soulbind.vpcf"
    local effect_cast_2 = ParticleManager:CreateParticle(particle_cast_2, PATTACH_ABSORIGIN_FOLLOW, self.parent)
    ParticleManager:SetParticleControlEnt(effect_cast_2, 0, self.parent, PATTACH_POINT_FOLLOW, "attach_hitloc", Vector(0,0,0), true)
    ParticleManager:SetParticleControlEnt(effect_cast_2, 1, self.caster, PATTACH_POINT_FOLLOW, "attach_hitloc", Vector(0,0,0), true)
    self:AddParticle(effect_cast_2, false, false, -1, false, false)
  end
end