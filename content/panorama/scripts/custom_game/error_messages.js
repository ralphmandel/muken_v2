
let newNotification = true
let panelMsg = $.GetContextPanel().FindChildTraverse("ErrorMessages")
let panelText;
//let text = panelMsg.GetChild(panelMsg.GetChildCount() - 1)
let timer;
let interval = 5;
let labels = ["You Can't Target This Tree", "Magic Imune Target"];


(function () {
  GameEvents.Subscribe("error_message_from_server", addErrorMessage);
}
)();

function addErrorMessage(tabela){
  if (panelMsg.GetChild(0)){
    $.CancelScheduled(timer)
    if (panelMsg.BHasClass("PopOutEffect")){
      panelMsg.RemoveClass("PopOutEffect")
    }
    panelMsg.AddClass("PopOutEffect");
    timer = $.Schedule(5, function(){
      panelMsg.RemoveClass("ShowErrorMsg")
      panelMsg.AddClass("Hidden");
      panelText.DeleteAsync(0);
    });
  } else {
    panelText = $.CreatePanel( "Label", panelMsg, "ErrorMsg" );
    panelText.text = labels[tabela.text];
    if (panelMsg.BHasClass("ShowErrorMsg")){
      panelMsg.RemoveClass("ShowErrorMsg")
    } 
    if (panelMsg.BHasClass("PopOutEffect")){
      panelMsg.RemoveClass("PopOutEffect")
    }
    if (panelMsg.BHasClass("Hidden")){
      panelMsg.RemoveClass("Hidden")
    } 
    panelMsg.AddClass("ShowErrorMsg");
    panelMsg.AddClass("PopOutEffect");
    timer = $.Schedule(5, function(){
      panelMsg.RemoveClass("ShowErrorMsg")
      panelMsg.AddClass("Hidden");
      panelText.DeleteAsync(0);
    }); } 
  }
  
  
  
  
  
  // Create Panel properties (type of panel: Panel, Label, etc, the panel which this panel will belong to, panel ID, and table )