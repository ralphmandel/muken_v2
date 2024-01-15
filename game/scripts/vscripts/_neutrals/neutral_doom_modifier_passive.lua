neutral_doom_modifier_passive = class({})

function neutral_doom_modifier_passive:IsHidden() return true end
function neutral_doom_modifier_passive:IsPurgable() return false end

-- CONSTRUCTORS -----------------------------------------------------------

function neutral_doom_modifier_passive:OnCreated(kv)
  self.caster = self:GetCaster()
  self.parent = self:GetParent()
  self.ability = self:GetAbility()
end

function neutral_doom_modifier_passive:OnRefresh(kv)
end

function neutral_doom_modifier_passive:OnRemoved()
end

-- API FUNCTIONS -----------------------------------------------------------

function neutral_doom_modifier_passive:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_TAKEDAMAGE
	}

	return funcs
end

function neutral_doom_modifier_passive:OnTakeDamage(keys)
  if not IsServer() then return end

	if keys.unit ~= self.parent then return end
  if keys.attacker == nil then return end
  if keys.attacker:IsBaseNPC() == false then return end
  if keys.attacker:GetTeamNumber() == TIER_TEAMS[RARITY_COMMON]
  or keys.attacker:GetTeamNumber() >= TIER_TEAMS[RARITY_RARE] then return end
  if keys.attacker:HasModifier("neutral_doom_modifier_pre")
  or keys.attacker:HasModifier("neutral_doom_modifier_debuff") then return end
  if self.ability:IsCooldownReady() == false  then return end
  if self.ability:IsOwnersManaEnough() == false then return end

  local ai = self.parent:FindModifierByName("_modifier__ai")
  if ai == nil then return end
  if ai.state ~= 1 then return end

  local result = UnitFilter(
    keys.attacker, self.ability:GetAbilityTargetTeam(),
    self.ability:GetAbilityTargetType(),
    self.ability:GetAbilityTargetFlags() + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS,
    self.parent:GetTeamNumber()
  )

  local distance = CalcDistanceBetweenEntityOBB(self.parent, keys.attacker)

  if result == UF_SUCCESS and distance < self.ability:GetCastRange(self.parent:GetOrigin(), nil) then
    self.parent:CastAbilityOnTarget(keys.attacker, self.ability, self.parent:GetPlayerOwnerID())
    if IsServer() then ai:StartIntervalThink(self.ability:GetCastPoint() + 0.5) end
  end
end

-- UTILS -----------------------------------------------------------

-- EFFECTS -----------------------------------------------------------