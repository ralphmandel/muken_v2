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
		local caster = self:GetCaster()

    local illusion = CreateIllusions(caster, caster, {
      outgoing_damage = 0,
      incoming_damage = self:GetSpecialValueFor("incoming_damage"),
      bounty_base = 0,
      bounty_growth = 0,
      duration = self:GetSpecialValueFor("duration")
    }, 1, 64, false, true)

    illusion = illusion[1]
    self:CheckMaxShadow()
    self.shadows[illusion:GetEntityIndex()] = GameRules:GetGameTime()

    FindClearSpaceForUnit(illusion, self:GetCursorPosition(), true)
    illusion:AddModifier(self, "strider_u_modifier_shadow", {entindex = illusion:GetEntityIndex()})

    local caster_modifier = caster:FindModifierByName("strider_special_values")
    local illusion_modifier = illusion:FindModifierByName("strider_special_values")
    illusion_modifier.ranks = caster_modifier.ranks
    illusion_modifier.data_props = caster_modifier.data_props
    illusion_modifier:SendBuffRefreshToClients()
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
