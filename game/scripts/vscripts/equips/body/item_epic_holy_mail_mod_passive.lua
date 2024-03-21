item_epic_holy_mail_mod_passive = class({})

function item_epic_holy_mail_mod_passive:IsHidden() return false end
function item_epic_holy_mail_mod_passive:IsPurgable() return false end
function item_epic_holy_mail_mod_passive:GetTexture() return "armor/holy_mail" end

-- CONSTRUCTORS -----------------------------------------------------------

function item_epic_holy_mail_mod_passive:OnCreated(kv)
  self.caster = self:GetCaster()
  self.parent = self:GetParent()
  self.ability = self:GetAbility()

  if not IsServer() then return end

  self.start_time = GameRules:GetGameTime()
  self.radius = self.ability:GetSpecialValueFor("radius")
  self.book_turn_rate = self.ability:GetSpecialValueFor("book_turn_rate")
  self.max_book = self.ability:GetSpecialValueFor("max_book")

  self.parent:AddAbilityStats(self.ability, {"max_mana"})

  self:StartIntervalThink(0.03)
end

function item_epic_holy_mail_mod_passive:OnRefresh(kv)
end

function item_epic_holy_mail_mod_passive:OnRemoved()
  if not IsServer() then return end

  self.parent:RemoveSubStats(self.ability, {"max_mana"})
  self.ability:DestroyBooks()
end

-- API FUNCTIONS -----------------------------------------------------------

function item_epic_holy_mail_mod_passive:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE
	}

	return funcs
end

function item_epic_holy_mail_mod_passive:GetModifierIncomingDamage_Percentage(keys)
  if keys.damage_type ~= DAMAGE_TYPE_PURE then return 0 end
  if keys.damage_flags == DOTA_DAMAGE_FLAG_DONT_DISPLAY_DAMAGE_IF_SOURCE_HIDDEN + DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION then return 0 end
  
  return -self.ability:GetSpecialValueFor("holy_reduction")
end

function item_epic_holy_mail_mod_passive:OnIntervalThink()
	if not IsServer() then return end
  if self.parent:IsAlive() == false and self.parent:IsReincarnating() == false then return end

  local elapsedTime = GameRules:GetGameTime() - self.start_time
  local origin = self.parent:GetOrigin()

  while self.ability.num_book < self.max_book do
    local newBook = CreateUnitByName("npc_dota_wisp_spirit", origin, false,  self.parent,  self.parent,  self.parent:GetTeam())
    newBook:AddModifier(self.ability, "item_epic_holy_mail_mod_book", {interval = 360 / self.book_turn_rate / self.max_book})
    self.ability.num_book = self.ability.num_book + 1
    self.ability.book[self.ability.num_book] = newBook
  end
  
  local currentRotationAngle	= elapsedTime * self.book_turn_rate
  local rotationAngleOffset	= 360 / self.max_book

  for index, book in pairs(self.ability.book) do
    if not book:IsNull() then
      local rotationAngle = currentRotationAngle - rotationAngleOffset * (index - 1)
      local relPos = Vector(0, self.radius, 0)
      relPos = RotatePosition(Vector(0,0,0), QAngle(0, -rotationAngle, 0), relPos)
      local absPos = GetGroundPosition(relPos + origin, book)

      book:SetAbsOrigin(absPos)
    end
  end
end

-- UTILS -----------------------------------------------------------

-- EFFECTS -----------------------------------------------------------