-- CDOTA_PlayerResource || RESOURCES

  function CDOTA_PlayerResource:GetAllPlayers()
    local data = {}

    for _, team in pairs(TEAMS) do
      for i = 1, CUSTOM_TEAM_PLAYER_COUNT[team[1]] do
        local playerID = self:GetNthPlayerIDOnTeam(team[1], i)
        if playerID ~= nil then
          if self:HasSelectedHero(playerID) then
            local hPlayer = self:GetPlayer(playerID)
            if hPlayer ~= nil then
              table.insert(data, hPlayer)
            end
          end
        end
      end
    end

    return data
  end

-- CDOTA_Item

  function CDOTA_Item:GetItemRarity()
    local items_table = LoadKeyValues("scripts/npc/npc_items_custom.txt")
    return items_table[self:GetAbilityName()].ItemQuality
  end

  function CDOTA_Item:GetItemType()
    local items_table = LoadKeyValues("scripts/npc/npc_items_custom.txt")
    return items_table[self:GetAbilityName()].ItemType
  end

-- CDOTA_Buff || EFFECTS

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

  function CDOTA_Buff:PopupBleedDamage(damage, target)
    if damage <= 0 then return end
    local digits = 1 + #tostring(damage)

    local pidx = ParticleManager:CreateParticle("particles/bocuse/bocuse_msg.vpcf", PATTACH_OVERHEAD_FOLLOW, target)
    ParticleManager:SetParticleControl(pidx, 3, Vector(0, damage, 3))
    ParticleManager:SetParticleControl(pidx, 4, Vector(1, digits, 0))
  end

-- CDOTA_BaseNPC || RANK SYSTEM

  function CDOTA_BaseNPC:HasRank(skill_id, tier, path)
    local special_kv_modifier = self:FindModifierByName(GetHeroName(self).."_special_values")
    if special_kv_modifier == nil then return false end

    return special_kv_modifier:HasRank(skill_id, tier, path)
  end

-- CDOTA_BaseNPC || GET STATS

  function CDOTA_BaseNPC:GetMainStat(stat)
    return self:FindModifierByName("_modifier_"..string.lower(stat))
  end

  function CDOTA_BaseNPC:GetDebuffPower(amount, target)
    amount = amount * (1 + self:GetMainStat("INT"):GetDebuffAmp())
  
    if target then
      if target:GetMainStat("VIT") then
        amount = amount * (1 - target:GetMainStat("VIT"):GetStatusResist(true))
      end
    end
  
    return amount
  end
  
  function CDOTA_BaseNPC:GetSpellDamage(amount, damage_type)
    if damage_type == DAMAGE_TYPE_PHYSICAL then
      return amount * self:GetMainStat("STR"):GetPhysicalDamageAmp() * 0.01
    end
  
    if damage_type == DAMAGE_TYPE_MAGICAL then
      return amount * self:GetMainStat("INT"):GetMagicalDamageAmp() * 0.01
    end
  
    if damage_type == DAMAGE_TYPE_PURE then
      return amount * self:GetMainStat("INT"):GetHolyDamageAmp() * 0.01
    end
  
    return amount
  end

-- CDOTA_BaseNPC || STATUS PANEL

  function CDOTA_BaseNPC:GetPlayersAmount()
    if not self.worldPanel then return false end

    local data = {}
    local players = PlayerResource:GetAllPlayers()

    for _, player in pairs(players) do
      local hero_index = player:GetAssignedHero():GetEntityIndex()
      for _, wp in pairs(self.worldPanel) do
        for ent_index, amount in pairs(wp.pt.data.entities) do
          if hero_index == ent_index then
            data[hero_index] = true
          end  
        end
      end
      if not data[hero_index] then
        data[hero_index] = false
      end
    end

    return data
  end

  function CDOTA_BaseNPC:UpdatePanel(data)
    if not self.worldPanel then self.worldPanel = {} end

    data.players_amount = self:GetPlayersAmount()

    for index, panel in pairs(self.worldPanel) do
      if panel.pt.data.status_name == data.status_name then
        panel:SetData(data, self.hp_offset)
        return
      end
    end

    self:AddStatusPanelToList(data)
  end

  function CDOTA_BaseNPC:AddStatusPanelToList(data)
    if not self.worldPanel then self.worldPanel = {} end

    local offset_base = STATUS_OFFSET_HERO
    if self:IsHero() == false then offset_base = STATUS_OFFSET_CREEP end

    local panel = WorldPanels:CreateWorldPanelForAll({
      layout = "file://{resources}/layout/custom_game/worldpanels/muken_status_bar.xml",
      entity = self:GetEntityIndex(),
      entityHeight = self.hp_offset,
      offsetY = offset_base + STATUS_OFFSET_SPACING,
      offsetX = -75;
      data = data
    })

    local leng = #self.worldPanel

    while leng > 0 do
      local new_index = leng + 1
      self.worldPanel[new_index] = self.worldPanel[leng]
      self.worldPanel[new_index]:SetOffsetY(offset_base + (new_index * STATUS_OFFSET_SPACING))
      leng = leng - 1
    end

    self.worldPanel[1] = panel
  end

  function CDOTA_BaseNPC:RemovePanelFromList(status_name)
    local offset_base = STATUS_OFFSET_HERO
    if self:IsHero() == false then offset_base = STATUS_OFFSET_CREEP end

    local leng = #self.worldPanel

    for index = 1, leng, 1 do
      if self.worldPanel[index].pt.data.status_name == status_name then
        self.worldPanel[index]:Delete()
        for i = index, leng, 1 do
          if i == leng then
            self.worldPanel[i] = nil
          else
            self.worldPanel[i] = self.worldPanel[i + 1]
            self.worldPanel[i]:SetOffsetY(offset_base + (i * STATUS_OFFSET_SPACING))
          end
        end
        return
      end
    end
  end