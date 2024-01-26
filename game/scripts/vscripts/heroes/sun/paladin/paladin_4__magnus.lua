paladin_4__magnus = class({})
LinkLuaModifier("paladin_4_modifier_passive", "heroes/sun/paladin/paladin_4_modifier_passive", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("paladin_4_modifier_aura", "heroes/sun/paladin/paladin_4_modifier_aura", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("paladin_4_modifier_aura_effect", "heroes/sun/paladin/paladin_4_modifier_aura_effect", LUA_MODIFIER_MOTION_NONE)

-- INIT

  function paladin_4__magnus:GetBehavior()
    if self:GetSpecialValueFor("special_cast_range") > 0 then
      return DOTA_ABILITY_BEHAVIOR_OPTIONAL_POINT + DOTA_ABILITY_BEHAVIOR_DIRECTIONAL + DOTA_ABILITY_BEHAVIOR_IMMEDIATE + DOTA_ABILITY_BEHAVIOR_ROOT_DISABLES
    end

    return DOTA_ABILITY_BEHAVIOR_NO_TARGET + DOTA_ABILITY_BEHAVIOR_IMMEDIATE
  end

  function paladin_4__magnus:GetAOERadius()
    return self:GetSpecialValueFor("radius")
  end

  function paladin_4__magnus:GetIntrinsicModifierName()
    return "paladin_4_modifier_passive"
  end

-- SPELL START

	function paladin_4__magnus:OnSpellStart()
		local caster = self:GetCaster()
    local cast_range = self:GetSpecialValueFor("special_cast_range")

    if cast_range > 0 then
      local origin = caster:GetOrigin()
      local point = self:GetCursorPosition()
      local dist_diff = (caster:GetAbsOrigin() - point):Length2D()
      local direction = (point - caster:GetAbsOrigin()):Normalized()
      if dist_diff > cast_range then point = origin + direction * cast_range end

      ProjectileManager:ProjectileDodge(caster)
      FindClearSpaceForUnit(caster, point, true)

      self:PlayEfxBlink(origin, caster:GetOrigin())
    end

    caster:AddModifier(self, "paladin_4_modifier_aura", {duration = self:GetSpecialValueFor("duration")})
    caster:EmitSound("Hero_ArcWarden.MagneticField.Cast")
	end

-- EFFECTS

  function paladin_4__magnus:PlayEfxBlink(start_point, end_point)
    local caster = self:GetCaster()
    local particle_start = "particles/econ/events/ti10/blink_dagger_start_ti10_lvl2.vpcf"
    local particle_end = "particles/econ/events/ti10/blink_dagger_end_ti10_lvl2.vpcf"

    local blink_start_fx = ParticleManager:CreateParticle(particle_start, PATTACH_ABSORIGIN, caster)
    ParticleManager:SetParticleControl(blink_start_fx, 0, start_point)
    ParticleManager:ReleaseParticleIndex(blink_start_fx)

    local blink_end_fx = ParticleManager:CreateParticle(particle_end, PATTACH_ABSORIGIN, caster)
    ParticleManager:SetParticleControl(blink_end_fx, 0, end_point)
    ParticleManager:ReleaseParticleIndex(blink_end_fx)

    caster:EmitSound("DOTA_Item.Overwhelming_Blink.Activate")
  end