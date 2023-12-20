var XP_LABEL, PROGRESS_BAR_LABEL, PROGRESS_BAR_CIRCULAR;

var current_portrait_entity = "";
var panels_init = false;
var manaBar = null, manaBarFire = null, manaBarParent = null;
var mana_style = {};
var energy_style = {};
var rage_style = {};
var original_style_remain = "gradient( linear, 0% 0%, 0% 100%, from( #101932 ), color-stop( 0.2, #172447 ), color-stop( .5, #162244), to( #101932 ) )";
var rage_style_remain = "gradient( linear, 0% 0%, 0% 100%, from( #120000 ), color-stop( 0.2, #1c0000 ), color-stop( .5, #1f0000), to( #120000 ) )";
var energy_style_remain = "gradient( linear, 0% 0%, 0% 100%, from( #2e3333 ), color-stop( 0.2, #3d4d4d ), color-stop( .5, #475959), to( #2e3333 ) )";

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
    manaBarFire.style.saturation = 1;
    manaBarRemain.forEach(ProgressBarRight => {
      ProgressBarRight.style.backgroundColor = rage_style_remain;
     });
  } else if (Entities.GetUnitName(current_portrait_entity) == "npc_dota_hero_muerta"){
    manaBar.style.backgroundColor = energy_style.color;
    manaBarFire.style.opacity = energy_style.opacity;
    manaBarFire.style.hueRotation = energy_style.hue;
    manaBarFire.style.saturation = 0.5;
    manaBarRemain.forEach(ProgressBarRight => {
      ProgressBarRight.style.backgroundColor = energy_style_remain;
     });
  } else {
    manaBar.style.backgroundColor = mana_style.color;
    manaBarFire.style.opacity = mana_style.opacity;
    manaBarFire.style.hueRotation = mana_style.hue;
    manaBarFire.style.saturation = 1;
    manaBarRemain.forEach(ProgressBarRight => {
      ProgressBarRight.style.backgroundColor = original_style_remain;
     });
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

  manaBarParent = $.GetContextPanel().GetParent().FindChildTraverse("health_mana").FindChildTraverse("ManaContainer").FindChildTraverse("ManaProgress");
  manaBarRemain = manaBarParent.FindChildrenWithClassTraverse("ProgressBarRight");

  manaBar = manaBarParent.FindChildTraverse("ManaProgress_Left")
  manaBarFire = manaBar.FindChildTraverse("ManaBurner");
  mana_style = {
    color: manaBar.style.backgroundColor, 
    opacity: manaBarFire.style.opacity, 
    hue: manaBarFire.style.hueRotation
  }
  energy_style = {
    color: "gradient( linear, 0% 0%, 0% 100%, from( #7f8787 ), color-stop( 0.2, #b6cfcf ), color-stop( .5, #ceebeb), to( #7f8787 ) )", 
    opacity: "0.5", 
    hue: "120deg"
  }
  rage_style = {
    color: "gradient( linear, 0% 0%, 0% 100%, from( #141414 ), color-stop( 0.2, #1f1f1f ), color-stop( .5, #212121), to( #141414 ) )", 
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