require("src.assets.chestObject")
require("src.assets.winsLabel")

SK_Player = {
  color = "",
  date = {},
  vote = -1,
  rounds = {}
}
SK_Player.__index = SK_Player

function SK_Player.create(color, data)
  local self = setmetatable({}, SK_Player)
  self.color = color
  self.data = data
  self.vote = -1
  self.rounds = {}
  self.playedCard = ""

  self.chest = ChestObject.create()
  self.winsLabel= WinsLabel.create()
  self.discardsDeck = nil
  return self
end

function SK_Player:startBidding(round)
  self.chest:draw(self.color, self.data)
  self.vote = -1
  self.rounds[round] = {
    cards = {},
    vote = -1,
    wins = 0,
    tricks = 0
  }
end

function SK_Player:startRound()
  local round = state.Game.round
  printToAll("Player " .. self.color .. " bet " .. self.rounds[round].vote .. " wins", self.color)
  self.rounds[round].wins = 0
  self.winsLabel:draw(self.data, self.color)
  self.winsLabel:init(self.rounds[round].vote)
end

function SK_Player:canBid(obj)
  if (obj.getGUID() ~= self.chest.obj.getGUID()) then
    return false
  end
  
  return self.rounds[state.Game.round].vote == -1
end

function SK_Player:bid(vote)
  broadcastToColor("You voted " .. vote, self.color, self.color)
  self.vote = vote
end

function SK_Player:submitBid()
  if (self.vote == -1) then
    self:bid(0)
  end

  self.rounds[state.Game.round].vote = self.vote
end

-- function SK_Player:hasCards(trick)
--   local count = 0
--   for index, handObj in ipairs(Player[self.color].getHandObjects()) do
--     count = count + 1
--   end
--   log(self.color .. " has " .. count .. " of ".. trick)

--   return trick > count
-- end

function SK_Player:playCard(cardId)
  local data = state.Deck.cards[cardId]
  if (not data) then
    return
  end

  printToAll(data.name .. " - " .. data.value, playerColor)
  local currentRound = self.rounds[state.Game.round]
  currentRound.tricks = currentRound.tricks + 1
  table.insert(currentRound.cards, currentRound.tricks, cardId)
end

function SK_Player:winTrick(trick)
  local round = state.Game.round
  self.rounds[round].wins = self.rounds[round].wins + 1
  self.winsLabel:update(self.rounds[round].wins)

  local trickCards = {}
  for _, cardId in pairs(trick.cards) do
    table.insert(trickCards, getObjectFromGUID(cardId))
  end
  if (self.discardsDeck) then
    table.insert(trickCards, self.discardsDeck.getGUID())
  end

  local deckPos = self.data.discardsPosition
  self.discardsDeck = group(trickCards)[1]
  self.discardsDeck.setPosition(Vector(deckPos.x, deckPos.y, deckPos.z))
end