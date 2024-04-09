item_epic_ruby_helm = class({})
LinkLuaModifier("item_epic_ruby_helm_mod_passive", "equips/head/item_epic_ruby_helm_mod_passive", LUA_MODIFIER_MOTION_NONE)

-- INIT

  function item_epic_ruby_helm:GetIntrinsicModifierName()
		return "item_epic_ruby_helm_mod_passive"
	end

-- SPELL START

  function item_epic_ruby_helm:CastFilterResultTarget(hTarget)
    if hTarget == self:GetCaster() then return UF_FAIL_CUSTOM end

    local result = UnitFilter(
      hTarget, DOTA_UNIT_TARGET_TEAM_FRIENDLY,
      DOTA_UNIT_TARGET_HERO,
      DOTA_UNIT_TARGET_FLAG_NONE,
      self:GetCaster():GetTeamNumber()
    )
    
    return result
  end

  function item_epic_ruby_helm:GetCustomCastErrorTarget(hTarget)
    if self:GetCaster() == hTarget then return "#dota_hud_error_cant_cast_on_self" end
  end
  
  function item_epic_ruby_helm:OnSpellStart()
    local caster = self:GetCaster()
    local target = self:GetCursorTarget()

    target:ApplyMana(self:GetSpecialValueFor("mana"), self, false, target, true)
    self:PlayEfxStart(target)
  end

  -- EFFECTS

  function item_epic_ruby_helm:PlayEfxStart(target)
    local string = "particles/items3_fx/mango_active.vpcf"
    local pfx = ParticleManager:CreateParticle(string, PATTACH_ABSORIGIN_FOLLOW, target)
    ParticleManager:SetParticleControl(pfx, 0, target:GetOrigin())
  
    target:EmitSound("DOTA_Item.Mango.Activate")
  end