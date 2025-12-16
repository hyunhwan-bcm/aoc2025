#!/usr/bin/env lua
--[[
Gaussian Elimination Solver for Binary Coefficient Systems
Solves directly using linear algebra - search only over free variables
]]

local M = {}

-- ============================================================
-- RATIONAL ARITHMETIC (exact, no floating point errors)
-- ============================================================

local function gcd(a, b)
    a, b = math.abs(a), math.abs(b)
    while b ~= 0 do a, b = b, a % b end
    return a == 0 and 1 or a
end

local function rat(n, d)
    d = d or 1
    if d == 0 then return nil end
    if n == 0 then return {0, 1} end
    if d < 0 then n, d = -n, -d end
    local g = gcd(n, d)
    return {n // g, d // g}
end

local function rat_add(a, b) return rat(a[1]*b[2] + b[1]*a[2], a[2]*b[2]) end
local function rat_sub(a, b) return rat(a[1]*b[2] - b[1]*a[2], a[2]*b[2]) end
local function rat_mul(a, b) return rat(a[1]*b[1], a[2]*b[2]) end
local function rat_div(a, b) return rat(a[1]*b[2], a[2]*b[1]) end
local function rat_neg(a) return {-a[1], a[2]} end
local function rat_is_zero(a) return a[1] == 0 end
local function rat_is_int(a) return a[1] % a[2] == 0 end
local function rat_to_int(a) return a[1] // a[2] end
local function rat_eq(a, b) return a[1]*b[2] == b[1]*a[2] end

-- ============================================================
-- GAUSSIAN ELIMINATION
-- ============================================================

function M.solve(A, b)
    local n = #A      -- equations
    local m = #A[1]   -- variables
    
    -- Build augmented matrix with rationals [A | b]
    local aug = {}
    for i = 1, n do
        aug[i] = {}
        for j = 1, m do
            aug[i][j] = rat(A[i][j])
        end
        aug[i][m + 1] = rat(b[i])
    end
    
    -- Forward elimination with partial pivoting
    local pivot_col = {}  -- pivot_col[row] = column of pivot
    local pivot_row = {}  -- pivot_row[col] = row of pivot (nil if free)
    local row = 1
    
    for col = 1, m do
        -- Find pivot
        local pivot = nil
        for i = row, n do
            if not rat_is_zero(aug[i][col]) then
                pivot = i
                break
            end
        end
        
        if pivot then
            -- Swap rows
            aug[row], aug[pivot] = aug[pivot], aug[row]
            
            -- Scale pivot row
            local scale = aug[row][col]
            for j = col, m + 1 do
                aug[row][j] = rat_div(aug[row][j], scale)
            end
            
            -- Eliminate column
            for i = 1, n do
                if i ~= row and not rat_is_zero(aug[i][col]) then
                    local factor = aug[i][col]
                    for j = col, m + 1 do
                        aug[i][j] = rat_sub(aug[i][j], rat_mul(factor, aug[row][j]))
                    end
                end
            end
            
            pivot_col[row] = col
            pivot_row[col] = row
            row = row + 1
        end
    end
    
    local rank = row - 1
    
    -- Check for inconsistency
    for i = rank + 1, n do
        if not rat_is_zero(aug[i][m + 1]) then
            return nil, nil  -- No solution
        end
    end
    
    -- Find free variables
    local free_vars = {}
    for col = 1, m do
        if not pivot_row[col] then
            free_vars[#free_vars + 1] = col
        end
    end
    
    -- If no free variables, unique solution
    if #free_vars == 0 then
        local solution = {}
        for col = 1, m do
            local r = pivot_row[col]
            if not rat_is_int(aug[r][m + 1]) then
                return nil, nil  -- Non-integer solution
            end
            local val = rat_to_int(aug[r][m + 1])
            if val < 0 then
                return nil, nil  -- Negative solution
            end
            solution[col] = val
        end
        local sum = 0
        for i = 1, m do sum = sum + solution[i] end
        return solution, sum
    end
    
    -- Search over free variables only
    local best_solution = nil
    local best_sum = math.huge
    
    -- Compute bounds for free variables
    local free_upper = {}
    for _, fv in ipairs(free_vars) do
        local upper = math.huge
        for i = 1, n do
            if A[i][fv] == 1 then
                upper = math.min(upper, b[i])
            end
        end
        free_upper[fv] = upper == math.huge and 200 or upper
    end
    
    -- Solve for pivot variables given free variable values
    local function solve_for_pivots(free_values)
        local solution = {}
        
        -- Set free variables
        for _, fv in ipairs(free_vars) do
            solution[fv] = free_values[fv]
        end
        
        -- Compute pivot variables from augmented matrix
        for r = rank, 1, -1 do
            local col = pivot_col[r]
            local val = aug[r][m + 1]
            
            -- Subtract contributions from free variables
            for _, fv in ipairs(free_vars) do
                val = rat_sub(val, rat_mul(aug[r][fv], rat(free_values[fv])))
            end
            
            if not rat_is_int(val) then return nil end
            local int_val = rat_to_int(val)
            if int_val < 0 then return nil end
            
            solution[col] = int_val
        end
        
        return solution
    end
    
    -- Recursive search over free variables
    local free_values = {}
    
    local function search(idx, current_sum)
        if current_sum >= best_sum then return end
        
        if idx > #free_vars then
            local solution = solve_for_pivots(free_values)
            if solution then
                local sum = 0
                for i = 1, m do sum = sum + solution[i] end
                if sum < best_sum then
                    best_sum = sum
                    best_solution = solution
                end
            end
            return
        end
        
        local fv = free_vars[idx]
        for val = 0, free_upper[fv] do
            free_values[fv] = val
            search(idx + 1, current_sum + val)
        end
    end
    
    search(1, 0)
    
    return best_solution, best_sum < math.huge and best_sum or nil
end

-- Utilities
function M.print_solution(solution, name)
    name = name or "Solution"
    if not solution then
        print(name .. ": nil")
        return
    end
    local parts = {}
    for i = 1, #solution do parts[i] = tostring(solution[i]) end
    print(name .. ": [" .. table.concat(parts, ", ") .. "]")
end

function M.to_string(solution, sep)
    if not solution then return "" end
    local parts = {}
    for i = 1, #solution do parts[i] = tostring(solution[i]) end
    return table.concat(parts, sep or ",")
end

return M
