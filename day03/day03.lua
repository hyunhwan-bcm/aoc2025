-- Advent of Code 2025 - Day 3
-- https://adventofcode.com/2025/day/3

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
  for _,line in ipairs(input) do
    local n = string.len(line)
    local maxi = 0
    for i=1,n-1 do
      for j=i+1,n do
        local cand_str = string.sub(line,i,i) .. string.sub(line,j,j)
        local cand = tonumber(cand_str)
        if cand and maxi < cand then
          maxi = cand
        end
      end
    end
    ret = ret + maxi
  end
  return ret
end

-- Part 2
local function part2(input)
  local ret = 0
  for _,line in ipairs(input) do
    local s = 0
    local t = {}
    for i=1,#line do
      t[i] = line:byte(i) - 48
    end

    local n = #line
    local best = 0
    for i=12,1,-1 do
      s = s+1
      local j = s
      local best_d = t[s]
      local best_where = s
      while n - j + 1 >= i do
        if t[j] > best_d then
          best_d = t[j]
          best_where = j
        end
        j = j + 1
      end
      best = best * 10 + best_d
      s = best_where
    end
    print(line, best)
    ret = ret + best
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
