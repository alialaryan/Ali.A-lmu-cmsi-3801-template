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

-- Write your first then lower case function here
function first_then_lower_case(list, callback)
    for i, each in pairs(list) do
        if callback(each) then
            return string.lower(each)
            end

    end




end




-- Write your powers generator here
function powers_generator(base, limit)
  return coroutine.create(function()
      local power = 0
      while base^power <= limit do
          coroutine.yield(base^power)
          power = power+1
      end
  end)
end

-- Write your say function here
function say(word)
  if word==nil then 
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

-- Write your line count function here
function meaningful_line_count(filename)
  local count = 0
  for line in io.lines(filename) do
      l = line:match'^%s*(.*)'
      if string.len(l) ~= 0 and string.sub(l, 1, 1) ~= "#" then
          count = count + 1
      end
  end
  return count
end

-- Write your Quaternion table here
