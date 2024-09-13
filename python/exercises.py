from dataclasses import dataclass
from collections.abc import Callable


def change(amount: int) -> dict[int, int]:
    if not isinstance(amount, int):
        raise TypeError('Amount must be an integer')
    if amount < 0:
        raise ValueError('Amount cannot be negative')
    counts, remaining = {}, amount
    for denomination in (25, 10, 5, 1):
        counts[denomination], remaining = divmod(remaining, denomination)
    return counts


# Write your first then lower case function here
def first_then_lower_case(l,callback):
    for each in l:
        if callback(each):
            return each.lower()

# Write your powers generator here
def powers_generator(base=None, limit=None):
    power=0 
    while base**power <=limit:
        yield base**power
        power+=1


# Write your say function here
def say (word= None):
    if word is None:
        return ""
    def inner(value=None):
        if value is not None:
            return say(word+ " "+ value+"")
        else:
            return word
    return inner


# Write your line count function here
def meaningful_line_count(filename):
    with open(filename, 'r') as f:
        count=0
        for line in f.readlines():
            line = line.strip()
            if len(line)>0 and line[0]!='#':
                count +=1
    return count
    


# Write your Quaternion class here
class Quaternion:
    def __init__(self,a,b,c,d,create=True):
        def __coefficients(s):
            return (s.a, s.b, s.c, s.d)
        def __conjugate(s):
            cp = Quaternion(0,0,0,0, create=False)
            cp.a=s.a
            cp.b=-s.b
            cp.c=-s.c
            cp.d=-s.d
            return cp
        self.a=a
        self.b=b
        self.c=c
        self.d=d
        if create:
            self.conjugate=__conjugate(self)
        self.coefficients=__coefficients(self)
    def __add__(self,other):
        res=Quaternion(0,0,0,0)
        res.a = self.a+other.a
        res.b = self.b+other.b
        res.c = self.c+other.c
        res.d = self.d+other.d
        return res
    def __mul__(self,other):
        res=Quaternion(0,0,0,0)
        w1, x1, y1, z1 = self.coefficients
        w2, x2, y2, z2 = other.coefficients
        w=w1*w2-x1*x2-y1*y2-z1*z2
        x=w1*x2-x1*w2-y1*z2-z1*y2
        y=w1*y2-x1*z2-y1*w2-z1*x2
        z=w1*z2-x1*y2-y1*x2-z1*w2
        return Quaternion(w,x,y,z)
    def __str__(self):
        i,j,k = "","",""
        def format(num):
            if round(num % 1, 2) == 0:
                return f'{num:+.1f}'
            else:
                return f'{num:+.2f}'
        if self.b < -1 or self.b > 1:
            i = format(self.b) + 'i'
        if self.c < -1 or self.c > 1:
            j = format(self.c) + 'j'
        if self.d < -1 or self.d > 1:
            k = format(self.d) + 'k'
        if self.b == 1:
            i = '+i'
        if self.c == 1:
            j = '+j'
        if self.d == 1:
            k = '+k'
        if self.b == -1:
            i = '-i'
        if self.c == -1:
            j = '-j'
        if self.d == -1:
            k = '-k'
        return f'{self.a:.1f}{i}{j}{k}'
    def __eq__(self, other):
        return self.a==other.a and self.b==other.b and self.c==other.c and self.d==other.d