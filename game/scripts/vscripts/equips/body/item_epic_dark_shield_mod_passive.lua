item_epic_dark_shield_mod_passive = class({})

function item_epic_dark_shield_mod_passive:IsHidden() return false end
function item_epic_dark_shield_mod_passive:IsPurgable() return false end
function item_epic_dark_shield_mod_passive:GetTexture() return "shield/dark_shield" end

-- CONSTRUCTORS -----------------------------------------------------------

function item_epic_dark_shield_mod_passive:OnCreated(kv)
  self.caster = self:GetCaster()
  self.parent = self:GetParent()
  self.ability = self:GetAbility()

  AddSubStats(self.parent, self.ability, {
    magical_block = self.ability:GetSpecialValueFor("magical_block"),
  }, false)
end

function item_epic_dark_shield_mod_passive:OnRefresh(kv)
end

function item_epic_dark_shield_mod_passive:OnRemoved()
  RemoveSubStats(self.parent, self.ability, {"magical_block"})
end

-- API FUNCTIONS -----------------------------------------------------------

function item_epic_dark_shield_mod_passive:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_ABSORB_SPELL
	}

	return funcs
end

function item_epic_dark_shield_mod_passive:GetAbsorbSpell(keys)
  if RandomFloat(0, 100) < self.ability:GetSpecialValueFor("chance") then
    if IsServer() then self:PlayEfxSpellBlock() end
    return 1
  end

  return 0
end


-- UTILS -----------------------------------------------------------

-- EFFECTS -----------------------------------------------------------

function item_epic_dark_shield_mod_passive:PlayEfxSpellBlock()
	local particle_cast = "particles/units/heroes/hero_antimage/antimage_spellshield_reflect.vpcf"
	local effect_cast = ParticleManager:CreateParticle(particle_cast, PATTACH_POINT_FOLLOW, self.parent)
	ParticleManager:SetParticleControlEnt(effect_cast, 0, self.parent, PATTACH_POINT_FOLLOW, "attach_hitloc", Vector(0,0,0), true)
	ParticleManager:ReleaseParticleIndex(effect_cast)

	if IsServer() then self.parent:EmitSound("DOTA_Item.LinkensSphere.Activate") end
end