-- require("src.data.seedData")
-- require("src.data.helperFunctions")

-- require("src.assets.deck")
-- require("src.assets.startButton")

-- require("src.SK_Player")
-- require("src.SK_Game")
-- require("src.SK_Global")

state = {
  -- Mode = {},
  StartButton = {},
  Deck = {},
  Player = {},
  Game = nil
}

function onLoad()
  for index, data in ipairs(getAllObjects()) do
    data.destruct()
  end

  state.StartButton = StartButton.create()
  state.Deck = Deck.create()

  state.StartButton:draw()
  state.Deck:draw()
  state.Deck:shuffle()
end

function onObjectPickUp(playerColor, obj)
  if (not state.Game or not state.Player) then return end
  local player = state.Player[playerColor]
  if (playerColor ~= Turns.turn_color or state.Game.phase == "bidding") then
    obj.drop()
    return
  end
end

function onObjectDrop(playerColor, obj)
  local player = state.Player[playerColor]
  local card = state.Deck.cards[obj.getGUID()]
  if (not player or not card) then return end

  local isCorrect = state.Game:playCard(player, obj.getGUID())
  if (isCorrect) then
    Turns.turn_color = Turns.getNextTurnColor()
  end
end

function onPlayerTurn(playerObj)
  if (not state.Game) then return end
  local isBidAgain = state.Game:endTrick()
  if (isBidAgain) then
    state.Game:startBidding()
  end
end