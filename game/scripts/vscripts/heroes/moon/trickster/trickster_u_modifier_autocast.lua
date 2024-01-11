trickster_u_modifier_autocast = class({})

function trickster_u_modifier_autocast:IsHidden() return self.enabled == false end
function trickster_u_modifier_autocast:IsPurgable() return false end
function trickster_u_modifier_autocast:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end
function trickster_u_modifier_autocast:GetTexture()
  if self.texture == 101 then return "fleaman_precision" end
  if self.texture == 102 then return "fleaman_jump" end
  if self.texture == 103 then return "fleaman_smoke" end
  if self.texture == 104 then return "bloodstained_rage" end
  if self.texture == 105 then return "bloodstained_seal" end
  if self.texture == 106 then return "lawbreaker_grenade" end
  if self.texture == 107 then return "lawbreaker_rain" end
  if self.texture == 108 then return "lawbreaker_form" end
  if self.texture == 301 then return "strider_silence" end
  if self.texture == 302 then return "strider_spin" end
  if self.texture == 303 then return "strider_smoke" end
  if self.texture == 401 then return "templar_hammer" end
  if self.texture == 402 then return "templar_revenge" end
  if self.texture == 403 then return "templar_praise" end
  if self.texture == 404 then return "ancient_roar" end
  if self.texture == 405 then return "ancient_walk" end
  if self.texture == 406 then return "ancient_fissure" end
  if self.texture == 407 then return "paladin_shield" end
  if self.texture == 408 then return "paladin_hammer" end
  if self.texture == 409 then return "paladin_magnus" end
  if self.texture == 501 then return "neutrals/acid_puddle" end
  if self.texture == 502 then return "neutrals/doom" end
  if self.texture == 503 then return "neutrals/fireball" end
  if self.texture == 504 then return "neutrals/immunity" end
  if self.texture == 505 then return "neutrals/iron_blow" end
  if self.texture == 506 then return "neutrals/smash" end
  if self.texture == 507 then return "neutrals/spiders" end
  if self.texture == 508 then return "neutrals/spike_armor" end
end

-- CONSTRUCTORS -----------------------------------------------------------

function trickster_u_modifier_autocast:OnCreated(kv)
  self.caster = self:GetCaster()
  self.parent = self:GetParent()
  self.ability = self:GetAbility()
  self.targets = {}
  self.enabled = true
  self.timer = true

  self.texture = self:GetParent():FindAbilityByName("trickster__precache"):GetLevel()

  if IsServer() then
    local ability = EntIndexToHScript(kv.ability_index)
    self.target = EntIndexToHScript(kv.target_index)

    if self.target:IsHero() then
      self.special_kv_name = GetHeroName(self.target).."_special_values"
    end

    AddModifier(self.caster, self.ability, self.special_kv_name, {}, false)

    for tier = 1, 3, 1 do
      for path = 1, 2, 1 do
        local rank_name = "_rank_"..tier..path
        if self.ability:GetSpecialValueFor("_rank_"..tier) == 1
        and self.target:HasAbility(ability:GetAbilityName()..rank_name) then
          self.ability.ranks[rank_name] = self.parent:AddAbility(ability:GetAbilityName()..rank_name)
        end
      end
    end

    self.stolen_ability = self.parent:AddAbility(ability:GetAbilityName())
    self.stolen_ability:SetLevel(self.ability:GetSpecialValueFor("ability_level"))
    self.stolen_ability:SetHidden(true)

    self:StartIntervalThink(self:GetDuration() - 0.5)
    self:CheckLast()
  end
end

function trickster_u_modifier_autocast:OnRefresh(kv)
end

function trickster_u_modifier_autocast:OnRemoved()
  local autocast_mods = self.parent:FindAllModifiersByName(self:GetName())
  local special_remove = true

  for _, mod in pairs(autocast_mods) do
    if mod.special_kv_name == self.special_kv_name then
      special_remove = false
    end
  end

  if self.special_kv_name and special_remove then self.parent:RemoveModifierByName(self.special_kv_name) end

  self.parent:RemoveAbilityByHandle(self.stolen_ability)
  
  for _,rank in pairs(self.ability.ranks) do
    self.parent:RemoveAbilityByHandle(rank)
  end

  self.ability.ranks = {}
  
  self:CheckLast()
end

-- API FUNCTIONS -----------------------------------------------------------

function trickster_u_modifier_autocast:DeclareFunctions()
	local funcs = {
    MODIFIER_EVENT_ON_MODIFIER_ADDED,
		MODIFIER_EVENT_ON_ATTACK
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

function trickster_u_modifier_autocast:OnAttack(keys)
  if keys.attacker ~= self.parent then return end
  if self.stolen_ability:IsActivated() == false then return end
  if self.stolen_ability:IsOwnersManaEnough() == false then return end
  if self.parent:HasModifier("paladin_5_modifier_sonicblow") then return end
  if self.parent:HasModifier("strider_2_modifier_spin") then return end
  if self.parent:HasModifier("flea_3_modifier_jump") then return end
  if not self.enabled then return end

  if RandomFloat(0, 100) < self:GetChance() then
    local target = keys.target

    if self.stolen_ability:GetAbilityTargetTeam() == DOTA_UNIT_TARGET_TEAM_FRIENDLY then
      target = self.parent
    end

    self.parent:SetCursorCastTarget(target)
    self.parent:SetCursorPosition(keys.target:GetOrigin())
    self.stolen_ability:OnSpellStart()
    self.stolen_ability:UseResources(true, true, true, false)
  end
end

function trickster_u_modifier_autocast:OnIntervalThink()
  self.enabled = false

  -- if self.target then
  --   if IsValidEntity(self.target) then
  --     RemoveSubStats(self.target, self.ability, {"manacost"})
  --   end
  -- end

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

  if self.timer == true then
    self.timer = false

    if IsServer() then
      if self.stolen_ability:GetAbilityName() == "fleaman_1__precision" then
        self:SetDuration(-1, true)
        self:StartIntervalThink(1.5)
        return
      end
      if self.stolen_ability:GetAbilityName() == "lawbreaker_4__rain" then
        self:SetDuration(-1, true)
        self:StartIntervalThink(15)
        return
      end
      if self.stolen_ability:GetAbilityName() == "strider_1__silence" then
        self:SetDuration(-1, true)
        self:StartIntervalThink(1)
        return
      end
      if self.stolen_ability:GetAbilityName() == "ancient_u__fissure" then
        self:SetDuration(-1, true)
        self:StartIntervalThink(3.5)
        return
      end
      if self.stolen_ability:GetAbilityName() == "neutral_spiders" then
        self:SetDuration(-1, true)
        self:StartIntervalThink(1)
        return
      end
    end
  end

  self:Destroy()
end

-- UTILS -----------------------------------------------------------

function trickster_u_modifier_autocast:GetChance()
  local cooldown = self.stolen_ability:GetCooldown(self.stolen_ability:GetLevel())
  local restore_time = self.stolen_ability:GetAbilityChargeRestoreTime(self.stolen_ability:GetLevel())
  local mana_cost = self.stolen_ability:GetManaCost(self.stolen_ability:GetLevel()) * 0.1

  local chance = cooldown
  if restore_time > 0 then chance = restore_time end
  if self.stolen_ability:GetAbilityName() == "ancient_u__fissure" then chance = mana_cost / 2 end

  return (100 / chance) * self.ability:GetSpecialValueFor("chance_mult")
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