-- Advent of Code 2025 - Day 8
-- https://adventofcode.com/2025/day/8

local function read_input(filename)
  local file = assert(io.open(filename, "r"), "Could not open file: " .. filename)
  local lines = {}
  for line in file:lines() do
    lines[#lines + 1] = line
  end
  file:close()
  return lines
end

local function split_wspace(line)
  local t = {}
  for tok in line:gmatch("%S+") do
    t[#t + 1] = tok
  end
  return t
end

local function get_coordinate(line)
  local t = {}
  for tok in line:gmatch("%d+") do
    t[#t + 1] = tonumber(tok)
  end
  return t
end

local function get_distance(x, y)
  return x[1]*y[1] + x[2]*y[2] + x[3]*y[3]
end
-- Part 1
local function part1(input)
  -- TODO: Implement part 1
  for i=1,#input do
    input[i] = get_coordinate(input[i])
  end

  local dist = {}
  for i=1,#input do
    for j=i+1,#input do
      table.insert(dist,{get_distance(input[i],input[j]),i,j})
    end
  end
  table.sort(dist, function(a,b)
    return a[1] < b[1]
  end)

  return 0
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
  
  print("Part 1: " .. part1(input))
  print("Part 2: " .. part2(input))
end

main()
