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
  order = {
    [1] = "White",
    [2] = "Pink",
    [3] = "Blue",
    [4] = "Green",
    [5] = "Yellow",
    [6] = "Red"
  }
}

function onLoad()
  for index, data in ipairs(getAllObjects()) do
    data.destruct()
  end

  createStartButton()
  createDeck()
  savedData.deck.shuffle()
  Turns.enable = false
  Turns.pass_turns = false
  Turns.type = 2
end

function onUpdate()
  for index, playerColor in ipairs(getSeatedPlayers()) do
    if (not savedData.rounds[savedData.round]) then
      return
    end
    if (savedData.rounds[savedData.round][playerColor].vote == -1) then
      return
    end
  end
  
  -- play!
end
