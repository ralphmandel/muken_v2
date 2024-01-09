









function CDOTA_Item:GetItemRarity()
  local items_table = LoadKeyValues("scripts/npc/npc_items_custom.txt")
  return items_table[self:GetAbilityName()].ItemQuality
end

function CDOTA_Item:GetItemType()
  local items_table = LoadKeyValues("scripts/npc/npc_items_custom.txt")
  return items_table[self:GetAbilityName()].ItemType
end

function CDOTA_Buff:StartGenericEfxBlock(target)
  local parent = self:GetParent()
  local string = "particles/econ/items/lanaya/ta_ti9_immortal_shoulders/ta_ti9_refract_hit.vpcf"
  local direction = (parent:GetOrigin() - target:GetOrigin()):Normalized()
  local origin = parent:GetAbsOrigin()
  --origin.z = origin.z -200

  local hit_particle = ParticleManager:CreateParticle(string, PATTACH_ABSORIGIN_FOLLOW, parent)
  ParticleManager:SetParticleControlEnt(hit_particle, 0, parent, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", origin, true)
  ParticleManager:SetParticleControlTransformForward(hit_particle, 1, parent:GetOrigin(), direction)
  ParticleManager:SetParticleControlEnt(hit_particle, 2, parent, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", origin, true)
  ParticleManager:ReleaseParticleIndex(hit_particle)

  if IsServer() then parent:EmitSound("Generic.Damage.Block") end
end