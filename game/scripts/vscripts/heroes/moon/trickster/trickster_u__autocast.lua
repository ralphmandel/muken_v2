trickster_u__autocast = class({})
LinkLuaModifier("trickster_u_modifier_passive", "heroes/moon/trickster/trickster_u_modifier_passive", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("trickster_u_modifier_autocast", "heroes/moon/trickster/trickster_u_modifier_autocast", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("trickster_u_modifier_last", "heroes/moon/trickster/trickster_u_modifier_last", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("trickster_u_modifier_used", "heroes/moon/trickster/trickster_u_modifier_used", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("fleaman_special_values", "heroes/death/fleaman/fleaman-special_values", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("bloodstained_special_values", "heroes/death/bloodstained/bloodstained-special_values", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("lawbreaker_special_values", "heroes/death/lawbreaker/lawbreaker-special_values", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("templar_special_values", "heroes/sun/templar/templar-special_values", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("ancient_special_values", "heroes/sun/ancient/ancient-special_values", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("paladin_special_values", "heroes/sun/paladin/paladin-special_values", LUA_MODIFIER_MOTION_NONE)

-- INIT

  function trickster_u__autocast:Spawn()
    self.texture = 1
    self.ranks = {}
  end

  function trickster_u__autocast:GetIntrinsicModifierName()
    return "trickster_u_modifier_passive"
  end

  function trickster_u__autocast:CastFilterResultTarget(hTarget)
		local caster = self:GetCaster()

		local result = UnitFilter(
			hTarget, self:GetAbilityTargetTeam(),
			self:GetAbilityTargetType(),
			self:GetAbilityTargetFlags(),
			caster:GetTeamNumber()
		)

    if result == UF_SUCCESS then
      if hTarget:HasModifier("trickster_u_modifier_last") == false
      or hTarget:HasModifier("trickster_u_modifier_used") then
        return UF_FAIL_CUSTOM
      end
    end
		
		return result
	end

	function trickster_u__autocast:GetCustomCastErrorTarget(hTarget)
    if hTarget:HasModifier("trickster_u_modifier_used") then return "YOU ALREADY STOLE THIS ABILITY" end
		if hTarget:HasModifier("trickster_u_modifier_last") == false then return "NO ABILITIES AVAILABLE FOR STEALING" end
	end

-- SPELL START

  function trickster_u__autocast:OnAbilityPhaseStart()
    local caster = self:GetCaster()
    caster:StartGestureWithPlaybackRate(ACT_DOTA_TELEPORT, 2)
    return true
  end

  function trickster_u__autocast:OnAbilityPhaseInterrupted()
		local caster = self:GetCaster()
    caster:FadeGesture(ACT_DOTA_TELEPORT)
  end

  function trickster_u__autocast:OnSpellStart()
		local caster = self:GetCaster()
		local target = self:GetCursorTarget()

    Timers:CreateTimer(0.5, function()
      caster:FadeGesture(ACT_DOTA_TELEPORT)
    end)

    if target:TriggerSpellAbsorb(self) then return end
		local modifier = target:FindModifierByName("trickster_u_modifier_last")

    if modifier == nil then
      self:EndCooldown()
      return
    end

    local autocast_mods = caster:FindAllModifiersByName("trickster_u_modifier_autocast")
    local ability_name = EntIndexToHScript(modifier.ability_index):GetAbilityName()

    for _, autocast_mod in pairs(autocast_mods) do
      if autocast_mod.stolen_ability:GetAbilityName() ~= ability_name then
        if autocast_mod.enabled == true then
          if IsServer() then autocast_mod:OnIntervalThink() end
        end
      end
    end

    ProjectileManager:CreateTrackingProjectile({
      Target = caster,
      Source = target,
      Ability = self,
      EffectName = "particles/trickster/spell_steal/trickster_spell_steal.vpcf",
      iMoveSpeed = 900,
      vSourceLoc = target:GetAbsOrigin(),
      bDrawsOnMinimap = false,
      bDodgeable = false,
      bVisibleToEnemies = true,
      bReplaceExisting = false,
      ExtraData = {
        ability_index = modifier.ability_index,
        target_index = target:entindex()
      }
    })

    if IsServer() then
      caster:EmitSound("Hero_Rubick.SpellSteal.Cast.Arcana")
      target:EmitSound("Hero_Rubick.SpellSteal.Target")
    end
	end

  function trickster_u__autocast:OnProjectileHit_ExtraData(hTarget, vLocation, table)
    local caster = self:GetCaster()
    local texture = self:GetTextureID(table.ability_index)

    if IsServer() then caster:EmitSound("Hero_Rubick.SpellSteal.Complete") end

    local autocast_mods = caster:FindAllModifiersByName("trickster_u_modifier_autocast")
    local ability_name = EntIndexToHScript(table.ability_index):GetAbilityName()
    local target = EntIndexToHScript(table.target_index)

    -- local ability_target = target:FindAbilityByName(ability_name)
    -- if ability_target then
    --   local add_cd = ability_target:GetCooldown(ability_target:GetLevel()) * self:GetSpecialValueFor("special_cd_mult")
    --   ability_target:StartCooldown(ability_target:GetCooldownTimeRemaining() + add_cd)
    -- end

    for _, autocast_mod in pairs(autocast_mods) do
      if autocast_mod.stolen_ability:GetAbilityName() == ability_name then
        for tier = 1, 3, 1 do
          for path = 1, 2, 1 do
            local rank_name = "_rank_"..tier..path
            if self:GetSpecialValueFor(rank_name) == 1 then
              if caster:HasAbility(ability_name..rank_name) == false then
                self.ranks[rank_name] = caster:AddAbility(ability_name..rank_name)
              end
            end
          end
        end

        autocast_mod.stolen_ability:SetLevel(self:GetSpecialValueFor("ability_level"))
        autocast_mod.enabled = true
        autocast_mod.timer = true

        -- RemoveSubStats(target, self, {"manacost"})
        -- AddSubStats(target, self, {manacost = self:GetSpecialValueFor("special_manacost")}, false)

        if IsServer() then
          local duration = CalcStatus(self:GetSpecialValueFor("duration"), caster, caster)
          autocast_mod:SetDuration(duration + 0.5, true)
          autocast_mod:StartIntervalThink(duration)
          return
        end
      end
    end

    caster:FindAbilityByName("trickster__precache"):SetLevel(texture)

    AddModifier(caster, self, "trickster_u_modifier_autocast", {
      duration = CalcStatus(self:GetSpecialValueFor("duration"), caster, caster) + 0.5,
      ability_index = table.ability_index,
      target_index = table.target_index,
      texture = 1
    }, false)
  end

  function trickster_u__autocast:GetTextureID(ability_index)
    local ability_name = EntIndexToHScript(ability_index):GetAbilityName()
  
    local list = {
      ["fleaman_1__precision"] = 101,
      ["fleaman_3__jump"] = 102,
      ["fleaman_5__smoke"] = 103,
      ["bloodstained_1__rage"] = 104,
      ["bloodstained_u__seal"] = 105,
      ["lawbreaker_3__grenade"] = 106,
      ["lawbreaker_4__rain"] = 107,
      ["lawbreaker_u__form"] = 108,
      ["templar_3__hammer"] = 401,
      ["templar_4__revenge"] = 402,
      ["templar_u__praise"] = 403,
      ["ancient_2__roar"] = 404,
      ["ancient_5__walk"] = 405,
      ["ancient_u__fissure"] = 406,
      ["paladin_2__shield"] = 407,
      ["paladin_3__hammer"] = 408,
      ["paladin_4__magnus"] = 409
    }
  
    return list[ability_name]
  end

-- EFFECTS