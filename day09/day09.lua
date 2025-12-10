-- Advent of Code 2025 - Day 9
-- https://adventofcode.com/2025/day/9

local function read_input(filename)
  local file = assert(io.open(filename, "r"), "Could not open file: " .. filename)
  local lines = {}
  for line in file:lines() do
    lines[#lines + 1] = line
  end
  file:close()
  return lines
end

local function split_numbers(line)
  local t = {}
  for tok in line:gmatch("%d+") do
    t[#t + 1] = tok
  end
  return t
end

-- Part 1
local function part1(input)
  local n = #input

  for i=1,n do
    input[i] = split_numbers(input[i])
  end

  local ret = 0
  for i=1,n do
    for j=i+1,n do
      local dx = math.abs(input[i][1]-input[j][1])+1
      local dy = math.abs(input[i][2]-input[j][2])+1
      local area = dy * dx
      ret = ret > area and ret or area
    end
  end
  -- TODO: Implement part 1
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
  
  print("Part 1: " .. part1(input))
  print("Part 2: " .. part2(input))
end

main()
