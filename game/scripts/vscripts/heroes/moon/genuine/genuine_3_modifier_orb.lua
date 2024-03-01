genuine_3_modifier_orb = class({})

function genuine_3_modifier_orb:IsHidden() return true end
function genuine_3_modifier_orb:IsPurgable() return false end

-- CONSTRUCTORS -----------------------------------------------------------

function genuine_3_modifier_orb:OnCreated(kv)
  self.caster = self:GetCaster()
  self.parent = self:GetParent()
  self.ability = self:GetAbility()

  if not IsServer() then return end

  self.caster:AddModifier(self.ability, "genuine_3_modifier_travel", {})
	self:PlayEfxSound()
end

function genuine_3_modifier_orb:OnRefresh(kv)
end

function genuine_3_modifier_orb:OnRemoved()
  if not IsServer() then return end

  self.caster:RemoveModifierByName("genuine_3_modifier_travel")
  self.parent:StopSound("Hero_Puck.Illusory_Orb")
end

-- API FUNCTIONS -----------------------------------------------------------

-- UTILS -----------------------------------------------------------

-- EFFECTS -----------------------------------------------------------

function genuine_3_modifier_orb:PlayEfxSound()
  self.parent:StopSound("Hero_Puck.Illusory_Orb")
  self.parent:EmitSound("Hero_Puck.Illusory_Orb")
end