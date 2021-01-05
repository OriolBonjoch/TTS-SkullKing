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
  state.Interface.ScoreBoard:setData("totals")
  self.round = self.round + 1
  self.trick = 0
  self.phase = "bidding"
  self.tricks = {}

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
  table.insert(self.tricks, SK_Trick.create(Turns.turn_color))
end

function SK_Game:isInvalidCard(playerColor, obj)
  if (self.phase == "bidding") then return true end
  local cardData = state.Deck.cards[obj.getGUID()]
  local currentTrick = self.tricks[self.trick + 1]
  if (not cardData or not currentTrick) then return false end
  return not currentTrick:isValid(playerColor, cardData)
end

function SK_Game:playCard(player, cardId)
  local card = table.find(Player[player.color].getHandObjects(), function(obj) return obj.getGUID() == cardId end)
  if (self.phase == "bidding" or card or Turns.turn_color ~= player.color) then
    return
  end

  local currentTrick = self.tricks[self.trick + 1]
  if (not currentTrick) then 
    currentTrick = SK_Trick.create(player.color)
    table.insert(self.tricks, currentTrick)
  end

  currentTrick:playCard(player, cardId)
  local cardData = state.Deck.cards[cardId]
  if (cardData.name == "scary mary") then
    state.Interface.ScaryMaryPrompt:show(cardId)
    return
  end

  Turns.turn_color = Turns.getNextTurnColor()
  Wait.time(function() self:endTrick() end, 5)
end

function SK_Game:endTrick()
  local currentTrick = self.tricks[self.trick + 1]
  if (not currentTrick) then return end
  if (not currentTrick:isFinished()) then return end

  currentTrick:calculate()
  local winnerColor = currentTrick.result.winner
  local winnerPlayer = state.Player[winnerColor]
  winnerPlayer:winTrick(currentTrick)
  
  if (Turns.turn_color ~= winnerColor) then
    Turns.turn_color = winnerColor
  end

  self.trick = self.trick + 1
  if (self.trick ~= self.round) then return end
  Wait.time(function() self:score() end, 2)
end

function SK_Game:score()
  local diff = {}
  for playerColor, player in pairs(state.Player) do
    local points = 0
    if (player.currentBid == 0) then
      points = self.round * (player.wins == 0 and 10 or -10)
    elseif (player.currentBid == player.wins) then
      points = player.currentBid * 20
    else
      points = -10 * math.abs(player.currentBid - player.wins)
    end

    if (points > 0) then
      for _, trick in ipairs(self.tricks) do
        if (trick.result.points[playerColor]) then
          points = points + trick.result.points[playerColor]
        end
      end
    end
    -- log(playerColor .. " voted " .. player.currentBid .. " and got " .. player.wins .. " = " .. tostring(points))
    diff[playerColor] = points
  end
  state.Interface.ScoreBoard:setData("differences", diff)
  for playerColor, player in pairs(state.Player) do
    player:addPoints(diff[playerColor])
  end
  
  Wait.time(function() self:startBidding() end, 5)
end