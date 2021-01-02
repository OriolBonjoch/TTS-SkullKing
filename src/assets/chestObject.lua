ChestObject = {}
ChestObject.__index = ChestObject

function ChestObject.create()
  local self = setmetatable({}, ChestObject)
  self.obj = nil
  return self
end

function ChestObject:draw(playerColor, data)
  if (self.obj) then
    self.obj.destruct()
  end
  self.obj =
    spawnObject(
    {
      type = "Tileset_Chest",
      position = data.chestPosition,
      rotation = data.chestRotation,
      scale = {x = 2, y = 2, z = 2},
      callback_function = function(obj)
        obj.setLock(true)
        obj.setColorTint(data.chestColor)
        self:_createChestButtons(obj, data.chestColor)
      end
    }
  )
end


function ChestObject:_createChestButtons(obj, color)
  obj.createButton(
    {
      click_function = "_chestClickedCallback",
      color = color,
      width = 370,
      height = 290,
      position = {x = 0, y = -0.2, z = 0}
    }
  )

  obj.createButton(
    {
      click_function = "_chestSubmitCallback",
      color = color,
      width = 370,
      height = 290,
      label = "submit",
      position = {x = 0, y = 0, z = 1},
      rotation = {x = 0, y = 180, z = 0}
    }
  )
end

function _chestClickedCallback(obj, player_clicker_color, alt_click)
  local player = state.Player[player_clicker_color]
  if (not player:canBid(obj)) then
    return
  end

  local vote = (player.vote == -1) and 0 or player.vote
  local newValue = vote
  if alt_click and vote > 0 then
    newValue = vote - 1
  elseif (not alt_click and vote < state.Game.round) then
    newValue = vote + 1
  else
    return
  end

  player:bid(newValue)
end

function _chestSubmitCallback(obj, player_clicker_color, alt_click)
  local player = state.Player[player_clicker_color]
  if (not player:canBid(obj)) then
    return
  end

  player:submitBid()
  broadcastToAll(player_clicker_color .. " voted", player_clicker_color)
  obj.clearButtons()

  local round = state.Game.round
  for color, player in pairs(state.Player) do
    if (player.rounds[round].vote == -1) then
      return
    end
  end

  state.Game:startRound()
end