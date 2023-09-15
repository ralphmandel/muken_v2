dasdingo_2_modifier_aura_effect = class({})

function dasdingo_2_modifier_aura_effect:IsHidden()
	return false
end

function dasdingo_2_modifier_aura_effect:IsPurgable()
	return false
end

-----------------------------------------------------------

function dasdingo_2_modifier_aura_effect:OnCreated(kv)
    self.caster = self:GetCaster()
    self.parent = self:GetParent()
    self.ability = self:GetAbility()

	local defense = self.ability:GetSpecialValueFor("defense")
	local special = 0

	-- UP 2.31
	if self.ability:GetRank(31) then
		defense = defense + 5
	end

	AddBonus(self.ability, "_2_DEF", self.parent, defense, 0, nil)
	self:PlayEfxStart()
end

function dasdingo_2_modifier_aura_effect:OnRefresh(kv)
end

function dasdingo_2_modifier_aura_effect:OnRemoved(kv)
	RemoveBonus(self.ability, "_2_DEF", self.parent)
end

------------------------------------------------------------

function dasdingo_2_modifier_aura_effect:DeclareFunctions()

    local funcs = {
    MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS
    }
    return funcs
end

function dasdingo_2_modifier_aura_effect:GetModifierIncomingDamage_Percentage(keys)
	if keys.attacker == nil then return 0 end
	if keys.attacker:IsBaseNPC() == false then return 0 end

	-- UP 2.11
	if self.ability:GetRank(11) then
		if keys.damage_flags ~= DOTA_DAMAGE_FLAG_REFLECTION then
			local damageTable = {
				victim = keys.attacker,
				attacker = self.parent,
				damage = keys.original_damage * 0.15,
				damage_type = keys.damage_type,
				ability = self.ability,
				damage_flags = DOTA_DAMAGE_FLAG_REFLECTION,
			}
			ApplyDamage(damageTable)
		end
	end

  return 0
end

-----------------------------------------------------------

function dasdingo_2_modifier_aura_effect:PlayEfxStart()
	local special = ((self.ability:GetLevel() - 1) * 12) + 8
	local string = "particles/dasdingo/dasdingo_aura.vpcf"
	local effect_cast = ParticleManager:CreateParticle(string, PATTACH_ABSORIGIN_FOLLOW, self.parent)
	ParticleManager:SetParticleControlEnt(effect_cast, 1, self.parent, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", Vector(0,0,0), true)
	ParticleManager:SetParticleControl(effect_cast, 3, Vector(special, 0, 0 ))

	self:AddParticle(effect_cast, false, false, -1, false, false)

	if IsServer() then self.parent:EmitSound("Hero_Pangolier.TailThump.Cast") end
end