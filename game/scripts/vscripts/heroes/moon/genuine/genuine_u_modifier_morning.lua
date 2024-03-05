genuine_u_modifier_morning = class({})

function genuine_u_modifier_morning:IsHidden() return false end
function genuine_u_modifier_morning:IsPurgable() return false end
function genuine_u_modifier_morning:RemoveOnDeath() return false end

-- CONSTRUCTORS -----------------------------------------------------------

function genuine_u_modifier_morning:OnCreated(kv)
	self.caster = self:GetCaster()
	self.parent = self:GetParent()
	self.ability = self:GetAbility()

  if not IsServer() then return end

  self.parent:EmitSound("Genuine.Morning")

  self.parent:AddMainStats(self.ability, {
    int = self.ability:GetSpecialValueFor("int"),
    agi = self.ability:GetSpecialValueFor("agi")
  })

  if self.ability:GetSpecialValueFor("special_passive") == 1 then
    self.parent:StartGesture(ACT_DOTA_CAST_ABILITY_3)
    self.parent:FindModifierByName(self.ability:GetIntrinsicModifierName()):PlayEfxBuff()
  else
    GameRules:BeginTemporaryNight(self:GetDuration())
    self.ability:SetActivated(false)
  end

  
  self.ability:EndCooldown()
  self:StartIntervalThink(1)
end

function genuine_u_modifier_morning:OnRefresh(kv)  
end

function genuine_u_modifier_morning:OnRemoved(kv)
  if not IsServer() then return end

  self.parent:RemoveMainStats(self.ability, {"int", "agi"})
  self.parent:FindModifierByName(self.ability:GetIntrinsicModifierName()):StopEfxBuff()

	if self.ability:IsActivated() == false then self.ability:SetActivated(true) end
  self.ability:StartCooldown(self.ability:GetEffectiveCooldown(self.ability:GetLevel()))
end

-- API FUNCTIONS -----------------------------------------------------------

function genuine_u_modifier_morning:CheckState()
	local state = {}

  if self.ability:GetSpecialValueFor("special_fly_vision") == 1 then
    state = {[MODIFIER_STATE_FORCED_FLYING_VISION] = true}
  end

	return state
end

-- UTILS -----------------------------------------------------------

function genuine_u_modifier_morning:OnIntervalThink()
  if not IsServer() then return end

  local starfall_damage = self.ability:GetSpecialValueFor("starfall_damage")

  if starfall_damage > 0 then
    local enemies = FindUnitsInRadius(
      self.parent:GetTeam(), self.parent:GetAbsOrigin(), nil, FIND_UNITS_EVERYWHERE,
      DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
      DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_NO_INVIS,
      FIND_ANY_ORDER, false
    )
  
    for _,enemy in pairs(enemies) do
      if self.parent:CanEntityBeSeenByMyTeam(enemy) then
        local modifier_thinker = CreateModifierThinker(
          self.parent, self.ability, "genuine__modifier_starfall", {starfall_damage = starfall_damage},
          enemy:GetOrigin(), self.parent:GetTeamNumber(), false
        )
        self:StartIntervalThink(self.ability:GetSpecialValueFor("special_interval"))
        return
      end
    end
  end

  self:StartIntervalThink(1)
end

-- EFFECTS -----------------------------------------------------------