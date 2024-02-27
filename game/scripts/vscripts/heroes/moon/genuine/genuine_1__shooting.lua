genuine_1__shooting = class({})
LinkLuaModifier("genuine_1_modifier_orb", "heroes/moon/genuine/genuine_1_modifier_orb", LUA_MODIFIER_MOTION_NONE)

-- INIT

  function genuine_1__shooting:Spawn()
    if not IsServer() then return end

    Timers:CreateTimer(0.2, function()
      if self:IsTrained() == false then
        self:UpgradeAbility(true)
      end
    end)
  end

  function genuine_1__shooting:GetIntrinsicModifierName()
		return "genuine_1_modifier_orb"
	end

	function genuine_1__shooting:GetProjectileName()
		return "particles/genuine/shooting_star/genuine_shooting.vpcf"
	end

-- SPELL START

  function genuine_1__shooting:OnOrbFire(keys)
    local caster = self:GetCaster()
    caster:EmitSound("Hero_DrowRanger.FrostArrows")
  end

  function genuine_1__shooting:OnOrbImpact(keys)
    local caster = self:GetCaster()
    local origin = caster:GetOrigin()

    keys.target:EmitSound("Hero_DrowRanger.Marksmanship.Target")

    if keys.target:IsMagicImmune() == false and self:IsCooldownReady()
    and RandomFloat(0, 100) < self:GetSpecialValueFor("special_fear_chance") then
      self:StartCooldown(self:GetEffectiveCooldown(self:GetLevel()))
      
      keys.target:AddModifier(self, "_modifier_fear", {
        duration = self:GetSpecialValueFor("special_fear_duration"), bResist = 1,
        special = 1, x = origin.x, y = origin.y, z = origin.z
      })
    end

    if caster:GetMainStat("STR").has_crit == true then
      caster:SetForceSpellCrit(self:GetSpecialValueFor("special_crit_damage"))
    end

    ApplyDamage({
      victim = keys.target, attacker = caster,
      damage = self:GetSpecialValueFor("damage"),
      damage_type = self:GetAbilityDamageType(),
      ability = self
    })
  end

  function genuine_1__shooting:OnOrbFail(keys)
  end

-- EFFECTS