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

function onObjectDrop(playerColor, obj)
  local player = state.Player[playerColor]
  local card = state.Deck.cards[obj.getGUID()]
  if (not card) then return end

  state.Game:playCard(player, obj.getGUID())
  Turns.turn_color = Turns.getNextTurnColor()
end

function onPlayerTurn(playerObj)
  if (not state.Game) then return end
  if (not state.Game:isEndTrick()) then return end
  state.Game:endTrick()
end