# Lua Control Flow

## Conditionals

### if-then-end
```lua
local x = 10

if x > 5 then
    print("x is greater than 5")
end
```

### if-else
```lua
local x = 3

if x > 5 then
    print("x is greater than 5")
else
    print("x is 5 or less")
end
```

### if-elseif-else
```lua
local score = 85

if score >= 90 then
    print("A")
elseif score >= 80 then
    print("B")
elseif score >= 70 then
    print("C")
else
    print("F")
end
```

### Conditions with Logical Operators
```lua
local age = 25
local has_license = true

if age >= 18 and has_license then
    print("Can drive")
end

if age < 18 or not has_license then
    print("Cannot drive")
end
```

### Truthiness
Only `false` and `nil` are falsy. Everything else (including 0 and empty string) is truthy:
```lua
if 0 then print("0 is truthy") end           -- prints
if "" then print("empty string is truthy") end  -- prints
if nil then print("won't print") end         -- doesn't print
if false then print("won't print") end       -- doesn't print
```

### Short-circuit Evaluation
```lua
-- and returns first false/nil or last value
local result = true and "yes"    -- "yes"
local result = nil and "yes"     -- nil

-- or returns first true value or last value
local result = false or "default"  -- "default"
local result = nil or 0           -- 0

-- Common pattern: default values
local x = input or 10  -- Use 10 if input is nil/false
```

## Loops

### while Loop
```lua
local i = 1
while i <= 5 do
    print(i)
    i = i + 1
end
-- Output: 1 2 3 4 5
```

### repeat-until Loop
```lua
local i = 1
repeat
    print(i)
    i = i + 1
until i > 5
-- Output: 1 2 3 4 5
-- Note: executes at least once
```

### Numeric for Loop
```lua
-- for var = start, end do
for i = 1, 5 do
    print(i)
end
-- Output: 1 2 3 4 5

-- With step
for i = 0, 10, 2 do
    print(i)
end
-- Output: 0 2 4 6 8 10

-- Counting down
for i = 5, 1, -1 do
    print(i)
end
-- Output: 5 4 3 2 1
```

### Generic for Loop (ipairs)
```lua
local colors = {"red", "green", "blue"}

for index, value in ipairs(colors) do
    print(index, value)
end
-- Output:
-- 1    red
-- 2    green
-- 3    blue
```

### Generic for Loop (pairs)
```lua
local person = {name = "Alice", age = 30, city = "NYC"}

for key, value in pairs(person) do
    print(key, value)
end
-- Output (order not guaranteed):
-- name    Alice
-- age     30
-- city    NYC
```

### Nested Loops
```lua
-- 2D grid iteration
local grid = {
    {1, 2, 3},
    {4, 5, 6},
    {7, 8, 9}
}

for i = 1, #grid do
    for j = 1, #grid[i] do
        print(grid[i][j])
    end
end
```

### Break
```lua
for i = 1, 10 do
    if i == 5 then
        break  -- Exit loop
    end
    print(i)
end
-- Output: 1 2 3 4
```

### Continue (using goto)
Lua doesn't have `continue`, but you can use `goto`:
```lua
for i = 1, 5 do
    if i == 3 then
        goto continue
    end
    print(i)
    ::continue::
end
-- Output: 1 2 4 5

-- Alternative: restructure with if
for i = 1, 5 do
    if i ~= 3 then
        print(i)
    end
end
```

## Functions

### Basic Function
```lua
local function greet(name)
    print("Hello, " .. name)
end

greet("Alice")  -- Hello, Alice
```

### Function with Return
```lua
local function add(a, b)
    return a + b
end

local sum = add(5, 3)
print(sum)  -- 8
```

### Multiple Return Values
```lua
local function min_max(a, b)
    if a < b then
        return a, b
    else
        return b, a
    end
end

local min, max = min_max(10, 5)
print(min, max)  -- 5  10
```

### Optional Parameters
```lua
local function greet(name, greeting)
    greeting = greeting or "Hello"
    print(greeting .. ", " .. name)
end

greet("Alice")           -- Hello, Alice
greet("Bob", "Hi")       -- Hi, Bob
```

### Variable Arguments
```lua
local function sum(...)
    local total = 0
    for _, v in ipairs({...}) do
        total = total + v
    end
    return total
end

print(sum(1, 2, 3))        -- 6
print(sum(1, 2, 3, 4, 5))  -- 15
```

### Anonymous Functions
```lua
local double = function(x)
    return x * 2
end

print(double(5))  -- 10

-- As callback
local numbers = {1, 2, 3, 4, 5}
table.sort(numbers, function(a, b)
    return a > b  -- Sort descending
end)
```

### Closures
```lua
local function make_counter()
    local count = 0
    return function()
        count = count + 1
        return count
    end
end

local counter = make_counter()
print(counter())  -- 1
print(counter())  -- 2
print(counter())  -- 3
```

### Recursive Functions
```lua
local function factorial(n)
    if n <= 1 then
        return 1
    else
        return n * factorial(n - 1)
    end
end

print(factorial(5))  -- 120

-- Fibonacci
local function fib(n)
    if n <= 2 then
        return 1
    else
        return fib(n - 1) + fib(n - 2)
    end
end
```

### Local Functions (Forward Declaration)
```lua
local helper  -- Forward declaration

local function main()
    helper()
end

helper = function()
    print("Helper function")
end

main()
```

## Error Handling

### assert
```lua
local function divide(a, b)
    assert(b ~= 0, "Cannot divide by zero")
    return a / b
end

print(divide(10, 2))  -- 5
-- divide(10, 0)      -- Error: Cannot divide by zero
```

### error
```lua
local function check_positive(n)
    if n < 0 then
        error("Number must be positive")
    end
    return n
end
```

### pcall (Protected Call)
```lua
local function risky_function()
    error("Something went wrong!")
end

local success, result = pcall(risky_function)
if success then
    print("Success:", result)
else
    print("Error:", result)
end
-- Output: Error: Something went wrong!

-- With arguments
local success, result = pcall(divide, 10, 0)
if not success then
    print("Division failed:", result)
end
```

### xpcall (Extended Protected Call)
```lua
local function error_handler(err)
    print("Error occurred: " .. err)
    print(debug.traceback())
end

local function risky()
    error("Oops!")
end

xpcall(risky, error_handler)
```

## goto Statement

```lua
local x = 10

if x > 5 then
    goto skip
end

print("This won't print")

::skip::
print("After skip")

-- Common use: continue in loops
for i = 1, 10 do
    if i % 2 == 0 then
        goto continue
    end
    print(i)  -- Only odd numbers
    ::continue::
end
```

## Common Patterns for AOC

### Early Return
```lua
local function find_first_match(arr, target)
    for i, v in ipairs(arr) do
        if v == target then
            return i  -- Early return
        end
    end
    return nil
end
```

### Guard Clauses
```lua
local function process(value)
    if value == nil then
        return nil
    end

    if value < 0 then
        return 0
    end

    -- Main logic here
    return value * 2
end
```

### Memoization
```lua
local memo = {}

local function expensive_calculation(n)
    if memo[n] then
        return memo[n]
    end

    -- Do expensive work
    local result = n * n

    memo[n] = result
    return result
end
```

### State Machine
```lua
local state = "start"

while true do
    if state == "start" then
        -- Do start logic
        state = "process"
    elseif state == "process" then
        -- Do process logic
        if condition then
            state = "finish"
        end
    elseif state == "finish" then
        break
    end
end
```

### Retry Logic
```lua
local function try_with_retry(func, max_attempts)
    for attempt = 1, max_attempts do
        local success, result = pcall(func)
        if success then
            return result
        end
        print("Attempt " .. attempt .. " failed")
    end
    error("All attempts failed")
end
```

## Tips

1. **No continue**: Use `goto` or restructure logic
2. **No ++/--**: Use `i = i + 1` instead
3. **Functions are first-class**: Can be stored in variables, passed as arguments
4. **Local by default**: Always use `local` for functions
5. **Multiple returns**: Lua functions can return multiple values
6. **Truthiness**: Only `false` and `nil` are falsy
7. **Short-circuit**: `and`/`or` can be used for conditional assignment
8. **pcall**: Use for error handling without crashing
