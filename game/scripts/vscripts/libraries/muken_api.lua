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

-- CDOTAPlayerController || FORGE/ITENS

  function CDOTAPlayerController:ToggleForgeTower(ent_index)
    if self.ForgeWorldPanel == nil then
      self:CreateForgePanel(ent_index)
    else
      if self.ForgeWorldPanel.pt.entity == ent_index then
        self.ForgeWorldPanel:Delete()
        self.ForgeWorldPanel = nil
      else
        self.ForgeWorldPanel:Delete()
        self:CreateForgePanel(ent_index)
      end
    end
  end

  function CDOTAPlayerController:CreateForgePanel(ent_index)
    self.ForgeWorldPanel = WorldPanels:CreateWorldPanelForAll({
      layout = "file://{resources}/layout/custom_game/muken_forge.xml",
      entity = ent_index,
      entityHeight = 200,
      offsetY = 100,
      offsetX = 0,
      horizontalAlign = "center",
      data = {}
    })
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
    if target == nil then return end
    if IsValidEntity(target) == false then return end

    damage = math.floor(damage)

    if damage <= 0 then return end
    local digits = 1 + #tostring(damage)

    local pidx = ParticleManager:CreateParticle("particles/bocuse/bocuse_msg.vpcf", PATTACH_OVERHEAD_FOLLOW, target)
    ParticleManager:SetParticleControl(pidx, 3, Vector(0, damage, 3))
    ParticleManager:SetParticleControl(pidx, 4, Vector(1, digits, 0))
  end

  function CDOTA_Buff:PopupColdDamage(damage, target)
    if target == nil then return end
    if IsValidEntity(target) == false then return end

    SendOverheadEventMessage(nil, OVERHEAD_ALERT_BONUS_SPELL_DAMAGE, target, damage, target)
  end

-- CDOTA_BaseNPC_Hero

  function CDOTA_BaseNPC_Hero:GetBaseHeroAbility()
    return self:FindAbilityByName("base_hero")
  end

  function CDOTA_BaseNPC_Hero:GetBaseHeroModifier()
    return self:FindModifierByName("base_hero_mod")
  end

  function CDOTA_BaseNPC_Hero:HasRank(skill_id, tier, path)
    local special_kv_modifier = self:FindModifierByName(self:GetHeroName().."_special_values")
    if special_kv_modifier == nil then return false end

    return special_kv_modifier:HasRank(skill_id, tier, path)
  end

-- CDOTA_BaseNPC || GET STATS

  function CDOTA_BaseNPC:GetHeroName()
    local data = LoadKeyValues("scripts/kv/heroes_name.kv")

    if self:GetUnitName() == "strider_shadow" then return "strider" end

    for name, id_name in pairs(data) do
      if self:GetUnitName() == id_name then return name end
    end

    return ""
  end

  function CDOTA_BaseNPC:GetHeroTeam()
    local data = LoadKeyValues("scripts/kv/heroes_team.kv")

    for team, hero_list in pairs(data) do
      for _,hero_name in pairs(hero_list) do
        if self:GetHeroName() == hero_name then
          return team
        end
      end
    end
  end

  function CDOTA_BaseNPC:GetMainStat(stat)
    return self:FindModifierByName("_modifier_"..string.lower(stat))
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

  function CDOTA_BaseNPC:GetSummonPower(amount)
    local result = amount * self:GetMainStat("INT"):GetSummonPower()
    if result < 0 then result = 0 end

    return result
  end

  function CDOTA_BaseNPC:GetBuffPower(amount)
    return amount * (1 + self:GetMainStat("VIT"):GetIncomingBuff())
  end

  function CDOTA_BaseNPC:GetHealPower(amount)
    return amount * (1 + self:GetMainStat("INT"):GetHealPower())
  end

  function CDOTA_BaseNPC:GetDebuffPower(amount, target)
    amount = amount * (1 + self:GetMainStat("INT"):GetDebuffAmp())
    if target then amount = target:GetStatusResist(amount) end
  
    return amount
  end

  function CDOTA_BaseNPC:GetStatusResist(amount)
    if self:GetMainStat("VIT") == nil then return amount end

    return amount * (1 - self:GetMainStat("VIT"):GetStatusResist(true))
  end

  function CDOTA_BaseNPC:IncrementStatus(status_name, ability, inflictor, amount)
    if amount <= 0 then return end
    
    self:AddModifier(ability, status_name, {inflictor = inflictor:entindex(), status_amount = amount})
  end

  function CDOTA_BaseNPC:GetResistance(type)
    if self:GetMainStat("STR") == nil or self:GetMainStat("AGI") == nil
    or self:GetMainStat("INT") == nil or self:GetMainStat("VIT") == nil then
      return 100
    end

    local name = string.sub(type, 12, string.len(type))
    
    if name == "stone" then
      return 100 + self:GetMainStat("STR"):GetStoneResist()
    end

    if name == "poison" then
      return 100 + self:GetMainStat("AGI"):GetPoisonResist()
    end

    if name == "cold" then
      return 100 + self:GetMainStat("INT"):GetColdResist()
    end

    if name == "curse" then
      return 100 + self:GetMainStat("VIT"):GetCurseResist()
    end

    if name == "bleed" then
      return 100 + ((self:GetMainStat("STR"):GetBleedResist() + self:GetMainStat("AGI"):GetBleedResist()) / 2)
    end

    if name == "thunder" then
      return 100 + ((self:GetMainStat("AGI"):GetThunderResist() + self:GetMainStat("INT"):GetThunderResist()) / 2)
    end

    if name == "sleep" then
      return 100 + ((self:GetMainStat("INT"):GetSleepResist() + self:GetMainStat("STR"):GetSleepResist()) / 2)
    end

    return 100
  end

  function CDOTA_BaseNPC:GetLuck(amount)
    local result = amount * (1 + self:GetMainStat("INT"):GetLuck())
    if result < 0 then result = 0 elseif result > 100 then result = 100 end

    return result
  end

-- CDOTA_BaseNPC || ADD MODIFIERS/STATS

  function CDOTA_BaseNPC:AddMainStats(ability, table)
    return self:AddModifier(ability, "main_stat_modifier", table)
  end

  function CDOTA_BaseNPC:AddSubStats(ability, table)
    return self:AddModifier(ability, "sub_stat_modifier", table)
  end

  function CDOTA_BaseNPC:RemoveMainStats(ability, list)
    if IsValidEntity(self) == false then return end

    local mod = self:FindAllModifiersByName("main_stat_modifier")
    for _,modifier in pairs(mod) do
      local bPass = true

      for _, stat in pairs(list) do
        if modifier.kv[stat] == nil then
          bPass = false
        end
      end

      if bPass == true and (modifier:GetAbility() == ability or ability == nil) then
        modifier:Destroy()
      end
    end
  end

  function CDOTA_BaseNPC:RemoveSubStats(ability, list)
    if IsValidEntity(self) == false then return end

    local mod = self:FindAllModifiersByName("sub_stat_modifier")
    for _,modifier in pairs(mod) do
      local bPass = true

      for _, sub_stat in pairs(list) do
        if modifier.kv[sub_stat] == nil then
          bPass = false
        end
      end

      if bPass == true and (modifier:GetAbility() == ability or ability == nil) then
        modifier:Destroy()
      end
    end
  end

  function CDOTA_BaseNPC:AddModifier(ability, modifier_name, table)
    local caster = ability:GetCaster()

    if self:HasModifier("status_bar_cold_max") then
      if modifier_name == "status_bar_cold" then return end
    end

    if self:HasModifier("status_bar_curse_max") then
      if modifier_name == "status_bar_curse" then return end
    end

    if modifier_name == "modifier_knockback" then ability = nil end

    if table.duration then
      if table.bResist then
        if self:GetTeamNumber() == caster:GetTeamNumber() then
          table.duration = self:GetBuffPower(table.duration)
        else
          table.duration = self:GetStatusResist(table.duration)
        end
      end

      if table.duration <= 0 then return end
    end

    return self:AddNewModifier(caster, ability, modifier_name, table)
  end

  function CDOTA_BaseNPC:RemoveAllModifiersByNameAndAbility(name, ability)
    local mod = self:FindAllModifiersByName(name)
    for _,modifier in pairs(mod) do
      if modifier:GetAbility() == ability or ability == nil then
        modifier:Destroy()
      end
    end
  end

  function CDOTA_BaseNPC:AddModToList(modifier)
    if not self.modifiers_list then self.modifiers_list = {} end

    table.insert(self.modifiers_list, modifier)
  end

  function CDOTA_BaseNPC:RemoveModFromList(modifier)
    for i = 1, #self.modifiers_list, 1 do
      if modifier == self.modifiers_list[i] then
        table.remove(self.modifiers_list, i)
        return
      end
    end
  end

  function CDOTA_BaseNPC:GetModList()
    if not self.modifiers_list then self.modifiers_list = {} end
    return self.modifiers_list
  end

-- CDOTA_BaseNPC || PERFORMS

  function CDOTA_BaseNPC:ApplyHeal(amount, ability, bAmplify)
    if bAmplify and ability then
      local caster = ability:GetCaster()
      if caster then
        if IsValidEntity(caster) then
          amount = caster:GetHealPower(amount)
        end
      end
    end

    self:Heal(amount, ability)
    return amount
  end

  function CDOTA_BaseNPC:ApplyMana(amount, ability, bAmplify, target, bMessage)
    if ability == nil then return 0 end
    local caster = ability:GetCaster()

    if target then
      if bAmplify then
        amount = caster:GetDebuffPower(amount, target)
      end

      if amount > target:GetMana() then
        amount = target:GetMana()
      end
      if amount > 0 then
        target:Script_ReduceMana(amount, ability)
        if bMessage then SendOverheadEventMessage(nil, OVERHEAD_ALERT_MANA_LOSS, target, amount, nil) end
      else
        return 0
      end
    else
      if bAmplify then
        if ability:GetCaster():GetTeamNumber() == self:GetTeamNumber() then
          amount = caster:GetHealPower(amount)
        else
          amount = caster:GetDebuffPower(amount, self)
        end
      end
    end

    if self:GetMaxMana() == 0 then return 0 end

    if amount > 0 then
      self:GiveMana(amount)
      if bMessage then SendOverheadEventMessage(nil, OVERHEAD_ALERT_MANA_ADD, self, amount, nil) end
    elseif amount < 0 then
      self:Script_ReduceMana(amount, ability)
      if bMessage then SendOverheadEventMessage(nil, OVERHEAD_ALERT_MANA_LOSS, self, amount, nil) end
    end

    return amount
  end

  function CDOTA_BaseNPC:ReduceStatus(amount, list)
    if amount <= 0 then return end
    
    for _,status_name in pairs(list) do
      local modifier = self:FindModifierByName(status_name)
      if modifier then
        if modifier.bCompleted == nil then
          modifier:ReduceAmount(amount)
        end
      end
    end
  end

  function CDOTA_BaseNPC:SetBloodIllusion(ent, bRemove)
    if not self.blood_illusion then self.blood_illusion = {} end
    if not self.blood_efx then self.blood_efx = {} end

    local ent_index = ent:GetEntityIndex()

    if bRemove then
      self.blood_illusion[ent_index] = nil
    else
      self.blood_illusion[ent_index] = ent
    end

    if self.blood_illusion[ent_index] then
      local string = "particles/bloodstained/bloodstained_u_track1.vpcf"
      self.blood_efx[ent_index] = ParticleManager:CreateParticle(string, PATTACH_ABSORIGIN_FOLLOW, self)
      ParticleManager:SetParticleControlEnt(self.blood_efx[ent_index], 3, self, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", self:GetAbsOrigin(), true)
      self.parent:EmitSound("Hero_LifeStealer.OpenWounds")
    else
      if self.blood_efx[ent_index] then
        ParticleManager:DestroyParticle(self.blood_efx[ent_index], true)
        self.blood_efx[ent_index] = nil
      end
    end
  end

  function CDOTA_BaseNPC:GetBloodIllusions()
    if not self.blood_illusion then self.blood_illusion = {} end

    for _,illusion in pairs(self.blood_illusion) do
      return self.blood_illusion
    end

    return nil
  end

  function CDOTA_BaseNPC:GetCriticalDamage()
    return self:GetMainStat("STR"):GetCriticalDamage()
  end

  function CDOTA_BaseNPC:SetForceCrit(chance, damage)
    self:GetMainStat("STR"):SetForceCrit(chance, damage)
  end

  function CDOTA_BaseNPC:SetForceSpellCrit(damage)
    if damage <= 100 then return end
    self:GetMainStat("INT"):SetForceSpellCrit(damage - 100)
  end

-- CDOTA_BaseNPC || COSMETICS

  function CDOTA_BaseNPC:GetBaseCosmetic()
    return self:FindAbilityByName("cosmetics")
  end

  function CDOTA_BaseNPC:AddStatusEfx(caster, ability, string)
    if self:GetBaseCosmetic() then self:GetBaseCosmetic():SetStatusEffect(caster, ability, string, true) end
  end

  function CDOTA_BaseNPC:RemoveStatusEfx(caster, ability, string)
    if self:GetBaseCosmetic() then self:GetBaseCosmetic():SetStatusEffect(caster, ability, string, false) end
  end

  function CDOTA_BaseNPC:SetModifierOnAllCosmetics(ability, modifier_name, table, bEnabled)      
    if self:GetBaseCosmetic() == nil then return end

    if bEnabled == true then
      self:AddNewModifier(self, ability, modifier_name, table)

      for i = 1, #self:GetBaseCosmetic().cosmetic, 1 do
        self:GetBaseCosmetic().cosmetic[i]:AddNewModifier(self, ability, modifier_name, table)
      end
    else
      self:RemoveAllModifiersByNameAndAbility(modifier_name, ability)

      for i = 1, #self:GetBaseCosmetic().cosmetic, 1 do
        self:GetBaseCosmetic().cosmetic[i]:RemoveAllModifiersByNameAndAbility(modifier_name, ability)
      end
    end
  end

-- CDOTA_BaseNPC || STATUS PANEL

  function CDOTA_BaseNPC:GetPlayersAmount()
    if not self.worldPanel then return false end

    local data = {}
    local players = PlayerResource:GetAllPlayers()

    for _, player in pairs(players) do
      local hero_index = player:GetAssignedHero():GetEntityIndex()
      for _, wp in pairs(self.worldPanel) do
        if wp.pt.data.max_state == 1 then
          data[hero_index] = true
        elseif wp.pt.data.entities ~= nil then
          for ent_index, amount in pairs(wp.pt.data.entities) do
            if hero_index == ent_index then
              data[hero_index] = true
            end  
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
      offsetX = -75,
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