genuine_u_modifier_morning = class({})

function genuine_u_modifier_morning:IsHidden() return false end
function genuine_u_modifier_morning:IsPurgable() return false end
function genuine_u_modifier_morning:RemoveOnDeath() return false end

-- CONSTRUCTORS -----------------------------------------------------------

function genuine_u_modifier_morning:OnCreated(kv)
	self.caster = self:GetCaster()
	self.parent = self:GetParent()
	self.ability = self:GetAbility()

  if not IsServer() then return end

  GameRules:BeginTemporaryNight(self:GetDuration())

  self.parent:EmitSound("Genuine.Morning")

  self.parent:AddMainStats(self.ability, {
    int = self.ability:GetSpecialValueFor("int"),
    agi = self.ability:GetSpecialValueFor("agi")
  })

  self.ability:SetActivated(false)
  self.ability:EndCooldown()
end

function genuine_u_modifier_morning:OnRefresh(kv)  
end

function genuine_u_modifier_morning:OnRemoved(kv)
  if not IsServer() then return end

  self.parent:RemoveMainStats(self.ability, {"int", "agi"})
  self.parent:FindModifierByName(self.ability:GetIntrinsicModifierName()):StopEfxBuff()

	self.ability:SetActivated(true)
  self.ability:StartCooldown(self.ability:GetEffectiveCooldown(self.ability:GetLevel()))
end

-- API FUNCTIONS -----------------------------------------------------------

-- UTILS -----------------------------------------------------------

-- EFFECTS -----------------------------------------------------------