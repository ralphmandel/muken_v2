ancient_2_modifier_gesture = class({})

function ancient_2_modifier_gesture:IsHidden() return true end
function ancient_2_modifier_gesture:IsPurgable() return false end

-- CONSTRUCTORS -----------------------------------------------------------

function ancient_2_modifier_gesture:OnCreated(kv)
  self.caster = self:GetCaster()
  self.parent = self:GetParent()
  self.ability = self:GetAbility()
  self.step = self.ability:GetSpecialValueFor("step")

  if GetHeroName(self.parent) == "trickster" then
    self.parent:FadeGesture(ACT_DOTA_ATTACK_EVENT)
    self.parent:StartGestureWithPlaybackRate(ACT_DOTA_CAST_ABILITY_2, 1.16) -- 1 / 0.86
  else
    self.parent:StartGesture(ACT_DOTA_CAST_ABILITY_1)
  end


  if IsServer() then self:StartIntervalThink(0.5) end
end

function ancient_2_modifier_gesture:OnRefresh(kv)
end

function ancient_2_modifier_gesture:OnRemoved()
  self.parent:FadeGesture(ACT_DOTA_CAST_ABILITY_1)
end

-- API FUNCTIONS -----------------------------------------------------------

function ancient_2_modifier_gesture:OnIntervalThink()
  if IsServer() then
    if self.step == 1 then
      self.step = 2
      self:PlayEfxPre()
      self:StartIntervalThink(0.3)

    elseif self.step == 2 then
      self.step = 3

      if GetHeroName(self.parent) == "trickster" then
        self.parent:FadeGesture(ACT_DOTA_CAST_ABILITY_2)
        self.parent:StartGestureWithPlaybackRate(ACT_DOTA_CAST_ABILITY_2, 1.16) -- 1 / 0.86
      else
        self.parent:FadeGesture(ACT_DOTA_CAST_ABILITY_1)
        self.parent:StartGesture(ACT_DOTA_CAST_ABILITY_1)
      end

      self:StartIntervalThink(0.5)
    elseif self.step == 3 then
      self.step = 4
      self:PlayEfxPre()

      if GetHeroName(self.parent) == "trickster" then
        self:StartIntervalThink(0.3)
      else
        self:StartIntervalThink(-1)
      end
    else
      self.parent:FadeGesture(ACT_DOTA_CAST_ABILITY_2)
      self.parent:StartGestureWithPlaybackRate(ACT_DOTA_CAST_ABILITY_1, 0.5)
      self:StartIntervalThink(-1)
    end
  end
end

-- UTILS -----------------------------------------------------------

-- EFFECTS -----------------------------------------------------------

function ancient_2_modifier_gesture:PlayEfxPre()
  local particle_shake = "particles/osiris/poison_alt/osiris_poison_splash_shake.vpcf"
	local effect = ParticleManager:CreateParticle(particle_shake, PATTACH_ABSORIGIN, self.parent)
	ParticleManager:SetParticleControl(effect, 0, self.parent:GetOrigin())
	ParticleManager:SetParticleControl(effect, 1, Vector(500, 0, 0))

  if IsServer() then self.parent:EmitSound("Hero_PrimalBeast.GroundPound.Loud")end
end