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

export function firstThenLowerCase(list, callback) {
  for (const eachString of list) {
    if (callback(eachString)) {
      return eachString.toLowerCase()
    }
  }
}

export function* powersGenerator({ ofBase: base, upTo: limit }) {
  let power = 1
  while (power <= limit) {
    yield power
    power *= base
  }
}

export function say(word) {
  if (word === undefined) return ""

  return (nextWord) => {
    if (nextWord === undefined) return word
    return say(`${word} ${nextWord}`)
  }
}

export async function meaningfulLineCount(filename) {
  let count = 0
  const inFile = await open(filename, "r")
  for await (const eachLine of inFile.readLines()) {
    const trimmedLine = eachLine.trim()
    if (trimmedLine && trimmedLine[0] !== "#") {
      count++
    }
  }
  return count
}

export class Quaternion {
  static ZERO = new Quaternion(0, 0, 0, 0)
  static I = new Quaternion(0, 1, 0, 0)
  static J = new Quaternion(0, 0, 1, 0)
  static K = new Quaternion(0, 0, 0, 1)
  constructor(a, b, c, d) {
    this.a = a
    this.b = b
    this.c = c
    this.d = d
    Object.freeze(this)
  }
  plus(q) {
    return new Quaternion(
      this.a + q.a,
      this.b + q.b,
      this.c + q.c,
      this.d + q.d
    )
  }
  times(q) {
    return new Quaternion(
      this.a * q.a - this.b * q.b - this.c * q.c - this.d * q.d,
      this.a * q.b + this.b * q.a + this.c * q.d - this.d * q.c,
      this.a * q.c - this.b * q.d + this.c * q.a + this.d * q.b,
      this.a * q.d + this.b * q.c - this.c * q.b + this.d * q.a
    )
  }
  toString() {
    const parts = []
    const coefficientsAndLetters = [
      [this.a, ""],
      [this.b, "i"],
      [this.c, "j"],
      [this.d, "k"],
    ]
    for (const [coefficient, letter] of coefficientsAndLetters) {
      if (coefficient !== 0) {
        let part =
          (Math.abs(coefficient) === 1 && letter !== ""
            ? ""
            : Math.abs(coefficient)) + letter
        if (coefficient < 0) {
          part = "-" + part
        } else if (parts.length > 0) {
          part = "+" + part
        }
        parts.push(part)
      }
    }
    return parts.join("") || "0"
  }
  equals(other) {
    if (!(other instanceof Quaternion)) {
      return false
    }
    return (
      this.a === other.a &&
      this.b === other.b &&
      this.c === other.c &&
      this.d === other.d
    )
  }
  get conjugate() {
    return new Quaternion(this.a, -this.b, -this.c, -this.d)
  }
  get coefficients() {
    return [this.a, this.b, this.c, this.d]
  }
}
