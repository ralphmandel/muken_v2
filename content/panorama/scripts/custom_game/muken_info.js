var INFO_WINDOW, INFO_CONTAINER = {}, INFO_LAYOUT = {};
var isWindowOpened = true;
var alt_pressed = false;
var current_info = {};

// LAYOUT CREATION
  function CreateLayout() {
    for (let tab = 1; tab <= 4; tab++) {
      INFO_LAYOUT[tab] = {};
      CreateColumn(tab, "INFO_NAME");
      CreateColumn(tab, "INFO_VALUE");
    }
  }

  function CreateColumn(tab, column) {
    var InfoColumnPanel = $.CreatePanel("Panel", INFO_CONTAINER[tab], "");
    InfoColumnPanel.SetHasClass("InfoColumn", true);
    INFO_LAYOUT[tab][column] = InfoColumnPanel;

    if (tab == 1) {
      CreateRow(tab, column, "attack_damage", '');
      CreateRow(tab, column, "attack_speed", '');
      CreateRow(tab, column, "evasion", '');
      CreateRow(tab, column, "crit_chance", '%');
      CreateRow(tab, column, "crit_damage", '%');
    }
    if (tab == 2) {
      CreateRow(tab, column, "physical_damage", '%');
      CreateRow(tab, column, "armor", '');
      CreateRow(tab, column, "magical_damage", '%');
      CreateRow(tab, column, "magical_resist", '');
      CreateRow(tab, column, "status_resist", '%');
    }
    if (tab == 3) {
      CreateRow(tab, column, "heal_power", '%');
      CreateRow(tab, column, "summon_power", '');
      CreateRow(tab, column, "debuff_amp", '%');
      CreateRow(tab, column, "buff_amp", '%');
      CreateRow(tab, column, "luck", '%');
    }
    if (tab == 4) {
      CreateRow(tab, column, "movespeed", '');
      CreateRow(tab, column, "cd_reduction", '');
      CreateRow(tab, column, "miss_chance", '%');
      CreateRow(tab, column, "current_vision", '');
      CreateRow(tab, column, "heal_amp", '%');
    }
  }

  function CreateRow(tab, column, row, string) {
    var InfoRowPanel = $.CreatePanel("Panel", INFO_LAYOUT[tab][column], "");
    InfoRowPanel.SetHasClass("InfoRow", true);
    INFO_LAYOUT[tab][column][row] = InfoRowPanel;
    INFO_LAYOUT[tab][column][row]["string"] = string;
    
    var titleLabel = $.CreatePanel("Label", InfoRowPanel, "");
    titleLabel.SetHasClass("TitleLabel", true);
    INFO_LAYOUT[tab][column][row]["label"] = titleLabel;

    if (column == "INFO_NAME") {
      titleLabel.text = $.Localize("#tooltip_" + row);
      //INFO_LAYOUT[tab][column][row]["label"].text = row
    }
    if (column == "INFO_VALUE") {
      titleLabel.text = 0 + string;
      titleLabel.SetHasClass("ShadowEffect", true);
    }
  }

// STAT BUTTON
  function OnInfoButtonClick() {
    isWindowOpened = !isWindowOpened;
    INFO_WINDOW.SetHasClass("WindowIn", isWindowOpened);
    Game.EmitSound("General.SelectAction");
  }

// UPDATE FUNCTIONS
  function OnUpdateSelectedUnit() {
    OnUnitInfoUpdate(null);
  }

  function OnUpdateQueryUnit() {
    OnUnitInfoUpdate(null);
  }

  function OnInfoUpdate(event) {
    current_info = event;

    for (const [name, value] of Object.entries(event)) {
      if (name == "unit_name"){
        INFO_BUTTON.GetChild(1).text = $.Localize("#" + value);
      }

      for (let tab = 1; tab <= 4; tab++) {
        for (const [layout_name, layout_value] of Object.entries(INFO_LAYOUT[tab]["INFO_VALUE"])) {
          if (alt_pressed == true && (layout_name == "evasion" || layout_name == "magical_resist" || layout_name == "cd_reduction")) {
            if (name == layout_name + "_percent") {
              var text = FormatValue(value) + "%";
              INFO_LAYOUT[tab]["INFO_VALUE"][layout_name]["label"].text = text; 
            }  
          } else if (name == layout_name) {
            var text = FormatValue(value) + INFO_LAYOUT[tab]["INFO_VALUE"][layout_name]["string"];
            INFO_LAYOUT[tab]["INFO_VALUE"][layout_name]["label"].text = text;            
          }
        }
      }
    }
  }

  function OnUnitInfoUpdate(event) {
    GameEvents.SendCustomGameEventToServer("request_unit_info_from_panorama", {"entity": Players.GetLocalPlayerPortraitUnit()})
  }

  function FormatValue(value) {
    var length = Number(value.toFixed()).toString().length;
    var decimals = 4 - length;
    if (decimals < 0) {decimals = 0}
    if (decimals > 2) {decimals = 2}

    return Number(value.toFixed(decimals))
  }

//INIT
  (function() {
    INFO_BUTTON = $("#InfoButton");
    INFO_WINDOW = $("#InfoContainer");
    INFO_WINDOW.SetHasClass("WindowOut", true);
    INFO_WINDOW.SetHasClass("WindowIn", true);
    INFO_CONTAINER[1] = $("#InfoColumnContainer_1");
    INFO_CONTAINER[2] = $("#InfoColumnContainer_2");
    INFO_CONTAINER[3] = $("#InfoColumnContainer_3");
    INFO_CONTAINER[4] = $("#InfoColumnContainer_4");

    GameEvents.Subscribe("unit_info_from_lua", OnInfoUpdate);
    GameEvents.Subscribe("unit_info_request_from_lua", OnUnitInfoUpdate);
    GameEvents.Subscribe("dota_player_update_selected_unit", OnUpdateSelectedUnit);
    GameEvents.Subscribe("dota_player_update_query_unit", OnUpdateQueryUnit);

    CreateLayout()
    // SetOpenState(isWindowOpened)
  })();

  $.RegisterForUnhandledEvent("DOTAHudUpdate", () => {
    if (GameUI.IsAltDown()) {
      alt_pressed = true;
      OnInfoUpdate(current_info);
    }  
    if (GameUI.IsAltDown() == false) {
      alt_pressed = false;
      OnInfoUpdate(current_info);
    }
  });