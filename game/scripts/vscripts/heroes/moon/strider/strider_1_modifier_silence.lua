strider_1_modifier_silence = class({})

function strider_1_modifier_silence:IsHidden() return false end
function strider_1_modifier_silence:IsPurgable() return true end

-- CONSTRUCTORS -----------------------------------------------------------

function strider_1_modifier_silence:OnCreated(kv)
  self.caster = self:GetCaster()
  self.parent = self:GetParent()
  self.ability = self:GetAbility()
	self.purge = true

  if IsServer() then
		self:StartIntervalThink(self:GetDuration())
    self:PlayEfxStart()
    if not self.damage_received then
			self.damage_received = 0
		end
  end
end

function strider_1_modifier_silence:OnRefresh(kv)
  if IsServer() then
    self:PlayEfxStart()
  end
end

function strider_1_modifier_silence:OnRemoved(bDeath)
--	if self.particle_silence then ParticleManager:DestroyParticle(self.particle_silence, true) end

		-- If damage was taken, play the effect and damage the self.parent
		if self.damage_received > 0 then

			-- Calculate and heal strider
			local heal_base = self.ability:GetSpecialValueFor("heal_base")
			local heal_bonus = self.ability:GetSpecialValueFor("heal_bonus")
			local heal_amount = (self.damage_received * (heal_bonus / 100)) -- + heal_base -  TALENT UPGRADE

			-- Fire damage particle
			local orchid_end_pfx = ParticleManager:CreateParticle("particles/items2_fx/orchid_pop.vpcf", PATTACH_OVERHEAD_FOLLOW, self.parent)
			ParticleManager:SetParticleControl(orchid_end_pfx, 0, self.parent:GetAbsOrigin())
			ParticleManager:SetParticleControl(orchid_end_pfx, 1, Vector(100, 0, 0))
			ParticleManager:ReleaseParticleIndex(orchid_end_pfx)

			-- Heal Strider based on target amount damage received
			if self.purge == false or bDeath == true then
				self.caster:Heal(heal_amount, self.ability)
			end

	-- Clear damage taken variable
		self.damage_received = nil
	end
end

-- function strider_1_modifier_silence:OnDestroy()
	
-- end

-- API FUNCTIONS -----------------------------------------------------------

function strider_1_modifier_silence:OnIntervalThink()
	self.purge = false
end


function strider_1_modifier_silence:DeclareFunctions()
	return {
		MODIFIER_EVENT_ON_TAKEDAMAGE
	}
end

function strider_1_modifier_silence:OnTakeDamage(keys)
	if IsServer() then
		local target = keys.unit

		-- If this unit is the one suffering damage, store it
		if self.parent == target then
			self.damage_received = self.damage_received + keys.damage
		end
	end
end

function strider_1_modifier_silence:CheckState()
	local state = {
		[MODIFIER_STATE_SILENCED] = true,
	}

	return state
end

-- UTILS -----------------------------------------------------------

-- EFFECTS -----------------------------------------------------------

-- function strider_1_modifier_silence:GetEffectName()
-- 	return "particles/items2_fx/orchid.vpcf"
-- end

-- function strider_1_modifier_silence:GetEffectAttachType()
-- 	return PATTACH_OVERHEAD_FOLLOW
-- end

function strider_1_modifier_silence:PlayEfxStart()
  if IsServer() then self.parent:EmitSound("Hero_PhantomAssassin.Dagger.Target") end

end

function strider_1_modifier_silence:GetEffectName()
	return "particles/econ/items/phantom_assassin/pa_ti8_immortal_head/pa_ti8_immortal_dagger_debuff.vpcf"
end

function strider_1_modifier_silence:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end


-- function strider_1_modifier_silence:PlayEfxEnemy()
--   local particle_cast = "particles/econ/items/phantom_assassin/pa_ti8_immortal_head/pa_ti8_immortal_dagger_debuff.vpcf"
--   local effect_cast = ParticleManager:CreateParticle(particle_cast, PATTACH_ABSORIGIN_FOLLOW, self.parent)
--   ParticleManager:SetParticleControl(effect_cast, 2, Vector(radius, radius, radius))
-- end



