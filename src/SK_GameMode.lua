SK_GameMode = {}
SK_GameMode.__index = SK_GameMode

function SK_GameMode.create(isHotSeat)
  local self = setmetatable({}, SK_GameMode)
  self.isHotSeat = isHotSeat or false
  return self
end

function SK_GameMode:start()
  local order = getSeatedPlayers()
  log(order)
  shuffleTable(order)
  log(order)
  Turns.order = order
  Turns.pass_turns = false
  Turns.turn_color = order[1]
end