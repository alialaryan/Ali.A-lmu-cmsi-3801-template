import Foundation

struct NegativeAmountError: Error {}
struct NoSuchFileError: Error {}

func change(_ amount: Int) -> Result<[Int:Int], NegativeAmountError> {
    if amount < 0 {
        return .failure(NegativeAmountError())
    }
    var (counts, remaining) = ([Int:Int](), amount)
    for denomination in [25, 10, 5, 1] {
        (counts[denomination], remaining) = 
            remaining.quotientAndRemainder(dividingBy: denomination)
    }
    return .success(counts)
}

func firstThenLowerCase(of array: [String], satisfying condition: (String) -> Bool) -> String? {
    return array.first(where: condition)?.lowercased() ?? nil
}

class Say {
    private var words: [String]
    init(words: [String] = []) {
        self.words = words
    }
    func and(_ word: String) -> Say {
        return Say(words: self.words + [word])
    }
    var phrase: String {
        return words.joined(separator: " ")
    }
}
func say(_ word: String = "") -> Say {
    return Say().and(word)
}

func meaningfulLineCount(_ fileName: String) -> Result<Int, Error> {
    do {
        let fileURL = URL(fileURLWithPath: fileName)
        let content = try String(contentsOf: fileURL)
        let lines = content.split(separator: "\n")
        let meaningfulLines = lines.filter {
            !$0.trimmingCharacters(in: .whitespaces).isEmpty &&
            !$0.trimmingCharacters(in: .whitespaces).hasPrefix("#")
        }
        return .success(meaningfulLines.count)
    } catch {
        return .failure(error)
    }
}

struct Quaternion:Equatable,CustomStringConvertible {
    let a: Double
    let b: Double
    let c: Double
    let d: Double

    static let ZERO = Quaternion(a: 0, b: 0, c: 0, d: 0)
    static let I = Quaternion(a: 0, b: 1, c: 0, d: 0)
    static let J = Quaternion(a: 0, b: 0, c: 1, d: 0)
    static let K = Quaternion(a: 0, b: 0, c: 0, d: 1)

    init(a: Double = 0.0, b: Double = 0.0, c: Double = 0.0, d: Double = 0.0) {
        guard !a.isNaN, !b.isNaN, !c.isNaN, !d.isNaN else { //exit early if all parameter are not numbers. 
            fatalError("all parameter must be numbers")
        }
        self.a = a
        self.b = b
        self.c = c
        self.d = d
    }
    static func +(_ lhs: Quaternion,_ rhs: Quaternion) -> Quaternion {
        return Quaternion(a: lhs.a + rhs.a, b: lhs.b + rhs.b, c: lhs.c + rhs.c, d: lhs.d + rhs.d)
    }
    static func *(_ lhs: Quaternion,_ rhs: Quaternion) -> Quaternion {
        let a = lhs.a * rhs.a - lhs.b * rhs.b - lhs.c * rhs.c - lhs.d * rhs.d
        let b = lhs.a * rhs.b + lhs.b * rhs.a + lhs.c * rhs.d - lhs.d * rhs.c
        let c = lhs.a * rhs.c - lhs.b * rhs.d + lhs.c * rhs.a + lhs.d * rhs.b
        let d = lhs.a * rhs.d + lhs.b * rhs.c - lhs.c * rhs.b + lhs.d * rhs.a
        return Quaternion(a: a, b: b, c: c, d: d)
    }
    static func ==(lhs: Quaternion, rhs: Quaternion) -> Bool { return lhs.a == rhs.a && lhs.b == rhs.b && lhs.c == rhs.c && lhs.d == rhs.d }
    var conjugate: Quaternion { return Quaternion(a: a, b: -b, c: -c, d: -d) }
    var coefficients:[Double] {
        return [a, b, c, d]
    }
    var description: String {
        var ans = ""
        if a != 0 {
            ans += "\(a)"
        }
        let coefficientsAndLetters = [(b, "i"), (c, "j"), (d, "k")]
         // iterate over all the coefficients and letters
        for (coefficient, letter) in coefficientsAndLetters {
            if abs(coefficient) == 1 {
                ans += (coefficient > 0 ? "+" : "-") + letter
            } else if coefficient != 0 {
                ans += (coefficient > 0 ? "+" : "") + "\(coefficient)\(letter)"
            }
        }
        if ans.isEmpty {
            return "0"
        }
        if ans.first == "+" {
            ans.removeFirst()
        }
        return ans
    }
}

// custom convertable needed to for custom descreption.
protocol BinarySearchTree: CustomStringConvertible {
    var isEmpty: Bool {get}
    var size: Int {get}
    func contains(_ value: String) -> Bool
    func insert(_ value: String) -> BinarySearchTree
}
struct Empty: BinarySearchTree {
    var isEmpty: Bool {
        return true
    }
    var size: Int {
        return 0
    }
    func contains(_ value: String) -> Bool {
        return false
    }
    func insert(_ value: String) -> BinarySearchTree {
        return Node(value: value, left: self, right: self)
    }
    var description: String {
        return "()"
    }
}
struct Node: BinarySearchTree {
    let value: String
    let left: BinarySearchTree
    let right: BinarySearchTree
    var isEmpty: Bool {
        return false
    }
    var size: Int {
        return 1 + left.size + right.size
    }
    func contains(_ value: String) -> Bool {
        return self.value == value || left.contains(value) || right.contains(value)
    }
    func insert(_ value: String) -> BinarySearchTree {
        if value < self.value {
            return Node(value: self.value, left: left.insert(value), right: right)
        } else {
            return Node(value: self.value, left: left, right: right.insert(value))
        }
    }
    var description: String {
        let leftStr = self.left.isEmpty ? "" : "\(self.left)" // check if the left is empty
        let rightStr = self.right.isEmpty ? "" : "\(self.right)" //check if the right is empty
            return "(\(leftStr)\(value)\(rightStr))"
    }   
}
