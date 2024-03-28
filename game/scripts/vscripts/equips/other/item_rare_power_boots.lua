item_rare_power_boots = class({})
LinkLuaModifier("item_rare_power_boots_mod_passive", "equips/other/item_rare_power_boots_mod_passive", LUA_MODIFIER_MOTION_NONE)

-- INIT

  function item_rare_power_boots:GetAbilityTextureName()
    if self:GetSpecialValueFor("state") == 1 then return "boots/power_boots_str" end
    if self:GetSpecialValueFor("state") == 2 then return "boots/power_boots_agi" end
    if self:GetSpecialValueFor("state") == 3 then return "boots/power_boots_int" end
    if self:GetSpecialValueFor("state") == 4 then return "boots/power_boots_vit" end
  end

  function item_rare_power_boots:GetIntrinsicModifierName()
		return "item_rare_power_boots_mod_passive"
	end

-- SPELL START

  function item_rare_power_boots:OnSpellStart()
    local caster = self:GetCaster()

    local state = self:GetSpecialValueFor("state")
    if state == 4 then state = 1 else state = state + 1 end

    local base_hero_mod = caster:FindModifierByName("base_hero_mod")
    if base_hero_mod then base_hero_mod:UpdateData("power_boots_state", state) end

    self:SwitchStat(self:GetSpecialValueFor("state"))
    self:StartCooldown(0.2)
  end

  function item_rare_power_boots:SwitchStat(state)
    local caster = self:GetCaster()
    local stats = {[1] = "str", [2] = "agi", [3] = "int", [4] = "vit"}

    for i, stat in pairs(stats) do
      caster:RemoveMainStats(self, {stat})

      if state == i then
        caster:AddMainStats(self, {[stat] = self:GetSpecialValueFor("bonus_stat")})
      end
    end
  end

-- EFFECTS