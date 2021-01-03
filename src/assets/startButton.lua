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
      type = "Custom_Model",
      position = {x = 0, y = 1.2, z = -5},
      rotation = {x = 0, y = 180, z = 0},
      callback_function = function(obj)
        obj.setColorTint(Color.Grey)
        obj.setLock(true)
        obj.createButton(
          {
            click_function = "_startButtonClickedCallback",
            label = "Start",
            width = 400,
            height = 300,
            font_size = 100,
            position = {x = 0, y = 0.27, z = 0},
            color = {0.5, 0.5, 0.5},
            font_color = {1, 1, 1}
          }
        )
      end
    }
  )

  self.obj.setCustomObject(
    {
      mesh = "https://github.com/OriolBonjoch/TTS-SkullKing/raw/main/data/botonazito_dividido_2mm_origen.obj",
      material = 1,
      convex = true
    }
  )
end

function _startButtonClickedCallback(obj, playerClickerColor, altClick)
  local getPlayersOrder = function()
    local result = {}
    for _, playerColor in ipairs({ "White", "Red", "Yellow", "Green", "Blue", "Pink"}) do
      local isSeatedPlayer = function(c) return c == playerColor end
      if (table.find(getSeatedPlayers(), isSeatedPlayer)) then
        table.insert(result, playerColor)
      end
    end
    return result
  end

  state.Game = SK_Game.create()
  state.Player = {}
  for index, playerColor in ipairs(getSeatedPlayers()) do
    state.Player[playerColor] = SK_Player.create(playerColor, staticData.players[playerColor])
  end
  state.Game:startBidding()

  Turns.enable = true
  Turns.type = 2
  Turns.pass_turns = false
  Turns.turn_color = table.random(getSeatedPlayers())
  Turns.order = getPlayersOrder()
  obj.destruct()
end

