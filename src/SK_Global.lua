-- require("src.data.seedData")
-- require("src.data.helperFunctions")

-- require("src.assets.deck")
-- require("src.assets.startButton")

-- require("src.SK_GameMode")
-- require("src.SK_Player")
-- require("src.SK_Game")
-- require("src.SK_Global")


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

  state.Mode = SK_GameMode.create(false)
  state.StartButton = StartButton.create()
  state.Deck = Deck.create()
  
  state.StartButton:draw()
  state.Deck:draw()
  state.Deck:shuffle()
end

function onObjectDrop(playerColor, obj)
  local player = state.Player[playerColor]
  local card = state.Deck.cards[obj.getGUID()]
  if (not card) then
    return
  end

  state.Game:playCard(player, obj.getGUID())
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

  -- state.Game:startTrick()
end