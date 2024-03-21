item_epic_holy_mail_mod_book = class({})

function item_epic_holy_mail_mod_book:IsHidden() return true end
function item_epic_holy_mail_mod_book:IsPurgable() return false end

-- CONSTRUCTORS -----------------------------------------------------------

function item_epic_holy_mail_mod_book:OnCreated(kv)
  self.caster = self:GetCaster()
  self.parent = self:GetParent()
  self.ability = self:GetAbility()

  if not IsServer() then return end

  self.collision_radius = self.ability:GetSpecialValueFor("collision_radius")

  self:PlayEfxStart()
  self:StartIntervalThink(0.1)
end

function item_epic_holy_mail_mod_book:OnRefresh(kv)
end

function item_epic_holy_mail_mod_book:OnRemoved()
  if not IsServer() then return end

  if self.pfx then ParticleManager:DestroyParticle(self.pfx, false) end
end

-- API FUNCTIONS -----------------------------------------------------------

function item_epic_holy_mail_mod_book:CheckState()
	local state = {
		[MODIFIER_STATE_NO_TEAM_MOVE_TO] 	= true,
		[MODIFIER_STATE_NO_TEAM_SELECT] 	= true,
		[MODIFIER_STATE_COMMAND_RESTRICTED] = true,
		[MODIFIER_STATE_ATTACK_IMMUNE] 		= true,
		[MODIFIER_STATE_MAGIC_IMMUNE] 		= true,
		[MODIFIER_STATE_INVULNERABLE] 		= true,
		[MODIFIER_STATE_UNSELECTABLE] 		= true,
		[MODIFIER_STATE_NOT_ON_MINIMAP] 	= true,
		[MODIFIER_STATE_NO_HEALTH_BAR] 		= true,
	}

	return state
end

function item_epic_holy_mail_mod_book:OnIntervalThink()
  if not IsServer() then return end

  local enemies = FindUnitsInRadius(
    self.caster:GetTeamNumber(), self.parent:GetOrigin(), nil, self.collision_radius,
    DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 
    DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false
  )

  for _,enemy in pairs(enemies) do
    if enemy:HasModifier("item_epic_holy_mail_mod_hit") == false then
      enemy:AddModifier(self.ability, "item_epic_holy_mail_mod_hit", {duration = 0.6})

      self:PlayEfxHit(enemy)

      ApplyDamage({
        attacker = self.caster, victim = enemy, ability = self.ability,
        damage = self.ability:GetSpecialValueFor("damage"),
        damage_type = self.ability:GetAbilityDamageType()
      })
    end
  end
end

-- UTILS -----------------------------------------------------------

-- EFFECTS -----------------------------------------------------------

function item_epic_holy_mail_mod_book:PlayEfxStart()
  local string = "particles/items/holy_mail/holy_mail_book.vpcf"
  self.pfx = ParticleManager:CreateParticle(string, PATTACH_ABSORIGIN_FOLLOW, self.parent)
end

function item_epic_holy_mail_mod_book:PlayEfxHit(target)
  local string = "particles/econ/items/wisp/calavera/io_calavera_attack_explosion.vpcf"
  local pfx = ParticleManager:CreateParticle(string, PATTACH_ABSORIGIN_FOLLOW, target)
  ParticleManager:SetParticleControl(pfx, 3, target:GetOrigin())

  target:EmitSound("Book.Hit")
end