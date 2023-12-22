var XP_LABEL, PROGRESS_BAR_LABEL, PROGRESS_BAR_CIRCULAR;

var current_portrait_entity = "";
var panels_init = false;

var mana_bar_root = null, mana_bar_left = null, mana_bar_right = null, mana_bar_fire = null;
var special_style = {};

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
  if (event.rank_level == 0 && event.max_level == 0) {
    PROGRESS_BAR_CIRCULAR.style.clip = "radial( 50% 50%, 0deg, " + 0 + "deg )";
    PROGRESS_BAR_LABEL.text = "-";
    XP_LABEL.text = event.rank_level + " / " + event.max_level;
    UpdateManaBar(event.style);

  } else if (event.entity == Players.GetLocalPlayerPortraitUnit()) {
    var progress = parseInt(event.rank_level) * (360 / event.max_level);
    PROGRESS_BAR_CIRCULAR.style.clip = "radial( 50% 50%, 0deg, " + progress + "deg )";
    PROGRESS_BAR_LABEL.text = event.points;
    XP_LABEL.text = event.rank_level + " / " + event.max_level;
    UpdateManaBar(event.style);
  }
}

function SetupManaBarStyles() {
  special_style["mana"] = {
    color: mana_bar_left.style.backgroundColor, 
    opacity: mana_bar_fire.style.opacity, 
    hue: mana_bar_fire.style.hueRotation,
    shadow: "gradient( linear, 0% 0%, 0% 100%, from( #101932 ), color-stop( 0.2, #172447 ), color-stop( .5, #162244), to( #101932 ) )"
  }
  special_style["energy"] = {
    color: "gradient( linear, 0% 0%, 0% 100%, from( #7f8787 ), color-stop( 0.2, #b6cfcf ), color-stop( .5, #ceebeb), to( #7f8787 ) )", 
    opacity: "0.9", 
    hue: "120deg",
    shadow: "gradient( linear, 0% 0%, 0% 100%, from( #2e3333 ), color-stop( 0.2, #3d4d4d ), color-stop( .5, #475959), to( #2e3333 ) )"
  }
  special_style["rage"] = {
    color: "gradient( linear, 0% 0%, 0% 100%, from( #141414 ), color-stop( 0.2, #1f1f1f ), color-stop( .5, #212121), to( #141414 ) )", 
    opacity: "0.4", 
    hue: "240deg",
    shadow: "gradient( linear, 0% 0%, 0% 100%, from( #120000 ), color-stop( 0.2, #1c0000 ), color-stop( .5, #1f0000), to( #120000 ) )"
  }
}

function UpdateManaBar(style) {
  mana_bar_left.style.backgroundColor = special_style[style].color;
  mana_bar_fire.style.opacity = special_style[style].opacity;
  mana_bar_fire.style.hueRotation = special_style[style].hue;
  mana_bar_fire.style.saturation = 1;
  mana_bar_right.forEach(ProgressBarRight => {
    ProgressBarRight.style.backgroundColor = special_style[style].shadow;
  });
}

(function(){
  XP_LABEL = $("#RankXPLabel");
  PROGRESS_BAR_LABEL = $("#LevelLabel");
  PROGRESS_BAR_CIRCULAR = $.GetContextPanel().FindChildTraverse("RankXPProgress_FG");

  mana_bar_root = $.GetContextPanel().GetParent().FindChildTraverse("health_mana").FindChildTraverse("ManaContainer").FindChildTraverse("ManaProgress");
  mana_bar_right = mana_bar_root.FindChildrenWithClassTraverse("ProgressBarRight");
  mana_bar_left = mana_bar_root.FindChildTraverse("ManaProgress_Left");
  mana_bar_fire = mana_bar_left.FindChildTraverse("ManaBurner");

  SetupManaBarStyles();

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