strider_1_modifier_silence = class({})

function strider_1_modifier_silence:IsHidden() return false end
function strider_1_modifier_silence:IsPurgable() return true end

-- CONSTRUCTORS -----------------------------------------------------------

function strider_1_modifier_silence:OnCreated(kv)
  self.caster = self:GetCaster()
  self.parent = self:GetParent()
  self.ability = self:GetAbility()

	self.purge = true
  self.damage_received = 0
  self.health_cost = kv.health_cost

  AddModifier(self.parent, self.ability, "_modifier_silence", {duration = self:GetDuration(), special = 2}, false)

  if self.ability:GetSpecialValueFor("special_disarm") == 1 then
    AddModifier(self.parent, self.ability, "_modifier_disarm", {}, false)
  end

  if IsServer() then
    self.parent:EmitSound("Hero_PhantomAssassin.Dagger.Target")
		self:StartIntervalThink(self:GetDuration())
  end
end

function strider_1_modifier_silence:OnRefresh(kv)
  self:CalcDebuff(true)

  self.purge = true
  self.damage_received = 0
  self.health_cost = kv.health_cost

  RemoveAllModifiersByNameAndAbility(self.parent, "_modifier_silence", self.ability)
  RemoveAllModifiersByNameAndAbility(self.parent, "_modifier_disarm", self.ability)

  AddModifier(self.parent, self.ability, "_modifier_silence", {duration = self:GetDuration(), special = 2}, false)

  if self.ability:GetSpecialValueFor("special_disarm") == 1 then
    AddModifier(self.parent, self.ability, "_modifier_disarm", {}, false)
  end

  if IsServer() then
    self.parent:EmitSound("Hero_PhantomAssassin.Dagger.Target")
		self:StartIntervalThink(self:GetDuration())
  end
end

function strider_1_modifier_silence:OnRemoved(bDeath)
  RemoveAllModifiersByNameAndAbility(self.parent, "_modifier_silence", self.ability)
  RemoveAllModifiersByNameAndAbility(self.parent, "_modifier_disarm", self.ability)
  self:CalcDebuff(bDeath)
end

-- API FUNCTIONS -----------------------------------------------------------

function strider_1_modifier_silence:DeclareFunctions()
	return {
		MODIFIER_EVENT_ON_TAKEDAMAGE
	}
end

function strider_1_modifier_silence:OnTakeDamage(keys)
  if keys.unit ~= self.parent then return end
  if keys.attacker == nil then return end
  if IsValidEntity(keys.attacker) == false then return end
  if keys.attacker:GetTeamNumber() ~= self.caster:GetTeamNumber() then return end

  self.damage_received = self.damage_received + keys.damage
end

function strider_1_modifier_silence:OnIntervalThink()
	self.purge = false
end

-- UTILS -----------------------------------------------------------

function strider_1_modifier_silence:CalcDebuff(bDeath)
  if self.damage_received > 0 and (self.purge == false or bDeath == true) then
    local stun_mult = self.ability:GetSpecialValueFor("special_stun_mult")
    local damage_mult = self.ability:GetSpecialValueFor("special_damage_mult")

    if stun_mult > 0 then
      AddModifier(self.parent, self.ability, "_modifier_stun", {
        duration = self.damage_received / (self.health_cost* stun_mult)
      }, false)
    end

    if damage_mult > 0 then
      ApplyDamage({
        victim = self.parent, attacker = self.caster, ability = self.ability,
        damage = self.damage_received / (self.health_cost * damage_mult),
        damage_type = self.ability:GetAbilityDamageType(),
        damage_flags = DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION
      })
    end

    self.caster:Heal(self.damage_received * self.ability:GetSpecialValueFor("heal_bonus") * 0.01, self.ability)    
    self:PlayEfxEnd()
  end
end

-- EFFECTS -----------------------------------------------------------

function strider_1_modifier_silence:GetEffectName()
	return "particles/econ/items/phantom_assassin/pa_ti8_immortal_head/pa_ti8_immortal_dagger_debuff.vpcf"
end

function strider_1_modifier_silence:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

function strider_1_modifier_silence:PlayEfxEnd()
  local string = "particles/items2_fx/orchid_pop.vpcf"
  local orchid_end_pfx = ParticleManager:CreateParticle(string, PATTACH_OVERHEAD_FOLLOW, self.parent)
  ParticleManager:SetParticleControl(orchid_end_pfx, 0, self.parent:GetAbsOrigin())
  ParticleManager:SetParticleControl(orchid_end_pfx, 1, Vector(100, 0, 0))
  ParticleManager:ReleaseParticleIndex(orchid_end_pfx)
end


-- function strider_1_modifier_silence:GetEffectName()
-- 	return "particles/items2_fx/orchid.vpcf"
-- end

-- function strider_1_modifier_silence:GetEffectAttachType()
-- 	return PATTACH_OVERHEAD_FOLLOW
-- end

-- function strider_1_modifier_silence:PlayEfxEnemy()
--   local particle_cast = "particles/econ/items/phantom_assassin/pa_ti8_immortal_head/pa_ti8_immortal_dagger_debuff.vpcf"
--   local effect_cast = ParticleManager:CreateParticle(particle_cast, PATTACH_ABSORIGIN_FOLLOW, self.parent)
--   ParticleManager:SetParticleControl(effect_cast, 2, Vector(radius, radius, radius))
-- end



