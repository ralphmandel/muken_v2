bocuse_3_modifier_sauce = class({})

function bocuse_3_modifier_sauce:IsHidden() return false end
function bocuse_3_modifier_sauce:IsPurgable() return true end

-- CONSTRUCTORS -----------------------------------------------------------

function bocuse_3_modifier_sauce:OnCreated(kv)
  self.caster = self:GetCaster()
	self.parent = self:GetParent()
  self.ability = self:GetAbility()

	if IsServer() then
		self:SetStackCount(1)
		self:CheckCounterEfx()
		self:PlayEfxStart()
    self:StartIntervalThink(self:GetDuration() * 0.2)
	end
end

function bocuse_3_modifier_sauce:OnRefresh(kv)
  if IsServer() then
    self:IncrementStackCount()
    self:StartIntervalThink(self:GetDuration() * 0.2)
	end
end

function bocuse_3_modifier_sauce:OnRemoved()
	if self.pidx then ParticleManager:DestroyParticle(self.pidx, true) end
	self:CheckCounterEfx()

  RemoveBonus(self.ability, "DEX", self.parent)
  RemoveAllModifiersByNameAndAbility(self.parent, "_modifier_percent_movespeed_debuff", self.ability)
  RemoveAllModifiersByNameAndAbility(self.parent, "_modifier_break", self.ability)
  RemoveAllModifiersByNameAndAbility(self.parent, "_modifier_disarm", self.ability)
  RemoveAllModifiersByNameAndAbility(self.parent, "_modifier_silence", self.ability)
end

-- API FUNCTIONS -----------------------------------------------------------

function bocuse_3_modifier_sauce:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
		MODIFIER_EVENT_ON_TAKEDAMAGE
	}

	return funcs
end

function bocuse_3_modifier_sauce:GetModifierIncomingDamage_Percentage(keys)
  if keys.attacker:GetTeamNumber() == self.caster:GetTeamNumber() then
    return self:GetAbility():GetSpecialValueFor("damage_amp_stack") * self:GetStackCount()
  end

  return 0
end

function bocuse_3_modifier_sauce:OnTakeDamage(keys)
	if keys.unit ~= self.parent then return end
  if keys.attacker == nil then return end
  if keys.attacker:IsBaseNPC() == false then return end
  if keys.attacker:GetTeamNumber() ~= self.caster:GetTeamNumber() then return end

	local heal_amount = keys.damage * self.ability:GetSpecialValueFor("lifesteal") * 0.01
	keys.attacker:Heal(heal_amount, self.ability)
	self:PlayEfxLifesteal(keys.attacker)
end

function bocuse_3_modifier_sauce:OnStackCountChanged(old)
	if self:GetStackCount() ~= old then
		self:ModifySauce(self:GetStackCount())
		self.chance = 0
	end	
end

-- UTILS -----------------------------------------------------------

function bocuse_3_modifier_sauce:ModifySauce(stack_count)
	local slow_stack = self.ability:GetSpecialValueFor("special_slow_stack")
	local slow_duration = self.ability:GetSpecialValueFor("special_slow_duration")
	if stack_count > 0 then self:PopupSauce(true) end

  RemoveAllModifiersByNameAndAbility(self.parent, "_modifier_percent_movespeed_debuff", self.ability)

  if slow_stack > 0 then
    AddModifier(self.parent, self.ability, "_modifier_percent_movespeed_debuff", {
      percent = slow_stack * stack_count
    }, false)
  end

  if slow_duration > 0 then
    AddModifier(self.parent, self.ability, "_modifier_percent_movespeed_debuff", {
      duration = slow_duration, percent = 100
    }, true)
  end

	if stack_count == self.ability:GetSpecialValueFor("max_stack") then
    if self.ability:GetSpecialValueFor("special_dex") < 0 then
      AddBonus(self.ability, "DEX", self.parent, self.ability:GetSpecialValueFor("special_dex"), 0, self:GetRemainingTime())
		end

    if self.ability:GetSpecialValueFor("special_break") == 1 then
      AddModifier(self.parent, self.ability, "_modifier_break", {
        duration = self:GetRemainingTime()
      }, false)
		end

		if self.ability:GetSpecialValueFor("special_silence") == 1 then
      AddModifier(self.parent, self.ability, "_modifier_silence", {
        duration = self:GetRemainingTime(), special = 2
      }, false)
		end

    if self.ability:GetSpecialValueFor("special_disarm") == 1 then
      AddModifier(self.parent, self.ability, "_modifier_disarm", {
        duration = self:GetRemainingTime()
      }, false)
		end
	end
end

-- EFFECTS -----------------------------------------------------------

function bocuse_3_modifier_sauce:PlayEfxStart()
	local particle_cast_1 = "particles/econ/items/bloodseeker/bloodseeker_eztzhok_weapon/bloodseeker_bloodrage_ground_eztzhok.vpcf"
	local effect_cast_1 = ParticleManager:CreateParticle( particle_cast_1, PATTACH_ABSORIGIN_FOLLOW, self.parent )
	ParticleManager:SetParticleControlEnt(effect_cast_1, 1, self.parent, PATTACH_ABSORIGIN_FOLLOW, "", Vector(0,0,0), true)
  self:AddParticle(effect_cast_1, false, false, -1, false, false)
end

function bocuse_3_modifier_sauce:CheckCounterEfx()
	local mod = self.parent:FindModifierByName("icebreaker__modifier_hypo")
	if mod then
		if IsServer() then mod:PopupIce(false) end
	end
end

function bocuse_3_modifier_sauce:PopupSauce(sound)
	if self.pidx then ParticleManager:DestroyParticle(self.pidx, true) end

	local particle = "particles/bocuse/bocuse_3_counter.vpcf"
	if self.parent:HasModifier("icebreaker__modifier_hypo") then particle = "particles/bocuse/bocuse_3_double_counter.vpcf" end
	self.pidx = ParticleManager:CreateParticle(particle, PATTACH_OVERHEAD_FOLLOW, self.parent)
	ParticleManager:SetParticleControl(self.pidx, 2, Vector(self:GetStackCount(), 0, 0))
	
	if sound == true then
		if IsServer() then self.parent:EmitSound("") end
	end
end

function bocuse_3_modifier_sauce:PlayEfxLifesteal(attacker)
	local particle_cast = "particles/bocuse/sauce/bocuse_sauce_heal.vpcf"
	local effect_cast = ParticleManager:CreateParticle(particle_cast, PATTACH_ABSORIGIN_FOLLOW, attacker)
	ParticleManager:SetParticleControl(effect_cast, 1, attacker:GetOrigin())
	ParticleManager:ReleaseParticleIndex(effect_cast)
end