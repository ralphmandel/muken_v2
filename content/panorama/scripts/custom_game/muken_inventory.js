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
    var itemName = item.itemname;

    var displayPanel = $.CreatePanel("DOTAItemImage", $.GetContextPanel(), "dragImage");
    displayPanel.style.width = "59px";
    displayPanel.style.height = "45px";
    displayPanel.itemname = itemName;

    // displayPanel.contextEntityIndex = m_Item;
    // displayPanel.m_DragItem = m_Item;
    displayPanel.m_contID = -1;
    displayPanel.m_DragCompleted = false; // whether the drag was successful
    displayPanel.m_OriginalPanel = item;
    displayPanel.m_QueryUnit = m_QueryUnit;
    displayPanel.row = row;
    displayPanel.slot = slot;
    
    // hook up the display panel, and specify the panel offset from the cursor
    dragCallbacks.displayPanel = displayPanel;
    dragCallbacks.offsetX = 0;
    dragCallbacks.offsetY = 0;
  }

  return false;
}

function OnDragEnd(panelId, draggedPanel) {
  draggedPanel.DeleteAsync(0);
  return false;
}

function OnDragDrop(newPanel, draggedPanel) {
  $.Msg('Slot Drop ->');
  
  var m_QueryUnit = draggedPanel.m_QueryUnit;
  var itemname = draggedPanel.itemname;
  var row = newPanel.GetParent().id;
  var slot = newPanel.id;

  if (newPanel.id == "item") {
    row = newPanel.GetParent().GetParent().id;
    slot = newPanel.GetParent().id;
  }

  var slot_index = parseInt(slot.substr(slot.length - 1));
  var context = ROWS[row].GetChild(slot_index);

  if (draggedPanel.equip_type != null) {
    GameEvents.SendCustomGameEventToServer("unequip_item_from_panorama", {unit: m_QueryUnit, itemname: itemname});
  }

  if (draggedPanel.row != row || draggedPanel.slot != slot) {
    Game.EmitSound("General.ButtonClickRelease");
    //General.Buttonrollover
    //Item.PickUpGemWorld
    //Item.PickUpRingWorld

    if (newPanel.id == "item") {
      draggedPanel.m_OriginalPanel.itemname = newPanel.itemname;
      newPanel.itemname = itemname;
    } else {
      draggedPanel.m_OriginalPanel.DeleteAsync(0);
      var panel = $.CreatePanel("DOTAItemImage", context, "item");
      panel.itemname = itemname;
    }
  }

	return true;
}

// function OnDragEnter(panelId, draggedPanel) {
//   $.Msg('OnDragEnter -> ');
//   $.Msg(panelId.id);
//   $.Msg(draggedPanel.id);

// 	return true;
// }

// function OnDragLeave(panelId, draggedPanel) {
//   $.Msg('OnDragLeave -> ');
//   $.Msg(panelId.id);
//   $.Msg(draggedPanel.id);

// 	return true;
// }

function OnItemIventoryAdded(event){
  for (let row = 0; row < MAX_ROWS; row++) {
    var row_id = "row" + row;
    for(var i = 0; i < ROWS[row_id].GetChildCount(); i++) {
      if (ROWS[row_id].GetChild(i).GetChild(0) == null) {
        Game.EmitSound("Item.PickUpWorld");
        var panel = $.CreatePanel("DOTAItemImage", ROWS[row_id].GetChild(i), "item");
        panel.itemname = event.itemname;
        return;
      }
    }
  }
}

(function(){
  var inventory_container = $.GetContextPanel().FindChildTraverse("inventory_list_container")
  
  for (let row = 0; row < MAX_ROWS; row++) {
    var row_id = "row" + row;
    ROWS[row_id] = $.CreatePanel("Panel", inventory_container, row_id);
    ROWS[row_id].BLoadLayout("file://{resources}/layout/custom_game/muken_inventory_row.xml", false, false);

    for(var i = 0; i < ROWS[row_id].GetChildCount(); i++) {
      $.RegisterEventHandler('DragStart', ROWS[row_id].GetChild(i), OnDragStart);
      $.RegisterEventHandler('DragEnd', ROWS[row_id].GetChild(i), OnDragEnd);
      $.RegisterEventHandler('DragDrop', ROWS[row_id].GetChild(i), OnDragDrop);
    }
  }

  GameEvents.Subscribe("add_item_inventory_from_lua", OnItemIventoryAdded);
})()