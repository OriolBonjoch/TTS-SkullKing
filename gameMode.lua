GameMode = {}
GameMode.__index = GameMode

function GameMode.create(isHotSeat)
  local self = setmetatable({}, GameMode)
  self.isHotSeat = isHotSeat or false
  return self
end

function GameMode:start()
  Turns.order = createInitialOrder()
  Turns.pass_turns = false
  if (self.isHotSeat) then
    Turns.enable = true
    Turns.turn_color = Turns.order[1]
  end
end

function GameMode:startRound()
  if (self.isHotSeat) then
    Turns.enable = true
  end
end

function GameMode:startBidding()
  if (self.isHotSeat) then
    Turns.enable = false
  end
end

function GameMode:isPlayerTurn(playerColor)
  if (self.isHotSeat) then
    -- HotSeat is buggy
    return true
  end

  if (not Turns.enable) then
    return true
  end

  return Turns.turn_color == playerColor
end

function GameMode:submitBid()
  if (self.isHotSeat) then
    Turns.turn_color = Turns.getNextTurnColor()
  end
end

function GameMode:playCard()
  if (self.isHotSeat) then
    Turns.turn_color = Turns.getNextTurnColor()
  end
end