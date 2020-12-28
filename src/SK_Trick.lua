SK_Trick = {}
SK_Trick.__index = SK_Trick

function SK_Trick.create()
  local self = setmetatable({}, SK_Trick)
  self.trick = 0
  self.cards = {}
  self.winner = ""
  self.extraPoints = {}
  return self
end

function SK_Trick:playCard(player, card)
  -- player:playCard(obj)
end

-- Player[self.color].getHandObjects()