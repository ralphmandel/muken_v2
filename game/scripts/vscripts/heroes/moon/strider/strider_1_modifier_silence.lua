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

  if IsServer() then
    self.parent:EmitSound("Hero_PhantomAssassin.Dagger.Target")
		self:StartIntervalThink(self:GetDuration())
  end
end

function strider_1_modifier_silence:OnRefresh(kv)
  if IsServer() then
    self.parent:EmitSound("Hero_PhantomAssassin.Dagger.Target")
		self:StartIntervalThink(self:GetDuration())
  end
end

function strider_1_modifier_silence:OnRemoved(bDeath)
  if self.damage_received > 0 and (self.purge == false or bDeath == true) then
    self.caster:Heal(self.damage_received * self.ability:GetSpecialValueFor("heal_bonus") * 0.01, self.ability)    
    self:PlayEfxEnd()
  end
end

-- API FUNCTIONS -----------------------------------------------------------

function strider_1_modifier_silence:DeclareFunctions()
	return {
		MODIFIER_EVENT_ON_TAKEDAMAGE
	}
end

function strider_1_modifier_silence:OnTakeDamage(keys)
  if keys.unit ~= self.parent then return end
  self.damage_received = self.damage_received + keys.damage
end

function strider_1_modifier_silence:CheckState()
	local state = {
		[MODIFIER_STATE_SILENCED] = true
	}

	return state
end

function strider_1_modifier_silence:OnIntervalThink()
	self.purge = false
end

-- UTILS -----------------------------------------------------------

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



