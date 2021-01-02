require("src.assets.scoreBoardUI")

require("src.SK_Trick")

SK_Game = {}
SK_Game.__index = SK_Game

function SK_Game.create()
  local self = setmetatable({}, SK_Game)
  self.round = 0
  self.trick = 0
  self.tricks = {}
  self.phase = "bidding"

  self.scoreBoard = ScoreBoardUI.create()
  return self
end

function SK_Game:startBidding()
  self.scoreBoard:draw()
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

function SK_Game:endTrick()
  local currentTrick = self.tricks[self.trick + 1]
  if (not currentTrick) then return false end
  if (not currentTrick:isFinished()) then return false end
  currentTrick:calculate()
  local winnerColor = currentTrick.result.winner
  local winnerPlayer = state.Player[winnerColor]
  winnerPlayer:winTrick(currentTrick)

  log("winner: " .. winnerColor)
  if (Turns.turn_color ~= winnerColor) then
    Turns.turn_color = winnerColor
  end

  self.trick = self.trick + 1
  if (self.trick ~= self.round) then
    table.insert(self.tricks, SK_Trick.create())
    return false
  end

  for index, playerColor in ipairs(getSeatedPlayers()) do
    local player = state.Player[playerColor]
    local points = 0
    if (player.vote == 0) then
      points = self.round * (player.rounds[self.round].wins == 0 and 10 or -10)
    elseif (player.vote == player.rounds[self.round].wins) then
      points = player.vote * 20
    else
      points = -10 * math.abs(player.vote - player.rounds[self.round].wins)
    end
    log(playerColor .. " voted " .. player.vote .. " and got " .. player.rounds[self.round].wins .. " = " .. tostring(points))
    player:addPoints(points)
  end
  return true
end

function SK_Game:playCard(player, cardId)
  local card = table.find(Player[player.color].getHandObjects(), function(obj) return obj.getGUID() == cardId end)
  if (self.phase == "bidding" or card or Turns.turn_color ~= player.color) then
    log("playCard")
    log(self.phase == "bidding")
    log(card)
    log(Turns.turn_color ~= player.color)
    return false
  end

  local trick = self.tricks[self.trick+1]
  trick:playCard(player, cardId)
  return true
end
