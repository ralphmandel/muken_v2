neutral_spiders_modifier_summon = class({})

function neutral_spiders_modifier_summon:IsHidden() return false end
function neutral_spiders_modifier_summon:IsPurgable() return false end

-- CONSTRUCTORS -----------------------------------------------------------

function neutral_spiders_modifier_summon:OnCreated(kv)
  self.caster = self:GetCaster()
  self.parent = self:GetParent()
  self.ability = self:GetAbility()

  AddSubStats(self.parent, self.ability, {
    attack_speed = self.caster:GetMainStat("INT"):GetSummonPower() * 1,
    max_health = self.caster:GetMainStat("INT"):GetSummonPower() * 4,
  }, false)

  if IsServer() then
    self.target = EntIndexToHScript(kv.target)
    self.parent:SetForceAttackTarget(self.target)
    self.parent:MoveToTargetToAttack(self.target)
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
		MODIFIER_PROPERTY_TRANSLATE_ATTACK_SOUND,
    MODIFIER_EVENT_ON_ATTACK_LANDED,
		MODIFIER_EVENT_ON_DEATH,
    MODIFIER_EVENT_ON_ABILITY_FULLY_CAST
	}

	return funcs
end

function neutral_spiders_modifier_summon:GetAttackSound(keys)
  return ""
end

function neutral_spiders_modifier_summon:OnAttackLanded(keys)
	if keys.attacker ~= self.parent then return end
	if IsServer() then self.parent:EmitSound("Hero_Broodmother.Attack") end
end

function neutral_spiders_modifier_summon:OnDeath(keys)
	if keys.unit ~= self.caster then return end
  if self.caster:IsHero() then return end
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
        if self.target:IsAlive() and self.parent:GetAggroTarget() == self.target then
          return
        end
      end
    end

    if self.caster:GetAggroTarget() then
      self.target = self.caster:GetAggroTarget()
      self.parent:SetForceAttackTarget(self.target)
      self.parent:MoveToTargetToAttack(self.target)
      return
    end

    self.target = nil
    self.parent:SetForceAttackTarget(nil)
    self.parent:MoveToNPC(self.caster)
  end
end

-- UTILS -----------------------------------------------------------

-- EFFECTS -----------------------------------------------------------