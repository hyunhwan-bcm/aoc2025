-- Advent of Code 2025 - Day 1
-- https://adventofcode.com/2025/day/1

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

local function rotate(cur, dir)
  -- Validate direction early
  if dir ~= "L" and dir ~= "R" then
    error("invalid direction: " .. tostring(dir))
  end

  if dir == "L" then
    return (cur == 0) and 99 or cur - 1
  else  -- dir == "R"
    return (cur == 99) and 0 or cur + 1
  end
end


-- Part 1
local function part1(input)
    local ret = 0
    local cur = 50
    for _, line in pairs(input) do
      local rot = tonumber(string.sub(line, 2))
      local dir = string.sub(line, 1, 1)

      for _ = 1,rot do
        cur = rotate(cur, dir)
      end
      if cur == 0 then
        ret = ret + 1
      end
    end
    return ret
end

-- Part 2
local function part2(input)
    -- Be careful: if the dial were pointing at 50, 
    -- a single rotation like R1000 would cause the dial to point 
    -- at 0 ten times before returning back to 50!
    local ret = 0
    local cur = 50
    for _, line in pairs(input) do
      local rot = tonumber(string.sub(line, 2))
      local dir = string.sub(line, 1, 1)

      for _ = 1,rot do
        cur = rotate(cur, dir)
        if cur == 0 then
          ret = ret + 1
        end
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
