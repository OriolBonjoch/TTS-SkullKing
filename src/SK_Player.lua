require("src.assets.chestObject")
require("src.assets.winsLabel")

SK_Player = {
  color = "",
  data = {},
  score = 0,
  tempBid = -1,
  currentBid = -1
}
SK_Player.__index = SK_Player

function SK_Player.create(color, data)
  local self = setmetatable({}, SK_Player)
  self.color = color
  self.data = data
  self.score = 0
  self.tempBid = -1
  self.currentBid = -1

  self.chest = ChestObject.create()
  self.winsLabel= WinsLabel.create()
  return self
end

function SK_Player:startBidding(round)
  self.chest:draw(self.color, self.data)
  self.winsLabel:hide()
  self.wins = 0
  self.tempBid = -1
  self.currentBid = -1
end

function SK_Player:startRound()
  local round = state.Game.round
  printToAll("Player " .. self.color .. " bet " .. self.currentBid .. " wins", self.color)
  self.wins = 0
  self.winsLabel:draw(self.data, self.color)
  self.winsLabel:init(self.currentBid)
end

function SK_Player:canBid(obj)
  return obj.getGUID() == self.chest.obj.getGUID() and self.currentBid == -1
end

function SK_Player:bid(bid)
  broadcastToColor("You betted " .. bid, self.color, self.color)
  self.tempBid = bid
end

function SK_Player:submitBid()
  if (self.tempBid == -1) then
    self:bid(0)
  end

  self.currentBid = self.tempBid
end

function SK_Player:addPoints(points)
  self.score = self.score + points
end

function SK_Player:winTrick(trick)
  local round = state.Game.round
  self.wins = self.wins + 1
  self.winsLabel:update(self.wins)

  local trickCards = {}
  for _, cardId in pairs(trick.cards) do
    state.Deck:discard(getObjectFromGUID(cardId))
  end
end