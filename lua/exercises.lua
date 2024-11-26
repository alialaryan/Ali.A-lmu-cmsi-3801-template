function change(amount)
  if math.floor(amount) ~= amount then
      error("Amount must be an integer")
  end
  if amount < 0 then
      error("Amount cannot be negative")
  end
  local counts, remaining = {}, amount
  for _, denomination in ipairs({25, 10, 5, 1}) do
      counts[denomination] = math.floor(remaining / denomination)
      remaining = remaining % denomination
  end
  return counts
end

function first_then_lower_case(list, callback)
  for i, string in pairs(list) do
      if callback(string) then
          return string.lower(string)
      end
  end
end

function powers_generator(base, limit)
  return coroutine.create(function()
      local power = 0
      while base ^ power <= limit do
          coroutine.yield(base ^ power)
          power = power + 1
      end
  end)
end

function say(word)
  if word == nil then
      return ""
  end
  return function(nextWord)
      if nextWord then
          return say(word .. " " .. nextWord)
      else
          return word
      end
  end
end

function meaningful_line_count(filename)
  local count = 0
  local file = io.open(filename, "r")
  if file == nil then
      error("No such file")
  end
  for line in file:lines() do
      local trimmed_line = line:match("^%s*(.*)")
      if string.len(trimmed_line) ~= 0 and string.sub(trimmed_line, 1, 1) ~= "#" then
          count = count + 1
      end
  end
  file:close()
  return count
end

Quaternion = {}
Quaternion.__index = Quaternion

function Quaternion.new(a, b, c, d)
  local self = setmetatable({}, Quaternion)
  self.a = a or 0
  self.b = b or 0
  self.c = c or 0
  self.d = d or 0
  return self
end

function Quaternion:__add(other)
  return Quaternion.new(
      self.a + other.a,
      self.b + other.b,
      self.c + other.c,
      self.d + other.d
  )
end

function Quaternion:__mul(other)
  return Quaternion.new(
      self.a * other.a - self.b * other.b - self.c * other.c - self.d * other.d,
      self.a * other.b + self.b * other.a + self.c * other.d - self.d * other.c,
      self.a * other.c - self.b * other.d + self.c * other.a + self.d * other.b,
      self.a * other.d + self.b * other.c - self.c * other.b + self.d * other.a
  )
end

function Quaternion:__tostring()
  local parts = {}
  local coefficients_and_letters = {
      {self.a, ""},
      {self.b, "i"},
      {self.c, "j"},
      {self.d, "k"}
  }

  for _, pair in pairs(coefficients_and_letters) do
      local coefficient, letter = pair[1], pair[2]
      if coefficient ~= 0 then
          local part = (math.abs(coefficient) == 1 and letter ~= "" and "" or math.abs(coefficient)) .. letter
          if coefficient < 0 then
              part = "-" .. part
          elseif #parts > 0 then
              part = "+" .. part
          end
          table.insert(parts, part)
      end
  end

  return #parts > 0 and table.concat(parts) or "0"
end

function Quaternion:__eq(other)
  if getmetatable(other) ~= Quaternion then
      return false
  end
  return self.a == other.a and self.b == other.b and self.c == other.c and self.d == other.d
end

function Quaternion:conjugate()
  return Quaternion.new(self.a, -self.b, -self.c, -self.d)
end

function Quaternion:coefficients()
  return {self.a, self.b, self.c, self.d}
end
