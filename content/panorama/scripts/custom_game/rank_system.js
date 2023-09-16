var RANK_WINDOW, RANK_WINDOW_TITLE, RANK_PANELS = {}, BUTTON_LAYOUT = {};

var rank_states = {
  1: "RankStateDisabled", 2: "RankStateAvailable", 3: "RankStateUpgraded",
};

var window_position = {
  "Low": {
    "Ability0": "ContainerPosLow0",
    "Ability1": "ContainerPosLow1",
    "Ability2": "ContainerPosLow2",
    "Ability3": "ContainerPosLow3",
  },
  "Mid": {
    "Ability0": "ContainerPosMid0",
    "Ability1": "ContainerPosMid1",
    "Ability2": "ContainerPosMid2",
    "Ability3": "ContainerPosMid3",
    "Ability4": "ContainerPosMid4",
  },
  "High": {
    "Ability0": "ContainerPosHigh0",
    "Ability1": "ContainerPosHigh1",
    "Ability2": "ContainerPosHigh2",
    "Ability3": "ContainerPosHigh3",
    "Ability4": "ContainerPosHigh4",
    "Ability5": "ContainerPosHigh5",
  },
};

(function(){
  GameEvents.Subscribe("ranks_layout_from_lua", CreateLayout);
  GameEvents.Subscribe("ranks_from_lua", OnRankPanelUpdate);
  GameEvents.Subscribe("skill_name_from_lua", OnRanksRequest);
  
  CreateLayout();
})()

function OnRanksRequest(event) {
  var abilities_panel = $.GetContextPanel().GetParent().GetParent().FindChildTraverse("HUDElements").FindChildTraverse("abilities");
  var skill_name = abilities_panel.FindChildTraverse(event.id).FindChildTraverse("AbilityImage").abilityname;

  GameEvents.SendCustomGameEventToServer("ranks_from_panorama", {"skill_name": skill_name});
}

function OnRankPanelUpdate(event) {
  for(var tier = 1; tier <= 3; tier++) {
    for(var path = 1; path <= 2; path++) {
      //RANK_PANELS[tier][path].GetChild(0).abilityname = event.table[tier][path]["rank_name"];
      for (const [i, state] of Object.entries(rank_states)) {
        //RANK_PANELS[tier][path].GetChild(0).SetHasClass(state, state == event.table[tier][path]["rank_state"]);
      }
    }
  }

  RANK_WINDOW_TITLE.FindChildTraverse("SkillName").text = $.Localize("#DOTA_Tooltip_ability_" + event.skill_name);
}

function OnRankButtonClick(id) {
  Game.EmitSound("General.SelectAction");

  for (const [button_id, button] of Object.entries(BUTTON_LAYOUT)) {
    if (button_id == id) {
      if (BUTTON_LAYOUT[button_id].GetChild(0).checked == true) {
        RANK_WINDOW.style.visibility = "visible";
        GameEvents.SendCustomGameEventToServer("request_skill_name_from_panorama", {"id": button_id});
      } else {
        RANK_WINDOW.style.visibility = "collapse";
      }
    } else {
      BUTTON_LAYOUT[button_id].GetChild(0).SetSelected(false);
    }
  }

  for (const [class_id, class_name] of Object.entries(window_position["High"])) {
    RANK_WINDOW.SetHasClass(class_name, class_id == id);
  }
}

function ShowRankTooltip(id, tier, path) {
  // var rank_image = RANK_PANELS[tier][path].GetChild(0);
  // $.DispatchEvent("DOTAShowAbilityTooltip", rank_image, rank_image.abilityname);
}

function HideRankTooltip(id, tier, path) {
  // var rank_image = RANK_PANELS[tier][path].GetChild(0);
  // $.DispatchEvent("DOTAHideAbilityTooltip", rank_image);
}

function OnRankClick(id, tier, path) {
  $.Msg(id, tier, path);
}

function OnMouseIn(id) {
  Game.EmitSound("Config.Move");
}

function OnMouseOut(id) {
}

function CreateLayout(){
  var abilities_panel = $.GetContextPanel().GetParent().GetParent().FindChildTraverse("HUDElements").FindChildTraverse("abilities");
  var lower_hud_panel = $.GetContextPanel().GetParent().GetParent().FindChildTraverse("HUDElements").FindChildTraverse("lower_hud");

  RANK_WINDOW = $.CreatePanel("Panel", lower_hud_panel, "RankWindowRoot");
  RANK_WINDOW.BLoadLayout("file://{resources}/layout/custom_game/rank_system_window.xml", false, false);
  RANK_WINDOW.style.visibility = "collapse";
  RANK_WINDOW_TITLE = RANK_WINDOW.FindChildTraverse("Title");

  for(var tier = 1; tier <= 3; tier++) {
    var tier_panel = RANK_WINDOW.FindChildTraverse("Tier" + tier);
    for(var path = 1; path <= 2; path++) {
      RANK_PANELS[tier] = {};
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
}