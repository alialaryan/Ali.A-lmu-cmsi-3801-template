package exercises
import java.io.BufferedReader
import java.io.FileReader
import java.io.IOException
import java.io.File
fun change(amount: Long): Map<Int, Long> {
    require(amount >= 0) { "Amount cannot be negative" }
    val counts = mutableMapOf<Int, Long>()
    var remaining = amount
    for (denomination in listOf(25, 10, 5, 1)) {
        counts[denomination] = remaining / denomination
        remaining %= denomination
    }
    return counts
}

fun firstThenLowerCase(a: List<String>, p: (String) -> Boolean): String? {
    return a.firstOrNull { p(it) }?.lowercase()
}

class Say(public var phrase: String = "") {
    fun and(nextPhrase: String): Say {
        return Say("$phrase $nextPhrase")
    }
}
fun say(word: String = ""): Say {
    return Say(word)
}

@Throws(IOException::class)
fun meaningfulLineCount(filePath: String): Long {
    return File(filePath).useLines { lines ->
        lines.map { line -> line.trim() }
        .count { line -> line.isNotEmpty() && !line.startsWith("#") }
        }.toLong()
}

data class Quaternion(val a : Double, val b : Double, val c : Double, val d : Double) {
    companion object {
        val I = Quaternion(0.0, 1.0, 0.0, 0.0)
        val J = Quaternion(0.0, 0.0, 1.0, 0.0)
        val K = Quaternion(0.0, 0.0, 0.0, 1.0)
        val ZERO = Quaternion(0.0, 0.0, 0.0, 0.0)
    }
    operator fun plus(other: Quaternion): Quaternion {
        return Quaternion(a + other.a, b + other.b, c + other.c, d + other.d)
    }
    operator fun times(other: Quaternion): Quaternion {
        return Quaternion(
            a * other.a - b * other.b - c * other.c - d * other.d,
            a * other.b + b * other.a + c * other.d - d * other.c,
            a * other.c - b * other.d + c * other.a + d * other.b,
            a * other.d + b * other.c - c * other.b + d * other.a
        )
    }
    fun coefficients(): List<Double> = listOf(a, b, c, d)
    fun conjugate(): Quaternion  = Quaternion(a, -b, -c, -d)
    override fun toString(): String {
        var quaternionString = ""
        if (a != 0.0) quaternionString += "${a}"
        if (b == 1.0 || b == -1.0) quaternionString += "${if (b > 0) "+" else "-"}i"
        else if (b != 0.0) quaternionString += "${if (b > 0) "+" else ""}${b}i"
        if (c == 1.0 || c == -1.0) quaternionString += "${if (c > 0) "+" else "-"}j"
        else if (c != 0.0) quaternionString += "${if (c > 0) "+" else ""}${c}j"
        if (d == 1.0 || d == -1.0) quaternionString += "${if (d > 0) "+" else "-"}k"
        else if (d != 0.0) quaternionString += "${if (d > 0) "+" else ""}${d}k"
        if (quaternionString == "") return "0"
        if (quaternionString[0] == '+') quaternionString = quaternionString.substring(1)
        return quaternionString
    }
}

sealed interface BinarySearchTree {
    fun insert(value: String): BinarySearchTree
    fun contains(value: String): Boolean
    fun size(): Int
    object Empty : BinarySearchTree {
        override fun insert(value: String): BinarySearchTree = Node(value, Empty, Empty)
        override fun contains(value: String): Boolean = false
        override fun size(): Int = 0
        override fun toString(): String = "()"
    }
    data class Node(private val value: String, private val left: BinarySearchTree, private val right: BinarySearchTree) : BinarySearchTree {
        override fun insert(value: String): BinarySearchTree = when {
            value < this.value -> Node(this.value, left.insert(value), right)
            value > this.value -> Node(this.value, left, right.insert(value))
            else -> this
        }
        override fun contains(value: String): Boolean = when {
            value < this.value -> left.contains(value)
            value > this.value -> right.contains(value)
            else -> true
        }
        override fun size(): Int {
            // size is 1 (the current node) plus the size of both subtrees
            return 1 + left.size() + right.size()
        }
        override fun toString(): String {
            // string representation of the tree, empty branches are omitted
            val leftStr = if (left == Empty) "" else "$left"
            val rightStr = if (right == Empty) "" else "$right"
            return "($leftStr$value$rightStr)"
        }
    }
}