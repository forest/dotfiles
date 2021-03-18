hs.loadSpoon("WinWin")

-- hs.hotkey.bind({"cmd", "alt", "ctrl"}, "Left", function()
--   WinWin:moveAndResize("halfleft")
-- end)

hs.hotkey.bind({"cmd", "ctrl"}, "Left", function()
  spoon.WinWin:moveAndResize("halfleft")
end)

hs.hotkey.bind({"cmd", "ctrl"}, "Right", function()
  spoon.WinWin:moveAndResize("halfright")
end)

hs.hotkey.bind({"cmd", "ctrl"}, "Up", function()
  spoon.WinWin:moveAndResize("center")
end)

hs.hotkey.bind({"cmd", "ctrl"}, "Down", function()
  spoon.WinWin:moveAndResize("shrink")
end)

hs.hotkey.bind({"cmd", "alt", "ctrl"}, "Right", function()
  spoon.WinWin:moveAndResize("cornerNE")
end)

hs.hotkey.bind({"cmd", "alt", "ctrl"}, "Left", function()
  spoon.WinWin:moveAndResize("cornerNW")
end)

hs.hotkey.bind({"cmd", "alt", "ctrl"}, "Down", function()
  spoon.WinWin:moveAndResize("maximize")
end)

hs.hotkey.bind({"cmd", "alt"}, "Right", function()
  spoon.WinWin:moveToScreen("next")
end)


