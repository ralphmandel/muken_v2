var RANK_WINDOW, BUTTON_LAYOUT = {};

var window_position = {
  "Low": {
    "RankButton0": "ContainerPosLow0",
    "RankButton1": "ContainerPosLow1",
    "RankButton2": "ContainerPosLow2",
    "RankButton3": "ContainerPosLow3",
  },
  "Mid": {
    "RankButton0": "ContainerPosMid0",
    "RankButton1": "ContainerPosMid1",
    "RankButton2": "ContainerPosMid2",
    "RankButton3": "ContainerPosMid3",
    "RankButton4": "ContainerPosMid4",
  },
  "High": {
    "RankButton0": "ContainerPosHigh0",
    "RankButton1": "ContainerPosHigh1",
    "RankButton2": "ContainerPosHigh2",
    "RankButton3": "ContainerPosHigh3",
    "RankButton4": "ContainerPosHigh4",
    "RankButton5": "ContainerPosHigh5",
  },
};

(function(){
  GameEvents.Subscribe("ranks_layout_from_lua", CreateLayout);
  //CreateLayout();
})()

function OnRankButtonClick(id) {
  Game.EmitSound("General.SelectAction");

  for (const [button_id, button] of Object.entries(BUTTON_LAYOUT)) {
    if (button_id == id) {
      if (BUTTON_LAYOUT[button_id].GetChild(0).checked == true) {
        RANK_WINDOW.style.visibility = "visible";
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

function CreateLayout(){
  var abilities_panel = $.GetContextPanel().GetParent().GetParent().FindChildTraverse("HUDElements").FindChildTraverse("abilities");
  var lower_hud_panel = $.GetContextPanel().GetParent().GetParent().FindChildTraverse("HUDElements").FindChildTraverse("lower_hud");

  RANK_WINDOW = $.CreatePanel("Panel", lower_hud_panel, "RankWindowRoot");
  RANK_WINDOW.BLoadLayout("file://{resources}/layout/custom_game/rank_system_window.xml", false, false);
  RANK_WINDOW.SetHasClass("ContainerPosHigh0", true);
  RANK_WINDOW.style.visibility = "collapse";

  for(var i = 0; i <= abilities_panel.GetChildCount() - 1; i++) {
    var button_id = "RankButton" + i;
    BUTTON_LAYOUT[button_id] = $.CreatePanel("Panel", abilities_panel.GetChild(i), button_id);
    BUTTON_LAYOUT[button_id].BLoadLayout("file://{resources}/layout/custom_game/rank_system_button.xml", false, false);
    BUTTON_LAYOUT[button_id].hittest = true;
    BUTTON_LAYOUT[button_id].Data().OnRankButtonClick = OnRankButtonClick;

    abilities_panel.GetChild(i).MoveChildBefore(BUTTON_LAYOUT[button_id], abilities_panel.GetChild(i).FindChildTraverse("ButtonAndLevel"));
    abilities_panel.GetChild(i).FindChildTraverse("LevelUp0").style.visibility = "collapse";
  }
}