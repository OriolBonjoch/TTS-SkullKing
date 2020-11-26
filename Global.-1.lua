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
  order = {}
}

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
  Turns.type = 2
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