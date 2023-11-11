vulture_1__tree = class({})
LinkLuaModifier("vulture_1_modifier_tree", "heroes/death/vulture/vulture_1_modifier_tree", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("_modifier_stun", "_modifiers/_modifier_stun", LUA_MODIFIER_MOTION_NONE)

-- INIT

-- SPELL START

	function vulture_1__tree:OnSpellStart()
		local caster = self:GetCaster()
		self.tree = self:GetCursorTarget()
		local direction = self:GetCursorPosition() - caster:GetOrigin()
    direction.z = 0
    direction = direction:Normalized()
		
		local linear_info = {
			Source = caster,
			Ability = self,
			bDeleteOnHit = true,
			
			iUnitTargetTeam = self:GetAbilityTargetTeam(),
			iUnitTargetFlags = self:GetAbilityTargetFlags(),
			iUnitTargetType = self:GetAbilityTargetType(),
			
			EffectName = "particles/units/heroes/hero_venomancer/venomancer_venomous_gale.vpcf",
			fDistance = self:GetCastRange(caster:GetOrigin(), nil),
			fStartRadius = 50,
			fEndRadius = 50,
			vVelocity = direction * 1000,

			bProvidesVision = true,
			iVisionRadius = 100,
			iVisionTeamNumber = caster:GetTeamNumber()
		}

		ProjectileManager:CreateLinearProjectile(linear_info)
		


	end

-- EFFECTS



