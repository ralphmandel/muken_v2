item_rare_cloak_evasion_mod_passive = class({})

function item_rare_cloak_evasion_mod_passive:IsHidden() return false end
function item_rare_cloak_evasion_mod_passive:IsPurgable() return false end
function item_rare_cloak_evasion_mod_passive:GetTexture() return "armor/cloak_evasion" end

-- CONSTRUCTORS -----------------------------------------------------------

function item_rare_cloak_evasion_mod_passive:OnCreated(kv)
  self.caster = self:GetCaster()
  self.parent = self:GetParent()
  self.ability = self:GetAbility()

  AddSubStats(self.parent, self.ability, {
    evasion = self.ability:GetSpecialValueFor("evasion")
  }, false)
end

function item_rare_cloak_evasion_mod_passive:OnRefresh(kv)
end

function item_rare_cloak_evasion_mod_passive:OnRemoved()
  RemoveSubStats(self.parent, self.ability, {"evasion"})
end

-- API FUNCTIONS -----------------------------------------------------------

function item_rare_cloak_evasion_mod_passive:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_ATTACK_FAIL,
    MODIFIER_EVENT_ON_PROJECTILE_DODGE
	}

	return funcs
end

function item_rare_cloak_evasion_mod_passive:OnAttackFail(keys)
  self:ApplyInvisibility(keys)
end

function item_rare_cloak_evasion_mod_passive:OnProjectileDodge(keys)
  self:ApplyInvisibility(keys)
end

-- UTILS -----------------------------------------------------------

function item_rare_cloak_evasion_mod_passive:ApplyInvisibility(keys)
  if keys.target ~= self.parent then return end
  if self.parent:HasModifier("_modifier_invisible") then return end
  if self.parent:IsMuted() then return end

  if RandomFloat(0, 100) < CalcLuck(self.parent, self.ability:GetSpecialValueFor("invi_chance")) then
    if IsServer() then self.parent:EmitSound("Hunter.Invi") end

    local invi_duration = self.ability:GetSpecialValueFor("invi_duration")
    local invi_delay = self.ability:GetSpecialValueFor("invi_delay")
  
    AddModifier(self.parent, self.ability, "_modifier_invisible", {
      delay = invi_delay, attack_break = 0, spell_break = 0, duration = invi_duration + invi_delay
    }, false)
  end
end

-- EFFECTS -----------------------------------------------------------