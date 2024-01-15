fleaman_u__steal = class({})
LinkLuaModifier("fleaman_u_modifier_passive", "heroes/death/fleaman/fleaman_u_modifier_passive", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("fleaman_u_modifier_chain", "heroes/death/fleaman/fleaman_u_modifier_chain", LUA_MODIFIER_MOTION_NONE)

-- INIT

  function fleaman_u__steal:Spawn()
    self.origin = nil
  end

  function fleaman_u__steal:GetIntrinsicModifierName()
    return "fleaman_u_modifier_passive"
  end

-- SPELL START

  function fleaman_u__steal:OnOwnerDied()
    if not IsServer() then return end

    local caster = self:GetCaster()
    local passive = caster:FindModifierByName(self:GetIntrinsicModifierName())
    local mult = self:GetSpecialValueFor("special_respawn_self")

    if caster:IsIllusion() then return end
    if passive == nil then return end
    if mult == 0 then return end

    local respawn = caster:GetRespawnTime() - (passive:GetStackCount() * mult)

    if respawn < 1 then
      self.origin = caster:GetOrigin()
      respawn = 0
    end

    caster:SetTimeUntilRespawn(respawn)
  end

  function fleaman_u__steal:OnOwnerSpawned()
    if not IsServer() then return end

    local caster = self:GetCaster()

    if self.origin then
      caster:SetOrigin(self.origin)
      FindClearSpaceForUnit(caster, self.origin, true)
    end

    self.origin = nil
  end

  function fleaman_u__steal:OnHeroDiedNearby(unit, attacker, table)
    if not IsServer() then return end

    local caster = self:GetCaster()
    local mult = self:GetSpecialValueFor("special_respawn_enemy")
    local modifiers = unit:FindAllModifiersByName("sub_stat_modifier")

    if unit:GetTeamNumber() == caster:GetTeamNumber() then return end
    if modifiers == nil then return end
    if mult == 0 then return end

    local total = 0

    for _, mod in pairs(modifiers) do
      if mod.kv.attack_damage and mod:GetAbility() == self then
        total = total + mod.kv.attack_damage
      end
    end

    unit:SetTimeUntilRespawn(unit:GetRespawnTime() - (total * mult))
  end

-- EFFECTS