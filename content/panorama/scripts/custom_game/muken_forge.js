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
  if (newPanel.id == "item") {
    $.Msg("FF", newPanel.GetParent().id);
    newPanel.GetParent().SetHasClass("dragHover", true);
  } else {
    $.Msg("FF", newPanel.id);
    newPanel.SetHasClass("dragHover", true);
  }

	return true;
}

function OnDragLeave(newPanel, draggedPanel)
{
	//var draggedItem = draggedPanel.m_DragItem;
  if (newPanel.id == "item") {
    $.Msg("GG", newPanel.GetParent().id);
    newPanel.GetParent().SetHasClass("dragHover", false);
  } else {
    $.Msg("GG", newPanel.id);
    newPanel.SetHasClass("dragHover", false);
  }

	return true;
}

function OnItemIventoryAdded(event){
  for (let row = 0; row < MAX_ROWS; row++) {
    var row_id = "row" + row;
    for(var i = 0; i < ROWS[row_id].GetChildCount(); i++) {
      if (ROWS[row_id].GetChild(i).GetChild(0) == null) {
        Game.EmitSound("Item.PickUpWorld");
        var panel = $.CreatePanel("DOTAItemImage", ROWS[row_id].GetChild(i), "item");
        panel.itemname = event.itemname;
        panel.itemrarity = event.itemrarity;
        panel.itemtype = event.itemtype;
        return;
      }
    }
  }
}

var message = "You can forge items by dragging shards of the same type to each slot container, then select the item type and forge it to receive a random item based on shard tier.";

(function(){
  ForgePanelCheck();

  var panel = $.GetContextPanel().FindChildTraverse("help_panel");
  var container = $.GetContextPanel().FindChildTraverse("muken_forge_items");
  //     $.RegisterEventHandler('DragStart', ROWS[row_id].GetChild(i), OnDragStart);
  //     $.RegisterEventHandler('DragEnd', ROWS[row_id].GetChild(i), OnDragEnd);
  //     $.RegisterEventHandler('DragDrop', ROWS[row_id].GetChild(i), OnDragDrop);
  //     $.RegisterEventHandler('DragEnter', ROWS[row_id].GetChild(i), OnDragEnter);
  //     $.RegisterEventHandler('DragLeave', ROWS[row_id].GetChild(i), OnDragLeave);

  // GameEvents.Subscribe("add_item_inventory_from_lua", OnItemIventoryAdded);

  container.SetHasClass("Hidden", false);


  panel.SetPanelEvent("onmouseover", function() {
    $.DispatchEvent("DOTAShowTextTooltip", panel, message);
  })

  panel.SetPanelEvent("onmouseout", function(){
    $.DispatchEvent("DOTAHideTextTooltip", panel);
  })

})()

var radioButton = $.GetContextPanel().FindChildTraverse("forge_list_container").FindChildTraverse("item_row_id"); 

function RadioSelect(button){
  if(button == 4){
    radioButton.GetChild(3).style.visibility = "collapse";
    radioButton.GetChild(4).style.visibility = "collapse";
    radioButton.style.marginLeft = "51px";
  } else{
    radioButton.GetChild(3).style.visibility = "visible"
    radioButton.GetChild(4).style.visibility = "visible"
    radioButton.style.marginLeft = "0px";
  }
}

function ForgePanelCheck()
{
  var wp = $.GetContextPanel().WorldPanel;
  var offScreen = $.GetContextPanel().OffScreen;

  if (!offScreen && wp){
    var ent = wp.entity;
    if (ent){
      if (!Entities.IsAlive(ent)){
        $.GetContextPanel().style.opacity = "0";
        $.Schedule(1/30, ForgePanelCheck);
        return;
      }

      $.GetContextPanel().style.opacity = "1";
    }
  }

  $.Schedule(1/30, ForgePanelCheck);
}