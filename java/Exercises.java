import java.util.List;
import java.util.Map;
import java.util.HashMap;
import java.util.Optional;
import java.util.function.Predicate;
import java.io.BufferedReader;
import java.io.FileReader;
import java.io.IOException;
import java.util.Optional;
import java.io.*;
import java.util.*;

public class Exercises {
    static Map<Integer, Long> change(long amount) {
        if (amount < 0) {
            throw new IllegalArgumentException("Amount cannot be negative");
        }
        var counts = new HashMap<Integer, Long>();
        for (var denomination : List.of(25, 10, 5, 1)) {
            counts.put(denomination, amount / denomination);
            amount %= denomination;
        }
        return counts;
    }

    //This returns the lowercase version of the first sting to match predicate
    public static Optional<String> firstThenLowerCase(List<String> a, Predicate<String> p) {
        return a.stream().filter(p).findFirst().map(String::toLowerCase);
    }

    // Sayer record is used to facilliate changing functions 
    static record Sayer(String phrase) {
        Sayer and(String word) {
            return new Sayer(phrase + " " + word);
        }
    }
    public static Sayer say(String phrase) {
        return new Sayer(phrase);
    }
    public static Sayer say() {
        return new Sayer("");
    }

    //Counts non-empty lines that are not comments
    public static int meaningfulLineCount(String fileName) throws FileNotFoundException {
        try (BufferedReader reader = new BufferedReader(new FileReader(fileName))) {
            return (int)reader.lines().filter(line -> !line.trim().isEmpty() && !line.trim().startsWith("#")).count();
        } catch (IOException e) {
            throw new FileNotFoundException("No such file");
        }
    }
}

record Quaternion(double a, double b, double c, double d) {
    public static Quaternion ZERO = new Quaternion(0, 0, 0, 0);
    public static Quaternion I = new Quaternion(0, 1, 0, 0);
    public static Quaternion J = new Quaternion(0, 0, 1, 0);
    public static Quaternion K = new Quaternion(0, 0, 0, 1);
    Quaternion {
        if (Double.isNaN(a) || 
            Double.isNaN(b) || 
            Double.isNaN(c) || 
            Double.isNaN(d)) {
            throw new IllegalArgumentException("Coefficients cannot be NaN");
        }
    }
    Quaternion plus(Quaternion other) {
        return new Quaternion(a + other.a, b + other.b, c + other.c, d + other.d);
    }
    Quaternion times(Quaternion other) {
        return new Quaternion(a * other.a - b * other.b - c * other.c - d * other.d,
                               a * other.b + b * other.a + c * other.d - d * other.c,
                               a * other.c - b * other.d + c * other.a + d * other.b,
                               a * other.d + b * other.c - c * other.b + d * other.a);
    }
    Quaternion conjugate() {
        return new Quaternion(a, -b, -c, -d);
    }
    List<Double> coefficients() {
        return Arrays.asList(a,b,c,d);
    }
    @Override
    public String toString() {
        String quaternionString = "";
        if (a != 0) {
            quaternionString += a;
        }
        double[] coefficients = {b, c, d};
        char[] letters = {'i', 'j', 'k'};
        for (int index = 0; index < coefficients.length; index++) {
            double coeff = coefficients[index];
            char varName = letters[index];
            if (Math.abs(coeff) == 1) {
                quaternionString += (coeff > 0 ? "+" : "-") + varName;
            } else if (coeff != 0) {
                String sign = coeff > 0 ? "+" : "";
                quaternionString += sign + coeff + varName;
            }
        }
        if (quaternionString.length() == 0){
            return "0";
        }
        if (quaternionString.charAt(0) == '+') {
            quaternionString = quaternionString.substring(1);
        }
        return quaternionString;
    }
}

sealed interface BinarySearchTree permits Empty, Node {
    boolean isEmpty();
    int size();
    boolean contains(String value);
    BinarySearchTree insert(String value);
}
final record Empty() implements BinarySearchTree {
    @Override
    public boolean isEmpty() {
        return true;
    }
    @Override
    public int size() {
        return 0;
    }
    @Override
    public boolean contains(String value) {
        return false;
    }
    @Override
    public BinarySearchTree insert(String value) {
        return new Node(value, this, this);
    }
    @Override
    public String toString() {
        return "()";
    }
}
final class Node implements BinarySearchTree {
    private final String value;
    private final BinarySearchTree left;
    private final BinarySearchTree right;
    public Node(String value, BinarySearchTree left, BinarySearchTree right) {
        this.value = value;
        this.left = left;
        this.right = right;
    }
    @Override
    public boolean isEmpty() {
        return false;
    }
    @Override
    public int size() {
        return 1 + left.size() + right.size();
    }
    @Override
    public boolean contains(String value) {
        return this.value.equals(value) || left.contains(value) || right.contains(value);
    }
    @Override
    public BinarySearchTree insert(String value) {
        if (value.compareTo(this.value) < 0) {
            return new Node(this.value, left.insert(value), right);
        } else {
            return new Node(this.value, left, right.insert(value));
        }
    }
    @Override
    public String toString() { 
        String leftStr = left.isEmpty() ? "" : left.toString();
        String rightStr = right.isEmpty() ? "" : right.toString(); 
        return "(" + leftStr + value + rightStr + ")";
    }
}