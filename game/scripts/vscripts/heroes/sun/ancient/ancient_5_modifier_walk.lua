ancient_5_modifier_walk = class ({})

function ancient_5_modifier_walk:IsHidden() return false end
function ancient_5_modifier_walk:IsPurgable() return false end
function ancient_5_modifier_walk:GetPriority() return MODIFIER_PRIORITY_ULTRA end

-- CONSTRUCTORS -----------------------------------------------------------

function ancient_5_modifier_walk:OnCreated(kv)
  self.caster = self:GetCaster()
	self.parent = self:GetParent()
	self.ability = self:GetAbility()

  self.ability:SetActivated(false)
  self.ability:EndCooldown()

  local block_physical = self.ability:GetSpecialValueFor("block_physical")
  local block_magical = self.ability:GetSpecialValueFor("block_magical")

  AddModifier(self.parent, self.ability, "_modifier_petrified", {
    special = 1, physical_block = block_physical, magical_block = block_magical
  }, false)

  AddSubStats(self.parent, self.ability, {
    status_resist_stack = self.ability:GetSpecialValueFor("status_resist_stack")
  }, false)

	if IsServer() then
    self:SetStackCount(self.ability:GetSpecialValueFor("waves"))
    self:PlayEfxStart()
    self:OnIntervalThink()
  end
end

function ancient_5_modifier_walk:OnRefresh(kv)
end

function ancient_5_modifier_walk:OnRemoved()
	self.ability:SetActivated(true)
  self.ability:StartCooldown(self.ability:GetEffectiveCooldown(self.ability:GetLevel()))

  RemoveAllModifiersByNameAndAbility(self.parent, "_modifier_petrified", self.ability)
  RemoveSubStats(self.parent, self.ability, {"status_resist_stack"})
end

-- API FUNCTIONS -----------------------------------------------------------

function ancient_5_modifier_walk:CheckState()
	local state = {
    [MODIFIER_STATE_ROOTED] = false,
    [MODIFIER_STATE_STUNNED] = false,
    [MODIFIER_STATE_FROZEN] = false
  }

	return state
end

function ancient_5_modifier_walk:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_LIMIT
	}
	
	return funcs
end

function ancient_5_modifier_walk:GetModifierMoveSpeed_Limit()
	return self:GetAbility():GetSpecialValueFor("ms_limit")
end

function ancient_5_modifier_walk:OnIntervalThink()
	self:ApplyDebuff()

	if IsServer() then
    self:DecrementStackCount()
		self:PlayEfxTick()
		self:StartIntervalThink(self.ability:GetSpecialValueFor("interval"))
	end
end

function ancient_5_modifier_walk:OnStackCountChanged(old)
  if self:GetStackCount() ~= old and self:GetStackCount() == 0 then self:Destroy() end
end

-- UTILS -----------------------------------------------------------

function ancient_5_modifier_walk:ApplyDebuff()
  if RandomFloat(0, 100) < CalcLuck(self.parent, self.ability:GetSpecialValueFor("special_bkb_chance")) then
    local allies = FindUnitsInRadius(
      self.parent:GetTeamNumber(), self.parent:GetOrigin(), nil, self.ability:GetAOERadius(),
      DOTA_UNIT_TARGET_TEAM_FRIENDLY, self.ability:GetAbilityTargetType(),
      self.ability:GetAbilityTargetFlags(), 0, false
    )
  
    for _,ally in pairs(allies) do
      if ally ~= self.parent then
        ally:Purge(false, true, false, true, false)
        RemoveAllModifiersByNameAndAbility(ally, "_modifier_bkb", self.ability)
        AddModifier(ally, self.ability, "_modifier_bkb", {
          duration = self.ability:GetSpecialValueFor("special_duration")
        }, true)        
      end
    end
  end

  local enemies = FindUnitsInRadius(
		self.parent:GetTeamNumber(), self.parent:GetOrigin(), nil, self.ability:GetAOERadius(),
    self.ability:GetAbilityTargetTeam(), self.ability:GetAbilityTargetType(),
    self.ability:GetAbilityTargetFlags(), 0, false
	)

	for _,enemy in pairs(enemies) do
    if RandomFloat(0, 100) < self.ability:GetSpecialValueFor("special_petrify_chance") then
      RemoveAllModifiersByNameAndAbility(enemy, "_modifier_petrified", self.ability)
      AddModifier(enemy, self.ability, "_modifier_petrified", {
        duration = self.ability:GetSpecialValueFor("special_duration")
      }, true)
    end
    
    AddModifier(enemy, self.ability, "ancient_5_modifier_debuff", {
      duration = self.ability:GetSpecialValueFor("debuff_duration")
    }, false)
	end
end

-- EFFECTS -----------------------------------------------------------

function ancient_5_modifier_walk:PlayEfxStart()
	local particle = "particles/econ/items/pugna/pugna_ward_golden_nether_lord/pugna_gold_ambient.vpcf"
	local effect_caster = ParticleManager:CreateParticle(particle, PATTACH_ABSORIGIN_FOLLOW, self.parent)
	ParticleManager:SetParticleControl(effect_caster, 0, self.parent:GetOrigin())
	ParticleManager:SetParticleControl(effect_caster, 1, self.parent:GetOrigin())
	ParticleManager:SetParticleControl(effect_caster, 2, self.parent:GetOrigin())
	ParticleManager:SetParticleControl(effect_caster, 4, self.parent:GetOrigin())
	self:AddParticle(effect_caster, false, false, -1, false, false)

  if IsServer() then
    self.parent:EmitSound("Ancient.Aura.Cast")
    self.parent:EmitSound("Ancient.Aura.Effect")
  end
end

function ancient_5_modifier_walk:PlayEfxTick()
	local particle_cast = "particles/ancient/ancient_aura_pulses.vpcf"
	local effect_cast = ParticleManager:CreateParticle(particle_cast, PATTACH_POINT_FOLLOW, self.parent)
	ParticleManager:SetParticleControl(effect_cast, 1, self.parent:GetOrigin())

	if IsServer() then
		self.parent:EmitSound("Ancient.Aura.Layer")
		self.parent:EmitSound("Hero_EarthShaker.Totem.Attack.Immortal.Layer")
	end
end