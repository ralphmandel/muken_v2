vulture_1__tree = class({})
LinkLuaModifier("vulture_1_modifier_tree", "heroes/death/vulture/vulture_1_modifier_tree", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("vulture__modifier_rot_stack", "heroes/death/vulture/vulture__modifier_rot_stack", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("vulture__modifier_rot", "heroes/death/vulture/vulture__modifier_rot", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("_modifier_stun", "_modifiers/_modifier_stun", LUA_MODIFIER_MOTION_NONE)

-- INIT

	vulture_1__tree.projectiles = {}
	vulture_1__tree.tree_root = {}

	function vulture_1__tree:CastFilterResultTarget(target)
		return UF_FAIL_CUSTOM
	end

	function vulture_1__tree:GetCustomCastErrorTarget(target)
		return "INVALID TREE"
	end

-- SPELL START

	function vulture_1__tree:GetAOERadius()
		return self:GetSpecialValueFor("radius")
	end

	function vulture_1__tree:OnAbilityPhaseStart()
		for id, tree in pairs(self.tree_root) do
			if tree == self:GetCursorTarget() then
				-- CustomGameEventManager:FireGameEvent("error_message_from_server", {text = 0})
				CustomGameEventManager:Send_ServerToPlayer(self:GetCaster():GetPlayerOwner(), "error_message_from_server", {text = 0})
				return false
			end
		end
		return true
	end

	function vulture_1__tree:OnSpellStart()
		local caster = self:GetCaster()
		local tree = self:GetCursorTarget()
		local direction = tree:GetOrigin() - caster:GetOrigin()
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

		local proj = ProjectileManager:CreateLinearProjectile(linear_info)
		self.projectiles[proj] = {}
		self.projectiles[proj].tree = tree
		self.projectiles[proj].origin = tree:GetOrigin()
		
		if IsServer() then
			caster:EmitSound( "Hero_Bristleback.ViscousGoo.Cast" )
		end
	end


	function vulture_1__tree:OnProjectileThinkHandle(id)
		local caster = self:GetCaster()
		local position = ProjectileManager:GetLinearProjectileLocation(id)
		if self.projectiles[id] == nil then return end
		local distance = (position - self.projectiles[id].origin):Length2D()

		if distance < 20 then
			if self.projectiles[id].tree then
				
				if self.projectiles[id].tree:IsStanding() then
					CreateModifierThinker(caster, self, "vulture_1_modifier_tree", {
						duration = self:GetSpecialValueFor("duration"),
						tree = self.projectiles[id].tree:entindex()
					}, self.projectiles[id].origin, caster:GetTeamNumber(), false)
				end

			end
			table.insert(self.tree_root, self.projectiles[id].tree:entindex(), self.projectiles[id].tree)
			ProjectileManager:DestroyLinearProjectile(id)
			self.projectiles[id] = nil
		end
  end

-- EFFECTS



