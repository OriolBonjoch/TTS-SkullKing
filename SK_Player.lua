require("chest")
require("winsLabel")

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
  self.chest = Chest.create()
  self.winsLabel= WinsLabel.create()
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
  printToAll("Player " .. self.color .. " voted " .. self.rounds[round].vote, self.color)
  self.rounds[round].wins = 0
  self.winsLabel:draw(self.data, self.color)
  self.winsLabel:update(0)
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
  state.Mode:submitBid()
end

function SK_Player:hasCardInHand(obj)
  for index, handObj in ipairs(Player[self.color].getHandObjects()) do
    if obj.getGUID() == handObj.getGUID() then
      return true
    end
  end

  return false
end

function SK_Player:playCard(card)
  local data = state.Deck.cards[card.getGUID()]
  log(data)
  if (not data) then
    return
  end

  -- if (not savedData.suit and has_value({ "mapa", "cofre", "loro", "bandera"}, data.name)) then
  --   savedData.suit = data.name
  -- end

  printToAll(data.name .. " - " .. data.value, playerColor)
  local currentRound = self.rounds[state.Game.round]
  currentRound.tricks = currentRound.tricks + 1
  table.insert(currentRound.cards, currentRound.tricks, card.getGUID())
  state.Mode:playCard()
end

function SK_Player:hasCards()
  for index, handObj in ipairs(Player[self.color].getHandObjects()) do
    return true
  end

  return false
end