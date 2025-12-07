-- Advent of Code 2025 - Day 6
-- https://adventofcode.com/2025/day/6

-- Read input file
local function read_input(filename)
  local lines = {}
  local file = io.open(filename, "r")
  if not file then
    error("Could not open file: " .. filename)
  end

  for line in file:lines() do
    table.insert(lines, line)
  end
  file:close()
  return lines
end

local function split_wspace(line)
  local t = {}
  for tok in line:gmatch("%S+") do
    table.insert(t, tok)
  end
  return t
end

local function has_operators(tb)
  for _,v in ipairs(tb) do
    if v == "*" or v == '+' then
      return true
    end
  end
  return false
end
-- Part 1
local function part1(input)
  -- TODO: Implement part 1
  local numbers = {}
  local operator = {}
  local ret = 0
  for _,line in ipairs(input) do
    line = split_wspace(line)
    if has_operators(line) then
      operator = line
      break
    end
    for i=1,#line do
      line[i] = tonumber(line[i])
    end
    table.insert(numbers, line)
  end

  local n = #numbers
  local m = #numbers[1]

  for j=1,m do
    local ans = numbers[1][j]
    for i=2,n do
      if operator[j] == '*' then
        ans = ans * numbers[i][j]
      else
        ans = ans + numbers[i][j]
      end
    end
    ret = ret + ans
  end
  return ret
end

-- Part 2
local function part2(input)
  -- TODO: Implement part 2
  return 0
end

-- Main execution
local function main()
  local filename = arg[1] or "input.txt"
  local input = read_input(filename)

  local result1 = part1(input)
  print("Part 1: " .. result1)

  local result2 = part2(input)
  print("Part 2: " .. result2)
end

main()
