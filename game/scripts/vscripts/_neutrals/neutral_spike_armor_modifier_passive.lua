neutral_spike_armor_modifier_passive = class({})

function neutral_spike_armor_modifier_passive:IsHidden() return true end
function neutral_spike_armor_modifier_passive:IsPurgable() return false end

-- CONSTRUCTORS -----------------------------------------------------------

function neutral_spike_armor_modifier_passive:OnCreated(kv)
  self.caster = self:GetCaster()
  self.parent = self:GetParent()
  self.ability = self:GetAbility()
end

function neutral_spike_armor_modifier_passive:OnRefresh(kv)
end

function neutral_spike_armor_modifier_passive:OnRemoved()
end

-- API FUNCTIONS -----------------------------------------------------------

function neutral_spike_armor_modifier_passive:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_TAKEDAMAGE
	}

	return funcs
end

function neutral_spike_armor_modifier_passive:OnTakeDamage(keys)
  if keys.unit ~= self.parent then return end
  if self.ability:IsActivated() == false then return end
  if self.ability:IsCooldownReady() == false then return end
	if self.ability:IsOwnersManaEnough() == false then return end

  local ai = self.parent:FindModifierByName("_modifier__ai")
  if ai == nil then return end
  if ai.state ~= 1 then return end

  if keys.attacker then
    if keys.attacker:IsBaseNPC() then
      if keys.attacker:GetTeamNumber() ~= TIER_TEAMS[RARITY_COMMON] and keys.attacker:GetTeamNumber() < TIER_TEAMS[RARITY_RARE] then
        self.parent:CastAbilityNoTarget(self.ability, self.parent:GetPlayerOwnerID())
        if IsServer() then ai:StartIntervalThink(0.5) end
      end
    end
  end
end

-- UTILS -----------------------------------------------------------

-- EFFECTS -----------------------------------------------------------