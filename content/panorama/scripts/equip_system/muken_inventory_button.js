"use strict"

var mukenItems = null;
var buttonContainer = null;
var inventoryButton = null;
var ROWS = {}, SLOTS = {};

var current_portrait_entity = Players.GetLocalPlayerPortraitUnit();
var alt_pressed = false;

function OnUpdateSelectedUnit() {
  var nEntityIndex = Players.GetLocalPlayerPortraitUnit();
  if (nEntityIndex != current_portrait_entity) {OnPortraitChanged(nEntityIndex)}
}

function OnUpdateQueryUnit() {
  var nEntityIndex = Players.GetLocalPlayerPortraitUnit();
  if (nEntityIndex != current_portrait_entity) {OnPortraitChanged(nEntityIndex)}
}

function OnPortraitChanged(nEntityIndex) {
  current_portrait_entity = nEntityIndex;

  if (Entities.GetUnitName(current_portrait_entity) == "npc_dota_watch_tower") {
    //GameEvents.SendCustomGameEventToServer("forge_tower_from_panorama", {ent_index: current_portrait_entity});
  }
}

function toggleInventory(){  
  Game.EmitSound("ui.inv_equip_metalarmour");

  if (inventoryButton.BHasClass("inventory-opened")){
    inventoryButton.RemoveClass("inventory-opened");
    mukenItems.AddClass("Hidden");
  } else{
    inventoryButton.SetFocus();
    inventoryButton.AddClass("inventory-opened");
    mukenItems.RemoveClass("Hidden");
  }
}


(function(){
  mukenItems = $.GetContextPanel().GetParent().GetParent().GetParent().GetParent().GetParent().FindChildTraverse("muken_inventory_items");
  inventoryButton = $.GetContextPanel().FindChildTraverse("inventory-button");
  buttonContainer = $.GetContextPanel().FindChildTraverse("inventory-container");

  buttonContainer.SetPanelEvent(
    "onmouseover",
    function(){
      $.DispatchEvent("DOTAShowTitleTextTooltip", buttonContainer, "Inventory", "Click to Open/Close your inventory.");
    }
  )

  buttonContainer.SetPanelEvent(
    "onmouseout",
    function(){
      $.DispatchEvent("DOTAHideTitleTextTooltip", buttonContainer);
    }
  )

  $.RegisterKeyBind(inventoryButton, "key_escape", () => {
    if (inventoryButton.BHasClass("inventory-opened")){
      toggleInventory();
    }
  });

  Game.AddCommand("OpenInventory", toggleInventory, "", 0 );

  GameEvents.Subscribe("dota_player_update_selected_unit", OnUpdateSelectedUnit);
  GameEvents.Subscribe("dota_player_update_query_unit", OnUpdateQueryUnit);
})()