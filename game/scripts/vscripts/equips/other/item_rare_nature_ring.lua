item_rare_nature_ring = class({})
LinkLuaModifier("item_rare_nature_ring_mod_passive", "equips/other/item_rare_nature_ring_mod_passive", LUA_MODIFIER_MOTION_NONE)

-- INIT

  function item_rare_nature_ring:GetIntrinsicModifierName()
		return "item_rare_nature_ring_mod_passive"
	end

-- SPELL START

  function item_rare_nature_ring:OnSpellStart()
    local caster = self:GetCaster()
    local tree = self:GetCursorTarget()

    caster:ApplyHeal(self:GetSpecialValueFor("heal"), self, false)

    tree:CutDownRegrowAfter(300, caster:GetTeamNumber())
  end
  
-- EFFECTS