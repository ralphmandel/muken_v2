var current_portrait_entity = Players.GetLocalPlayerPortraitUnit();
var player_hero_entity = Game.GetLocalPlayerInfo().player_selected_hero_entity_index;
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
}

function StatusBarCheck()
{
  var wp = $.GetContextPanel().WorldPanel;
  var offScreen = $.GetContextPanel().OffScreen;
  if (!offScreen && wp){
    var ent = wp.entity;
    if (ent){
      if ((HasPlayerAmount() == false && alt_pressed == false &&
      ent != current_portrait_entity && ent != player_hero_entity) || !Entities.IsAlive(ent)){
        $.GetContextPanel().style.opacity = "0";
        $.Schedule(1/30, StatusBarCheck);
        return;
      }

      $.GetContextPanel().style.opacity = "1";
      var current = wp.data.current_status;
      var max = wp.data.max_status;
      var perc = (current * 100 / max).toFixed(0);

      var pan = $("#current_status_panel");
      pan.GetParent().style.width = wp.data.max_status + "px;";
      pan.style.width = perc + "%;";

      var icon = $("#icon");
      SetIcon(icon, wp.data.status_name);
      SetBarStyle(pan, wp.data.status_name);
    }
  }

  $.Schedule(1/30, StatusBarCheck);
}

function OnStatusUpdate(event) {
  var wp = $.GetContextPanel().WorldPanel;

  if (event.entity == wp.entity && event.data.status_name == wp.data.status_name) {
    wp.data = event.data;
    wp.offsetY = event.offsetY;

    var status_max_panel = $("#status_max_panel");
    var current_status_panel = $("#current_status_panel").GetParent();
    status_max_panel.SetHasClass("max_state", wp.data.max_state == "1");
    current_status_panel.SetHasClass("max_state", wp.data.max_state == "1");
  }
}

function HasPlayerAmount() {
  var wp = $.GetContextPanel().WorldPanel;

  for (const [entindex, bool] of Object.entries(wp.data.players_amount)) {
    if (player_hero_entity == entindex) {
      return bool;
    }
  }
}

function SetIcon(icon, status_name) {
  var source = "";

  if (status_name == "bleed__status") {
    source = "file://{resources}/images/custom_game/status_bar/status_bleed.png";
  }

  if (status_name == "ice__status") {
    source = "file://{resources}/images/custom_game/status_bar/status_freeze.png";
  }

  icon.SetImage(source);
}

function SetBarStyle(pan, status_name) {
  pan.SetHasClass("bleed__status", "bleed__status" == status_name);
  pan.SetHasClass("ice__status", "ice__status" == status_name);
}

(function()
{ 
  StatusBarCheck();
  GameEvents.Subscribe("update_status_bar_state_from_server", OnStatusUpdate);
  GameEvents.Subscribe("dota_player_update_selected_unit", OnUpdateSelectedUnit);
  GameEvents.Subscribe("dota_player_update_query_unit", OnUpdateQueryUnit);
})();

$.RegisterForUnhandledEvent("DOTAHudUpdate", () => {
  if (GameUI.IsAltDown()) {
    alt_pressed = true;
  }  
  if (GameUI.IsAltDown() == false) {
    alt_pressed = false;
  }
});