neutral_smash = class({})
LinkLuaModifier("neutral_smash_modifier_passive", "_neutrals/neutral_smash_modifier_passive", LUA_MODIFIER_MOTION_NONE)

function neutral_smash:Spawn()
  Timers:CreateTimer((0.2), function()
    if IsServer() then
      self:SetLevel(self:GetMaxLevel())
    end
  end)
end

function neutral_smash:GetAOERadius()
	return self:GetSpecialValueFor("stun_radius")
end

function neutral_smash:GetIntrinsicModifierName()
	return "neutral_smash_modifier_passive"
end

function neutral_smash:OnAbilityPhaseStart()
  local caster = self:GetCaster()
  if IsServer() then caster:EmitSound("Generic.Jump") end

  return true
end

function neutral_smash:OnAbilityPhaseInterrupted()
  local caster = self:GetCaster()
  if IsServer() then caster:StopSound("Generic.Jump") end
end

function neutral_smash:OnSpellStart()
  local caster = self:GetCaster()

	local enemies = FindUnitsInRadius(
		caster:GetTeamNumber(), caster:GetOrigin(), nil, self:GetAOERadius(),
		self:GetAbilityTargetTeam(), self:GetAbilityTargetType(),
		self:GetAbilityTargetFlags(), FIND_ANY_ORDER, false
	)

	for _,enemy in pairs(enemies) do
    if enemy:GetTeamNumber() ~= TIER_TEAMS[RARITY_COMMON] and enemy:GetTeamNumber() < TIER_TEAMS[RARITY_RARE] then
      if enemy:IsMagicImmune() == false then
        AddModifier(enemy, self, "_modifier_stun", {duration = self:GetSpecialValueFor("stun_duration")}, true)

        local distance_percent = 1 - ((caster:GetOrigin() - enemy:GetOrigin()):Length2D() / self:GetAOERadius())

        local bash = AddModifier(enemy, self, "modifier_knockback", {
          center_x = caster:GetAbsOrigin().x + 1,
          center_y = caster:GetAbsOrigin().y + 1,
          center_z = caster:GetAbsOrigin().z,
          knockback_height = 15,
          duration = distance_percent * 0.2,
          knockback_duration = distance_percent * 0.2,
          knockback_distance = distance_percent * self:GetAOERadius()
        }, true)
      end
      
      ApplyDamage({
        attacker = caster, victim = enemy, ability = self,
        damage = self:GetSpecialValueFor("stun_damage"),
        damage_type = self:GetAbilityDamageType(),
      })
    end
	end

  self:PlayEfxStart()
end

function neutral_smash:PlayEfxStart()
  local caster = self:GetCaster()
  local string = "particles/neutral_fx/ogre_bruiser_smash.vpcf"
  local particle = ParticleManager:CreateParticle(string, PATTACH_ABSORIGIN, caster)
  ParticleManager:SetParticleControl(particle, 0, caster:GetAbsOrigin())
  ParticleManager:ReleaseParticleIndex(particle)

  if IsServer() then caster:EmitSound("n_creep_OgreBruiser.Smash.Stun") end
end