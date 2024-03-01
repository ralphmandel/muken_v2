genuine__modifier_starfall = class({})

function genuine__modifier_starfall:IsHidden() return true end
function genuine__modifier_starfall:IsPurgable() return false end

-- CONSTRUCTORS -----------------------------------------------------------

function genuine__modifier_starfall:OnCreated(kv)
  self.caster = self:GetCaster()
  self.parent = self:GetParent()
  self.ability = self:GetAbility()

  if not IsServer() then return end

  self.damageTable = {
    attacker = self.caster,
    ability = self.ability,
    damage = kv.starfall_damage,
    damage_type = DAMAGE_TYPE_MAGICAL
  }

  self:PlayEfxStart()
  self:StartIntervalThink(0.5)
end

function genuine__modifier_starfall:OnRefresh(kv)
end

function genuine__modifier_starfall:OnRemoved()
end

-- API FUNCTIONS -----------------------------------------------------------

function genuine__modifier_starfall:OnIntervalThink()
  local sound = false

  local enemies = FindUnitsInRadius(
    self.parent:GetTeamNumber(), self.parent:GetOrigin(), nil,
    self.ability:GetSpecialValueFor("starfall_radius"),
    DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
    DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, 0, false
  )

  for _,enemy in pairs(enemies) do
    self.damageTable.victim = enemy
    ApplyDamage(self.damageTable)
    
    if sound == false then
      self.parent:EmitSound("Hero_Mirana.Starstorm.Impact")
      sound = true
    end
  end

  self:Destroy()
end

-- UTILS -----------------------------------------------------------

-- EFFECTS -----------------------------------------------------------

function genuine__modifier_starfall:PlayEfxStart()
  local particle_cast = "particles/genuine/starfall/genuine_starfall_attack.vpcf"
  local effect_cast = ParticleManager:CreateParticle(particle_cast, PATTACH_WORLDORIGIN, nil)
  ParticleManager:SetParticleControl(effect_cast, 0, self.parent:GetOrigin())
  ParticleManager:ReleaseParticleIndex(effect_cast)

  self.parent:EmitSound("Hero_Mirana.Starstorm.Cast")
end