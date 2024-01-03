var RANK_WINDOW, RANK_TITLE = {}, RANK_PANELS = {}, BUTTON_LAYOUT = {};

var rank_states = {
  1: "StateDisabled", 2: "StateAvailable", 3: "StateUpgraded",
}

var current_id = "Ability0";
var bFiveAbilities = false;
var bSixAbilities = false;
var isWindowOpened = false;
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
  if (panels_init == false) {return}

  current_portrait_entity = nEntityIndex;
  isWindowOpened = false;
  RANK_WINDOW.style.transform = "translateY(400px)";
  RANK_WINDOW.style.opacity = "0";

  GameEvents.SendCustomGameEventToServer("request_buttons_state_from_panorama", {"entity": nEntityIndex});

  for (const [button_id, button] of Object.entries(BUTTON_LAYOUT)) {
    if (BUTTON_LAYOUT[button_id].GetChild(0).checked == true) {
      BUTTON_LAYOUT[button_id].GetChild(0).SetSelected(false);
    }
  }
}

function SetRankButtonsVisibility(event) {
  for (const [button_id, button] of Object.entries(BUTTON_LAYOUT)) {
    if (event.bEnable == true) {
      BUTTON_LAYOUT[button_id].style.visibility = "visible";
    } else {
      BUTTON_LAYOUT[button_id].style.visibility = "collapse";
    }
  }

  if (event.bEnable == false) {
    var abilities_panel = $.GetContextPanel().GetParent().GetParent().FindChildTraverse("HUDElements").FindChildTraverse("abilities");
    for(var i = 0; i <= abilities_panel.GetChildCount() - 1; i++) {
      if (abilities_panel.GetChild(i).BHasClass("level_secret") == true) {
        abilities_panel.GetChild(i).RemoveClass("no_level");
        abilities_panel.GetChild(i).RemoveClass("enemy");
        abilities_panel.GetChild(i).RemoveClass("level_secret");
      }
    }
  }
}

function OnRankButtonClick(id) {
  Game.EmitSound("General.SelectAction");

  current_id = id;

  for (const [button_id, button] of Object.entries(BUTTON_LAYOUT)) {
    if (button_id == id) {
      if (BUTTON_LAYOUT[button_id].GetChild(0).checked == true) {
        isWindowOpened = true;
      } else {
        isWindowOpened = false;
        RANK_WINDOW.style.transform = "translateY(400px)";
        RANK_WINDOW.style.opacity = "0";
      }
    } else {
      BUTTON_LAYOUT[button_id].GetChild(0).SetSelected(false);
    }
  }

  SendRankWindowUpdateRequest({"entity": current_portrait_entity});
}

function SendRankWindowUpdateRequest(event) {
  if (event.entity == Players.GetLocalPlayerPortraitUnit()) {
    for (const [button_id, button] of Object.entries(BUTTON_LAYOUT)) {
      if (BUTTON_LAYOUT[button_id].GetChild(0).checked == true) {
        GameEvents.SendCustomGameEventToServer("request_skill_name_from_panorama", {"id": button_id});
      }
    }
  }
}

function SendRanksRequest(event) {
  var lower_hud_panel = $.GetContextPanel().GetParent().GetParent().FindChildTraverse("HUDElements").FindChildTraverse("lower_hud");
  bFiveAbilities = lower_hud_panel.BHasClass("FiveAbilities");
  bSixAbilities = lower_hud_panel.BHasClass("SixAbilities");

  var abilities_panel = $.GetContextPanel().GetParent().GetParent().FindChildTraverse("HUDElements").FindChildTraverse("abilities");
  var skill_name = abilities_panel.FindChildTraverse(event.id).FindChildTraverse("AbilityImage").abilityname;

  GameEvents.SendCustomGameEventToServer("ranks_from_panorama", {"skill_name": skill_name, "entity": Players.GetLocalPlayerPortraitUnit()});
}

function OnRankPanelUpdate(event) {
  for(var tier = 1; tier <= 3; tier++) {
    for(var path = 1; path <= 2; path++) {
      RANK_PANELS[tier][path].GetChild(0).abilityname = event.table[tier][path]["rank_name"];
      for (const [i, state] of Object.entries(rank_states)) {
        RANK_PANELS[tier][path].SetHasClass(state, state == event.table[tier][path]["rank_state"]);
      }
    }
  }

  RANK_PANELS["skill_name"] = event.skill_name;
  RANK_TITLE["Name"].text = $.Localize("#DOTA_Tooltip_ability_" + event.skill_name);
  RANK_TITLE["Level"].text = event.skill_level;
  UpdateRankPosition();
}

function UpdateRankPosition() {
  for(var i = 0; i <= 5; i++) {
    var class_name = "Ability" + i;
    RANK_WINDOW.SetHasClass(class_name, current_id == class_name);
  }

  RANK_WINDOW.SetHasClass("FiveAbilities", bFiveAbilities);
  RANK_WINDOW.SetHasClass("SixAbilities", bSixAbilities);

  if (isWindowOpened == true) {
    RANK_WINDOW.style.transform = "translateY(0px)";
    RANK_WINDOW.style.opacity = "1";
  }
}

function ShowRankTooltip(id, tier, path) {
  var rank_image = RANK_PANELS[tier][path].GetChild(0);
  $.DispatchEvent("DOTAShowAbilityTooltip", rank_image, rank_image.abilityname);
  Game.EmitSound("Config.Move");

  rank_image.SetHasClass("ShowAbility", true);
  RANK_PANELS[tier][path].SetHasClass("ShowAbilityLeft", true);
}

function HideRankTooltip(id, tier, path) {
  var rank_image = RANK_PANELS[tier][path].GetChild(0);
  $.DispatchEvent("DOTAHideAbilityTooltip", rank_image);
  Game.EmitSound("Config.Move");

  rank_image.SetHasClass("ShowAbility", false);
  RANK_PANELS[tier][path].SetHasClass("ShowAbilityLeft", false);
}

function OnRankClick(id, tier, path) {
  if (Game.IsInToolsMode() || Game.GetLocalPlayerInfo().player_selected_hero_entity_index == current_portrait_entity) {
    if (RANK_PANELS[tier][path].BHasClass(rank_states[2])) {
      Game.EmitSound("Config.Ok");
      GameEvents.SendCustomGameEventToServer("rank_up_from_panorama", {
        "skill_name": RANK_PANELS["skill_name"], "tier": tier, "path": path, "entity": current_portrait_entity
      });
    }
  }
}

function OnMouseIn(id) {
  //Game.EmitSound("Config.Move");
}

function OnMouseOut(id) {
}

function CreateLayout(){
  var abilities_panel = $.GetContextPanel().GetParent().GetParent().FindChildTraverse("HUDElements").FindChildTraverse("abilities");
  var lower_hud_panel = $.GetContextPanel().GetParent().GetParent().FindChildTraverse("HUDElements").FindChildTraverse("lower_hud");

  RANK_WINDOW = $.CreatePanel("Panel", lower_hud_panel, "RankWindowRoot");
  RANK_WINDOW.BLoadLayout("file://{resources}/layout/custom_game/rank_system_window.xml", false, false);
  RANK_WINDOW.style.transform = "translateY(400px)";
  RANK_WINDOW.style.opacity = "0";

  RANK_TITLE["Name"] = RANK_WINDOW.FindChildTraverse("RankNameContainer").FindChildTraverse("SkillName");
  RANK_TITLE["Level"] = RANK_WINDOW.FindChildTraverse("RankLevelContainer").FindChildTraverse("SkillLevel");

  for(var tier = 1; tier <= 3; tier++) {
    var tier_panel = RANK_WINDOW.FindChildTraverse("Tier" + tier);
    RANK_PANELS[tier] = {};
    for(var path = 1; path <= 2; path++) {
      RANK_PANELS[tier][path] = $.CreatePanel("Button", tier_panel, "Rank_" + tier + path);
      RANK_PANELS[tier][path].BLoadLayout("file://{resources}/layout/custom_game/rank_system_ranks.xml", false, false);
      RANK_PANELS[tier][path].Data().ShowRankTooltip = ShowRankTooltip;
      RANK_PANELS[tier][path].Data().HideRankTooltip = HideRankTooltip;
      RANK_PANELS[tier][path].Data().OnRankClick = OnRankClick;
    }
  }

  for(var i = 0; i <= abilities_panel.GetChildCount() - 1; i++) {
    var id = abilities_panel.GetChild(i).id;
    BUTTON_LAYOUT[id] = $.CreatePanel("Panel", abilities_panel.GetChild(i), id);
    BUTTON_LAYOUT[id].BLoadLayout("file://{resources}/layout/custom_game/rank_system_button.xml", false, false);
    BUTTON_LAYOUT[id].Data().OnRankButtonClick = OnRankButtonClick;
    BUTTON_LAYOUT[id].Data().OnMouseIn = OnMouseIn;
    BUTTON_LAYOUT[id].Data().OnMouseOut = OnMouseOut;

    abilities_panel.GetChild(i).MoveChildBefore(BUTTON_LAYOUT[id], abilities_panel.GetChild(i).FindChildTraverse("ButtonAndLevel"));
    abilities_panel.GetChild(i).FindChildTraverse("LevelUp0").style.visibility = "collapse";
  }

  panels_init = true;
  OnPortraitChanged(Players.GetLocalPlayerPortraitUnit());
}

(function(){
  GameEvents.Subscribe("ranks_layout_from_lua", CreateLayout);
  GameEvents.Subscribe("ranks_from_lua", OnRankPanelUpdate);
  GameEvents.Subscribe("skill_name_from_lua", SendRanksRequest);
  GameEvents.Subscribe("update_rank_window_from_lua", SendRankWindowUpdateRequest);
  GameEvents.Subscribe("set_rank_buttons_from_lua", SetRankButtonsVisibility);
  GameEvents.Subscribe("dota_player_update_selected_unit", OnUpdateSelectedUnit);
  GameEvents.Subscribe("dota_player_update_query_unit", OnUpdateQueryUnit);
})()