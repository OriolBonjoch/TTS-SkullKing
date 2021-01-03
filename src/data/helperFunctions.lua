-- function shuffleTable(tbl)
--   local len, random = #tbl, math.random
--   for i = len, 2, -1 do
--     local j = random(1, i)
--     tbl[i], tbl[j] = tbl[j], tbl[i]
--   end
--   return tbl
-- end

function table.random(tbl)
  local len, random = #tbl, math.random
  return tbl[random(1, len)]
end

function table.find(tbl, func)
  for _, value in ipairs(tbl) do
    if func(value) then
      return value
    end
  end
  return nil
end

function table.countValue(tbl, match)
  local result = 0
  for _, value in ipairs(tbl) do
    if value == match then result = result + 1 end
  end
  return result
end


function table.advance(tbl, first)
  local result = {}
  local found = false
  for _, value in ipairs(tbl) do
    if (found or value == first) then
      found = true
      table.insert(result, value)
    end
  end
  for _, value in ipairs(tbl) do
    if (value == first) then
      return result
    end
    table.insert(result, value)
  end
  return tbl
end

function table.existsValue(tbl, val)
  for _, value in ipairs(tbl) do
    if value == val then
      return true
    end
  end
  return false
end

-- function table.map(f, t)
--   local t1 = {}
--   local t_len = #t
--   for i = 1, t_len do
--     t1[i] = f(t[i])
--   end
--   return t1
-- end
