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

local function split_wspace(line) local t = {} for tok in line:gmatch("%S+") do t[#t + 1] = tok:gsub(":", "") end
  return t
end


local function count_path(G, start, goal)
  local memo = {}

  local function dfs(node)
    -- Base Case: We reached the goal
    if node == goal then
      return 1
    end

    -- Check Cache: Have we already counted paths from this node?
    if memo[node] then
      return memo[node]
    end

    local total_paths = 0
    local edges = G[node]

    if edges then
      for _, neighbor in pairs(edges) do
        total_paths = total_paths + dfs(neighbor)
      end
    end

    -- Store result in cache before returning
    memo[node] = total_paths
    return total_paths
  end

  return dfs(start)
end


-- Part 1
local function part1(input)
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
      end table.insert(G[fr], to)
    end
  end

  return count_path(G, "you", "out")
end


local function build_graph(input, blockers)
  local G = {}
  for i=1,#input do
    local l = split_wspace(input[i])

    local fr = l[1]

    if blockers[fr] ~= nil then
      goto skip
    end
    if G[fr] == nil then
      G[fr] = {}
    end

    for j=2,#l do
      local to = l[j]
      if blockers[to] == nil and G[to] == nil then
        G[to] = {}
      end
      if blockers[to] == nil then
        table.insert(G[fr], to)
      end
    end
    ::skip::
  end

  return G
end

local function part2(input)
  local G = build_graph(input, {})
  local G_not_fft = build_graph(input, {fft = true})
  local G_not_dac = build_graph(input, {dac = true})
  local G_not_fft_dac = build_graph(input, {fft = true, dac = true})

  local c1 = count_path(G, "svr", "out")
  local c2 = count_path(G_not_fft, "svr", "out")
  local c3 = count_path(G_not_dac, "svr", "out")
  local c4 = count_path(G_not_fft_dac, "svr", "out")

  print(c1, c2 , c3, c4)
  return c1 - c2 - c3 + c4
end
-- Main execution
local function main()
  local filename = arg[1] or "input.txt"
  local input = read_input(filename)
  print("Part 1: " .. part1(input))
  print("Part 2: " .. part2(input))
end

main()
