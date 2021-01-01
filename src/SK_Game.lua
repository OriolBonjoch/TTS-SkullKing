require("src.SK_Trick")

SK_Game = {}
SK_Game.__index = SK_Game

function SK_Game.create()
  local self = setmetatable({}, SK_Game)
  self.round = 0
  self.trick = 0
  self.tricks = {}
  self.phase = "bidding"
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
  self.tricks = {}
  table.insert(self.tricks, SK_Trick.create())
end

function SK_Game:isEndTrick()
  local currentTrick = self.tricks[self.trick+1]
  if (not currentTrick) then
    return false
  end
  return currentTrick:isFinished()
end

function SK_Game:endTrick()
  -- broadcastToAll("Trick finished! calculate winner", Color.White)
  local currentTrick = self.tricks[self.trick + 1]
  currentTrick:calculate()
  local winnerColor = currentTrick.result.winner
  local winnerPlayer = state.Player[winnerColor]
  winnerPlayer:winTrick(currentTrick)

  self.trick = self.trick + 1
  if (self.trick ~= self.round) then
    return
  end

  log("round finished! calculate round points.")
  for index, playerColor in ipairs(getSeatedPlayers()) do
    local player = state.Player[playerColor]
    log(playerColor .. " voted " .. player.vote .. " and got " .. player.rounds[self.round].vote)
  end
end

function SK_Game:playCard(player, cardId)
  local isCard = function(obj)
    return obj.getGUID() == cardId
  end
  local card = table.find(Player[player.color].getHandObjects(), isCard)
  if (self.phase == "bidding" or card) then -- or Turns.turn_color ~= player.color
    return
  end

  local trick = self.tricks[self.trick+1]
  trick:playCard(player, cardId)
end
