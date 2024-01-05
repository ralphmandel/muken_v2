"use strict";

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
    displayPanel.equip_type = equip_type;
    
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
  $.Msg('Equip Drop -> ', newPanel.id);

  var m_QueryUnit = draggedPanel.m_QueryUnit;
  var itemname = draggedPanel.itemname;
  var equip_type = newPanel.GetParent().id;
  
  if (newPanel.id == "item") {
    equip_type = newPanel.GetParent().GetParent().id;
  }

  var context = SLOTS[equip_type]["center"].GetChild(0);

  if (draggedPanel.equip_type == null) {
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

      GameEvents.SendCustomGameEventToServer("equip_item_from_panorama", {unit: m_QueryUnit, itemname: itemname});
    }
  } else if (draggedPanel.equip_type != equip_type) {
    Game.EmitSound("General.Item_CantMove_Slot");
  }

	return true;
}

function SetupEvents(panel, header, message){
  $.RegisterEventHandler('DragStart', panel.GetChild(0), OnDragStart);
  $.RegisterEventHandler('DragEnd', panel.GetChild(0), OnDragEnd);
  $.RegisterEventHandler('DragDrop', panel.GetChild(0), OnDragDrop);

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
    SetupEvents(SLOTS[type]["center"], TOOLTIPS["header"][type], TOOLTIPS["message"][type]);
  }

  SLOTS["head"]["square"].BLoadLayoutSnippet("SquareRare");
  SLOTS["armor"]["square"].BLoadLayoutSnippet("SquareEpic");
  SLOTS["weapon"]["square"].BLoadLayoutSnippet("SquareLegendary");
  SLOTS["misc"]["square"].BLoadLayoutSnippet("SquareRare");
  SLOTS["misc"]["square"].GetChild(0).DeleteAsync(0);
})()

function headItemChange(){
  if (head.BHasClass("item-equipped")){
    if (head.GetChild(0).BHasClass("item-rare")){
      if (squareHead.GetChild(0).BHasClass("square-hidden")){
        squareHead.GetChild(0).RemoveClass("square-hidden");
      }
      if (squareHead.GetChild(1).BHasClass("square-hidden")){
      } else {squareHead.GetChild(1).AddClass("square-hidden")}
      if (squareHead.GetChild(2).BHasClass("square-hidden")){
      } else {squareHead.GetChild(2).AddClass("square-hidden")}

    } else if (head.GetChild(0).BHasClass("item-epic")){
      if (squareHead.GetChild(1).BHasClass("square-hidden")){
        squareHead.GetChild(1).RemoveClass("square-hidden");
      }
      if (squareHead.GetChild(0).BHasClass("square-hidden")){
      } else {squareHead.GetChild(0).AddClass("square-hidden")}
      if (squareHead.GetChild(2).BHasClass("square-hidden")){
      } else {squareHead.GetChild(2).AddClass("square-hidden")}

    } else if (head.GetChild(0).BHasClass("item-legendary")){
      if (squareHead.GetChild(2).BHasClass("square-hidden")){
        squareHead.GetChild(2).RemoveClass("square-hidden");
      }
      if (squareHead.GetChild(0).BHasClass("square-hidden")){
      } else {squareHead.GetChild(0).AddClass("square-hidden")}
      if (squareHead.GetChild(1).BHasClass("square-hidden")){
      } else {squareHead.GetChild(1).AddClass("square-hidden")}

    }
  } else {
    if (squareHead.GetChild(0).BHasClass("square-hidden")){
    } else {squareHead.GetChild(0).AddClass("square-hidden");}
    if (squareHead.GetChild(1).BHasClass("square-hidden")){
    } else {squareHead.GetChild(1).AddClass("square-hidden");}
    if (squareHead.GetChild(2).BHasClass("square-hidden")){
    } else { squareHead.GetChild(2).AddClass("square-hidden");}
  }
}

function armoItemChange(){
  if (armor.BHasClass("item-equipped")){
    if (armor.GetChild(0).BHasClass("item-rare")){
      if (squareArmo.GetChild(0).BHasClass("square-hidden")){
        squareArmo.GetChild(0).RemoveClass("square-hidden");
      }
      if (squareArmo.GetChild(1).BHasClass("square-hidden")){
      } else {squareArmo.GetChild(1).AddClass("square-hidden")}
      if (squareArmo.GetChild(2).BHasClass("square-hidden")){
      } else {squareArmo.GetChild(2).AddClass("square-hidden")}

    } else if (armor.GetChild(0).BHasClass("item-epic")){
      if (squareArmo.GetChild(1).BHasClass("square-hidden")){
        squareArmo.GetChild(1).RemoveClass("square-hidden");
      }
      if (squareArmo.GetChild(0).BHasClass("square-hidden")){
      } else {squareArmo.GetChild(0).AddClass("square-hidden")}
      if (squareArmo.GetChild(2).BHasClass("square-hidden")){
      } else {squareArmo.GetChild(2).AddClass("square-hidden")}

    } else if (armor.GetChild(0).BHasClass("item-legendary")){
      if (squareArmo.GetChild(2).BHasClass("square-hidden")){
        squareArmo.GetChild(2).RemoveClass("square-hidden");
      }
      if (squareArmo.GetChild(0).BHasClass("square-hidden")){
      } else {squareArmo.GetChild(0).AddClass("square-hidden")}
      if (squareArmo.GetChild(1).BHasClass("square-hidden")){
      } else {squareArmo.GetChild(1).AddClass("square-hidden")}

    }
  } else {
    if (squareArmo.GetChild(0).BHasClass("square-hidden")){
    } else {squareArmo.GetChild(0).AddClass("square-hidden");}
    if (squareArmo.GetChild(1).BHasClass("square-hidden")){
    } else {squareArmo.GetChild(1).AddClass("square-hidden");}
    if (squareArmo.GetChild(2).BHasClass("square-hidden")){
    } else { squareArmo.GetChild(2).AddClass("square-hidden");}
  }
}

function weaponItemChange(){
  if (weapon.BHasClass("item-equipped")){
    if (weapon.GetChild(0).BHasClass("item-rare")){
      if (squareWeapon.GetChild(0).BHasClass("square-hidden")){
        squareWeapon.GetChild(0).RemoveClass("square-hidden");
      }
      if (squareWeapon.GetChild(1).BHasClass("square-hidden")){
      } else {squareWeapon.GetChild(1).AddClass("square-hidden")}
      if (squareWeapon.GetChild(2).BHasClass("square-hidden")){
      } else {squareWeapon.GetChild(2).AddClass("square-hidden")}

    } else if (weapon.GetChild(0).BHasClass("item-epic")){
      if (squareWeapon.GetChild(1).BHasClass("square-hidden")){
        squareWeapon.GetChild(1).RemoveClass("square-hidden");
      }
      if (squareWeapon.GetChild(0).BHasClass("square-hidden")){
      } else {squareWeapon.GetChild(0).AddClass("square-hidden")}
      if (squareWeapon.GetChild(2).BHasClass("square-hidden")){
      } else {squareWeapon.GetChild(2).AddClass("square-hidden")}

    } else if (weapon.GetChild(0).BHasClass("item-legendary")){
      if (squareWeapon.GetChild(2).BHasClass("square-hidden")){
        squareWeapon.GetChild(2).RemoveClass("square-hidden");
      }
      if (squareWeapon.GetChild(0).BHasClass("square-hidden")){
      } else {squareWeapon.GetChild(0).AddClass("square-hidden")}
      if (squareWeapon.GetChild(1).BHasClass("square-hidden")){
      } else {squareWeapon.GetChild(1).AddClass("square-hidden")}

    }
  } else {
    if (squareWeapon.GetChild(0).BHasClass("square-hidden")){
    } else {squareWeapon.GetChild(0).AddClass("square-hidden");}
    if (squareWeapon.GetChild(1).BHasClass("square-hidden")){
    } else {squareWeapon.GetChild(1).AddClass("square-hidden");}
    if (squareWeapon.GetChild(2).BHasClass("square-hidden")){
    } else { squareWeapon.GetChild(2).AddClass("square-hidden");}
  }
}

function miscItemChange(){
  if (misc.BHasClass("item-equipped")){
    if (misc.GetChild(0).BHasClass("item-rare")){
      if (squareMisc.GetChild(0).BHasClass("square-hidden")){
        squareMisc.GetChild(0).RemoveClass("square-hidden");
      }
      if (squareMisc.GetChild(1).BHasClass("square-hidden")){
      } else {squareMisc.GetChild(1).AddClass("square-hidden")}
      if (squareMisc.GetChild(2).BHasClass("square-hidden")){
      } else {squareMisc.GetChild(2).AddClass("square-hidden")}

    } else if (misc.GetChild(0).BHasClass("item-epic")){
      if (squareMisc.GetChild(1).BHasClass("square-hidden")){
        squareMisc.GetChild(1).RemoveClass("square-hidden");
      }
      if (squareMisc.GetChild(0).BHasClass("square-hidden")){
      } else {squareMisc.GetChild(0).AddClass("square-hidden")}
      if (squareMisc.GetChild(2).BHasClass("square-hidden")){
      } else {squareMisc.GetChild(2).AddClass("square-hidden")}

    } else if (misc.GetChild(0).BHasClass("item-legendary")){
      if (squareMisc.GetChild(2).BHasClass("square-hidden")){
        squareMisc.GetChild(2).RemoveClass("square-hidden");
      }
      if (squareMisc.GetChild(0).BHasClass("square-hidden")){
      } else {squareMisc.GetChild(0).AddClass("square-hidden")}
      if (squareMisc.GetChild(1).BHasClass("square-hidden")){
      } else {squareMisc.GetChild(1).AddClass("square-hidden")}

    }
  } else {
    if (squareMisc.GetChild(0).BHasClass("square-hidden")){
    } else {squareMisc.GetChild(0).AddClass("square-hidden");}
    if (squareMisc.GetChild(1).BHasClass("square-hidden")){
    } else {squareMisc.GetChild(1).AddClass("square-hidden");}
    if (squareMisc.GetChild(2).BHasClass("square-hidden")){
    } else { squareMisc.GetChild(2).AddClass("square-hidden");}
  }
}

// $.Schedule(5, () => {
//   particle.DeleteAsync(0);
// });