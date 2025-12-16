-- Advent of Code 2025 - Day 11
-- https://adventofcode.com/2025/day/11

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
    t[#t + 1] = tok:gsub(":", "")
  end
  return t
end

-- Part 1
local function part1(input)
  -- TODO: Implement part 1
  local G = {}
  for i=1,#input do
    local l = split_wspace(input[i])

    local fr = l[1]

    if G[fr] == nil then
      G[fr] = {}
    end
    for j=2,#l do
      local to = l[j]
      if G[to] == nil then
        G[to] = {}
      end
      table.insert(G[fr], to)
    end
  end

  local ans = {}
  local visited = {}
  local cur = {"you"}

  ans["you"] = 1

  while #cur > 0 do
    local next = {}
    for _,node in pairs(cur) do
      if visited[node] ~= true then
        visited[node] = true
        local E = G[node]
        for _,to in pairs(E) do
          if visited[to] ~= nil then
            goto continue
          end
          table.insert(next, to)
          if ans[to] == nil then
            ans[to] = 0
          end
          ans[to] = ans[to] + ans[node]
          ::continue::
        end
      end
      cur = next
    end
  end

  return ans["out"]
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
