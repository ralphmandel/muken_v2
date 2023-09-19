var XP_LABEL, PROGRESS_BAR_LABEL, PROGRESS_BAR_CIRCULAR;

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
    var progress = parseInt(event.rank_level) * 24;
    PROGRESS_BAR_CIRCULAR.style.clip = "radial( 50% 50%, 0deg, " + progress + "deg )";
    PROGRESS_BAR_LABEL.text = event.points;
    XP_LABEL.text = event.rank_level + " / " + event.max_level;
  }
}

(function(){
  XP_LABEL = $("#RankXPLabel");
  PROGRESS_BAR_LABEL = $("#LevelLabel");
  PROGRESS_BAR_CIRCULAR = $.GetContextPanel().FindChildTraverse("RankXPProgress_FG");

  GameEvents.Subscribe("update_bar_from_lua", OnBarUpdate);
  GameEvents.Subscribe("dota_player_update_selected_unit", OnUpdateSelectedUnit);
  GameEvents.Subscribe("dota_player_update_query_unit", OnUpdateQueryUnit);
})()

$.RegisterForUnhandledEvent("DOTAHudUpdate", () => {
  if (GameUI.IsAltDown() && $.GetContextPanel().FindChildTraverse("RankXPLabel").BHasClass("AltPressed") == false) {
    $.GetContextPanel().FindChildTraverse("RankXPLabel").SetHasClass("AltPressed", true);
  }  
  if (GameUI.IsAltDown() == false && $.GetContextPanel().FindChildTraverse("RankXPLabel").BHasClass("AltPressed") == true) {
    $.GetContextPanel().FindChildTraverse("RankXPLabel").RemoveClass("AltPressed");
  }
});