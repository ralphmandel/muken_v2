"use strict"

function OnPathClick(id) {

}

function OnUpdateWindow(event) {

}

function CreateLayout(){

}

var mukenItems = null;
var buttonContainer = null;
var inventoryButton = null;

(function(){
  mukenItems = $.GetContextPanel().GetParent().GetParent().GetParent().GetParent().FindChildTraverse("muken_inventory_items");
  buttonContainer = $.GetContextPanel().FindChildTraverse("inventory-container");
  inventoryButton = $.GetContextPanel().FindChildTraverse("inventory-button");

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
      toggleInventory(inventoryButton);
    }
  });
  $.RegisterKeyBind(mukenItems, "key_escape", () => {
    if (inventoryButton.BHasClass("inventory-opened")){
      toggleInventory(inventoryButton);
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
