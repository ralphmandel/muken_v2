"use strict";
//General.Buttonrollover
//Item.PickUpGemWorld
//Item.PickUpRingWorld

var SLOTS = {
  "head": {}, "armor": {}, "weapon": {}, "misc": {}
}

const TOOLTIPS = {
  "header": {
    "head": "Head Slot", "armor": "Armor Slot", "weapon": "Weapon Slot", "misc": "Misc Slot"
  },
  "message": {
    "head": "Any helm type equipament can be equipped on this slot.",
    "armor": "Any armor type equipament can be equipped on this slot.",
    "weapon": "Any weapon type equipament can be equipped on this slot.",
    "misc": "Any misc type equipament can be equipped on this slot."
  }
}

function OnDragStart(panelId, dragCallbacks) {
  $.Msg('Equip Start ->');

  var m_QueryUnit = Players.GetLocalPlayerPortraitUnit();
  var item = panelId.GetChild(0);
  var equip_type = panelId.GetParent().id

  if (item != null) {
    $.DispatchEvent("DOTAHideAbilityTooltip", $.GetContextPanel());
    var displayPanel = $.CreatePanel("DOTAItemImage", $.GetContextPanel(), "dragImage");
    displayPanel.SetHasClass("itemDragOn", true);
    item.SetHasClass("itemDragOff", true);

    displayPanel.style.width = "75px";
    displayPanel.style.height = "57px";
    displayPanel.itemname = item.itemname;
    displayPanel.itemrarity = item.itemrarity;
    displayPanel.itemtype = item.itemtype;

    // displayPanel.contextEntityIndex = m_Item;
    // displayPanel.m_DragItem = m_Item;
    displayPanel.m_contID = -1;
    displayPanel.m_DragCompleted = false; // whether the drag was successful
    displayPanel.m_OriginalPanel = item;
    displayPanel.m_QueryUnit = m_QueryUnit;
    displayPanel.swap_itens = false;
    displayPanel.equip_type = equip_type;
    
    // hook up the display panel, and specify the panel offset from the cursor
    dragCallbacks.displayPanel = displayPanel;
    dragCallbacks.offsetX = 0;
    dragCallbacks.offsetY = 0;
  }

  return false;
}

function OnDragEnd(newPanel, draggedPanel) {
  var m_QueryUnit = draggedPanel.m_QueryUnit;
  var itemname = draggedPanel.itemname;
  var itemtype = draggedPanel.itemtype;
  var itemname_target = draggedPanel.m_OriginalPanel.itemname;
  var itemrarity_target = draggedPanel.m_OriginalPanel.itemrarity;

  draggedPanel.m_OriginalPanel.SetHasClass("itemDragOff", false);

  if (draggedPanel.m_DragCompleted == true) {
    if (draggedPanel.swap_itens == false) {
      ChangeItem(m_QueryUnit, "0", itemtype, itemname, null);
    } else {
      ChangeItem(m_QueryUnit, itemrarity_target, itemtype, itemname, itemname_target);
    }
  }

  draggedPanel.DeleteAsync(0);
  return false;
}

function OnDragDrop(newPanel, draggedPanel) {
  $.Msg('Equip Drop -> ', newPanel.id);

  if (Game.IsGamePaused() == true) {
    Game.EmitSound("General.Item_CantMove_Slot");
    return;
  }

  var m_QueryUnit = draggedPanel.m_QueryUnit;
  var itemname = draggedPanel.itemname;
  var itemrarity = draggedPanel.itemrarity;
  var itemtype = draggedPanel.itemtype;
  var equip_type = newPanel.GetParent().id;
  
  if (newPanel.id == "item") {
    equip_type = newPanel.GetParent().GetParent().id;
  }

  var context = SLOTS[equip_type]["center"].GetChild(0);

  if (draggedPanel.equip_type == null) {
    if (itemtype != newPanel.itemtype) {
      Game.EmitSound("General.Item_CantMove_Slot");
    } else {
      Game.EmitSound("General.ButtonClickRelease");

      if (newPanel.id == "item") {
        draggedPanel.m_DragCompleted = true;
        draggedPanel.swap_itens = true;
        draggedPanel.m_OriginalPanel.itemname = newPanel.itemname;
        draggedPanel.m_OriginalPanel.itemrarity = newPanel.itemrarity;
        draggedPanel.m_OriginalPanel.itemtype = newPanel.itemtype;

        newPanel.itemname = itemname;
        newPanel.itemrarity = itemrarity;
        newPanel.itemtype = itemtype;
        
        ChangeItem(m_QueryUnit, itemrarity, itemtype, draggedPanel.m_OriginalPanel.itemname, itemname);

      } else {
        draggedPanel.m_DragCompleted = true;
        draggedPanel.m_OriginalPanel.DeleteAsync(0);

        var panel = $.CreatePanel("DOTAItemImage", context, "item");
        panel.itemname = itemname;
        panel.itemrarity = itemrarity;
        panel.itemtype = itemtype;

        ChangeItem(m_QueryUnit, itemrarity, itemtype, null, itemname);
      }
    }
  } else if (draggedPanel.equip_type != equip_type) {
    Game.EmitSound("General.Item_CantMove_Slot");
  }

	return true;
}

function OnDragEnter(newPanel, draggedPanel)
{
	//var draggedItem = draggedPanel.m_DragItem;

	return true;
}

function OnDragLeave(newPanel, draggedPanel)
{
	//var draggedItem = draggedPanel.m_DragItem;

	return true;
}

function SetupEvents(panel, header, message){
  $.RegisterEventHandler('DragStart', panel.GetChild(0), OnDragStart);
  $.RegisterEventHandler('DragEnd', panel.GetChild(0), OnDragEnd);
  $.RegisterEventHandler('DragDrop', panel.GetChild(0), OnDragDrop);
  $.RegisterEventHandler('DragEnter', panel.GetChild(0), OnDragEnter);
	$.RegisterEventHandler('DragLeave', panel.GetChild(0), OnDragLeave);

  panel.SetPanelEvent("onmouseover", function() {
    $.DispatchEvent("DOTAShowTitleTextTooltip", panel, header, message);
  })

  panel.SetPanelEvent("onmouseout", function(){
    $.DispatchEvent("DOTAHideTitleTextTooltip", panel);
  })
}

(function(){
  for (const [type, table] of Object.entries(SLOTS)) {
    SLOTS[type]["center"] = $("#" + type);
    SLOTS[type]["square"] = $("#square-" + type);
    SLOTS[type]["center"].GetChild(0).itemtype = type;
    SetupEvents(SLOTS[type]["center"], TOOLTIPS["header"][type], TOOLTIPS["message"][type]);
  }

  // SLOTS["head"]["square"].BLoadLayoutSnippet("SquareRare");
  // SLOTS["armor"]["square"].BLoadLayoutSnippet("SquareEpic");
  // SLOTS["weapon"]["square"].BLoadLayoutSnippet("SquareLegendary");
  // SLOTS["misc"]["square"].BLoadLayoutSnippet("SquareRare");
  // SLOTS["misc"]["square"].GetChild(0).DeleteAsync(0);
})()

function ChangeItem(m_QueryUnit, rarity, type, toRemove, toEquip){
  var bEquipped = !(toEquip == null);

  SLOTS[type]["center"].SetHasClass("item-equipped", bEquipped);
  SLOTS[type]["center"].SetHasClass("item-rare", rarity == 1);
  SLOTS[type]["center"].SetHasClass("item-epic", rarity == 2);
  SLOTS[type]["center"].SetHasClass("item-legendary", rarity == 3);

  for (let i = 0; i < 3; i++) {
    if (SLOTS[type]["square"].GetChild(i) != null) {
      //SLOTS[type]["square"].GetChild(i).SetHasClass("square-hidden", bEquipped == false || !(i == rarity - 1));
    }
  }

  if (toRemove != null) {
    GameEvents.SendCustomGameEventToServer("unequip_item_from_panorama", {unit: m_QueryUnit, itemname: toRemove});
  }

  if (toEquip != null) {
    GameEvents.SendCustomGameEventToServer("equip_item_from_panorama", {unit: m_QueryUnit, itemname: toEquip, type: type});
  }
}

// $.Schedule(5, () => {
//   particle.DeleteAsync(0);
// });