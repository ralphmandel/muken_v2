"use strict"

var ROWS = {};
const MAX_ROWS = 5;

function OnDragStart(panelId, dragCallbacks) {
  $.Msg('Slot Start ->');

  var m_QueryUnit = Players.GetLocalPlayerPortraitUnit();
  var item = panelId.GetChild(0);
  var row = panelId.GetParent().id;
  var slot = panelId.id;

  if (item != null) {
    $.DispatchEvent("DOTAHideAbilityTooltip", $.GetContextPanel());
    var displayPanel = $.CreatePanel("DOTAItemImage", $.GetContextPanel(), "dragImage");
    displayPanel.SetHasClass("itemDragOn", true);
    item.SetHasClass("itemDragOff", true);

    displayPanel.style.width = "59px";
    displayPanel.style.height = "45px";
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
    displayPanel.row = row;
    displayPanel.slot = slot;
    
    // hook up the display panel, and specify the panel offset from the cursor
    dragCallbacks.displayPanel = displayPanel;
    dragCallbacks.offsetX = 0;
    dragCallbacks.offsetY = 0;
  }

  return false;
}

function OnDragEnd(newPanel, draggedPanel) {
  draggedPanel.m_OriginalPanel.SetHasClass("itemDragOff", false);
  draggedPanel.DeleteAsync(0);
  return false;
}

function OnDragDrop(newPanel, draggedPanel) {
  $.Msg('Slot Drop ->', newPanel.itemname, draggedPanel.itemname);

  if (Game.IsGamePaused() == true) {
    Game.EmitSound("General.Item_CantMove_Slot");
    return;
  }
  
  var m_QueryUnit = draggedPanel.m_QueryUnit;
  var itemname = draggedPanel.itemname;
  var itemrarity = draggedPanel.itemrarity;
  var itemtype = draggedPanel.itemtype;
  var row = newPanel.GetParent().id;
  var slot = newPanel.id;

  if (newPanel.id == "item") {
    row = newPanel.GetParent().GetParent().id;
    slot = newPanel.GetParent().id;
  }

  var slot_index = parseInt(slot.substr(slot.length - 1));
  var context = ROWS[row].GetChild(slot_index);

  if (draggedPanel.row != row || draggedPanel.slot != slot) {
    if (newPanel.id == "item") {
      if (draggedPanel.equip_type != null && itemtype != newPanel.itemtype) {
        Game.EmitSound("General.Item_CantMove_Slot");
      } else {
        Game.EmitSound("General.ButtonClickRelease");

        draggedPanel.m_DragCompleted = true;
        draggedPanel.swap_itens = true;
        draggedPanel.m_OriginalPanel.itemname = newPanel.itemname;
        draggedPanel.m_OriginalPanel.itemrarity = newPanel.itemrarity;
        draggedPanel.m_OriginalPanel.itemtype = newPanel.itemtype;
  
        newPanel.itemname = itemname;
        newPanel.itemrarity = itemrarity;
        newPanel.itemtype = itemtype;
      }
    } else {
      Game.EmitSound("General.ButtonClickRelease");

      draggedPanel.m_DragCompleted = true;
      draggedPanel.m_OriginalPanel.DeleteAsync(0);
      var panel = $.CreatePanel("DOTAItemImage", context, "item");
      panel.itemname = itemname;
      panel.itemrarity = itemrarity;
      panel.itemtype = itemtype;
    }
  }

	return true;
}

function OnDragEnter(newPanel, draggedPanel)
{
	//var draggedItem = draggedPanel.m_DragItem;
  Game.EmitSound("Config.Move");

  if (newPanel.id == "item") {
    newPanel.GetParent().SetHasClass("dragHover", true);
  } else {
    newPanel.SetHasClass("dragHover", true);
  }

	return true;
}

function OnDragLeave(newPanel, draggedPanel)
{
	//var draggedItem = draggedPanel.m_DragItem;
  if (newPanel.id == "item") {
    newPanel.GetParent().SetHasClass("dragHover", false);
  } else {
    newPanel.SetHasClass("dragHover", false);
  }

	return true;
}

function OnItemIventoryAdded(event){
  Game.EmitSound("Item.PickUpWorld");

  for (let row = 0; row < MAX_ROWS; row++) {
    var row_id = "row" + row;
    for(var i = 0; i < ROWS[row_id].GetChildCount(); i++) {
      if (ROWS[row_id].GetChild(i).GetChild(0) == null) {
        var panel = $.CreatePanel("DOTAItemImage", ROWS[row_id].GetChild(i), "item");
        panel.itemname = event.itemname;
        panel.itemrarity = event.itemrarity;
        panel.itemtype = event.itemtype;
        return;
      }
    }
  }

  var player_hero_index = Players.GetPlayerHeroEntityIndex(Players.GetLocalPlayer());
  GameEvents.SendCustomGameEventToServer("drop_item_from_panorama", {unit: player_hero_index, itemname: event.itemname});
}

(function(){
  var inventory_container = $.GetContextPanel().FindChildTraverse("inventory_list_container")
  
  for (let row = 0; row < MAX_ROWS; row++) {
    var row_id = "row" + row;
    ROWS[row_id] = $.CreatePanel("Panel", inventory_container, row_id);
    ROWS[row_id].BLoadLayout("file://{resources}/layout/custom_game/equip_system/muken_inventory_row.xml", false, false);

    for(var i = 0; i < ROWS[row_id].GetChildCount(); i++) {
      $.RegisterEventHandler('DragStart', ROWS[row_id].GetChild(i), OnDragStart);
      $.RegisterEventHandler('DragEnd', ROWS[row_id].GetChild(i), OnDragEnd);
      $.RegisterEventHandler('DragDrop', ROWS[row_id].GetChild(i), OnDragDrop);
      $.RegisterEventHandler('DragEnter', ROWS[row_id].GetChild(i), OnDragEnter);
      $.RegisterEventHandler('DragLeave', ROWS[row_id].GetChild(i), OnDragLeave);
    }
  }

  GameEvents.Subscribe("add_item_inventory_from_lua", OnItemIventoryAdded);
})()