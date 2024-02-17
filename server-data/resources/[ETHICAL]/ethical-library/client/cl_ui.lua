local registered = {}

function RegisterUICallback(name, cb)
  local function interceptCb(data, innerCb)
    cb(data, function(result)
      if result.meta.ok then
        result.meta.message = "done"
      end
      innerCb(result)
    end)
  end
  AddEventHandler(('_npx_uiReq:%s'):format(name), interceptCb)

  if (GetResourceState("ethical-ui") == "started") then exports["ethical-ui"]:RegisterUIEvent(name) end

  registered[#registered + 1] = name
end

function SendUIMessage(data)
  exports["ethical-ui"]:SendUIMessage(data)
end

function SetUIFocus(hasFocus, hasCursor)
  exports["ethical-ui"]:SetUIFocus(hasFocus, hasCursor)
end

function GetUIFocus()
  return exports["ethical-ui"]:GetUIFocus()
end

AddEventHandler("_npx_uiReady", function()
  for _, eventName in ipairs(registered) do
    exports["ethical-ui"]:RegisterUIEvent(eventName)
  end
end)
