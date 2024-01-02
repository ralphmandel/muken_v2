neutral_fireball_modifier_passive = class({})

function neutral_fireball_modifier_passive:IsHidden() return true end
function neutral_fireball_modifier_passive:IsPurgable() return false end

-- CONSTRUCTORS -----------------------------------------------------------

function neutral_fireball_modifier_passive:OnCreated(kv)
  self.caster = self:GetCaster()
  self.parent = self:GetParent()
  self.ability = self:GetAbility()

  if IsServer() then self:StartIntervalThink(1) end
end

function neutral_fireball_modifier_passive:OnRefresh(kv)
end

function neutral_fireball_modifier_passive:OnRemoved()
end

-- API FUNCTIONS -----------------------------------------------------------

function neutral_fireball_modifier_passive:OnIntervalThink()
  local ai = self.parent:FindModifierByName("_modifier__ai")
  if ai == nil then return end

	if ai.state ~= 1 or self.ability:IsCooldownReady() == false or self.ability:IsOwnersManaEnough() == false then
    if IsServer() then self:StartIntervalThink(1) end
    return
  end

  local enemies = FindUnitsInRadius(
		self.parent:GetTeamNumber(), self.parent:GetOrigin(), nil, self.ability:GetCastRange(self.parent:GetOrigin(), nil),
		self.ability:GetAbilityTargetTeam(), self.ability:GetAbilityTargetType(),
		self.ability:GetAbilityTargetFlags(), FIND_ANY_ORDER, false
	)

	for _,enemy in pairs(enemies) do
    if enemy:GetTeamNumber() ~= TIER_TEAMS[RARITY_COMMON] and enemy:GetTeamNumber() < TIER_TEAMS[RARITY_RARE] then
      self.parent:CastAbilityOnTarget(enemy, self.ability, self.parent:GetPlayerOwnerID())
      break
    end
	end
  
  if IsServer() then
    self:StartIntervalThink(self.ability:GetCastPoint() + 0.5)
    ai:StartIntervalThink(self.ability:GetCastPoint() + 0.5)
  end
end

-- UTILS -----------------------------------------------------------

-- EFFECTS -----------------------------------------------------------