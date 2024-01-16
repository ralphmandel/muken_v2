$.Msg("StatusBar");

var current_portrait_entity = "";
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
    //$.Msg("kubo", wp.data.scale);
    var ent = wp.entity;
    if (ent){
      if ((alt_pressed == false && ent != current_portrait_entity && ent != player_hero_entity) || !Entities.IsAlive(ent)){
        $.GetContextPanel().style.opacity = "0";
        $.Schedule(1/30, StatusBarCheck);
        return;
      }

      $.GetContextPanel().style.opacity = "1";
      var current = wp.data.current_status;
      var max = wp.data.max_status;
      var perc = (current * 100 / max).toFixed(0);

      var pan = $("#HP_inner");
      pan.GetParent().style.width = wp.data.max_status + "px;";
      pan.style.width = perc + "%;";
      pan.style.backgroundColor = "red;";
    }
  }

  $.Schedule(1/30, StatusBarCheck);
}

function OnStatusUpdate(event) {
  var wp = $.GetContextPanel().WorldPanel;

  if (event.entity == wp.entity) {
    wp.data = event.data;
  }
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