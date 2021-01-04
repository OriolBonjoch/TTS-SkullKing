-- require("src.data.seedData")
-- require("src.data.helperFunctions")

-- require("src.assets.deck")
-- require("src.assets.startButton")

-- require("src.SK_Player")
-- require("src.SK_Game")
-- require("src.SK_Global")
-- require("src.SK_Interface")

state = {
  StartButton = nil,
  Deck = nil,
  Player = {},
  Game = nil,
  Interface = nil
}

function onLoad()
  for index, data in ipairs(getAllObjects()) do
    data.destruct()
  end

  state.StartButton = StartButton.create()
  state.Deck = Deck.create()
  state.Interface = SK_Interface.create()

  state.StartButton:draw()
  state.Deck:draw()
end

function onObjectPickUp(playerColor, obj)
  if (not state.Game or not state.Player[playerColor]) then return end
  local player = state.Player[playerColor]
  if (playerColor ~= Turns.turn_color or state.Game:isInvalidCard(playerColor, obj)) then
    obj.drop()
    return
  end
end

function onObjectDrop(playerColor, obj)
  if (not state.Game or not state.Player[playerColor] or not state.Deck) then return end
  local player = state.Player[playerColor]
  local card = state.Deck.cards[obj.getGUID()]
  if (not player or not card) then return end
  local isCorrect = state.Game:playCard(player, obj.getGUID())
  if (isCorrect) then
    if (card.name == "scary mary") then
      state.Interface.ScaryMaryPrompt:show(obj.getGUID())
    else
      Wait.time(function() Turns.turn_color = Turns.getNextTurnColor() end, 5)
    end
  end
end

function onPlayerTurn(playerObj)
  if (not state.Game) then return end
  local isEndRound = state.Game:endTrick()
  if (isEndRound) then
    state.Game:score()
    Wait.time(function() state.Game:startBidding() end, 5)
  end
end