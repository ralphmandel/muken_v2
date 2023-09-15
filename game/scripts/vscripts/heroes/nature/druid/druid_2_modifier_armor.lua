druid_2_modifier_armor = class({})

function druid_2_modifier_armor:IsHidden() return false end
function druid_2_modifier_armor:IsPurgable() return true end

-- CONSTRUCTORS -----------------------------------------------------------

function druid_2_modifier_armor:OnCreated(kv)
  self.caster = self:GetCaster()
  self.parent = self:GetParent()
  self.ability = self:GetAbility()

  AddBonus(self.ability, "DEF", self.parent, self.ability:GetSpecialValueFor("def"), 0, nil)
  AddBonus(self.ability, "RES", self.parent, self.ability:GetSpecialValueFor("special_res"), 0, nil)

  if self.ability:GetSpecialValueFor("special_purge") == 1 then
    self.parent:Purge(false, true, false, true, false)
  end

	if IsServer() then self:PlayEfxStart() end
end

function druid_2_modifier_armor:OnRefresh(kv)
  RemoveBonus(self.ability, "DEF", self.parent)
  RemoveBonus(self.ability, "RES", self.parent)
  AddBonus(self.ability, "DEF", self.parent, self.ability:GetSpecialValueFor("def"), 0, nil)
  AddBonus(self.ability, "RES", self.parent, self.ability:GetSpecialValueFor("special_res"), 0, nil)

  if self.ability:GetSpecialValueFor("special_purge") == 1 then
    self.parent:Purge(false, true, false, true, false)
  end
end

function druid_2_modifier_armor:OnRemoved()
	RemoveBonus(self.ability, "DEF", self.parent)
  RemoveBonus(self.ability, "RES", self.parent)
end

-- API FUNCTIONS -----------------------------------------------------------

function druid_2_modifier_armor:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
    MODIFIER_EVENT_ON_ATTACKED
	}

	return funcs
end

function druid_2_modifier_armor:GetModifierConstantHealthRegen()
	return self:GetParent():GetMaxHealth() * self:GetAbility():GetSpecialValueFor("regen") * 0.01
end

function druid_2_modifier_armor:OnAttacked(keys)
  if keys.attacker:IsMagicImmune() then return end
  if keys.target ~= self.parent then return end

  if RandomFloat(0, 100) < self.ability:GetSpecialValueFor("special_root_chance") then
    AddModifier(keys.attacker, self.ability, "_modifier_root", {
      duration = self.ability:GetSpecialValueFor("special_root_duration"), effect = 7
    }, true)
  end
end

-- UTILS -----------------------------------------------------------

-- EFFECTS -----------------------------------------------------------

function druid_2_modifier_armor:PlayEfxStart()
	local string = "particles/units/heroes/hero_treant/treant_livingarmor.vpcf"
	local particle = ParticleManager:CreateParticle(string, PATTACH_ABSORIGIN_FOLLOW, self.parent)
	ParticleManager:SetParticleControlEnt(particle, 1, self.parent, PATTACH_POINT_FOLLOW, "attach_origin", self.parent:GetAbsOrigin(), true)
	self:AddParticle(particle, false, false, -1, false, false)
end