require "seedData"
require "gameMode"
require "helpers"
require "chest"
require "deck"
require "winsLabel"
require "startButton"
require "gameLogic"

savedData = {
  round = 0,
  trick = 0,
  cards = {},
  suit = "",
  deck,
  chests = {},
  labels = {},
  votes = {},
  rounds = {},
  phase = "start"
}

state = {}

function onObjectDrop(playerColor, obj)
  if Turns.turn_color ~= playerColor then 
    -- broadcastToColor("Is not your turn", playerColor, colorName)
    return
  end

  if (has_value(getCurrentPlayerHandCardIds(), obj.getGUID())) then
    return
  end
  
  local data = savedData.cards[obj.getGUID()]
  if (not data) then
    return
  end

  if (not savedData.suit and has_value({ "mapa", "cofre", "loro", "bandera"}, data.name)) then
    savedData.suit = data.name
  end
  printToAll(data.name .. " - " .. data.value, playerColor)
  table.insert(savedData.rounds[savedData.round][playerColor].cards, savedData.trick, obj.getGUID())
end

function onLoad()
  for index, data in ipairs(getAllObjects()) do
    data.destruct()
  end

  -- state.Mode = GameMode:create(nil, true)
  startButtonDraw()
  deckDraw()
  savedData.deck.shuffle()
  -- state.Mode.start()  
  Turns.order = createInitialOrder()
  Turns.pass_turns = false
  Turns.enable = false
  Turns.type = 2
end

-- helper function to avoid cheating
function onObjectPickUp(player_color, obj)
  -- check if is a card
  -- chekc if there is suit
  -- check if is different from suit
  if (not Turns.enable or Turns.turn_color ~= player_color) then 
    obj.drop()
    return
  end

  local cardId = obj.getGUID()
  local cardData = savedData.cards[cardId]
  print('-1-')
  log(not cardData)
  print('-2-')
  log(cardData)
  print('-3-')
  if (not cardData) then
    return
  end
  
  function convertToCard(obj)
    local cardId = obj.getGUID()
    return savedData.cards[cardId].name
  end 

  print("Hemos llegado")
  cardsInHand = map(convertToCard, Player[player_color].getHandObjects(1))
  if (savedData.suit and savedData.suit ~= cardData.name and not has_value(staticData.isFigure, cardData.name) and has_value(cardsInHand, savedData.suit)) then
    obj.drop()
  end
end

function onPlayerTurn(person)
  if (not savedData.rounds[savedData.round]) then
    return
  end

  for index, player_color in ipairs(getSeatedPlayers()) do
    if (not savedData.rounds[savedData.round][player_color] or savedData.rounds[savedData.round][player_color].vote == -1) then
      return
    end
  end

  for index, player_color in ipairs(getSeatedPlayers()) do
    if (not savedData.rounds[savedData.round][player_color].cards[savedData.trick]) then
      return
    end
  end
  print(person.color .. "'s turn starts now.")

  endTrick()
  startTrick()
end
