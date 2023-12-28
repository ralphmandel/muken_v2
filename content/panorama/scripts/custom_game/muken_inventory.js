"use strict"

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
  GameEvents.Subscribe("add_item_inventory_from_lua", OnItemIventoryAdded);
  CreateLayout();
})()