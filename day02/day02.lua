-- Advent of Code 2025 - Day 2
-- https://adventofcode.com/2025/day/2

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


local function split(str, delimiter)
  local result = {}
  local pattern = string.format("([^%s]+)", delimiter)
  for token in string.gmatch(str, pattern) do
    table.insert(result, token)
  end
  return result
end

-- Part 1
local function part1(input)
  local ids = ""
  local ret = 0
  for _, line in ipairs(input) do
    ids = ids .. line
  end
  for range in string.gmatch(ids, '[%d]+-[%d]+') do
    local numbers = split(range, "-")
    local lo = tonumber(numbers[1])
    local hi = tonumber(numbers[2])
    for i=lo,hi do
      local s_i = tostring(i)
      local n = string.len(s_i)
      if n % 2 ~= 0 then goto continue end
      if string.sub(s_i, 1, n/2) == string.sub(s_i, n/2 + 1) then
        ret = ret + i
      end
      ::continue::
    end
  end
  return ret
end


local function eval(s, n)
  for j=1,n-1 do
    if n % j == 0 then
      local is_invalid = true
      for k=1,n,j do
        if string.sub(s, 1, j) ~= string.sub(s, k, k+j-1) then
          is_invalid = false
          break
        end
      end
      if is_invalid then return tonumber(s) end
    end
  end
  return 0
end

-- Part 2
local function part2(input)
  local ids = ""
  local ret = 0
  for _, line in ipairs(input) do
    ids = ids .. line
  end
  for range in string.gmatch(ids, '[%d]+-[%d]+') do
    local numbers = split(range, "-")
    local lo = tonumber(numbers[1])
    local hi = tonumber(numbers[2])
    for i=lo,hi do
      local s_i = tostring(i)
      ret = ret + eval(s_i, string.len(s_i))
    end

  end
  return ret
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
