GameUI.CustomUIConfig().team_logo_xml = "file://{resources}/layout/custom_game/muken_team_icon.xml";
GameUI.CustomUIConfig().team_logo_large_xml = "file://{resources}/layout/custom_game/muken_team_icon_large.xml";
GameUI.CustomUIConfig().multiteam_top_scoreboard =
{
  reorder_team_scores: true,
  LeftInjectXMLFile: "file://{resources}/layout/custom_game/muken_goal.xml",
  TeamOverlayXMLFile: "file://{resources}/layout/custom_game/muken_goal_team_overlay.xml"
};

var NoTalents = $.GetContextPanel().GetParent().GetParent().FindChildTraverse("HUDElements").FindChildTraverse("lower_hud").FindChildTraverse("center_with_stats").FindChildTraverse("center_block");
var NoTalentGlow = $.GetContextPanel().GetParent().GetParent().FindChildTraverse("HUDElements").FindChildTraverse("lower_hud").FindChildTraverse("center_with_stats").FindChildTraverse("center_block");
var NoAghanimsPanel = $.GetContextPanel().GetParent().GetParent().FindChildTraverse("HUDElements").FindChildTraverse("lower_hud");
var NoDotaPlus = $.GetContextPanel().GetParent().GetParent().FindChildTraverse("PreGame").FindChildTraverse("BottomPanelsContainer");
var HeroDescription = $.GetContextPanel().GetParent().GetParent().FindChildTraverse("PreGame").FindChildTraverse("MainContents").FindChildTraverse("ScreenContainer").FindChildTraverse("HeroPickScreen").FindChildTraverse("HeroInspect");
var NoFilter = $.GetContextPanel().GetParent().GetParent().FindChildTraverse("PreGame").FindChildTraverse("MainContents").FindChildTraverse("HeroGrid");
var NoMiniMap = $.GetContextPanel().GetParent().GetParent().FindChildTraverse("PreGame").FindChildTraverse("BottomPanelsContainer");
var NoDotaTeams = $.GetContextPanel().GetParent().GetParent().FindChildTraverse("PreGame").FindChildTraverse("Header");
var TimeofDay = $.GetContextPanel().GetParent().GetParent().FindChildTraverse("HUDElements").FindChildTraverse("topbar");
var HeroPanel = $.GetContextPanel().GetParent().GetParent().FindChildTraverse("HUDElements").FindChildTraverse("lower_hud");
var Killcountbar = $.GetContextPanel().GetParent().GetParent().FindChildTraverse("HUDElements").FindChildTraverse("stackable_side_panels");
var Glyph = $.GetContextPanel().GetParent().GetParent().FindChildTraverse("HUDElements").FindChildTraverse("minimap_container");
var Killcam = $.GetContextPanel().GetParent().GetParent().FindChildTraverse("HUDElements").FindChildTraverse("KillCam");
var NoStrategyScreen = $.GetContextPanel().GetParent().GetParent().FindChildTraverse("PreGame").FindChildTraverse("MainContents").FindChildTraverse("ScreenContainer").FindChildTraverse("StrategyScreen");
var RightColumnHeight = $.GetContextPanel().GetParent().GetParent().FindChildTraverse("PreGame").FindChildTraverse("MainContents").FindChildTraverse("ScreenContainer").FindChildTraverse("HeroPickScreen").FindChildTraverse("MainHeroPickScreenContents");
var mukenLogo = $.GetContextPanel().GetParent().GetParent().FindChildTraverse("PreGame").FindChildTraverse("ToGameTransition").FindChildTraverse("MiddleLogo");
//FindChildrenWithClassTraverse

mukenLogo.style.backgroundImage = "url('file://{images}/custom_game/muken_logo.png')";
NoTalents.FindChildTraverse("StatBranch").style.visibility = "collapse";
NoTalentGlow.FindChildTraverse("level_stats_frame").style.visibility = "collapse";
NoAghanimsPanel.FindChildTraverse("AghsStatusContainer").style.visibility = "collapse";
NoDotaPlus.FindChildTraverse("BottomPanels").style.visibility = "collapse";
NoFilter.FindChildTraverse("Footer").style.visibility = "collapse";
NoMiniMap.FindChildTraverse("PreMinimapContainer").style.visibility = "collapse";
NoDotaTeams.FindChildTraverse("RadiantTeamPlayers").style.visibility = "collapse";
NoDotaTeams.FindChildTraverse("DireTeamPlayers").style.visibility = "collapse";
Glyph.FindChildTraverse("GlyphScanContainer").style.visibility = "collapse";
Glyph.FindChildTraverse("minimap_block").style.boxShadow = "0px 0px 10px 1px #000000de";
HeroDescription.FindChildTraverse("HeroSimpleDescription").style.visibility = "collapse";
NoStrategyScreen.FindChildTraverse("RightContainer").style.visibility = "collapse";
RightColumnHeight.FindChildTraverse("HeroPickRightColumn").style.height = "990px";
var HeroInspect = RightColumnHeight.FindChildrenWithClassTraverse("HeroInspectContainer");
  HeroInspect.forEach(HeroInspectContainer => {
  HeroInspectContainer.style.height = "730px";
});
// Time Panel:

TimeofDay.FindChildTraverse("TimeOfDayBG").style.backgroundImage = "url('file://{images}/custom_game/bg_timer_edited.png')";
TimeofDay.FindChildTraverse("TimeOfDayBG").style.height = "65px";
TimeofDay.FindChildTraverse("TimeOfDayBG").style.width = "75px";

TimeofDay.FindChildTraverse("TimeOfDayBG").style.boxShadow = "0px 0px 5px -5px #000000de";
TimeofDay.FindChildTraverse("TimeUntil").style.verticalAlign = "center";
TimeofDay.FindChildTraverse("TimeUntil").style.marginLeft = "210px";
TimeofDay.FindChildTraverse("TimeUntil").style.marginTop = "-15px";
TimeofDay.FindChildTraverse("TimeOfDay").style.height = "55px";
TimeofDay.FindChildTraverse("TimeOfDay").FindChildTraverse("DayNightCycle").style.height = "33px";
TimeofDay.FindChildTraverse("TimeOfDay").FindChildTraverse("DayNightCycle").style.width = "33px";

TimeofDay.FindChildTraverse("GameTime").style.fontSize = "16px";
TimeofDay.FindChildTraverse("GameTime").style.marginBottom = "0px";

var TimerAdjust = TimeofDay.FindChildTraverse("TimeOfDay").FindChildTraverse("DayNightCycle").FindChildrenWithClassTraverse("TimeOfDayIcon");
TimeofDay.style.position = "-920px 50px 0px";
TimeofDay.style.margin = "0px 0px 0px 0px";
TimeofDay.style.width = "400px";
TimeofDay.style.height = "150px";
TimerAdjust.forEach(TimeOfDayIcon => {
  TimeOfDayIcon.style.width = "33px";
  TimeOfDayIcon.style.height = "33px";
});

//.FindChildrenWithClassTraverse("HeroCard")

if (Killcam) {
Killcam.style.marginTop = "438px";
};

//Hero Bottom Panel
HeroPanel.FindChildTraverse("left_flare").style.backgroundImage = "url('s2r://panorama/images/hud/reborn/hud_custom_ti10/side_flare_tall_psd.vtex')";
HeroPanel.FindChildTraverse("right_flare").style.backgroundImage = "url('s2r://panorama/images/hud/reborn/hud_custom_ti10/right_flare_bg_psd.vtex')";
HeroPanel.FindChildTraverse("center_bg").style.backgroundImage = "url('s2r://panorama/images/hud/reborn/hud_custom_ti10/ability_bg_psd.vtex')";
//HeroPanel.FindChildTraverse("InventoryBG").style.backgroundImage = "url('s2r://panorama/images/hud/reborn/hud_custom_ti10/inventory_bg_psd.vtex')";
//HeroPanel.FindChildTraverse("inventory_items").style.backgroundImage = "url('s2r://panorama/images/hud/reborn/hud_custom_ti10/inventory_bg_psd.vtex')";
//HeroPanel.FindChildTraverse("inventory_items").style.visibility = "collapse";
HeroPanel.FindChildTraverse("inventory_slot_2").style.visibility = "collapse";
HeroPanel.FindChildTraverse("inventory_slot_5").style.visibility = "collapse";
HeroPanel.FindChildTraverse("inventory").style.width = "138px";
HeroPanel.FindChildTraverse("inventory").style.marginRight = "140px";
HeroPanel.FindChildTraverse("inventory_backpack_list").style.visibility = "collapse";
HeroPanel.FindChildTraverse("right_flare").style.marginRight = "48px";
HeroPanel.FindChildTraverse("inventory_composition_layer_container").style.marginRight = "91px";

HeroPanel.FindChildTraverse("stragiint").style.visibility = "collapse";
Killcountbar.FindChildTraverse("quickstats").style.visibility = "collapse";
// Uncomment any of the following lines in order to disable that portion of the default UI

//GameUI.SetDefaultUIEnabled( DotaDefaultUIElement_t.DOTA_DEFAULT_UI_TOP_TIMEOFDAY, false );      //Time of day (clock).
GameUI.SetDefaultUIEnabled( DotaDefaultUIElement_t.DOTA_DEFAULT_UI_TOP_HEROES, false );     //Heroes and team score at the top of the HUD.
GameUI.SetDefaultUIEnabled( DotaDefaultUIElement_t.DOTA_DEFAULT_UI_FLYOUT_SCOREBOARD, false );      //Lefthand flyout scoreboard.
//GameUI.SetDefaultUIEnabled( DotaDefaultUIElement_t.DOTA_DEFAULT_UI_ACTION_PANEL, false );     //Hero actions UI.
//GameUI.SetDefaultUIEnabled( DotaDefaultUIElement_t.DOTA_DEFAULT_UI_ACTION_MINIMAP, false );     //Minimap.
//GameUI.SetDefaultUIEnabled( DotaDefaultUIElement_t.DOTA_DEFAULT_UI_INVENTORY_PANEL, false );      //Entire Inventory UI
GameUI.SetDefaultUIEnabled( DotaDefaultUIElement_t.DOTA_DEFAULT_UI_INVENTORY_SHOP, false );     //Shop portion of the Inventory. 
GameUI.SetDefaultUIEnabled( DotaDefaultUIElement_t.DOTA_DEFAULT_UI_INVENTORY_ITEMS, false );      //Player items.
GameUI.SetDefaultUIEnabled( DotaDefaultUIElement_t.DOTA_DEFAULT_UI_INVENTORY_QUICKBUY, false );     //Quickbuy.
GameUI.SetDefaultUIEnabled( DotaDefaultUIElement_t.DOTA_DEFAULT_UI_INVENTORY_COURIER, false );      //Courier controls.
GameUI.SetDefaultUIEnabled( DotaDefaultUIElement_t.DOTA_DEFAULT_UI_INVENTORY_PROTECT, false );      //Glyph.
GameUI.SetDefaultUIEnabled( DotaDefaultUIElement_t.DOTA_DEFAULT_UI_INVENTORY_GOLD, false );     //Gold display.
GameUI.SetDefaultUIEnabled( DotaDefaultUIElement_t.DOTA_DEFAULT_UI_SHOP_SUGGESTEDITEMS, false );      //Suggested items shop panel.
//GameUI.SetDefaultUIEnabled( DotaDefaultUIElement_t.DOTA_DEFAULT_UI_HERO_SELECTION_TEAMS, false );     //Hero selection Radiant and Dire player lists.
//GameUI.SetDefaultUIEnabled( DotaDefaultUIElement_t.DOTA_DEFAULT_UI_HERO_SELECTION_GAME_NAME, false );     //Hero selection game mode name display.
//GameUI.SetDefaultUIEnabled( DotaDefaultUIElement_t.DOTA_DEFAULT_UI_HERO_SELECTION_CLOCK, false );     //Hero selection clock.
//GameUI.SetDefaultUIEnabled( DotaDefaultUIElement_t.DOTA_DEFAULT_UI_TOP_MENU_BUTTONS, false );     //Top-left menu buttons in the HUD.
//GameUI.SetDefaultUIEnabled( DotaDefaultUIElement_t.DOTA_DEFAULT_UI_ENDGAME, false );      //Endgame scoreboard.    
//GameUI.SetDefaultUIEnabled( DotaDefaultUIElement_t.DOTA_DEFAULT_UI_TOP_BAR_BACKGROUND, false );     //Top-left menu buttons in the HUD.

// These lines set up the panorama colors used by each team (for game select/setup, etc)
GameUI.CustomUIConfig().team_colors = {}
GameUI.CustomUIConfig().team_colors[DOTATeam_t.DOTA_TEAM_NEUTRALS] = "#cccccc;";
GameUI.CustomUIConfig().team_colors[DOTATeam_t.DOTA_TEAM_CUSTOM_1] = "#ac0020;";
GameUI.CustomUIConfig().team_colors[DOTATeam_t.DOTA_TEAM_CUSTOM_2] = "#3dd296;";
GameUI.CustomUIConfig().team_colors[DOTATeam_t.DOTA_TEAM_CUSTOM_3] = "#8c2af4;";
GameUI.CustomUIConfig().team_colors[DOTATeam_t.DOTA_TEAM_CUSTOM_4] = "#c7e40d;";
GameUI.CustomUIConfig().team_colors[DOTATeam_t.DOTA_TEAM_CUSTOM_5] = "#4285f4;";
GameUI.CustomUIConfig().team_colors[DOTATeam_t.DOTA_TEAM_CUSTOM_6] = "#bd42fb;";
GameUI.CustomUIConfig().team_colors[DOTATeam_t.DOTA_TEAM_CUSTOM_7] = "#fbcc42;";

GameUI.CustomUIConfig().team_icons = {}
GameUI.CustomUIConfig().team_icons[DOTATeam_t.DOTA_TEAM_CUSTOM_1] = "file://{resources}/images/custom_game/skull_color45.png";
GameUI.CustomUIConfig().team_icons[DOTATeam_t.DOTA_TEAM_CUSTOM_2] = "file://{resources}/images/custom_game/leaf_color45.png";
GameUI.CustomUIConfig().team_icons[DOTATeam_t.DOTA_TEAM_CUSTOM_3] = "file://{resources}/images/custom_game/moon_color45.png";
GameUI.CustomUIConfig().team_icons[DOTATeam_t.DOTA_TEAM_CUSTOM_4] = "file://{resources}/images/custom_game/sun_color45.png";

//GameUI.CustomUIConfig().team_colors[DOTATeam_t.DOTA_TEAM_CUSTOM_1] = "#3dd296;";
//GameUI.CustomUIConfig().team_colors[DOTATeam_t.DOTA_TEAM_CUSTOM_2] = "#F3C909;";
//GameUI.CustomUIConfig().team_colors[DOTATeam_t.DOTA_TEAM_CUSTOM_3] = "#c54da8;";
//GameUI.CustomUIConfig().team_colors[DOTATeam_t.DOTA_TEAM_CUSTOM_4] = "#FF6C00;";
//GameUI.CustomUIConfig().team_colors[DOTATeam_t.DOTA_TEAM_CUSTOM_5] = "#c7e40d;";
//GameUI.CustomUIConfig().team_colors[DOTATeam_t.DOTA_TEAM_CUSTOM_6] = "#8c2af4;";
//GameUI.CustomUIConfig().team_colors[DOTATeam_t.DOTA_TEAM_CUSTOM_7] = "#815336;";
//GameUI.CustomUIConfig().team_colors[DOTATeam_t.DOTA_TEAM_CUSTOM_8] = "#1bc0d8;";
//GameUI.CustomUIConfig().team_colors[DOTATeam_t.DOTA_TEAM_CUSTOM_9] = "#c7e40d;";
//GameUI.CustomUIConfig().team_colors[DOTATeam_t.DOTA_TEAM_CUSTOM_10] = "#8c2af4;";