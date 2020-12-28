SK_Game = {}
SK_Game.__index = SK_Game

function SK_Game.create()
  local self = setmetatable({}, SK_Game)
  self.round = 0
  self.trick = 0
  self.tricks = {}
  self.phase = "bidding"
  -- self.suit = ""
  return self
end

function SK_Game:startBidding()
  self.round = self.round + 1
  self.phase = "bidding"
  
  log("+++ game startBidding")
  for playerColor, player in pairs(state.Player) do
    player:startBidding(self.round)
  end
  state.Deck:deal()
end

function SK_Game:startRound()
  self.phase = "cards"
  for playerColor, player in pairs(state.Player) do
    player:startRound()
  end

  self.trick = 0
end

function SK_Game:startTrick()
  for color, player in pairs(state.Player) do
    log(color)
    if (not player:hasCards(self.round - self.trick)) then
      return
    end
  end

  self.trick = self.trick + 1
  broadcastToAll("Trick finished! calculate winner", Color.White)

  if (self.trick == self.round) then
    log("round finished! calculate round points.")
  end
  -- local winner = calculateWinner()

  -- for index, player_color in ipairs(getSeatedPlayers()) do
  --   local cardId = savedData.rounds[savedData.round][player_color].cards[savedData.trick]
  --   local card = getObjectFromGUID(cardId)
  --   -- card.destruct()
  -- end

  -- savedData.rounds[savedData.round][winner].wins = savedData.rounds[savedData.round][winner].wins + 1
  
  -- winsLabelUpdate(winner)

  -- -- subir puntos (rey pirata o sirena)

  -- savedData.trick = savedData.trick - 1
  -- if (savedData.trick == 0) then
  --   startBidding()
  -- end
  -- savedData.suit = ""
end

function SK_Game:playCard(player, cardId)
  local isCard = function(obj) return obj.getGUID() == cardId end
  local card = table.find(isCard, Player[player.color].getHandObjects())
  if (self.phase == "bidding" or
      Turns.turn_color ~= player.color or 
      not card) then
      -- player:hasCardInHand(cardId)) then
    return
  end

  -- player:playCard(obj)
end
