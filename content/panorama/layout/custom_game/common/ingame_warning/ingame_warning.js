function CloseWarning(panelName) {
	$("#" + panelName).SetHasClass("hide", true);
}
function ScheludeCloseWarning(time, panelName) {
	$.Schedule(time, () => {
		CloseWarning(panelName);
	});
}
(function () {})();
