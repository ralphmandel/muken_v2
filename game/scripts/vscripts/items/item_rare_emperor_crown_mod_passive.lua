item_rare_emperor_crown_mod_passive = class({})

function item_rare_emperor_crown_mod_passive:IsHidden()
    return false
end

function item_rare_emperor_crown_mod_passive:IsPurgable()
    return false
end

---------------------------------------------------------------------------------------------------

function item_rare_emperor_crown_mod_passive:OnCreated( kv )
	self.caster = self:GetCaster()
	self.parent = self:GetParent()
	self.ability = self:GetAbility()
end

function item_rare_emperor_crown_mod_passive:OnRefresh( kv )
end

function item_rare_emperor_crown_mod_passive:OnRemoved( kv )
end