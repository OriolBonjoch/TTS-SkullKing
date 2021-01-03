-- require("src.data.seedData")
-- require("src.data.helperFunctions")

-- require("src.assets.deck")
-- require("src.assets.startButton")

-- require("src.SK_Player")
-- require("src.SK_Game")
-- require("src.SK_Global")

state = {
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
  
  -- local testButton = spawnObject({
  --   type = "BlockSquare",
  --   position = {x = 0, y = 5, z = 5},
  --   rotation = {x = 0, y = 0, z = 0}
  -- })

  -- testButton.createButton({
  --   click_function = "showLog_func",
  --   function_owner = self,
  --   label = "Log",
  --   position = {0, 0.5, 0},
  --   rotation = {0, 180, 0},
  --   width = 400,
  --   height = 400,
  --   font_size = 200,
  --   color = {0.5, 0.5, 0.5},
  --   font_color = {1, 1, 1}
  -- })
end

-- function showLog_func()
--   log("+++++++++++++++Game.tricks++++++++++++++++++")
--   log(state.Game.phase)
--   log(state.Game.tricks)
--   log("+++++++++++++++Players++++++++++++++++++")
--   log(state.Player)
--   log("+++++++++++++++++++++++++++++++++")
-- end

function onObjectPickUp(playerColor, obj)
  if (not state.Game or not state.Player[playerColor]) then return end
  local player = state.Player[playerColor]
  if (playerColor ~= Turns.turn_color or state.Game:isInvalidCard(playerColor, obj)) then
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
  local isEndRound = state.Game:endTrick()
  if (isEndRound) then
    state.Game:score()
    Wait.time(function() state.Game:startBidding() end, 5)
  end
end