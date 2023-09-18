var XP_LABEL, PROGRESS_BAR_LABEL, PROGRESS_BAR_LIFETIME, PROGRESS_BAR_CIRCULAR, PROGRESS_BAR_CIRCULAR_BLUR;

var current_portrait_entity = "";
var panels_init = false;

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
  GameEvents.SendCustomGameEventToServer("request_bar_info_from_panorama", {"entity": nEntityIndex});
}

function OnBarUpdate(event) {
  if (event.entity == Players.GetLocalPlayerPortraitUnit()) {
    XP_LABEL.text = event.rank_level + " / 15";
    PROGRESS_BAR_LABEL.text = event.points;
    PROGRESS_BAR_CIRCULAR.value(parseInt(event.rank_level));
    PROGRESS_BAR_CIRCULAR.min(0);
    PROGRESS_BAR_CIRCULAR.max(15);
    PROGRESS_BAR_CIRCULAR_BLUR.value(parseInt(event.rank_level));
    PROGRESS_BAR_CIRCULAR_BLUR.min(0);
    PROGRESS_BAR_CIRCULAR_BLUR.max(15);
    PROGRESS_BAR_LIFETIME.value(parseInt(event.rank_level));
    PROGRESS_BAR_LIFETIME.min(0);
    PROGRESS_BAR_LIFETIME.max(15);
    PROGRESS_BAR_LIFETIME.valuePerNotch(1);
  }
}

(function(){
  GameEvents.Subscribe("update_bar_from_lua", OnBarUpdate);

  XP_LABEL = $("#RankXPLabel");
  PROGRESS_BAR_LABEL = $("#LevelLabel");
  PROGRESS_BAR_CIRCULAR = $("#CircularXPProgress");
  PROGRESS_BAR_CIRCULAR_BLUR = $("#CircularXPProgressBlur");
  PROGRESS_BAR_LIFETIME = $("#LifetimeProgress");
})()

$.RegisterForUnhandledEvent("DOTAHudUpdate", () => {
  if (GameUI.IsAltDown() && $.GetContextPanel().FindChildTraverse("RankXPLabel").BHasClass("AltPressed") == false) {
    $.GetContextPanel().FindChildTraverse("RankXPLabel").SetHasClass("AltPressed", true);
  }  
  if (GameUI.IsAltDown() == false && $.GetContextPanel().FindChildTraverse("RankXPLabel").BHasClass("AltPressed") == true) {
    $.GetContextPanel().FindChildTraverse("RankXPLabel").RemoveClass("AltPressed");
  }
});