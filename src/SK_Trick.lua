SK_Trick = {}
SK_Trick.__index = SK_Trick

function SK_Trick.create(playerColor)
  local self = setmetatable({}, SK_Trick)
  self.firstPlayer = playerColor
  self.cards = {}
  self.result = nil
  self.suit = ""
  return self
end

function SK_Trick:isValid(playerColor, cardData)
  if (cardData.name == self.suit) then return true end
  if (table.exists({ "huida", "sirena", "pirata", "scary mary", "rey pirata" }, cardData.name)) then
    return true
  end

  local card = table.find(Player[playerColor].getHandObjects(), function(obj)
    local handCardData = state.Deck.cards[obj.getGUID()]
    return handCardData.name == self.suit
  end)
  return not card
end

function SK_Trick:playCard(player, cardId)
  local cardData = state.Deck.cards[cardId]
  if (self.suit == "" and table.exists({ "mapa", "cofre", "loro", "bandera"}, cardData.name)) then
    self.suit = cardData.name
  end
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
    log(" - " .. playerColor .. " played " .. cardData.name .. " [" .. tostring(cardData.value) .. "]")
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
        if (cardData.value > highestValue or suit ~= "bandera") then
          winner = playerColor
          highestValue = cardData.value
        end
        suit = "bandera"
      end
    end
  end

  self.result = {}
  self.result.winner = winner
  self.result.points = extraPoints
end