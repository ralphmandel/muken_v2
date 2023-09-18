

$.RegisterForUnhandledEvent("DOTAHudUpdate", () => {
    if (GameUI.IsAltDown() && $.GetContextPanel().FindChildTraverse("RankXPLabel").BHasClass("AltPressed") == false) {
        $.GetContextPanel().FindChildTraverse("RankXPLabel").SetHasClass("AltPressed", true);
    }  
    if (GameUI.IsAltDown() == false && $.GetContextPanel().FindChildTraverse("RankXPLabel").BHasClass("AltPressed") == true) {
        $.GetContextPanel().FindChildTraverse("RankXPLabel").RemoveClass("AltPressed");
    }
});