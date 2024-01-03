_neutral__ai = class({})
LinkLuaModifier( "_modifier__ai", "_neutrals/_modifier__ai", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier("_fountain_refresh_hp", "_modifiers/_fountain_refresh_hp", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("_fountain_refresh_mp", "_modifiers/_fountain_refresh_mp", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("_modifier_ban", "_modifiers/_modifier_ban", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("_modifier_bkb", "_modifiers/_modifier_bkb", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("_modifier_bleeding", "_modifiers/_modifier_bleeding", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("_modifier_blind", "_modifiers/_modifier_blind", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("_modifier_blind_stack", "_modifiers/_modifier_blind_stack", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("_modifier_break", "_modifiers/_modifier_break", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("_modifier_disarm", "_modifiers/_modifier_disarm", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("_modifier_ethereal", "_modifiers/_modifier_ethereal", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("_modifier_ethereal_status_efx", "_modifiers/_modifier_ethereal_status_efx", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("_modifier_fear", "_modifiers/_modifier_fear", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("_modifier_fear_status_efx", "_modifiers/_modifier_fear_status_efx", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("_modifier_generic_arc", "_modifiers/_modifier_generic_arc", LUA_MODIFIER_MOTION_BOTH)
LinkLuaModifier("_modifier_generic_custom_indicator", "_modifiers/_modifier_generic_custom_indicator", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("_modifier_generic_knockback_lua", "_modifiers/_modifier_generic_knockback_lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("_modifier_hex", "_modifiers/_modifier_hex", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("_modifier_hide", "_modifiers/_modifier_hide", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("_modifier_immunity", "_modifiers/_modifier_immunity", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("_modifier_invi_level", "_modifiers/_modifier_invi_level", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("_modifier_invisible", "_modifiers/_modifier_invisible", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("_modifier_invulnerable", "_modifiers/_modifier_invulnerable", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("_modifier_lighting", "_modifiers/_modifier_lighting", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("_modifier_no_bar", "_modifiers/_modifier_no_bar", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("_modifier_no_block", "_modifiers/_modifier_no_block", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("_modifier_no_vision_attacker", "_modifiers/_modifier_no_vision_attacker", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("_modifier_path", "_modifiers/_modifier_path", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("_modifier_petrified", "_modifiers/_modifier_petrified", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("_modifier_petrified_status_efx", "_modifiers/_modifier_petrified_status_efx", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("_modifier_phase", "_modifiers/_modifier_phase", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("_modifier_pull", "_modifiers/_modifier_pull", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("_modifier_restrict", "_modifiers/_modifier_restrict", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("_modifier_root", "_modifiers/_modifier_root", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("_modifier_silence", "_modifiers/_modifier_silence", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("_modifier_stun", "_modifiers/_modifier_stun", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("_modifier_tracking", "_modifiers/_modifier_tracking", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("_modifier_truesight", "_modifiers/_modifier_truesight", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("_modifier_turn_disabled", "_modifiers/_modifier_turn_disabled", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("_modifier_unslowable", "_modifiers/_modifier_unslowable", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("_modifier_untargetable", "_modifiers/_modifier_untargetable", LUA_MODIFIER_MOTION_NONE)

function _neutral__ai:GetIntrinsicModifierName()
	return "_modifier__ai"
end

function _neutral__ai:Spawn()
	local caster = self:GetCaster()

  Timers:CreateTimer((0.2), function()
    if IsServer() then
      local neutral_list = LoadKeyValues("scripts/vscripts/_neutrals/_neutral_units.txt")
      local abilities_stats = {
        ["str"] = caster:FindAbilityByName("_ability_str"),
        ["agi"] = caster:FindAbilityByName("_ability_agi"),
        ["int"] = caster:FindAbilityByName("_ability_int"),
        ["vit"] = caster:FindAbilityByName("_ability_vit")
      }
    
      for name, table in pairs(neutral_list) do
        if name == caster:GetUnitName() then
          for info, stats in pairs(table) do
            if info == "Stats" then
              for stat, value in pairs(stats) do
                abilities_stats[stat]:SetLevel(value * caster:GetLevel())
              end
              return
            end
          end
        end
      end      
    end
  end)
end