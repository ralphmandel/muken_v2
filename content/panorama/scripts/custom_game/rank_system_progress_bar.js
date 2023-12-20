var XP_LABEL, PROGRESS_BAR_LABEL, PROGRESS_BAR_CIRCULAR;

var current_portrait_entity = "";
var panels_init = false;
var manaBar = null, manaBarFire = null;
var mana_style = {};
var energy_style = {};
var rage_style = {};



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
  if (Entities.GetUnitName(current_portrait_entity) == "npc_dota_hero_elder_titan"){
    manaBar.style.backgroundColor = rage_style.color;
    manaBarFire.style.opacity = rage_style.opacity;
    manaBarFire.style.hueRotation = rage_style.hue;
  } else {
    manaBar.style.backgroundColor = mana_style.color;
    manaBarFire.style.opacity = mana_style.opacity;
    manaBarFire.style.hueRotation = mana_style.hue;
  }
  
}

function OnBarUpdate(event) {
  if (event.entity == Players.GetLocalPlayerPortraitUnit()) {
    var progress = parseInt(event.rank_level) * (360 / event.max_level);
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

  manaBar = $.GetContextPanel().GetParent().FindChildTraverse("health_mana").FindChildTraverse("ManaContainer").FindChildTraverse("ManaProgress").FindChildTraverse("ManaProgress_Left");
  manaBarFire = manaBar.FindChildTraverse("ManaBurner");
  mana_style = {
    color: manaBar.style.backgroundColor, 
    opacity: manaBarFire.style.opacity, 
    hue: manaBarFire.style.hueRotation
  }
  energy_style = {
    color: "gradient( linear, 0% 0%, 0% 100%, from( #7a8787 ), color-stop( 0.2, #a5cfcf ), color-stop( .5, #bcebeb), to( #7a8787 ) )", 
    opacity: "0.7", 
    hue: "120deg"
  }
  rage_style = {
    color: "gradient( linear, 0% 0%, 0% 100%, from( #0d0d0d ), color-stop( 0.2, #141414 ), color-stop( .5, #171717), to( #0d0d0d ) )", 
    opacity: "0.4", 
    hue: "240deg"
  }

})()

$.RegisterForUnhandledEvent("DOTAHudUpdate", () => {
  if (GameUI.IsAltDown() && $.GetContextPanel().FindChildTraverse("RankXPLabel").BHasClass("AltPressed") == false) {
    $.GetContextPanel().FindChildTraverse("RankXPLabel").SetHasClass("AltPressed", true);
  }  
  if (GameUI.IsAltDown() == false && $.GetContextPanel().FindChildTraverse("RankXPLabel").BHasClass("AltPressed") == true) {
    $.GetContextPanel().FindChildTraverse("RankXPLabel").RemoveClass("AltPressed");
  }
});