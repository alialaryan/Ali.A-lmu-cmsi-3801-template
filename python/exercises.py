import functools
from dataclasses import dataclass

def change(amount: int) -> dict[int, int]:
    if not isinstance(amount, int):
        raise TypeError("Amount must be an integer")
    if amount < 0:
        raise ValueError("Amount cannot be negative")
    counts, remaining = {}, amount
    for denomination in (25, 10, 5, 1):
        counts[denomination], remaining = divmod(remaining, denomination)
    return counts


def first_then_lower_case(list=[], callback=lambda x: False):
    for string in list:
        if callback(string):
            return string.lower()


@functools.lru_cache(maxsize=None)
def powers_generator(*, base, limit):
    power = 0
    while base ** power <= limit:
        yield base ** power
        power += 1


def say(word=None):
    if word is None:
        return ""

    def inner(value=None):
        if value is not None:
            return say(word + " " + value + "")
        else:
            return word

    return inner


def meaningful_line_count(filename):
    with open(filename, "r") as f:
        count = 0
        for line in f.readlines():
            line = line.strip()
            if len(line) > 0 and line[0] != "#":
                count += 1
    return count


@dataclass(frozen=True)
class Quaternion:
    a: float
    b: float
    c: float
    d: float

    def __add__(self, q: "Quaternion") -> "Quaternion":
        return Quaternion(
            round(self.a + q.a, 10),
            round(self.b + q.b, 10),
            round(self.c + q.c, 10),
            round(self.d + q.d, 10),
        )

    def __mul__(self, q: "Quaternion") -> "Quaternion":
        return Quaternion(
            round(self.a * q.a - self.b * q.b - self.c * q.c - self.d * q.d, 10),
            round(self.a * q.b + self.b * q.a + self.c * q.d - self.d * q.c, 10),
            round(self.a * q.c - self.b * q.d + self.c * q.a + self.d * q.b, 10),
            round(self.a * q.d + self.b * q.c - self.c * q.b + self.d * q.a, 10),
        )

    def __str__(self):
        string = ""
        coefficents_and_letters = zip(
            (self.a, self.b, self.c, self.d), ["", "i", "j", "k"]
        )

        for coefficient, letter in coefficents_and_letters:
            if coefficient == 0:
                continue
            if string and coefficient > 0:
                string += "+"
            if coefficient == -1 and letter:
                string += "-"
            elif coefficient == 1 and letter:
                string += ""
            else:
                string += str(coefficient)
            string += letter
        return string or "0"

    @property
    def conjugate(self):
        return Quaternion(self.a, -self.b, -self.c, -self.d)

    @property
    def coefficients(self):
        return (self.a, self.b, self.c, self.d)
