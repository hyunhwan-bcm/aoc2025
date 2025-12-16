-- Advent of Code 2025 - Day 10
-- https://adventofcode.com/2025/day/10

local function read_input(filename)
  local file = assert(io.open(filename, "r"), "Could not open file: " .. filename)
  local lines = {} for line in file:lines() do
    lines[#lines + 1] = line
  end
  file:close()
  return lines
end

local function split_num(line)
  local t = {}
  for tok in line:gmatch("%d+") do
    t[#t + 1] = tonumber(tok)
  end
  return t
end

local function get_input(line)
  local i, j = string.find(line, "^%[%S+%]")
  local L = string.sub(line, i+1, j-1)
  local B = {}
  for content in line:gmatch("%(.-%)") do
    content = split_num(content)
    for k,v in pairs(content) do
      content[k]=v+1
    end
    B[#B+1] = content
  end

  i, j = string.find(line, "%{.-%}")

  local J = split_num(string.sub(line, i+1,j-1))
  return L, B, J
end
-- Part 1
local function solve(S, L, B, idx)
  if table.concat(S, "") == L then
    return 0
  end

  if idx > #B then
    return 987654321
  end
  local ret = 987654321
  for _, i in ipairs(B[idx]) do
    S[i] = S[i] == '.' and '#' or '.'
  end

  ret = math.min(ret, solve(S, L, B, idx+1)+1)
  for _, i in ipairs(B[idx]) do
    S[i] = S[i] == '.' and '#' or '.'
  end
 
  ret = math.min(ret, solve(S, L, B, idx+1))
  return ret
end

local function part1(input)
  -- TODO: Implement part 1
  local n = #input
  local ret = 0
  for i=1,n do
    local L, B, _ = get_input(input[i])
    local S={}
    for j=1,#L do S[j]="." end
    ret = ret + solve(S, L, B, 1)
  end
  return ret
end

local function seek(tb, t)
  for _, v in ipairs(tb) do
    if v == t then
      return true
    end
  end
  return false
end

-- Part 2
local function part2(input)
  -- TODO: Implement part 2
  local n = #input
  local solver = require("gaussian")
  local ret = 0
  for i=1,n do
    local L, B, J = get_input(input[i])

    local A = {}
    for j=1,#L do
      A[j] = {}
      for k=1,#B do
        A[j][k] = seek(B[k], j) and 1 or 0
      end
    end
    local sol, obj = solver.solve(A, J)

    if sol then
      print(table.concat(sol, " "))
      print(obj)
    else
      print("error")
      for j=1,#A do
        print(table.concat(A[j], " "))
      end
      print(table.concat(J, " "))
    end
    ret = ret + obj
  end
  return math.floor(ret)
end

-- Main execution
local function main()
  local filename = arg[1] or "input.txt"
  local input = read_input(filename)
  
  print("Part 1: " .. part1(input))
  print("Part 2: " .. part2(input))
end

main()
