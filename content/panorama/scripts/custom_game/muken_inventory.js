"use strict"

var ROWS = {}, SLOTS = {};

function OnDragStart(panelId, dragCallbacks) {
  var slot = panelId.id;
  var row = panelId.GetParent().id;
  var itemName = SLOTS[row][slot].itemname;
  var m_QueryUnit = Players.GetLocalPlayerPortraitUnit();

  if (itemName != null) {
    $.DispatchEvent("DOTAHideAbilityTooltip", $.GetContextPanel());

    var displayPanel = $.CreatePanel("DOTAItemImage", $.GetContextPanel(), "dragImage");
    displayPanel.style.width = "59px";
    displayPanel.style.height = "45px";
    
    displayPanel.itemname = itemName;
    // displayPanel.contextEntityIndex = m_Item;
    // displayPanel.m_DragItem = m_Item;
    displayPanel.m_contID = -1;
    displayPanel.m_DragCompleted = false; // whether the drag was successful
    displayPanel.m_OriginalPanel = SLOTS[row][slot];
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
  $.Msg('OnDragEnd -> ', panelId.id, draggedPanel.m_OriginalPanel.id);

  draggedPanel.DeleteAsync(0);

  return false;
}

function OnDragDrop(panelId, draggedPanel) {
  $.Msg('OnDragDrop -> ', panelId.id, draggedPanel.m_OriginalPanel.id);

  var id = draggedPanel.itemname;
  var row = panelId.GetParent().id;
  var slot = panelId.id;

  if (panelId.paneltype == "DOTAItemImage") {
    row = panelId.GetParent().GetParent().id;
    slot = panelId.GetParent().id;
  }

  var slot_index = parseInt(slot.substr(slot.length - 1));
  var context = ROWS[row].GetChild(slot_index);

  if (draggedPanel.row != row || draggedPanel.slot != slot) {
    if (panelId.paneltype == "DOTAItemImage") {
      SLOTS[draggedPanel.row][draggedPanel.slot].itemname = SLOTS[row][slot].itemname;
      SLOTS[row][slot].itemname = draggedPanel.itemname;
    } else {
      draggedPanel.m_OriginalPanel.DeleteAsync(0);
      SLOTS[row][slot] = $.CreatePanel("DOTAItemImage", context, "item");
      SLOTS[row][slot].itemname = id;
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
  SLOTS["row2"]["slot3"] = $.CreatePanel("DOTAItemImage", ROWS["row2"].GetChild(3), "item");
  SLOTS["row2"]["slot3"].itemname = event.itemname;
}

(function(){
  var inventory_container = $.GetContextPanel().FindChildTraverse("inventory_list_container")
  
  for (let row = 0; row < 5; row++) {
    var row_id = "row" + row;
    ROWS[row_id] = $.CreatePanel("Panel", inventory_container, row_id);
    ROWS[row_id].BLoadLayout("file://{resources}/layout/custom_game/muken_inventory_row.xml", false, false);
    SLOTS[row_id] = {};

    for(var i = 0; i <= ROWS[row_id].GetChildCount() - 1; i++) {
      SLOTS[row_id][ROWS[row_id].GetChild(i).id] = null;
      $.RegisterEventHandler('DragStart', ROWS[row_id].GetChild(i), OnDragStart);
      $.RegisterEventHandler('DragEnd', ROWS[row_id].GetChild(i), OnDragEnd);
      $.RegisterEventHandler('DragDrop', ROWS[row_id].GetChild(i), OnDragDrop);
    }
  }

  GameEvents.Subscribe("add_item_inventory_from_lua", OnItemIventoryAdded);
})()