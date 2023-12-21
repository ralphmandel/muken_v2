"use strict";

var head = null;
var armo = null;
var weapon = null;
var misc = null;

var squareHead = null;
var squareArmo = null;
var squareWeapon = null;
var squareMisc = null;

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
  if (armo.BHasClass("item-equipped")){
    if (armo.GetChild(0).BHasClass("item-rare")){
      if (squareArmo.GetChild(0).BHasClass("square-hidden")){
        squareArmo.GetChild(0).RemoveClass("square-hidden");
      }
      if (squareArmo.GetChild(1).BHasClass("square-hidden")){
      } else {squareArmo.GetChild(1).AddClass("square-hidden")}
      if (squareArmo.GetChild(2).BHasClass("square-hidden")){
      } else {squareArmo.GetChild(2).AddClass("square-hidden")}

    } else if (armo.GetChild(0).BHasClass("item-epic")){
      if (squareArmo.GetChild(1).BHasClass("square-hidden")){
        squareArmo.GetChild(1).RemoveClass("square-hidden");
      }
      if (squareArmo.GetChild(0).BHasClass("square-hidden")){
      } else {squareArmo.GetChild(0).AddClass("square-hidden")}
      if (squareArmo.GetChild(2).BHasClass("square-hidden")){
      } else {squareArmo.GetChild(2).AddClass("square-hidden")}

    } else if (armo.GetChild(0).BHasClass("item-legendary")){
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



(function(){
    head = $.GetContextPanel().GetChild(1);
    armo = $.GetContextPanel().GetChild(3);
    weapon = $.GetContextPanel().GetChild(5);
    misc = $.GetContextPanel().GetChild(7);

    head.SetPanelEvent(
      "onmouseover", 
      function(){
        $.DispatchEvent("DOTAShowTitleTextTooltip", head, "Head Slot", "Any helm type equipament can be equipped on this slot.");
      }
      )
    armo.SetPanelEvent(
      "onmouseover", 
      function(){
        $.DispatchEvent("DOTAShowTitleTextTooltip", armo, "Armo Slot", "Any armo type equipament can be equipped on this slot.");
      }
    )
    weapon.SetPanelEvent(
      "onmouseover", 
      function(){
        $.DispatchEvent("DOTAShowTitleTextTooltip", weapon, "Weapon Slot", "Any weapon type equipament can be equipped on this slot.");
      }
    )
    misc.SetPanelEvent(
      "onmouseover", 
      function(){
        $.DispatchEvent("DOTAShowTitleTextTooltip", misc, "Misc Slot", "Any misc type equipament can be equipped on this slot.");
      }
    )

    head.SetPanelEvent(
      "onmouseout", 
      function(){
        $.DispatchEvent("DOTAHideTitleTextTooltip", head);
      }
      )
    armo.SetPanelEvent(
      "onmouseout", 
      function(){
        $.DispatchEvent("DOTAHideTitleTextTooltip", armo);
      }
    )
    weapon.SetPanelEvent(
      "onmouseout", 
      function(){
        $.DispatchEvent("DOTAHideTitleTextTooltip", weapon);
      }
    )
    misc.SetPanelEvent(
      "onmouseout", 
      function(){
        $.DispatchEvent("DOTAHideTitleTextTooltip", misc);
      }
    )
    
    squareHead = $.GetContextPanel().GetChild(0);
    squareArmo = $.GetContextPanel().GetChild(2);
    squareWeapon = $.GetContextPanel().GetChild(4);
    squareMisc = $.GetContextPanel().GetChild(6);

		squareHead.BLoadLayoutSnippet("SquareRare");
    squareHead.BLoadLayoutSnippet("SquareEpic");
    squareHead.BLoadLayoutSnippet("SquareLegendary");

    squareArmo.BLoadLayoutSnippet("SquareRare");
    squareArmo.BLoadLayoutSnippet("SquareEpic");
    squareArmo.BLoadLayoutSnippet("SquareLegendary");

    squareWeapon.BLoadLayoutSnippet("SquareRare");
    squareWeapon.BLoadLayoutSnippet("SquareEpic");
    squareWeapon.BLoadLayoutSnippet("SquareLegendary");

    squareMisc.BLoadLayoutSnippet("SquareRare");
    squareMisc.BLoadLayoutSnippet("SquareEpic");
    squareMisc.BLoadLayoutSnippet("SquareLegendary");
    

    headItemChange()
    armoItemChange()
    weaponItemChange()
    miscItemChange()
    
})()

