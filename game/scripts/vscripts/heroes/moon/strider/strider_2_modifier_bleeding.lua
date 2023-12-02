strider_2_modifier_bleeding = class({})

function strider_2_modifier_bleeding:IsHidden() return false end
function strider_2_modifier_bleeding:IsPurgable() return true end

-- CONSTRUCTORS -----------------------------------------------------------

function strider_2_modifier_bleeding:OnCreated(kv)
  self.caster = self:GetCaster()
  self.parent = self:GetParent()
  self.ability = self:GetAbility()

  if IsServer() then

    self:PlayEfxStart()
    if not self.parent.damage_received then
			self.parent.damage_received = 0
		end
  end
	caster:StartGestureWithFadeAndPlaybackRate(ACT_DOTA_OVERRIDE_ABILITY_1, 0, 0.24, 1)

end

function strider_2_modifier_bleeding:OnRefresh(kv)
  if IsServer() then
    self:PlayEfxStart()
  end
end

function strider_2_modifier_bleeding:OnRemoved()
	if self.particle_silence then ParticleManager:DestroyParticle(self.particle_silence, true) end

 
end

function strider_2_modifier_bleeding:OnDestroy()
  if IsServer() then
		end
	end
end

-- API FUNCTIONS -----------------------------------------------------------

function strider_2_modifier_bleeding:OnIntervalThink()

end


function strider_2_modifier_bleeding:DeclareFunctions()
	return {
		MODIFIER_EVENT_ON_TAKEDAMAGE
	}
end

-- UTILS -----------------------------------------------------------

-- EFFECTS -----------------------------------------------------------

-- function strider_2_modifier_bleeding:GetEffectName()
-- 	return "particles/items2_fx/orchid.vpcf"
-- end

-- function strider_2_modifier_bleeding:GetEffectAttachType()
-- 	return PATTACH_OVERHEAD_FOLLOW
-- end

function strider_2_modifier_bleeding:PlayEfxStart()
  if IsServer() then self.parent:EmitSound("Hero_PhantomAssassin.Dagger.Target") end

end

function strider_2_modifier_bleeding:GetEffectName()
	return "particles/econ/items/phantom_assassin/pa_ti8_immortal_head/pa_ti8_immortal_dagger_debuff.vpcf"
end

function strider_2_modifier_bleeding:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end


-- function strider_2_modifier_bleeding:PlayEfxEnemy()
--   local particle_cast = "particles/econ/items/phantom_assassin/pa_ti8_immortal_head/pa_ti8_immortal_dagger_debuff.vpcf"
--   local effect_cast = ParticleManager:CreateParticle(particle_cast, PATTACH_ABSORIGIN_FOLLOW, self.parent)
--   ParticleManager:SetParticleControl(effect_cast, 2, Vector(radius, radius, radius))
-- end



