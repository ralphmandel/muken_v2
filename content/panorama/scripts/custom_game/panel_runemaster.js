
function OnRunePower(){
    var power = $.GetContextPanel().FindChildTraverse("power");
    power.checked = true;
    $.Msg("teste2")
}

function OnRuneLight(){
    var light = $.GetContextPanel().FindChildTraverse("light");
    light.checked = true;
}

function OnRuneArcane(){
    var arcane = $.GetContextPanel().FindChildTraverse("arcane");
    arcane.checked = true;
}

function OnRuneShadow(){
    var shadow = $.GetContextPanel().FindChildTraverse("shadow");
    shadow.checked = true;
}



(function(){
    $.Msg("teste1")
    Game.AddCommand( "RunePowerCommand", OnRunePower, "", 0 );
    Game.AddCommand( "RuneLightCommand", OnRuneLight, "", 0 );
    Game.AddCommand( "RuneArcaneCommand", OnRuneArcane, "", 0 );
    Game.AddCommand( "RuneShadowCommand", OnRuneShadow, "", 0 );
})()

