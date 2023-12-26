"use strict"

var mukenItems = null;
var buttonContainer = null;
var inventoryButton = null;
var ROWS = {}, SLOTS = {};

function CreateLayout(){
  for (let index = 1; index < 6; index++) {
    CreateRows("row" + index); 
  }
}

function CreateRows(row){
  ROWS[row] = $("#inventory_" + row);
  SLOTS[row] = {};

  for (let index = 0; index < 5; index++) {
    SLOTS[row]["slot" + index] = ROWS[row].GetChild(index);
  }
}

function OnItemIventoryAdded(event){
  var item = $.CreatePanel("DOTAItemImage", SLOTS["row1"]["slot0"], event.itemname);
  item.itemname = event.itemname;
}

(function(){
  mukenItems = $.GetContextPanel().GetParent().GetParent().GetParent().GetParent().FindChildTraverse("muken_inventory_items");

  if ($.GetContextPanel().layoutfile == "panorama\\layout\\custom_game\\muken_inventory.xml") {
    GameEvents.Subscribe("add_item_inventory_from_lua", OnItemIventoryAdded);
    CreateLayout();

  } else {
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
  }

  Game.AddCommand("OpenInventory", toggleInventory, "", 0 );
})()


function toggleInventory(){  
  if (inventoryButton != null) {
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
}
