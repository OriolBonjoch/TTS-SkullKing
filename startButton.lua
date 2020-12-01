function startButtonClickedCallback(obj, player_clicker_color, alt_click)
  savedData.round = savedData.round + 1
  local roundData = {}
  for index, playerColor in ipairs(getSeatedPlayers()) do
    initPlayer(playerColor)
    savedData.deck.deal(savedData.round, playerColor)
    roundData[playerColor] = { vote = -1 }
    -- for _, data2 in ipairs(Player[playerColor].getHandObjects(1)) do
    --   local cardData2 = savedData.cards[data2.getGUID()]
    --   data2.setDescription(cardData2.name .. " - " .. cardData2.value)
    -- end
  end
  table.insert(savedData.rounds, savedData.round, roundData)
end

function startButtonDraw()
  local button =
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
            click_function = "startButtonClickedCallback",
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

  button.setCustomObject(
    {
      mesh = "https://github.com/OriolBonjoch/TTS-SkullKing/raw/main/data/botonazito_dividido_2mm_origen.obj",
      material = 1,
      convex = true
    }
  )
end
