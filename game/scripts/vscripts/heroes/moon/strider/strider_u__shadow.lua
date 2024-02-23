strider_u__shadow = class({})
LinkLuaModifier("strider_u_modifier_shadow", "heroes/moon/strider/strider_u_modifier_shadow", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("strider_u_modifier_shadow_status_efx", "heroes/moon/strider/strider_u_modifier_shadow_status_efx", LUA_MODIFIER_MOTION_NONE)

-- INIT

  function strider_u__shadow:Spawn()
    if not IsServer() then return end

    self.shadows = {}
  end

-- SPELL START

	function strider_u__shadow:OnAbilityPhaseStart()
		self:PlayEfxStart()
		return true
	end

	function strider_u__shadow:OnSpellStart()
    self:CreateShadow(self:GetCursorPosition())
	end

  function strider_u__shadow:CreateShadow(position)
    local caster = self:GetCaster()

    local shadow = CreateUnitByName("strider_shadow", position, true, caster, caster, caster:GetTeamNumber())
    shadow:CreatureLevelUp(self:GetLevel() - 1)

    self:CheckAbilities(shadow)
    self:CheckMaxShadow()
    self.shadows[shadow:GetEntityIndex()] = GameRules:GetGameTime()

    local shadow_modifier = shadow:AddModifier(self, "strider_u_modifier_shadow", {
      entindex = shadow:GetEntityIndex(),
      duration = self:GetSpecialValueFor("duration")
    })

    shadow_modifier:SetEndCallback(function(entindex_callback)
      self.shadows[entindex_callback] = nil
      self:SetActivated(#self.shadows < self:GetSpecialValueFor("max_shadows"))
    end)

    local caster_special_kv = caster:FindModifierByName("strider_special_values")
    local shadow_special_kv = shadow:FindModifierByName("strider_special_values")
    shadow_special_kv.ranks = caster_special_kv.ranks
    shadow_special_kv:SendBuffRefreshToClients()
  end

  function strider_u__shadow:CheckAbilities(shadow)
    local caster = self:GetCaster()
    local abilities_name = GetAbilitiesList(caster)

    for i = 1, 6, 1 do
      if i == 6 or caster:FindAbilityByName(abilities_name[i]):IsTrained() == false then
        shadow:FindAbilityByName(abilities_name[i]):SetLevel(0)
      end
    end
  end

  function strider_u__shadow:CheckMaxShadow()
    local caster = self:GetCaster()
    local current_number = 0
    local info = {}

    for index, time in pairs(self.shadows) do
      current_number = current_number + 1
      if info.time == nil then
        info.time = time
        info.index = index
      else
        if info.time > time then
          info.index = index
          info.time = time
        end
      end
    end

    if current_number >= self:GetSpecialValueFor("max_shadows") and info.index then
      local ent = EntIndexToHScript(info.index)
      if IsValidEntity(ent) then ent:Kill(self, caster) end
      self.shadows[info.index] = nil
    end
  end

-- EFFECTS

  function strider_u__shadow:PlayEfxStart()
    local caster = self:GetCaster()
    local string = "particles/strider/ult/strider_shadow_cast_hands.vpcf"
    local particle = ParticleManager:CreateParticle(string, PATTACH_ABSORIGIN_FOLLOW, caster)
    ParticleManager:SetParticleControl(particle, 0, caster:GetOrigin())
    ParticleManager:ReleaseParticleIndex( particle )
  end

  --particles/strider/ult/strider_shadow_ground.vpcf
  --particles/strider/ult/strider_shadow_blur.vpcf
  --particles/strider/ult/strider_shadow_status_effect.vpcf
