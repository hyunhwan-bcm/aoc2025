-- Advent of Code 2025 - Day 1
-- https://adventofcode.com/2025/day/1

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
    local cur = 50
    for i, line in pairs(input) do
      local rot = tonumber(string.sub(line, 2))
      if string.find(line, "L") ~= nil then
        cur = (cur + rot) % 100
      else
        cur = (cur + 100 - rot) % 100
      end

      if cur == 0 then
        ret = ret + 1
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
