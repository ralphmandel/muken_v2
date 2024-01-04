neutral_spiders_modifier_summon = class({})

function neutral_spiders_modifier_summon:IsHidden() return false end
function neutral_spiders_modifier_summon:IsPurgable() return false end

-- CONSTRUCTORS -----------------------------------------------------------

function neutral_spiders_modifier_summon:OnCreated(kv)
  self.caster = self:GetCaster()
  self.parent = self:GetParent()
  self.ability = self:GetAbility()

  if IsServer() then
    self.target = EntIndexToHScript(kv.target)
    self.parent:SetForceAttackTarget(self.target)
    self:StartIntervalThink(1)
  end
end

function neutral_spiders_modifier_summon:OnRefresh(kv)
end

function neutral_spiders_modifier_summon:OnRemoved()
  if self.parent:IsAlive() then self.parent:ForceKill(false) end
end

-- API FUNCTIONS -----------------------------------------------------------

function neutral_spiders_modifier_summon:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_DEATH,
    MODIFIER_EVENT_ON_ABILITY_FULLY_CAST
	}

	return funcs
end

function neutral_spiders_modifier_summon:OnDeath(keys)
	if keys.unit ~= self.caster then return end
	self:Destroy()
end

function neutral_spiders_modifier_summon:OnAbilityFullyCast(keys)
  if keys.unit ~= self.caster then return end
  if keys.ability ~= self.ability then return end
  self:Destroy()
end

function neutral_spiders_modifier_summon:OnIntervalThink()
  if IsServer() then
    if self.target then
      if IsValidEntity(self.target) then
        if self.parent:CanEntityBeSeenByMyTeam(self.target)
        and self.parent:GetAggroTarget() == self.target then
          return
        end
      end
    end

    if self.parent:GetAggroTarget() then
      self.target = self.parent:GetAggroTarget()
      self.parent:SetForceAttackTarget(self.target)
      return
    end

    if self.caster:GetAggroTarget() then
      self.target = self.caster:GetAggroTarget()
      self.parent:SetForceAttackTarget(self.target)
      return
    end

    self.parent:MoveToNPC(self.caster)
  end
end

-- UTILS -----------------------------------------------------------

-- EFFECTS -----------------------------------------------------------