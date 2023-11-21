ancient_2__roar = class({})
LinkLuaModifier("ancient_2_modifier_pre", "heroes/sun/ancient/ancient_2_modifier_pre", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("ancient_2_modifier_gesture", "heroes/sun/ancient/ancient_2_modifier_gesture", LUA_MODIFIER_MOTION_NONE)

-- INIT

-- SPELL START

  function ancient_2__roar:OnAbilityPhaseStart()
    local caster = self:GetCaster()
    caster:RemoveModifierByName("ancient_1_modifier_leap")
    return true
  end

	function ancient_2__roar:OnSpellStart()
    local caster = self:GetCaster()
    local point = self:GetCursorPosition()
    local cast_time = self:GetSpecialValueFor("cast_time")

    AddModifier(caster, self, "ancient_2_modifier_pre", {
      duration = cast_time, x = point.x, y = point.y
    })
	end

-- EFFECTS