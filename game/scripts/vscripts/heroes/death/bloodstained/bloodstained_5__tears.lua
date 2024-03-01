bloodstained_5__tears = class({})
LinkLuaModifier("bloodstained_5_modifier_tears", "heroes/death/bloodstained/bloodstained_5_modifier_tears", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("bloodstained_5_modifier_blood", "heroes/death/bloodstained/bloodstained_5_modifier_blood", LUA_MODIFIER_MOTION_NONE)

-- INIT

  function bloodstained_5__tears:OnOwnerSpawned()
    local caster = self:GetCaster()
    local special_kv_modifier = caster:FindModifierByName("bloodstained_special_values")
    if special_kv_modifier then special_kv_modifier:UpdateData("behavior_tears", 0) end
  end

  function bloodstained_5__tears:GetAbilityTextureName()
    if self:GetSpecialValueFor("behavior") == 1 then return "bloodstained_consume" end

    return "bloodstained_tears"
  end

  function bloodstained_5__tears:GetBehavior()
    if self:GetSpecialValueFor("behavior") == 1 then return DOTA_ABILITY_BEHAVIOR_NO_TARGET end

    return DOTA_ABILITY_BEHAVIOR_NO_TARGET + DOTA_ABILITY_BEHAVIOR_IMMEDIATE
  end

  function bloodstained_5__tears:GetAOERadius()
    return self:GetSpecialValueFor("radius")
  end

-- SPELL START

  function bloodstained_5__tears:OnSpellStart()
    local caster = self:GetCaster()
    local special_kv_modifier = caster:FindModifierByName("bloodstained_special_values")
    if special_kv_modifier == nil then return end

    if self:GetSpecialValueFor("behavior") == 0 then
      if self:GetSpecialValueFor("special_purge") == 1 then
        caster:Purge(false, true, false, false, false)
      end

      caster:AddModifier(self, "bloodstained_5_modifier_tears", {})
      self:PlayEfxShake()
      self:EndCooldown()
      self:StartCooldown(3)
      special_kv_modifier:UpdateData("behavior_tears", 1)
      return
    end

    if self:GetSpecialValueFor("behavior") == 1 then
      caster:RemoveModifierByName("bloodstained_5_modifier_tears")
      special_kv_modifier:UpdateData("behavior_tears", 0)
    end
  end

-- EFFECTS

  function bloodstained_5__tears:PlayEfxShake()
    local caster = self:GetCaster()
    local string_3 = "particles/osiris/poison_alt/osiris_poison_splash_shake.vpcf"
    local particle_3 = ParticleManager:CreateParticle(string_3, PATTACH_ABSORIGIN, caster)
    ParticleManager:SetParticleControl(particle_3, 0, caster:GetOrigin())
    ParticleManager:SetParticleControl(particle_3, 1, Vector(500, 0, 0))
  end