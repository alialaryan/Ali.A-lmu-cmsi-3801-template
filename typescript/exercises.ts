import { open } from "node:fs/promises";
import * as fs from 'fs';
import * as readline from 'readline';
import { constants } from "node:buffer";

export function change(amount: bigint): Map<bigint, bigint> {
  if (amount < 0) {
    throw new RangeError("Amount cannot be negative");
  }
  let counts: Map<bigint, bigint> = new Map();
  let remaining = amount;
  for (const denomination of [25n, 10n, 5n, 1n]) {
    counts.set(denomination, remaining / denomination);
    remaining %= denomination;
  }
  return counts;
}

//From homework helper video
export function firstThenApply<T, U>(
  arr: T[],
  predicate: (x: T) => boolean,
  f: (x: T) => U): U | U[] | undefined {
  if (arr.length === 0) {
    return undefined;
  }
  const filteredArray = arr.find(predicate);
  if (filteredArray === undefined) {
    return undefined;
  }
  return f(filteredArray);
}

//From homework helper video
export function* powersGenerator(base: bigint): Generator<bigint> {
  let power = 0n;
  while (true) {
    yield base ** power;
    power++;
  }
}

//From homework helper video
export async function meaningfulLineCount(path: string): Promise<number> {
  let count = 0;
  const fileStream = fs.createReadStream(path);
  const rl = readline.createInterface({
    input: fileStream,
    crlfDelay: Infinity
  });

  for await (const line of rl) {
    const trimmedLine = line.trim();
    if (trimmedLine.length > 0 && !trimmedLine.startsWith('#')) {
      count++;
    }
  }
  return count;
}

//From homework helper video
interface Sphere {
  kind: "Sphere";
  radius: number;
}

interface Box {
  kind: "Box";
  width: number;
  length: number;
  depth: number;
}

export type Shape = Sphere | Box;

export function surfaceArea(shape: Shape): number {
  switch (shape.kind) {
    case "Sphere":
      return 4 * Math.PI * Math.pow(shape.radius, 2);
    case "Box":
      return 2 * (shape.width * shape.length + shape.width * shape.depth + shape.length * shape.depth);
  }
}

export function volume(shape: Shape): number {
  switch (shape.kind) {
    case "Sphere":
      return (4 / 3) * Math.PI * Math.pow(shape.radius, 3);
    case "Box":
      return shape.width * shape.length * shape.depth;
  }
}

//From homework helper video
export interface BinarySearchTree<T> {
  size(): number;
  insert(value: T): BinarySearchTree<T>;
  contains(value: T): boolean;
  inorder(): Iterable<T>;
}

export class Empty<T> implements BinarySearchTree<T> {
  size(): number {
    return 0;
  }
  insert(value: T): BinarySearchTree<T> {
    return new Node(value, new Empty(), new Empty());
  }
  contains(_value: T): boolean {
    return false;
  }
  inorder(): Iterable<T> {
    return [];
  }
  toString(): string {
    return "()";
  }
}

class Node<T> implements BinarySearchTree<T> {
  constructor(
    private value: T,
    private left: BinarySearchTree<T>,
    private right: BinarySearchTree<T>
  ) { }

  size(): number {
    return 1 + this.left.size() + this.right.size();
  }

  insert(value: T): BinarySearchTree<T> {
    if (value < this.value) {
      return new Node(this.value, this.left.insert(value), this.right);
    } else if (value > this.value) {
      return new Node(this.value, this.left, this.right.insert(value));
    }
    return this;
  }

  contains(value: T): boolean {
    if (value === this.value) {
      return true;
    } else if (value < this.value) {
      return this.left.contains(value);
    } else {
      return this.right.contains(value);
    }
  }

  inorder(): Iterable<T> {
    function* inorderGenerator(node: Node<T>): IterableIterator<T> {
      if (node.left) yield* node.left.inorder();
      yield node.value;
      if (node.right) yield* node.right.inorder();
    }
    return inorderGenerator(this);
  }

  toString(): string {
    const leftStr = this.left.toString();
    const rightStr = this.right.toString();
    return `(${leftStr !== "()" ? leftStr : ""}${this.value}${rightStr !== "()" ? rightStr : ""})`;
  }
}

