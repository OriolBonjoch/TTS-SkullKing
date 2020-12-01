function createChestButtons(obj, color)
  obj.createButton(
    {
      click_function = "chestClickedCallback",
      color = color,
      width = 370,
      height = 290,
      position = {x = 0, y = -0.2, z = 0}
    }
  )

  obj.createButton(
    {
      click_function = "chestSubmitCallback",
      color = color,
      width = 370,
      height = 290,
      label = "submit",
      position = {x = 0, y = 0, z = 1},
      rotation = {x = 0, y = 180, z = 0}
    }
  )
end

function chestDraw(playerColor)
  local data = staticData.players[playerColor]
  local chest =
    spawnObject(
    {
      type = "Tileset_Chest",
      position = data.chestPosition,
      rotation = data.chestRotation,
      scale = {x = 2, y = 2, z = 2},
      callback_function = function(obj)
        savedData.chests[playerColor] = obj.getGUID()
        obj.setLock(true)
        obj.setColorTint(data.chestColor)
        createChestButtons(obj, data.chestColor)
      end
    }
  )
end

function chestClickedCallback(obj, player_clicker_color, alt_click)
  if (not chestValidateObject(obj, player_clicker_color)) then
    return
  end

  local oldValue = savedData.votes[player_clicker_color]
  local newValue = oldValue
  if alt_click and oldValue > 0 then
    newValue = oldValue - 1
  elseif (not alt_click and oldValue < savedData.round) then
    newValue = oldValue + 1
  else
    return
  end

  savedData.votes[player_clicker_color] = newValue
  broadcastToColor("You voted " .. newValue, player_clicker_color, player_clicker_color)
end

function chestSubmitCallback(obj, player_clicker_color, alt_click)
  if (not chestValidateObject(obj, player_clicker_color)) then
    return
  end

  savedData.rounds[savedData.round][player_clicker_color].vote = savedData.votes[player_clicker_color]
  broadcastToAll(player_clicker_color .. " voted", player_clicker_color)
  obj.clearButtons()

  for index, playerColor in ipairs(getSeatedPlayers()) do
    if (savedData.rounds[savedData.round][playerColor].vote == -1) then
      return
    end
  end

  startRound()
end

function chestValidateObject(obj, player_clicker_color)
  if (savedData.chests[player_clicker_color] ~= obj.getGUID()) then
    return false
  end

  if (savedData.rounds[savedData.round][player_clicker_color].vote ~= -1) then
    return false
  end
  return true
end