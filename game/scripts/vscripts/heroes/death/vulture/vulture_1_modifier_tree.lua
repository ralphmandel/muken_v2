vulture_1_modifier_tree = class({})

function vulture_1_modifier_tree:IsHidden() return false end
function vulture_1_modifier_tree:IsPurgable() return false end

-- CONSTRUCTORS -----------------------------------------------------------

function vulture_1_modifier_tree:OnCreated(kv)
  self.caster = self:GetCaster()
  self.parent = self:GetParent()
  self.ability = self:GetAbility()
  self.tree = EntIndexToHScript(kv.tree)

  self.fow = AddFOWViewer(
    self.caster:GetTeamNumber(),
    self.parent:GetOrigin(),
    self.ability:GetSpecialValueFor("radius"),
    self:GetDuration(),
    false
  )

  if IsServer() then
    self:StartIntervalThink(self.ability:GetSpecialValueFor("interval"))
    self:PlayEfxStart()
  end


end



function vulture_1_modifier_tree:OnRefresh(kv)
 
end

function vulture_1_modifier_tree:OnRemoved()
  if self.fow then
    RemoveFOWViewer(self.caster:GetTeamNumber(), self.fow)
    AddFOWViewer(
      self.caster:GetTeamNumber(),
      self.parent:GetOrigin(),
      self.ability:GetSpecialValueFor("radius"),
      1,
      false
    )
  end
  if self.tree then
    if self.tree:IsStanding() then
      self.tree:CutDown(self.caster:GetTeamNumber())
    end
  end
end

-- API FUNCTIONS -----------------------------------------------------------

function vulture_1_modifier_tree:OnIntervalThink()
  self:PlayEfxTick()
  local units = FindUnitsInRadius(
    self.caster:GetTeamNumber(), self.parent:GetOrigin(), nil, self.ability:GetAOERadius(),
    DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP,
    DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false
  )

  for _,unit in pairs(units) do
    AddModifier(unit, self.ability, "vulture__modifier_rot_stack", {stack = self.ability:GetSpecialValueFor("stack")}, false)
    ApplyDamage({
      attacker = self.caster,
      victim = unit,
      damage = self.ability:GetSpecialValueFor("damage"),
      damage_type = self.ability:GetAbilityDamageType(),
      ability = self.ability
    })
  end
  
 
end

-- UTILS -----------------------------------------------------------

-- EFFECTS -----------------------------------------------------------

function vulture_1_modifier_tree:PlayEfxStart()
  ---------OVER TREE---------
  local origin = self.parent:GetOrigin()
  origin.z = origin.z + 300
  local efx_parasyte = "particles/vulture/vulture_swarm_infected_debuff.vpcf"
  local parasyte = ParticleManager:CreateParticle(efx_parasyte, PATTACH_ABSORIGIN_FOLLOW, self.parent)
  ParticleManager:SetParticleControl(parasyte, 1, origin)
	self:AddParticle(parasyte, false, false, -1, false, false)
  ---------ON TREE---------
  local efx_rot = "particles/econ/items/pudge/pudge_immortal_arm/pudge_immortal_arm_rot.vpcf"
  local rot = ParticleManager:CreateParticle(efx_rot, PATTACH_ABSORIGIN_FOLLOW, self.parent)
  ParticleManager:SetParticleControl(rot, 0, self.parent:GetOrigin())
	self:AddParticle(rot, false, false, -1, false, false)
end

function vulture_1_modifier_tree:PlayEfxTick()
  local string = "particles/vulture/vulture_immortal_poison_nova.vpcf"
	local pfx = ParticleManager:CreateParticle(string, PATTACH_ABSORIGIN, self.parent)
	ParticleManager:SetParticleControl(pfx, 0, self.parent:GetAbsOrigin())
	ParticleManager:SetParticleControl(pfx, 1, Vector(self.ability:GetSpecialValueFor("radius"), 0.5, self.ability:GetSpecialValueFor("radius")))
	ParticleManager:ReleaseParticleIndex(pfx)

  self.parent:EmitSound( "Hero_Venomancer.VenomousGale" )


end
-- function vulture_1_modifier_tree:GetEffectName()
-- 	return ""
-- end

-- function vulture_1_modifier_tree:GetEffectAttachType()
-- 	return PATTACH_ABSORIGIN_FOLLOW
-- end