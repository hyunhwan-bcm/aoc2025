-- Advent of Code 2025 - Day 5
-- https://adventofcode.com/2025/day/5

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
  -- TODO: Implement part 1
  local ret = 0
  local intervals = {}
  local is_input_finished = false
  for _,line in ipairs(input) do
    if #line == 0 then
      is_input_finished = true
      goto continue
    end
    if is_input_finished == false then
      local l,r = line:match("^(%d+)-(%d+)$")
      l = tonumber(l)
      r = tonumber(r)
      table.insert(intervals,{l,r})
    else
      local num = tonumber(line)
      local found = false
      for _,p in ipairs(intervals) do
        local l = p[1]
        local r = p[2]
        if  l <= num and num <= r then
          found = true
          break
        end
      end

      if found then
        ret = ret + 1
      end
    end
    ::continue::
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

