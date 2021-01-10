StartButton = {}
StartButton.__index = StartButton

function StartButton.create()
  local self = setmetatable({}, StartButton)
  self.obj = nil
  return self
end

function StartButton:draw()
  local button = self
  self.obj =
    spawnObject(
    {
      type = "Quarter",
      position = {x = 0, y = 1.2, z = -5},
      rotation = {x = 0, y = 180, z = 0}
    }
  )
end

function StartButton:showPrompt()
  if (state.Interface and state.Interface:hasGame()) then return end
  state.Interface.ScoreBoard:setData("")
  state.Interface.Start:show()
end

function _startGameMenuClicked()
  for index, obj in ipairs(getAllObjects()) do
    obj.destruct()
  end

  state.StartButton = StartButton.create()
  state.Deck = Deck.create()
  state.Interface = SK_Interface.create()
  state.Interface.ScoreBoard:setData("")

  state.StartButton:draw()
  state.Deck:draw()
  state.Game = SK_Game.create()
end