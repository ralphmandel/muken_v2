vulture_1__tree = class({})
LinkLuaModifier("vulture_1_modifier_tree", "heroes/death/vulture/vulture_1_modifier_tree", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("vulture__modifier_rot_stack", "heroes/death/vulture/vulture__modifier_rot_stack", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("_modifier_stun", "_modifiers/_modifier_stun", LUA_MODIFIER_MOTION_NONE)

-- INIT

-- SPELL START

	function vulture_1__tree:GetAOERadius()
		return self:GetSpecialValueFor("radius")
	end

	function vulture_1__tree:OnSpellStart()
		local caster = self:GetCaster()
		self.tree = self:GetCursorTarget()
		self.origin = self.tree:GetOrigin()
		local direction = self.tree:GetOrigin() - caster:GetOrigin()
    direction.z = 0
    direction = direction:Normalized()
		
		local linear_info = {
			Source = caster,
			Ability = self,
			vSpawnOrigin = caster:GetOrigin(),
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

		self.proj = ProjectileManager:CreateLinearProjectile(linear_info)
		if IsServer() then
			caster:EmitSound( "Hero_Bristleback.ViscousGoo.Cast" )
		end
	end


	function vulture_1__tree:OnProjectileThink(position)
		local caster = self:GetCaster()
		if self.proj == nil then return end
		local distance = (position - self.origin):Length2D()
		if distance < 20 then
			ProjectileManager:DestroyLinearProjectile(self.proj)
			self.proj = nil
			if self.tree then
				if self.tree:IsStanding() then
					CreateModifierThinker(caster, self, "vulture_1_modifier_tree", {
						duration = self:GetSpecialValueFor("duration"),
						tree = self.tree:entindex()
					}, self.origin, caster:GetTeamNumber(), false)
				end
			end
		end
	
  end

-- EFFECTS



