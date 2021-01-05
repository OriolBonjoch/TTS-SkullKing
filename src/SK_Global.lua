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
  state.Game:playCard(player, obj.getGUID())
end