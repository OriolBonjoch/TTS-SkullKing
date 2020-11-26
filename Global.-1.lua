-- require("vscode/console")
require "seedData"
require "chest"
require "deck"
require "startButton"

savedData = {
  firstPlayer = "",
  round = 0,
  cards = {},
  deck,
  votes = {},
  rounds = {},
  phase = "start",
  counters = {},
  order = {},
  orderCount = 0
}

-- rounds = {
--   [1] = {
--     White = {
--       vote = 0,
--       card = XX
--     }
--   }
-- }

function onObjectDrop( player_color,  dropped_object)
  log(player_color)
  log(dropped_object)
end

function onObjectDrop(colorName, obj)
  log(obj.getJSON())
  if Turns.turn_color ~= colorName then 
    broadcastToColor("Is not your turn", colorName, colorName)
    return
  end

  local data = savedData.cards[obj.getGUID()]
  printToAll(data.name .. " - " .. data.value, "White")
  savedData.rounds[savedData.round][colorName].card = obj.getGUID()

  savedData.orderCount = savedData.orderCount + 1
  
  log(savedData.orderCount)
  log(Turns.getNextTurnColor())
  if (savedData.orderCount == #savedData.order) then
    -- calcular quien gana
    -- calcular puntos si es ultima mano
    savedData.orderCount = 0
    printToAll("inside")
  end

  log(savedData.order)
  printToAll(savedData.order[savedData.orderCount + 1])
  
  Turns.turn_color = savedData.order[savedData.orderCount + 1]

  broadcastToAll(colorName .. " dropped " .. obj.getGUID())
end


function onLoad()
  for index, data in ipairs(getAllObjects()) do
    data.destruct()
  end

  createStartButton()
  createDeck()
  savedData.deck.shuffle()
  savedData.order = createInitialOrder()
  Turns.enable = false
  Turns.pass_turns = false
  Turns.type = 1
end

function createInitialOrder()
  local tbl = getSeatedPlayers()
  local len, random = #tbl, math.random
  for i = len, 2, -1 do
      local j = random( 1, i )
      tbl[i], tbl[j] = tbl[j], tbl[i]
  end
  return tbl
end