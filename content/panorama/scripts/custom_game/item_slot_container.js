"use strict";

(function(){
    var head = $.GetContextPanel().GetChild(0);
    var armo = $.GetContextPanel().GetChild(1);
    var weapon = $.GetContextPanel().GetChild(2);
    var misc = $.GetContextPanel().GetChild(3);

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

})()

