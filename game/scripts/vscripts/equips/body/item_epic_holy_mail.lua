item_epic_holy_mail = class({})
LinkLuaModifier("item_epic_holy_mail_mod_passive", "equips/body/item_epic_holy_mail_mod_passive", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("item_epic_holy_mail_mod_book", "equips/body/item_epic_holy_mail_mod_book", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("item_epic_holy_mail_mod_hit", "equips/body/item_epic_holy_mail_mod_hit", LUA_MODIFIER_MOTION_NONE)

-- INIT

  function item_epic_holy_mail:Spawn()
    self.num_book = 0
    self.book = {}
  end

  function item_epic_holy_mail:GetIntrinsicModifierName()
		return "item_epic_holy_mail_mod_passive"
	end

  function item_epic_holy_mail:OnOwnerDied()
    self:DestroyBooks()
  end

  function item_epic_holy_mail:DestroyBooks()
    self.num_book = 0

    for index, book in pairs(self.book) do
      if not book:IsNull() then
        book:Kill(self, nil)
      end
    end
	end

-- SPELL START

-- EFFECTS