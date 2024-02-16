neutral_fireball = class({})
LinkLuaModifier("neutral_fireball_modifier_passive", "_neutrals/neutral_fireball_modifier_passive", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("neutral_fireball_modifier_burn", "_neutrals/neutral_fireball_modifier_burn", LUA_MODIFIER_MOTION_NONE)

function neutral_fireball:Spawn()
  if not IsServer() then return end

  Timers:CreateTimer((0.2), function()
    if IsServer() then
      self:SetLevel(self:GetMaxLevel())
    end
  end)
end

function neutral_fireball:GetIntrinsicModifierName()
	return "neutral_fireball_modifier_passive"
end

function neutral_fireball:OnSpellStart()
  if not IsServer() then return end

  local caster = self:GetCaster()
  local target = self:GetCursorTarget()
  local list = {}

  for i = 1, self:GetSpecialValueFor("targets"), 1 do
    if target then table.insert(list, target) end
    if i > 1 then target = self:FindTarget(list) end    
    
    if target then
      ProjectileManager:CreateTrackingProjectile({
        Target = target, Source = caster, Ability = self,	
        EffectName = "particles/units/heroes/hero_dragon_knight/dragon_knight_dragon_tail_dragonform_proj.vpcf",
        iMoveSpeed = 1000, bReplaceExisting = false, bDodgeable = false,
        bProvidesVision = true, iVisionRadius = 150, iVisionTeamNumber = caster:GetTeamNumber()
      })
    end
  end

  caster:EmitSound("Hero_Huskar.Burning_Spear.Cast")
end

function neutral_fireball:OnProjectileHit(hTarget, vLocation)
  if not IsServer() then return end

  if hTarget == nil then return end
  if hTarget:IsInvulnerable() then return end
  if hTarget:TriggerSpellAbsorb(self) then return end

  local caster = self:GetCaster()

  if hTarget:IsMagicImmune() == false then
    hTarget:AddModifier(self, "_modifier_stun", {
      duration = caster:GetDebuffPower(self:GetSpecialValueFor("stun_duration"), hTarget)
    })
  end
  
  hTarget:AddModifier(self, "neutral_fireball_modifier_burn", {
    duration = caster:GetDebuffPower(self:GetSpecialValueFor("flame_duration"), hTarget)
  })

  ApplyDamage({
    victim = hTarget, attacker = caster, ability = self,
    damage = caster:GetSpellDamage(self:GetSpecialValueFor("fireball_damage"), self:GetAbilityDamageType()),
    damage_type = self:GetAbilityDamageType()
  })
end

function neutral_fireball:FindTarget(list)
  local caster = self:GetCaster()
	local cast_direction = caster:GetForwardVector():Normalized()
	local cast_angle = VectorToAngles(cast_direction).y

	local enemies = FindUnitsInRadius(
		caster:GetTeamNumber(), caster:GetOrigin(), nil, self:GetCastRange(caster:GetOrigin(), nil),
		self:GetAbilityTargetTeam(), self:GetAbilityTargetType(),
		self:GetAbilityTargetFlags(), FIND_ANY_ORDER, false
	)

	for _,enemy in pairs(enemies) do
    local pass = true

    for _,target in pairs(list) do
      if enemy == target then pass = false end
    end

    if caster:IsHero() == false then
      if enemy:GetTeamNumber() == TIER_TEAMS[RARITY_COMMON]
      or enemy:GetTeamNumber() >= TIER_TEAMS[RARITY_RARE] then
        pass = false
      end      
    end

    if pass == true then
      local enemy_direction = (enemy:GetOrigin() - caster:GetOrigin()):Normalized()
      local enemy_angle = VectorToAngles(enemy_direction).y
      local angle_diff = math.abs(AngleDiff(cast_angle, enemy_angle))
  
      if angle_diff <= self:GetSpecialValueFor("angle") then
        return enemy
      end      
    end
  end
end