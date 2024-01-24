bloodstained_2__bloodsteal = class({})
LinkLuaModifier("bloodstained_2_modifier_passive", "heroes/death/bloodstained/bloodstained_2_modifier_passive", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("bloodstained_2_modifier_passive_status_efx", "heroes/death/bloodstained/bloodstained_2_modifier_passive_status_efx", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("bloodstained_2_modifier_death_delay", "heroes/death/bloodstained/bloodstained_2_modifier_death_delay", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("bloodstained_2_modifier_death_delay_status_efx", "heroes/death/bloodstained/bloodstained_2_modifier_death_delay_status_efx", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("bloodstained_2_modifier_barrier", "heroes/death/bloodstained/bloodstained_2_modifier_barrier", LUA_MODIFIER_MOTION_NONE)

-- INIT

  function bloodstained_2__bloodsteal:Spawn()
    if not IsServer() then return end

    self.min_hp = 0

    Timers:CreateTimer(0.2, function()
      if self:IsTrained() == false then
        self:UpgradeAbility(true)
      end
    end)
  end

  function bloodstained_2__bloodsteal:GetAOERadius()
    return self:GetSpecialValueFor("special_kill_radius")
  end

  function bloodstained_2__bloodsteal:GetIntrinsicModifierName()
    return "bloodstained_2_modifier_passive"
  end

-- SPELL START

  function bloodstained_2__bloodsteal:OnOwnerSpawned()
    self.min_hp = self:GetSpecialValueFor("special_min_hp")
  end

  function bloodstained_2__bloodsteal:OnOwnerDied()
    local caster = self:GetCaster()

    local special_respawn_time = self:GetSpecialValueFor("special_respawn_time") * 0.01
    caster:SetTimeUntilRespawn(caster:GetRespawnTime() * (1 + special_respawn_time))
  end

  function bloodstained_2__bloodsteal:OnHeroDiedNearby(unit, attacker, table)
    local caster = self:GetCaster()

    if attacker then
      if IsValidEntity(attacker) then
        if attacker == caster and unit:GetTeamNumber() ~= caster:GetTeamNumber() then
          local rage_restore = self:GetSpecialValueFor("special_rage_restore")
          caster:ApplyMana(caster:GetMaxMana() * rage_restore * 0.01, self, false, nil, true)
        end
      end
    end
  end

-- EFFECTS