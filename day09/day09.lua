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
  -- NOTE: if your input can have negatives, change "%d+" to "[-]?%d+"
  for tok in line:gmatch("%d+") do
    t[#t + 1] = tonumber(tok)
  end
  return t
end

local function min(a,b) return (a<b) and a or b end
local function max(a,b) return (a>b) and a or b end

-- Part 1
local function part1(input)
  local n = #input
  for i=1,n do
    if type(input[i]) == "string" then
      input[i] = split_numbers(input[i])
    end
  end

  local ret = 0
  for i=1,n do
    for j=i+1,n do
      local dx = math.abs(input[i][1]-input[j][1]) + 1
      local dy = math.abs(input[i][2]-input[j][2]) + 1
      local area = dy * dx
      if area > ret then
        ret = area
      end
    end
  end
  return ret
end

local function norm_rect(x1,y1,x2,y2)
  local rx1, rx2 = min(x1,x2), max(x1,x2)
  local ry1, ry2 = min(y1,y2), max(y1,y2)
  return rx1, ry1, rx2, ry2
end

-- Non-strict point-in-orthogonal-polygon (boundary counts as inside)
-- Ray cast in +x direction; with half-open y rule to avoid double counting.
-- Assumes polygon is axis-aligned (edges horizontal/vertical).
local function pip_nonstrict(px, py, poly)
  local n = #poly
  local inside = false

  for i=1,n do
    local a = poly[i]
    local b = poly[(i % n) + 1]

    if a.x == b.x then
      -- vertical edge at x = xv, from ylo..yhi
      local xv = a.x
      local ylo, yhi = min(a.y,b.y), max(a.y,b.y)

      -- boundary check for this vertical edge
      if px == xv and py >= ylo and py <= yhi then
        return true
      end

      -- crossing toggle (half-open in y)
      if (py >= ylo and py < yhi) and (xv > px) then
        inside = not inside
      end

    else
      -- horizontal edge at y = yh
      local yh = a.y
      local xlo, xhi = min(a.x,b.x), max(a.x,b.x)

      -- boundary check for horizontal edge
      if py == yh and px >= xlo and px <= xhi then
        return true
      end
      -- horizontal edges do NOT contribute to crossings
    end
  end

  return inside
end

-- Proper crossing between axis-aligned segments only (touch/overlap is NOT a failure).
-- Returns true only if they intersect at a point strictly inside BOTH segments.
local function seg_intersect_proper(ax,ay,bx,by, cx,cy,dx,dy)
  local aVert = (ax == bx)
  local cVert = (cx == dx)

  -- proper crossing only possible if perpendicular
  if aVert == cVert then return false end

  local xv, yv1, yv2, xh1, xh2, yh
  if aVert then
    xv, yv1, yv2 = ax, ay, by
    xh1, xh2, yh = cx, dx, cy
  else
    xv, yv1, yv2 = cx, cy, dy
    xh1, xh2, yh = ax, bx, ay
  end

  local ylo, yhi = min(yv1,yv2), max(yv1,yv2)
  local xlo, xhi = min(xh1,xh2), max(xh1,xh2)

  -- strict interior of both segments => excludes endpoint touches
  return (xv > xlo and xv < xhi) and (yh > ylo and yh < yhi)
end

-- Rectangle is inside-or-on-boundary of polygon
-- Touching polygon boundary is allowed. Only proper crossings fail.
local function rect_inside_or_touch(poly, x1,y1,x2,y2)
  local rx1,ry1,rx2,ry2 = norm_rect(x1,y1,x2,y2)
  if rx1 == rx2 or ry1 == ry2 then
    return false -- degenerate rectangle
  end

  -- rectangle edges
  local rectEdges = {
    {rx1,ry1, rx2,ry1}, -- bottom
    {rx2,ry1, rx2,ry2}, -- right
    {rx2,ry2, rx1,ry2}, -- top
    {rx1,ry2, rx1,ry1}, -- left
  }

  -- 1) reject only proper crossings between polygon edges and rectangle edges
  local n = #poly
  for i=1,n do
    local a = poly[i]
    local b = poly[(i % n) + 1]
    for k=1,4 do
      local e = rectEdges[k]
      if seg_intersect_proper(a.x,a.y,b.x,b.y, e[1],e[2],e[3],e[4]) then
        return false
      end
    end
  end

  -- 2) all corners must be inside-or-on-boundary
  local corners = {
    {rx1,ry1}, {rx2,ry1}, {rx2,ry2}, {rx1,ry2}
  }
  for _,c in ipairs(corners) do
    if not pip_nonstrict(c[1], c[2], poly) then
      return false
    end
  end

  return true
end

local function part2(input)
  local n = #input

  -- ensure numeric parsing (in case part2 is run alone)
  for i=1,n do
    if type(input[i]) == "string" then
      input[i] = split_numbers(input[i])
    end
  end

  -- build polygon (your original code swapped coords: x=input[i][2], y=input[i][1])
  local poly = {}
  for i=1,n do
    poly[#poly+1] = { x = input[i][2], y = input[i][1] }
  end

  local ret = 0
  for i=1,n do
    for j=i+1,n do
      if rect_inside_or_touch(poly, input[i][2], input[i][1], input[j][2], input[j][1]) then
        local dx = math.abs(input[i][2] - input[j][2]) + 1
        local dy = math.abs(input[i][1] - input[j][1]) + 1
        local area = dx * dy
        if area > ret then
          ret = area
        end
      end
    end
  end

  return ret
end

-- Main execution
local function main()
  local filename = arg[1] or "input.txt"
  local input = read_input(filename)
  print("Part 1: " .. part1(input))
  print("Part 2: " .. part2(input))
end

main()
