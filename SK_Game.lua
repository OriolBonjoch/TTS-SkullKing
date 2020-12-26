SK_Game = {}
SK_Game.__index = SK_Game

function SK_Game.create()
  local self = setmetatable({}, SK_Game)
  self.round = 0
  self.phase = "bidding"
  self.suit = ""
  return self
end

function SK_Game:startBidding()
  self.round = self.round + 1
  self.phase = "bidding"
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

  savedData.trick = savedData.round
  state.Mode:startRound()
end

function SK_Game:startTrick()
  broadcastToAll("Trick finished! calculate winner", playerColor)
  
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