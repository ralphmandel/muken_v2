trickster_5_modifier_teleport = class({})

function trickster_5_modifier_teleport:IsHidden() return true end
function trickster_5_modifier_teleport:IsPurgable() return false end

-- CONSTRUCTORS -----------------------------------------------------------

function trickster_5_modifier_teleport:OnCreated(kv)
  self.caster = self:GetCaster()
  self.parent = self:GetParent()
  self.ability = self:GetAbility()

  self.parent:FadeGesture(ACT_DOTA_ATTACK_EVENT)
  self.parent:StartGestureWithPlaybackRate(ACT_DOTA_CAST_ABILITY_4, 1 / self.ability.rate)

  AddModifier(self.parent, self.ability, "_modifier_restrict", {}, false)

  if IsServer() then self:PlayEfxStart() end
end

function trickster_5_modifier_teleport:OnRefresh(kv)
end

function trickster_5_modifier_teleport:OnRemoved()
  self.parent:FadeGesture(ACT_DOTA_CAST_ABILITY_4)

  RemoveAllModifiersByNameAndAbility(self.parent, "_modifier_restrict", self.ability)

  if IsServer() then self.parent:StopSound("Hero_Wisp.Relocate.Arc") end
end

-- API FUNCTIONS -----------------------------------------------------------

-- UTILS -----------------------------------------------------------

-- EFFECTS -----------------------------------------------------------

function trickster_5_modifier_teleport:PlayEfxStart()
  local string = "particles/econ/items/tinker/boots_of_travel/teleport_end_bots.vpcf"
  local pfx = ParticleManager:CreateParticle(string, PATTACH_ABSORIGIN_FOLLOW, self.parent)
  ParticleManager:SetParticleControl(pfx, 0, self.parent:GetOrigin())
  ParticleManager:SetParticleControl(pfx, 1, self.parent:GetOrigin())
  ParticleManager:SetParticleControl(pfx, 5, self.parent:GetOrigin())
  ParticleManager:SetParticleControl(pfx, 4, Vector(1,0,0))
  --ParticleManager:SetParticleControlEnt(pfx, 3, self.parent, PATTACH_CUSTOMORIGIN, "attach_hitloc", self.parent:GetOrigin(), true)
  self:AddParticle(pfx, false, false, 1, false, false)

  local pfx_2 = ParticleManager:CreateParticle(string, PATTACH_ABSORIGIN_FOLLOW, self.ability.target)
  ParticleManager:SetParticleControl(pfx_2, 0, self.ability.target:GetOrigin())
  ParticleManager:SetParticleControl(pfx_2, 1, self.ability.target:GetOrigin())
  ParticleManager:SetParticleControl(pfx_2, 5, self.ability.target:GetOrigin())
  ParticleManager:SetParticleControl(pfx_2, 4, Vector(1,0,0))
  --ParticleManager:SetParticleControlEnt(pfx_2, 3, self.ability.target, PATTACH_CUSTOMORIGIN, "attach_hitloc", self.ability.target:GetOrigin(), true)
  self:AddParticle(pfx_2, false, false, 1, false, false)

  if IsServer() then self.parent:EmitSound("Hero_Wisp.Relocate.Arc") end
end