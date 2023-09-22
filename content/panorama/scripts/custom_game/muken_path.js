PATH_LAYOUT = {};

var path_states = {
  1: "StateDisabled", 2: "StateAvailable", 3: "StateUpgraded",
}

function OnPathClick(id) {
  if (PATH_LAYOUT[id].BHasClass(path_states[2])) {
    Game.EmitSound("Config.Ok");
    GameEvents.SendCustomGameEventToServer("chosen_path_from_panorama", {"path": id});
  }
}

function OnUpdateWindow(event) {
  for (const [id, button] of Object.entries(PATH_LAYOUT)) {
    if (event.path_states[id]) {
      PATH_LAYOUT[id].SetHasClass("StateDisabled", false);
      PATH_LAYOUT[id].SetHasClass("StateAvailable", false);
      PATH_LAYOUT[id].SetHasClass("StateUpgraded", true);
    } else {
      PATH_LAYOUT[id].SetHasClass("StateDisabled", event.path_points == 0);
      PATH_LAYOUT[id].SetHasClass("StateAvailable", event.path_points > 0);
      PATH_LAYOUT[id].SetHasClass("StateUpgraded", false);
    }
  }
}

function CreateLayout(){
  var lower_hud_panel = $.GetContextPanel().GetParent().GetParent().FindChildTraverse("HUDElements").FindChildTraverse("lower_hud");

  PATH_LAYOUT["WindowRoot"] = $.CreatePanel("Panel", lower_hud_panel, "WindowRoot");
  PATH_LAYOUT["WindowRoot"].BLoadLayout("file://{resources}/layout/custom_game/muken_path_window.xml", false, false);

  for(var path = 1; path <= 3; path++) {
    var id = "Path_" + path;
    PATH_LAYOUT[id] = $.CreatePanel("Button", PATH_LAYOUT["WindowRoot"].FindChildTraverse("ButtonContainer"), id);
    PATH_LAYOUT[id].BLoadLayout("file://{resources}/layout/custom_game/muken_path_button.xml", false, false);
    PATH_LAYOUT[id].Data().OnPathClick = OnPathClick;
    //PATH_LAYOUT[id].GetChild(0).abilityname = id;
  }
}

(function(){
  GameEvents.Subscribe("muken_path_layout_from_lua", CreateLayout);
  GameEvents.Subscribe("update_path_window_from_lua", OnUpdateWindow);
})()