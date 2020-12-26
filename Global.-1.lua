require("seedData")
require("helpers")

require("deck")
require("startButton")
require("SK_Player")
-- require("gameLogic")
require("gameMode")
require("SK_Game")

savedData = {
  -- round = 0,
  trick = 0,
  cards = {},
  suit = "",
  labels = {},
  votes = {},
  rounds = {},
  phase = "start"
}

state = {
  Mode = {},
  StartButton = {},
  Deck = {},
  Player = {},
  Game = {}
}

function onLoad()
  for index, data in ipairs(getAllObjects()) do
    data.destruct()
  end

  state.Mode = GameMode.create(true)
  state.StartButton = StartButton.create()
  state.Deck = Deck.create()
  
  state.StartButton:draw()
  state.Deck:draw()
  state.Deck:shuffle()
end

function onObjectDrop(playerColor, obj)
  if (not state.Mode:isPlayerTurn(playerColor)) then 
    log("not player's turn")
    return
  end

  if (state.Game.phase == "bidding") then
    log("bidding phase")
    return
  end

  local player = state.Player[playerColor]
  if (player:hasCardInHand(obj)) then
    log("dropped at hand")
    return
  end

  player:playCard(obj)
end

-- helper function to avoid cheating
-- function onObjectPickUp(player_color, obj)
--   -- check if is a card
--   -- check if there is suit
--   -- check if is different from suit
--   if (not state.Mode:isPlayerTurnObject(playerColor)) then 
--     obj.drop()
--     return
--   end

--   local cardId = obj.getGUID()
--   local cardData = savedData.cards[cardId]
--   if (not cardData) then
--     return
--   end
  
--   function convertToCard(obj)
--     local cardId = obj.getGUID()
--     return savedData.cards[cardId].name
--   end 

--   print("Hemos llegado")
--   cardsInHand = map(convertToCard, Player[player_color].getHandObjects(1))
--   if (savedData.suit and savedData.suit ~= cardData.name and not has_value(staticData.isFigure, cardData.name) and has_value(cardsInHand, savedData.suit)) then
--     obj.drop()
--   end
-- end

function onPlayerTurn(person)
  if (state.Game.phase == "bidding") then
    return
  end

  state.Game:startTrick()
  for color, player in pairs(state.Player) do
    if (player:hasCards()) then
      return
    end
  end

  state.Game:startTrick()
end