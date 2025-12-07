-- Advent of Code 2025 - Day 7
-- GF
-- https://adventofcode.com/2025/day/7

local function read_input(filename)
  local file = assert(io.open(filename, "r"), "Could not open file: " .. filename)
  local lines = {}
  for line in file:lines() do
    local row = {}
    for i=1,#line do
      row[#row + 1] = line:sub(i,i)
    end
    lines[#lines + 1] = row
  end
  file:close()
  return lines
end

local function print_map(map)
  for i=1,#map do
    for j=1,#map[i] do
      io.write(map[i][j])
    end
    io.write("\n")
  end
end
local Queue = {} Queue.__index = Queue function Queue:new()
    return setmetatable({ items = {} }, self)
end

function Queue:enqueue(value)
    table.insert(self.items, value)    -- push at end
end

function Queue:dequeue()
    return table.remove(self.items, 1) -- remove from front (O(n))
end

function Queue:is_empty()
    return #self.items == 0
end

-- Part 1
local function part1(map)
  local ret = 0
  local si, sj = -1,-1

  for i=1,#map do
    for j=1,#map[i] do
      if map[i][j] == "S" then
        si,sj = i,j
      end
    end
  end

  map[si][sj] = "|"

  local que = Queue:new()

  que:enqueue({si, sj})

  while not que:is_empty() do
    local top = que:dequeue()
    local r,c = top[1], top[2]
    if r+1 > #map then goto continue end
    if map[r+1][c] == "^" then
      ret = ret + 1
      if c > 1 and map[r+1][c-1] == '.' then
        que:enqueue({r+1,c-1})
        map[r+1][c-1] = "|"
      end
      if c < #map[r+1] and map[r+1][c+1] == '.' then
        que:enqueue({r+1,c+1})
        map[r+1][c+1] = "|"
      end
    else
      if map[r+1][c] == '.' then
        que:enqueue({r+1,c})
        map[r+1][c] = "|"
      end
    end
    ::continue::
  end

  -- print_map(map)
  return ret
end

local cache = {}

local function make_key(status1, status2)
  -- Make sure to separate with something that cannot appear in values,
  -- or escape appropriately.
  return tostring(status1) .. "|" .. tostring(status2)
end

local function solve(map, i,j)
  if i >= #map then
    return 1
  end

  local key = make_key(i,j)
  if cache[key] ~= nil then
    return cache[key]
  end

  if map[i+1][j] == "^" then
    local ret = 0
    if j > 1 then ret = ret + solve(map, i+1,j-1) end
    if j < #map[i+1] then ret = ret + solve(map, i+1,j+1) end
    cache[key] = ret
    return ret
  else
    cache[key] = solve(map, i+1,j)
    return cache[key]
  end
end

local function part2(map)
  local sj = 0
  for j=1,#map[1] do
    if map[1][j] == "|" then sj = j end
  end

  return solve(map, 1, sj)
end


-- Main execution
local function main()
  local filename = arg[1] or "input.txt"
  local input = read_input(filename)
  
  print("Part 1: " .. part1(input))
  print("Part 2: " .. part2(input))
end

main()
