"use strict"

var mukenItems = null;
var buttonContainer = null;
var inventoryButton = null;
var ROWS = {}, SLOTS = {};

(function(){
  mukenItems = $.GetContextPanel().GetParent().GetParent().GetParent().GetParent().FindChildTraverse("muken_inventory_items");
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
})()


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
