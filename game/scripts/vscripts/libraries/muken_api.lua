









function CDOTA_Item:GetItemRarity()
  local items_table = LoadKeyValues("scripts/npc/npc_items_custom.txt")
  return items_table[self:GetAbilityName()].ItemQuality
end

function CDOTA_Item:GetItemType()
  local items_table = LoadKeyValues("scripts/npc/npc_items_custom.txt")
  return items_table[self:GetAbilityName()].ItemType
end

function CDOTA_Buff:StartGenericEfxBlock(keys)
  local parent = self:GetParent()
  local target = keys.attacker
  local direction = (parent:GetOrigin() - target:GetOrigin()):Normalized()
  local origin = parent:GetAbsOrigin()
  --origin.z = origin.z -200

  local string = "particles/generic/block_hit/physical_block_hit.vpcf"
  if keys.damage_type == DAMAGE_TYPE_MAGICAL then
    string = "particles/generic/block_hit/magical_block_hit.vpcf"
  end

  local hit_particle = ParticleManager:CreateParticle(string, PATTACH_ABSORIGIN_FOLLOW, parent)
  ParticleManager:SetParticleControlEnt(hit_particle, 0, parent, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", origin, true)
  ParticleManager:SetParticleControlTransformForward(hit_particle, 1, parent:GetOrigin(), direction)
  ParticleManager:SetParticleControlEnt(hit_particle, 2, parent, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", origin, true)
  ParticleManager:ReleaseParticleIndex(hit_particle)

  if IsServer() then parent:EmitSound("Generic.Damage.Block") end
end

function CDOTA_BaseNPC:GetMainStat(stat)
  return self:FindModifierByName("_modifier_"..string.lower(stat))
end

function CDOTA_BaseNPC:GetLastOriginalDamage(percent)
  return self:GetMainStat("STR").original_damage * percent * 0.01
end