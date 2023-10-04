bloodstained_u_modifier_aura_effect = class({})

function bloodstained_u_modifier_aura_effect:IsHidden() return false end
function bloodstained_u_modifier_aura_effect:IsPurgable() return false end
function bloodstained_u_modifier_aura_effect:GetPriority() return MODIFIER_PRIORITY_SUPER_ULTRA end

-- CONSTRUCTORS -----------------------------------------------------------

function bloodstained_u_modifier_aura_effect:OnCreated(kv)
  self.caster = self:GetCaster()
  self.parent = self:GetParent()
	self.ability = self:GetAbility()

  if self.ability:GetSpecialValueFor("special_bleed_in") == 1
  and self.caster:GetTeamNumber() ~= self.parent:GetTeamNumber() then
    AddModifier(self.parent, self.ability, "_modifier_bleeding", {}, false)
  end
end

function bloodstained_u_modifier_aura_effect:OnRefresh(kv)
end

function bloodstained_u_modifier_aura_effect:OnRemoved()
  RemoveAllModifiersByNameAndAbility(self.parent, "_modifier_bleeding", self.ability)
	self:ApplyBloodIllusion()
end

-- API FUNCTIONS -----------------------------------------------------------

function bloodstained_u_modifier_aura_effect:CheckState()
	local state = {
		[MODIFIER_STATE_SILENCED] = true
	}

  if self:GetAbility():GetSpecialValueFor("special_break") == 1
  and self:GetCaster():GetTeamNumber() ~= self:GetParent():GetTeamNumber() then
		table.insert(state, MODIFIER_STATE_PASSIVES_DISABLED, true)
	end

	return state
end

function bloodstained_u_modifier_aura_effect:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_AVOID_DAMAGE,
    MODIFIER_EVENT_ON_DEATH
	}

	return funcs
end

function bloodstained_u_modifier_aura_effect:GetModifierAvoidDamage(keys)
  if keys.attacker:HasModifier(self:GetName()) == false then return 1 end
	return 0
end

function bloodstained_u_modifier_aura_effect:OnDeath(keys)
  if keys.unit:IsHero() == false then return end
  if keys.unit:IsIllusion() then return end

  local kill = self.ability:GetSpecialValueFor("special_kill")

  if kill > 0 and keys.unit == self.parent then
    local cd = self.ability:GetCooldownTimeRemaining()
    self.ability:EndCooldown()
    self.ability:StartCooldown(cd - kill)
  end
end

-- UTILS -----------------------------------------------------------

function bloodstained_u_modifier_aura_effect:ApplyBloodIllusion()
	if self.caster:GetTeamNumber() == self.parent:GetTeamNumber() then return end
	if self.parent:IsAlive() == false then return end
	if self.parent:IsIllusion() then return end
	if self.parent:IsHero() == false then return end
	if self.ability:IsActivated() then return end
  if self.parent:HasModifier("bloodstained__modifier_bloodstained") then return end

  AddModifier(self.parent, self.ability, "sub_stat_movespeed_percent_decrease", {
    value = 100, duration = self.ability:GetSpecialValueFor("slow_duration")
  }, true)
	
	self:CreateCopy()
end

function bloodstained_u_modifier_aura_effect:CreateCopy()
  if not IsServer() then return end

  local copy_number = self.ability:GetSpecialValueFor("copy_number")
	local hp_stolen = math.floor(self.parent:GetBaseMaxHealth() * self.ability:GetSpecialValueFor("hp_stolen") * 0.01)

	local illu_array = CreateIllusions(self.caster, self.parent, {
		outgoing_damage = -85,
		incoming_damage = -100,
		bounty_base = 0,
		bounty_growth = 0,
		duration = -1
	}, copy_number, 64, false, true)

	for _,illu in pairs(illu_array) do
    AddModifier(illu, self.ability,"bloodstained__modifier_copy", {
      duration = self.ability:GetSpecialValueFor("copy_duration"),
      hp_stolen = hp_stolen, target_index = self.parent:GetEntityIndex()
    }, false)

		illu:SetForceAttackTarget(self.parent)

		local loc = self.parent:GetAbsOrigin() + RandomVector(100)
    FindClearSpaceForUnit(illu, loc, true)
		illu:SetForwardVector((self.parent:GetAbsOrigin() - loc):Normalized())
	end
end

-- EFFECTS -----------------------------------------------------------

function bloodstained_u_modifier_aura_effect:GetEffectName()
	return "particles/bloodstained/bloodstained_thirst_owner_smoke_dark.vpcf"
end

function bloodstained_u_modifier_aura_effect:GetEffectAttachType()
	return PATTACH_POINT_FOLLOW
end