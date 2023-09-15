item_rare_killer_dagger_mod_passive = class({})

function item_rare_killer_dagger_mod_passive:IsHidden()
    return true
end

function item_rare_killer_dagger_mod_passive:IsPurgable()
    return false
end

---------------------------------------------------------------------------------------------------

function item_rare_killer_dagger_mod_passive:OnCreated( kv )
	self.caster = self:GetCaster()
	self.parent = self:GetParent()
	self.ability = self:GetAbility()

	local passive_lck = self.ability:GetSpecialValueFor("passive_lck")
	local passive_str = self.ability:GetSpecialValueFor("passive_str")
	self.passive_agi = self.ability:GetSpecialValueFor("passive_agi")
	self.chance = self.ability:GetSpecialValueFor("chance")
	self.hits = 0

	AddBonus(self.ability, "LCK", self.parent, passive_lck, 0, nil)
	AddBonus(self.ability, "STR", self.parent, passive_str, 0, nil)
	AddBonus(self.ability, "AGI", self.parent, self.passive_agi, 0, nil)

	self.aspd = self.ability:GetSpecialValueFor("aspd")
end

function item_rare_killer_dagger_mod_passive:OnRefresh( kv )
end

function item_rare_killer_dagger_mod_passive:OnRemoved( kv )
	RemoveBonus(self.ability, "LCK", self.parent)
	RemoveBonus(self.ability, "STR", self.parent)
	RemoveBonus(self.ability, "AGI", self.parent)
end

-----------------------------------------------------------------------------

function item_rare_killer_dagger_mod_passive:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_ATTACK
	}
	
	return funcs
end

function item_rare_killer_dagger_mod_passive:OnAttack(keys)
	if keys.attacker ~= self.parent then return end
	if keys.target:GetTeamNumber() == self.parent:GetTeamNumber() then return end

	local ancient_mod = self.parent:FindModifierByName("ancient_1_modifier_passive")
	if ancient_mod then
		-- if RandomFloat(0, 100) < self.chance then
		-- 	ancient_mod:SetMultipleHits(2)
		-- end
		return
	end

	if self.hits > 0 then
		self.hits = self.hits - 1
	end
	
	if self.hits < 1 then
		RemoveBonus(self.ability, "AGI", self.parent)
		AddBonus(self.ability, "AGI", self.parent, self.passive_agi, 0, nil)
		self:StartIntervalThink(-1)
		self:StartIntervalThink(2)
	end

	if RandomFloat(0, 100) < self.chance then
		RemoveBonus(self.ability, "AGI", self.parent)
		AddBonus(self.ability, "AGI", self.parent, 999, 0, nil)
		self.hits = 1
	end
end

function item_rare_killer_dagger_mod_passive:OnIntervalThink()
	if self.hits > 0 then self.hits = 0 end
	self:StartIntervalThink(-1)
end