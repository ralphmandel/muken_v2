var DISABLE_RESET_TALENTS_BTN = true

var TALENTS_CONTAINER, TALENTS_WINDOW, ROWS_DATA;
var TALENTS_LAYOUT = {
    "lastColumn": -1
};

var talentsData = {
    "talentsCount": 0,
};

// init talents
function OnTalentsData(event) {
    // $.Msg(event);
    // $.Msg(Object.keys(event.talents).length);
    // var parsedTalents = JSON.parse(event.talents);
    // for(var i=1; i <= Object.keys(event.talents).length; i++) {
        ROWS_DATA = event.rows
        talentsData = event.talents
    // }
    BuildTalentTree(event);
    talentsData.talentsCount = Object.keys(event.talents).length;
    // if(talentsData.talentsCount >= event.count) {
	    GameEvents.SendCustomGameEventToServer( "talent_tree_get_state", {});
	    //TALENTS_LAYOUT[TALENTS_LAYOUT["lastColumn"]].SetHasClass("last", true);
    // }
}

// update talents
function OnTalentsState(event) {
    var talentPoints = event.points;
    var parsedStateData = JSON.parse(event.talents);
    for(var i=0; i < parsedStateData.length; i++) {
        var talentId = parsedStateData[i].id;
        talentsData[talentId].panel.SetHasClass("hidden", parsedStateData[i].hidden);
        talentsData[talentId].panel.SetHasClass("disabled", parsedStateData[i].disabled);
        talentsData[talentId].panel.SetHasClass("upgraded", parsedStateData[i].upgraded);
        talentsData[talentId].panel.levelLabel.text = parsedStateData[i].level + " / " + parsedStateData[i].maxlevel;
    }
    TALENTS_LAYOUT["TalentPointsLabel"].text = 'RANK POINTS: ' + talentPoints;//$.Localize("talent_tree_current_talent_points").replace("%POINTS%", talentPoints);
	
	//если есть поинтов нет прячем верхнюю картинку, если есть - анонируем, простите анимируем то есть
	var hasZeroTalentPoints = talentPoints <= 0
	$("#TalentTreeWindowButtonActiveImage").SetHasClass("hide", hasZeroTalentPoints)
	$("#TalentTreeWindowButtonActiveImage").SetHasClass("Animate", !hasZeroTalentPoints)
}

function OnResetState(event) {
    for(var column=1; column <= 3; column++) {
        for(var rows=1; rows <= 5; rows++) {
            TALENTS_LAYOUT[column][rows].RemoveAndDeleteChildren()
        }
    }
    talentsData = {"talentsCount": 0};
}

function BuildTalentTree(data) {
  for (var key in data.talents) {
    var talentColumn = data.talents[key].Tab;
    var talentRow = data.rows[data.talents[key].RankLevel];

    CreateTalentPanel(talentRow, talentColumn, key);
  }
}

function CreateTalentPanel(row, column, talentId) {
  if (TALENTS_LAYOUT[column]) {
    if (TALENTS_LAYOUT[column][row]) {
      if (column != 0 || TALENTS_LAYOUT[column][row].GetChildCount() < 1) {
        var talentPanel = $.CreatePanel("Panel", TALENTS_LAYOUT[column][row], "HeroTalent" + talentId);
        talentPanel.BLoadLayout("file://{resources}/layout/custom_game/talent.xml", false, false);
        talentPanel.hittest = true;
        talentPanel.hittestchildren = false;
        talentPanel.Data().ShowTalentTooltip = ShowTalentTooltip;
        talentPanel.Data().HideTalentTooltip = HideTalentTooltip;
        talentPanel.Data().OnTalentClick = OnTalentClick;
        var talentImagePanel = talentPanel.FindChildTraverse("TalentImage");
        if(talentImagePanel) {
          talentImagePanel.abilityname = talentsData[talentId].Ability;
        }
        if(column > TALENTS_LAYOUT["lastColumn"]) {
          TALENTS_LAYOUT["lastColumn"] = column;
        }
        talentsData[talentId].panel = talentPanel;
        talentsData[talentId].panel.levelLabel = talentPanel.FindChildTraverse("TalentLevel");
      }
    }
  } else {
    var talentColumnPanel = $.CreatePanel("Panel", TALENTS_CONTAINER, "");
    talentColumnPanel.SetHasClass("TalentTreeColumn", true);
    TALENTS_LAYOUT[column] = talentColumnPanel;
    talentColumnPanel.hittest = false;
    talentColumnPanel.hittestchildren = true;
    CreateTalentRows(column);
    CreateTalentPanel(row, column, talentId);
  }
}

function CreateTalentRows(column) {
  if (TALENTS_LAYOUT[column]) {
    var talentRowTitlePanel = $.CreatePanel("Panel", TALENTS_LAYOUT[column], "");
    talentRowTitlePanel.SetHasClass("TalentTreeRow", true);
    var titleLabel = $.CreatePanel("Label", talentRowTitlePanel, "");
    titleLabel.SetHasClass("TitleLabel", true);
    titleLabel.text = $.Localize("#talent_tree_column_" + column + "_title");
    talentRowTitlePanel.hittest = false;
    talentRowTitlePanel.hittestchildren = true;
    for (var key in ROWS_DATA) {
      var talentRowPanel = $.CreatePanel("Panel", TALENTS_LAYOUT[column], "");
      talentRowPanel.SetHasClass("TalentTreeRow", true);
      TALENTS_LAYOUT[column][ROWS_DATA[key]] = talentRowPanel;
    }
  }
}

function ShowTalentTooltip(talentId, hidden) {
  if (!hidden) {
    Game.EmitSound("Config.Move");
    var locID = Players.GetLocalPlayer();
    var hero = Players.GetPlayerHeroEntityIndex(locID);
    var ability = Entities.GetAbilityByName( hero, talentsData[talentId].Ability );
    var lvl = Abilities.GetLevel(ability) || 0;
    $.DispatchEvent("DOTAShowAbilityTooltipForLevel", $("#HeroTalent" + talentId), talentsData[talentId].Ability, lvl );
  }
}

function HideTalentTooltip(talentId) {
    $.DispatchEvent("DOTAHideAbilityTooltip", $("#HeroTalent" + talentId));
}

function OnTalentClick(talentId, disabled, upgraded) {
    if(disabled == false && upgraded == false) {
        GameEvents.SendCustomGameEventToServer( "talent_tree_level_up_talent", {"id": talentId});
        Game.EmitSound("Config.Ok");
    }
}

function OnResetTalentsButtonClick() {
    GameEvents.SendCustomGameEventToServer( "talent_tree_reset_talents", {});
    Game.EmitSound("General.SelectAction");
}

var isWindowOpened = false;

function OnTalentTreeWindowButtonClick() {
    if(isWindowOpened == true) {
        //TALENTS_WINDOW.style.visibility = "collapse";
		    TALENTS_WINDOW.GetParent().hittest = false
        TALENTS_WINDOW.SetHasClass("WindowIn", true)
    } else {
        //TALENTS_WINDOW.style.visibility = "visible";
        //************************************* */

    		// TALENTS_WINDOW.GetParent().hittest = true
        // TALENTS_WINDOW.SetHasClass("WindowIn", false)

        //************************************* */
        // TALENTS_LAYOUT[1][3].RemoveAndDeleteChildren()
        // for(var column=1; column <= 3; column++) {
        //     for(var rows=1; rows <= 5; rows++) {
        //         TALENTS_LAYOUT[column][rows].RemoveAndDeleteChildren()
        //     }
        // }
        // talentsData = {"talentsCount": 0};
        //TALENTS_LAYOUT = {"lastColumn": -1};
        //GameEvents.SendCustomGameEventToServer( "talent_tree_get_talents", {});
	    GameEvents.SendCustomGameEventToServer( "talent_tree_get_state", {});
    }
    isWindowOpened = !isWindowOpened;
    Game.EmitSound("General.SelectAction");
}

(function() {
    TALENTS_WINDOW = $("#TalentsWindowContainer")
    TALENTS_WINDOW.SetHasClass("WindowOut", true)
    TALENTS_WINDOW.SetHasClass("WindowIn", true)
    TALENTS_CONTAINER = $("#TalentTreeColumnsContainer");
    TALENTS_LAYOUT["TalentPointsLabel"] = $("#CurrentTalentPoints");
	
    GameEvents.Subscribe("talent_tree_get_talents_from_server", OnTalentsData);
    GameEvents.Subscribe("talent_tree_get_state_from_server", OnTalentsState);
    GameEvents.Subscribe("reset_state_from_server", OnResetState);
	
	//GameEvents.SendCustomGameEventToServer( "talent_tree_get_talents", {});
	
	TALENTS_WINDOW.FindChildTraverse("TalentsResetButton").SetHasClass("hide", DISABLE_RESET_TALENTS_BTN)
})();

