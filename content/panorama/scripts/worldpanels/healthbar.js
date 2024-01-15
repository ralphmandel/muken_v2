$.Msg("healthbar");

var units = {}

var teamColors = GameUI.CustomUIConfig().team_colors;

if (!teamColors) {
  GameUI.CustomUIConfig().team_colors = {}
  // GameUI.CustomUIConfig().team_colors[DOTATeam_t.DOTA_TEAM_GOODGUYS] = "#3dd296;";
  // GameUI.CustomUIConfig().team_colors[DOTATeam_t.DOTA_TEAM_BADGUYS ] = "#F3C909;";
  // GameUI.CustomUIConfig().team_colors[DOTATeam_t.DOTA_TEAM_CUSTOM_1] = "#c54da8;";
  // GameUI.CustomUIConfig().team_colors[DOTATeam_t.DOTA_TEAM_CUSTOM_2] = "#ac0020;";
  // GameUI.CustomUIConfig().team_colors[DOTATeam_t.DOTA_TEAM_CUSTOM_3] = "#3455FF;";
  // GameUI.CustomUIConfig().team_colors[DOTATeam_t.DOTA_TEAM_CUSTOM_4] = "#65d413;";
  // GameUI.CustomUIConfig().team_colors[DOTATeam_t.DOTA_TEAM_CUSTOM_5] = "#815336;";
  // GameUI.CustomUIConfig().team_colors[DOTATeam_t.DOTA_TEAM_CUSTOM_6] = "#1bc0d8;";
  // GameUI.CustomUIConfig().team_colors[DOTATeam_t.DOTA_TEAM_CUSTOM_7] = "#c7e40d;";
  // GameUI.CustomUIConfig().team_colors[DOTATeam_t.DOTA_TEAM_CUSTOM_8] = "#8c2af4;";

  teamColors = GameUI.CustomUIConfig().team_colors;
}

teamColors[DOTATeam_t.DOTA_TEAM_NEUTRALS] = teamColors[DOTATeam_t.DOTA_TEAM_NEUTRALS] || "#cccccc;";
teamColors[DOTATeam_t.DOTA_TEAM_NOTEAM]   = teamColors[DOTATeam_t.DOTA_TEAM_NOTEAM]   || "#cccccc;";
teamColors[DOTATeam_t.DOTA_TEAM_CUSTOM_5] = teamColors[DOTATeam_t.DOTA_TEAM_CUSTOM_5] || "#4285f4;";
teamColors[DOTATeam_t.DOTA_TEAM_CUSTOM_6] = teamColors[DOTATeam_t.DOTA_TEAM_CUSTOM_6] || "#bd42fb;";
teamColors[DOTATeam_t.DOTA_TEAM_CUSTOM_7] = teamColors[DOTATeam_t.DOTA_TEAM_CUSTOM_7] || "#fbcc42;";

function HealthCheck()
{
  var wp = $.GetContextPanel().WorldPanel
  var offScreen = $.GetContextPanel().OffScreen;
  if (!offScreen && wp){
    var ent = wp.entity;
    if (ent){
      if (!Entities.IsAlive(ent) || units[ent] == null){
        $.GetContextPanel().style.opacity = "0";
        $.Schedule(1/30, HealthCheck);
        return;
      }

      $.GetContextPanel().style.opacity = "1";
      var hp = Entities.GetHealth(ent);
      var hpMax = Entities.GetMaxHealth(ent);
      var hpPer = (hp * 100 / hpMax).toFixed(0);

      var perc = (units[ent].current_status / units[ent].max_status) * 100

      var pan = $("#HP_inner");
      pan.GetParent().style.width = units[ent].max_status + "px;";
      pan.style.width = perc + "%;";
      pan.style.backgroundColor = "red;";

      //$.Msg("oi", pan);

      // var pan = $("#HP_inner");
      // pan.style.width = hpPer + "%;";
      // pan.style.backgroundColor = "#4285f4;";
      
      // for (var i=1; i<=5; i++){
      //   var pan = $("#HP" + i);
      //   var perc = Math.min(Math.max(0, hpPer), 20) * 5;

      //   pan.style.width = perc + "%;";
      //   pan.style.backgroundColor = "#4285f4;";

      //   hpPer -= 20;
      // }
    }
  }

  $.Schedule(1/30, HealthCheck);
}

function OnStatusUpdate(event) {
  if (event.current_status == 0) {
    units[event.entity] = null;
  } else {
    units[event.entity] = {};
    units[event.entity].max_status = event.max_status;
    units[event.entity].current_status = event.current_status;
  }
}

(function()
{ 
  HealthCheck();

  GameEvents.Subscribe("update_status_bar_state_from_server", OnStatusUpdate);
})();