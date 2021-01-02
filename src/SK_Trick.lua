SK_Trick = {}
SK_Trick.__index = SK_Trick

function SK_Trick.create(playerColor)
  local self = setmetatable({}, SK_Trick)
  self.firstPlayer = playerColor
  self.cards = {}
  self.result = nil
  return self
end

function SK_Trick:playCard(player, cardId)
  self.cards[player.color] = cardId
end

function SK_Trick:isFinished()
  for playerColor, _ in pairs(state.Player) do
    if (not self.cards[playerColor]) then
      return false
    end
  end
  return true
end

function SK_Trick:calculate()
  local trickOrder = table.advance(Turns.order, self.firstPlayer)
  local extraPoints = {}
  local suit = ""
  local highestValue = -1
  local winner = self.firstPlayer
  for _, playerColor in ipairs(trickOrder) do
    local cardId = self.cards[playerColor]
    local cardData = state.Deck.cards[cardId]
    if (suit == "" and table.exists({ "mapa", "cofre", "loro", "bandera"}, cardData.name)) then
      suit = cardData.name
    end

    if (cardData.name == suit) then
      if (cardData.value > highestValue) then
        winner = playerColor
        highestValue = cardData.value
      end
    else
      if (table.exists({ "bandera", "sirena", "pirata", "scary mary", "rey pirata" }, cardData.name)) then
        suit = "bandera"
        if (cardData.value > highestValue) then
          winner = playerColor
          highestValue = cardData.value
        end
      end
    end
  end

  self.result = {}
  self.result.winner = winner
  self.result.points = extraPoints
end

function SK_Trick:isFinished()
  for playerColor, _ in pairs(state.Player) do
    if (not self.cards[playerColor]) then
      return false
    end
  end
  return true
end