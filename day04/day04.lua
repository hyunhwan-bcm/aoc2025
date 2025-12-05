-- Advent of Code 2025 - Day 4
-- https://adventofcode.com/2025/day/4

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

-- Part 1
local function part1(input)
  local ret = 0
  local map = {}

  for i, line in ipairs(input) do
    map[i] = {}
    for j = 1,#line do
      map[i][j] = line:sub(j,j)
    end
  end

  local n = #map
  local m = #map[1]

  for i=1,n do
    for j=1,m do
      if map[i][j] == "@" then
        local paper = 0
        for k=-1,1 do
          for l=-1,1 do
            if i+k < 1 or i+k > n then goto continue end
            if j+l < 1 or j+l > m then goto continue end
            if map[i+k][j+l] == "@" then paper = paper + 1 end
            ::continue::
          end
        end

        if paper <= 4 then ret = ret + 1 end
      end
    end
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
