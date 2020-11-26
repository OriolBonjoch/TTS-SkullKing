function startClickFunc(obj, player_clicker_color, alt_click)
  savedData.round = savedData.round + 1
  local roundData = {}
  for index, playerColor in ipairs(getSeatedPlayers()) do
    savedData.deck.deal(savedData.round, playerColor)
    initPlayer(playerColor)
    roundData[playerColor] = { vote = -1 }
    -- for _, data2 in ipairs(Player[playerColor].getHandObjects(1)) do
    --   local cardData2 = savedData.cards[data2.getGUID()]
    --   data2.setDescription(cardData2.name .. " - " .. cardData2.value)
    -- end
  end

  table.insert(savedData.rounds, savedData.round, roundData)
end

function createStartButton()
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
            click_function = "startClickFunc",
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
      mesh = "file:///C:\\Users\\Oriol\\Documents\\tabletop\\botonazito_dividido_2mm_origen.obj",
      material = 1,
      convex = true
    }
  )
  savedData.firstPlayer = savedData.order[1]
end

function initPlayer(playerColor)
  savedData.votes[playerColor] = 0
  createChest(playerColor)
end