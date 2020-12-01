GameMode = {}

function GameMode:new(o, isHotSeat)
  o = o or {}
  setmetatable(o, self)
  self.__index = self
  self.isHotSeat = isHotSeat or false
  return o
end

function GameMode:start()
  Turns.order = createInitialOrder()
  Turns.pass_turns = false
  Turns.enable = self.isHotSeat
  if (self.isHotSeat) then
    Turns.type = 1
  else
    Turns.type = 2
  end
end

