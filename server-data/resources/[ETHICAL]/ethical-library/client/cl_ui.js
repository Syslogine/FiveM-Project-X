const registered = [];

function RegisterUICallback(name, cb) {
    AddEventHandler(`_npx_uiReq:${name}`, cb);

    if (GetResourceState('ethical-ui') === 'started') exports['ethical-ui'].RegisterUIEvent(name);

    registered.push(name);
}

function SendUIMessage(data) {
    exports['ethical-ui'].SendUIMessage(data);
}

function SetUIFocus(hasFocus, hasCursor) {
    exports['ethical-ui'].SetUIFocus(hasFocus, hasCursor);
}

function GetUIFocus() {
    return exports['ethical-ui'].GetUIFocus();
}

AddEventHandler('_npx_uiReady', () => {
    registered.forEach((eventName) => exports['ethical-ui'].RegisterUIEvent(eventName));
});