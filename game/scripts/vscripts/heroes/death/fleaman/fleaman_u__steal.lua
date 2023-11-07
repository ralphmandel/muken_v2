fleaman_u__steal = class({})
LinkLuaModifier("fleaman_u_modifier_passive", "heroes/death/fleaman/fleaman_u_modifier_passive", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("fleaman_u_modifier_chain", "heroes/death/fleaman/fleaman_u_modifier_chain", LUA_MODIFIER_MOTION_NONE)

-- INIT

  function fleaman_u__steal:GetIntrinsicModifierName()
    return "fleaman_u_modifier_passive"
  end

-- SPELL START

  function fleaman_u__steal:OnOwnerDied()
    local caster = self:GetCaster()
    local passive = caster:FindModifierByName(self:GetIntrinsicModifierName())
    local mult = self:GetSpecialValueFor("special_respawn_mult")

    if caster:IsIllusion() then return end
    if passive == nil then return end
    if mult == 0 then return end

    local respawn = caster:GetRespawnTime() - (passive:GetStackCount() * mult)
    if respawn < 0 then respawn = 0 end

    caster:SetTimeUntilRespawn(respawn)
  end

-- EFFECTS