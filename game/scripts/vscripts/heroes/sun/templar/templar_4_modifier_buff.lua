templar_4_modifier_buff = class({})

function templar_4_modifier_buff:IsHidden() return false end
function templar_4_modifier_buff:IsPurgable() return true end

-- CONSTRUCTORS -----------------------------------------------------------

function templar_4_modifier_buff:OnCreated(kv)
  self.caster = self:GetCaster()
  self.parent = self:GetParent()
  self.ability = self:GetAbility()

  if IsServer() then
    self:SetStackCount(self.ability:GetSpecialValueFor("stack"))
    self:PlayEfxStart()
  end
end

function templar_4_modifier_buff:OnRefresh(kv)
  if IsServer() then
    self:SetStackCount(self.ability:GetSpecialValueFor("stack"))
    self:PlayEfxStart()
  end
end

function templar_4_modifier_buff:OnRemoved()
end

-- API FUNCTIONS -----------------------------------------------------------

function templar_4_modifier_buff:DeclareFunctions()
	local funcs = {
    MODIFIER_EVENT_ON_TAKEDAMAGE
	}

	return funcs
end

function templar_4_modifier_buff:OnTakeDamage(keys)
  if keys.unit ~= self.parent then return end
  if keys.attacker == nil then return end
  if keys.attacker:IsBaseNPC() == false then return end

  if RandomFloat(0, 100) < self.ability:GetSpecialValueFor("chance") then
    AddModifier(keys.attacker, self.ability, "templar_4_modifier_revenge", {duration = 5}, false)
    if IsServer() then self:DecrementStackCount() end
  end
end

function templar_4_modifier_buff:OnStackCountChanged(old)
  if self:GetStackCount() == 0 and self:GetStackCount() ~= old then self:Destroy() end
end

-- UTILS -----------------------------------------------------------

-- EFFECTS -----------------------------------------------------------

function templar_4_modifier_buff:PlayEfxStart()
	local particle = "particles/econ/items/pugna/pugna_ward_golden_nether_lord/pugna_gold_ambient.vpcf"
	local effect_caster = ParticleManager:CreateParticle(particle, PATTACH_ABSORIGIN_FOLLOW, self.parent)
	ParticleManager:SetParticleControl(effect_caster, 0, self.parent:GetOrigin())
	ParticleManager:SetParticleControl(effect_caster, 1, self.parent:GetOrigin())
	ParticleManager:SetParticleControl(effect_caster, 2, self.parent:GetOrigin())
	ParticleManager:SetParticleControl(effect_caster, 4, self.parent:GetOrigin())
	self:AddParticle(effect_caster, false, false, -1, false, false)

  if IsServer() then
    self.parent:EmitSound("Ancient.Aura.Cast")
    self.parent:EmitSound("Ancient.Aura.Effect")
  end
end