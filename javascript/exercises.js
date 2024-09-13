import { open } from "node:fs/promises"

export function change(amount) {
  if (!Number.isInteger(amount)) {
    throw new TypeError("Amount must be an integer")
  }
  if (amount < 0) {
    throw new RangeError("Amount cannot be negative")
  }
  let [counts, remaining] = [{}, amount]
  for (const denomination of [25, 10, 5, 1]) {
    counts[denomination] = Math.floor(remaining / denomination)
    remaining %= denomination
  }
  return counts
}

// Write your first then lower case function here
const firstThenLowerCase= (l,callback)=> {
  for (const each of l) {
    if (callback(each)){
      return each.toLowerCase()
    }
  }
}

// Write your powers generator here
function* powersGenerator (base, limit)  {
  let ans = 1
  while (ans <= limit){
    ans= Math(base,power++)
    yield ans
  }
}

// Write your say function here
const say =(word ="") => {
  return (nextWord="") => {
    if (nextWord) {
      return say(word + " "+ nextWord)
    }
    else {
      return word
    }
  }
}

// Write your line count function here
import fs from "fs"
const meaningfulLineCount = async (filename) => {
  try {
    const inputD = await fs.readFile(filename, 'utf-8');
    const lines = inputD.split('\n');
    let count = 0;

    for (let each of lines) {
      if (each.trim().length > 0 && each.trim().charAt(0) !== '#') {
        count++;
      }
    }

    console.log('____');
    console.log(count);
    return count;
  } catch (err) {
    console.error('Error reading file:', err);
  }
};

// Write your Quaternion class here

export {firstThenLowerCase,powersGenerator, say,meaningfulLineCount }
  
