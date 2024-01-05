









function CDOTA_Item:GetItemRarity()
  local items_table = LoadKeyValues("scripts/npc/npc_items_custom.txt")
  return items_table[self:GetAbilityName()].ItemQuality
end

function CDOTA_Item:GetItemType()
  local items_table = LoadKeyValues("scripts/npc/npc_items_custom.txt")
  return items_table[self:GetAbilityName()].ItemType
end