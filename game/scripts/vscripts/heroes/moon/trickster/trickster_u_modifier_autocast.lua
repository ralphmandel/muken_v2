trickster_u_modifier_autocast = class({})

function trickster_u_modifier_autocast:IsHidden() return false end
function trickster_u_modifier_autocast:IsPurgable() return false end
function trickster_u_modifier_autocast:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end
function trickster_u_modifier_autocast:GetTexture()
  if self:GetParent():FindAbilityByName("trickster__precache"):GetLevel() == 101 then return "fleaman_precision" end
  if self:GetParent():FindAbilityByName("trickster__precache"):GetLevel() == 102 then return "fleaman_jump" end
  if self:GetParent():FindAbilityByName("trickster__precache"):GetLevel() == 103 then return "fleaman_smoke" end
  if self:GetParent():FindAbilityByName("trickster__precache"):GetLevel() == 104 then return "bloodstained_rage" end
  if self:GetParent():FindAbilityByName("trickster__precache"):GetLevel() == 105 then return "bloodstained_seal" end
  if self:GetParent():FindAbilityByName("trickster__precache"):GetLevel() == 401 then return "templar_hammer" end
  if self:GetParent():FindAbilityByName("trickster__precache"):GetLevel() == 402 then return "templar_revenge" end
  if self:GetParent():FindAbilityByName("trickster__precache"):GetLevel() == 403 then return "templar_praise" end
end

-- CONSTRUCTORS -----------------------------------------------------------

function trickster_u_modifier_autocast:OnCreated(kv)
  self.caster = self:GetCaster()
  self.parent = self:GetParent()
  self.ability = self:GetAbility()
  self.targets = {}
  self.enabled = true

  if IsServer() then
    self.target = EntIndexToHScript(kv.target_index)

    if self.target:IsHero() then
      self.special_kv_name = GetHeroName(self.target:GetUnitName()).."_special_values"
    end

    AddModifier(self.caster, self.ability, self.special_kv_name, {}, false)

    local ability = EntIndexToHScript(kv.ability_index)
    self.stolen_ability = self.parent:AddAbility(ability:GetAbilityName())
    self.stolen_ability:UpgradeAbility(true)
    self.stolen_ability:SetHidden(true)

    self:StartIntervalThink(self:GetDuration() - 0.5)
    self:CheckLast()
  end
end

function trickster_u_modifier_autocast:OnRefresh(kv)
end

function trickster_u_modifier_autocast:OnRemoved()
  if self.special_kv_name then self.parent:RemoveModifierByName(self.special_kv_name) end
  self.parent:RemoveAbilityByHandle(self.stolen_ability)
  self:CheckLast()
end

-- API FUNCTIONS -----------------------------------------------------------

function trickster_u_modifier_autocast:DeclareFunctions()
	local funcs = {
    MODIFIER_EVENT_ON_MODIFIER_ADDED,
		MODIFIER_EVENT_ON_ATTACK_LANDED
	}

	return funcs
end

function trickster_u_modifier_autocast:OnModifierAdded(keys)
  if keys.added_buff:GetAbility() == self.stolen_ability then
    for _, target in pairs(self.targets) do
      if target == keys.unit then return end
    end

    table.insert(self.targets, keys.unit)
  end
end

function trickster_u_modifier_autocast:OnAttackLanded(keys)
  if keys.attacker ~= self.parent then return end
  if self.stolen_ability:IsActivated() == false then return end
  if not self.enabled then return end

  if RandomFloat(0, 100) < self:GetChance() then
    local target = keys.target

    if self.stolen_ability:GetAbilityTargetTeam() == DOTA_UNIT_TARGET_TEAM_FRIENDLY then
      target = self.parent
    end

    self.parent:SetCursorCastTarget(target)
    self.parent:SetCursorPosition(keys.target:GetOrigin())
    self.stolen_ability:OnSpellStart()
  end
end

function trickster_u_modifier_autocast:OnIntervalThink()
  self.enabled = false

  for _, target in pairs(self.targets) do
    if target then
      if IsValidEntity(target) then
        local mods = target:FindAllModifiers()
        for _, mod in pairs(mods) do
          if mod:GetAbility() == self.stolen_ability then
            if self.stolen_ability:GetIntrinsicModifierName() ~= mod:GetName() then
              if IsServer() then
                self:SetDuration(-1, true)
                self:StartIntervalThink(0.5)
                return
              end
            end
          end
        end
      end
    end
  end

  self:Destroy()
end

-- UTILS -----------------------------------------------------------

function trickster_u_modifier_autocast:GetChance()
  local cooldown = self.stolen_ability:GetCooldown(self.stolen_ability:GetLevel())
  local restore_time = self.stolen_ability:GetAbilityChargeRestoreTime(self.stolen_ability:GetLevel())

  local chance = 100 / cooldown
  if restore_time > 0 then chance = 100 / restore_time end

  chance = chance * self.ability:GetSpecialValueFor("chance_mult")
  return chance
end

function trickster_u_modifier_autocast:CheckLast()
  if self.target then
    if IsValidEntity(self.target) then
      local last_mod = self.target:FindModifierByName("trickster_u_modifier_last")
      if last_mod then last_mod:CheckAbility() end
    end
  end
end

-- EFFECTS -----------------------------------------------------------