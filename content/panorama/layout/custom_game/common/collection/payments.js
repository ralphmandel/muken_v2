function ClosePayment() {
	$("#PaymentWindow").SetHasClass("Hidden", true);
}

/** @param {"closed" | "loading" | "html" | { error: string }} state */
function setPaymentWindowStatus(state) {
	const hid = $("#PaymentWindow").BHasClass("Hidden");
	const visible = state !== "closed";
	$("#PaymentWindow").SetHasClass("Hidden", !visible);
	$("#PaymentWindowHTML_Loading").visible = state == "html";
	GameEvents.SendCustomGameEventToServer("payments:window", { visible });
	$("#PaymentWindowLoader").visible = state === "loading";
	$("#PaymentWindowHTML").visible = state === "html";
	const isError = typeof state === "object";
	$("#PaymentWindowError").visible = isError;
	if (isError) {
		$("#PaymentWindow").SetHasClass("Hidden", hid);
		$("#PaymentWindowErrorMessage").text = state.error;
	}
}

const createPaymentRequest = createEventRequestCreator("payments:create");

/** @type {GameEventListenerID} */
let paymentWindowUpdateListener;
/** @type {ScheduleID} */
let paymentWindowPostUpdateTimer;

function UpdateGiftCodeState() {
	isGiftCode = giftCodeChecker.IsSelected();
}

/** @type {"wechat" | "alipay" | "checkout"} */
function updatePaymentWindow(method) {
	/** @type {"Purchase1" | "Purchase2"} */
	$.Msg("Payment kind: " + paymentKind);
	if (!method) return;

	if (paymentWindowUpdateListener != null) {
		GameEvents.Unsubscribe(paymentWindowUpdateListener);
		paymentWindowUpdateListener = undefined;
	}

	if (paymentWindowPostUpdateTimer != null) {
		$.CancelScheduled(paymentWindowPostUpdateTimer);
		paymentWindowPostUpdateTimer = undefined;
	}

	setPaymentWindowStatus("loading");

	paymentWindowUpdateListener = createPaymentRequest({ method, paymentKind, isGiftCode }, (response) => {
		if (response.url == null) {
			setPaymentWindowStatus({ error: response.error || "Unknown error" });
			return;
		}

		if (method === "checkout") {
			const openBrowser = () => $.DispatchEvent("ExternalBrowserGoToURL", response.url);
			openBrowser();
			setPaymentWindowStatus("closed");
		} else {
			$("#PaymentWindowHTML").SetURL(response.url);
			paymentWindowPostUpdateTimer = $.Schedule(1, () => {
				paymentWindowPostUpdateTimer = undefined;
				setPaymentWindowStatus("html");
			});
		}
		SetPaymentVisible(false);
	});
}

setPaymentWindowStatus("closed");

function OpenPatreonURL() {
	$.DispatchEvent("ExternalBrowserGoToURL", "https://www.patreon.com/dota2unofficial");
	SetPaymentVisible(false);
}
GameEvents.Subscribe("payments:update", (response) => {
	if (response.error) {
		setPaymentWindowStatus({ error: response.error });
	} else {
		setPaymentWindowStatus("closed");
	}
});
