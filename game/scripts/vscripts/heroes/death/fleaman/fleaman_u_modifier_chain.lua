fleaman_u_modifier_chain = class({})

function fleaman_u_modifier_chain:IsHidden() return true end
function fleaman_u_modifier_chain:IsPurgable() return false end
function fleaman_u_modifier_chain:RemoveOnDeath() return false end

-- CONSTRUCTORS -----------------------------------------------------------

function fleaman_u_modifier_chain:OnCreated(kv)
	self.caster = self:GetCaster()
	self.parent = self:GetParent()
	self.ability = self:GetAbility()

  if not IsServer() then return end

  self.chain_hits = self.ability:GetSpecialValueFor("special_chain_hits")
  self.current_target = EntIndexToHScript(kv.target_index)
  self.source = self.parent
  self.targets = {}

  self.current_target:EmitSound("Hero_Zuus.ArcLightning.Cast")
  self:OnIntervalThink()
end

function fleaman_u_modifier_chain:OnRefresh(kv)
end

function fleaman_u_modifier_chain:OnRemoved()
end

-- API FUNCTIONS -----------------------------------------------------------

function fleaman_u_modifier_chain:OnIntervalThink()
  if not IsServer() then return end

  if self.current_target == nil or self.chain_hits <= 0 then
    self:Destroy()
    return
  end

  table.insert(self.targets, self.current_target)

  self:PlayEfxChain(self.source, self.current_target)

  local new_target = nil
	local enemies = FindUnitsInRadius(
		self.parent:GetTeamNumber(), self.current_target:GetOrigin(), nil,
    self.ability:GetSpecialValueFor("special_chain_radius"),
		DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
    DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_CLOSEST, false
	)

  for _, enemy in pairs(enemies) do
    local new = true
    for _, target in pairs(self.targets) do
      if enemy == target then
        new = false
      end
    end

    if new == true then
      new_target = enemy
    end
  end

  self.source = self.current_target
  self.current_target = new_target
  self.chain_hits = self.chain_hits - 1

  ApplyDamage({
    victim = self.current_target, attacker = self.parent,
    damage = self.ability:GetSpecialValueFor("special_chain_damage"),
    damage_type = self.ability:GetAbilityDamageType(),
    ability = self.ability
  })
  
  self:StartIntervalThink(0.2)
end

-- UTILS -----------------------------------------------------------

-- EFFECTS -----------------------------------------------------------

function fleaman_u_modifier_chain:PlayEfxChain(source, target)
  if source == nil then source = self.parent end
  if IsValidEntity(source) == false then source = self.parent end

	local particle_cast = "particles/units/heroes/hero_zuus/zuus_arc_lightning_.vpcf"
	local effect_cast = ParticleManager:CreateParticle(particle_cast, PATTACH_ABSORIGIN_FOLLOW, source)
  ParticleManager:SetParticleControlEnt(effect_cast, 0, source, PATTACH_POINT_FOLLOW, "attach_hitloc", source:GetAbsOrigin(), true)
  ParticleManager:SetParticleControlEnt(effect_cast, 1, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
  ParticleManager:SetParticleControl(effect_cast, 62, Vector(2, 0, 2))
  ParticleManager:ReleaseParticleIndex(effect_cast)

	target:EmitSound("Hero_Zuus.ArcLightning.Target")
end