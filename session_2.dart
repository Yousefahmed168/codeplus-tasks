void main() {
  // ===== Task 1 - Anonymous Functions =====
  execute(() {
    print('Hello Dart!');
  });

  print('---');

  // ===== Task 2 - Arrow Functions =====
  print(square(5));
  print(greet('Ali'));
  print(isEven(4));

  print('---');

  // ===== Task 3 - Higher-Order Functions & Callbacks =====
  calculate(10, 5, (a, b) => a + b);       // Addition
  calculate(10, 5, (a, b) => a - b);       // Subtraction
  calculate(10, 5, (a, b) => a * b);       // Multiplication
}

// ---------- Task 1 ----------
void execute(Function() action) {
  action();
}

// ---------- Task 2 (converted to arrow functions) ----------
int square(int number) => number * number;

String greet(String name) => "Hello $name";

bool isEven(int number) => number % 2 == 0;

// ---------- Task 3 ----------
void calculate(int a, int b, int Function(int, int) operation) {
  final result = operation(a, b);
  print('Result: $result');
}