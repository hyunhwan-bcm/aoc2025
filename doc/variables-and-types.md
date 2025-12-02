# Lua Variables and Data Types

## Variables

### Declaration
```lua
-- Global variable (avoid in most cases)
x = 10

-- Local variable (preferred)
local y = 20
local name = "Alice"
```

### Scope
Variables declared with `local` are only accessible within their function or block:
```lua
local function test()
    local x = 5  -- only accessible inside this function
    print(x)
end

test()  -- prints: 5
-- print(x)  -- error: x is nil outside the function
```

## Data Types

### Numbers
```lua
local integer = 42
local float = 3.14
local scientific = 1.5e10
local hex = 0xFF

-- Math operations
local sum = 10 + 5        -- 15
local difference = 10 - 5 -- 5
local product = 10 * 5    -- 50
local quotient = 10 / 5   -- 2.0
local modulo = 10 % 3     -- 1
local power = 2 ^ 3       -- 8
```

### Strings
```lua
local str1 = "Hello"
local str2 = 'World'
local multiline = [[
    This is a
    multiline string
]]

-- Concatenation
local greeting = str1 .. " " .. str2  -- "Hello World"

-- String with numbers
local result = "Answer: " .. 42  -- "Answer: 42"
```

### Booleans
```lua
local is_true = true
local is_false = false

-- Logical operators
local result1 = true and false  -- false
local result2 = true or false   -- true
local result3 = not true        -- false
```

### Nil
```lua
local x = nil  -- represents "no value"
local y        -- uninitialized variables are nil

if x == nil then
    print("x is nil")
end
```

## Type Checking
```lua
local x = 10
print(type(x))  -- "number"

local name = "Alice"
print(type(name))  -- "string"

local flag = true
print(type(flag))  -- "boolean"

local nothing = nil
print(type(nothing))  -- "nil"
```

## Operators

### Comparison
```lua
local a = 10
local b = 20

a == b   -- false (equal)
a ~= b   -- true  (not equal)
a < b    -- true  (less than)
a > b    -- false (greater than)
a <= b   -- true  (less than or equal)
a >= b   -- false (greater than or equal)
```

### Logical
```lua
-- and: returns first false/nil value, or last value if all true
true and false   -- false
true and 5       -- 5
nil and true     -- nil

-- or: returns first true value, or last value if all false
false or true    -- true
nil or 5         -- 5
false or nil     -- nil

-- not: negates boolean
not true         -- false
not false        -- true
not nil          -- true (nil is "falsy")
```

## Truthiness
In Lua, only `false` and `nil` are considered "falsy". Everything else is "truthy":
```lua
if 0 then print("0 is truthy") end        -- prints
if "" then print("empty string") end      -- prints
if false then print("won't print") end    -- doesn't print
if nil then print("won't print") end      -- doesn't print
```

## Constants
Lua doesn't have built-in constants, but you can use naming conventions:
```lua
local MAX_SIZE = 100    -- uppercase suggests constant
local PI = 3.14159
```
