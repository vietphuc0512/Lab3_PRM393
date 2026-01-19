import 'dart:async';
import 'dart:convert';

void main() async {
  print('===== EXERCISE 1: Product Model & Repository =====');
  await exercise1();

  print('\n===== EXERCISE 2: User Repository with JSON =====');
  await exercise2();

  print('\n===== EXERCISE 3: Async + Microtask Debugging =====');
  exercise3();

  // Delay to allow async logs to complete before next exercise
  await Future.delayed(Duration(seconds: 1));

  print('\n===== EXERCISE 4: Stream Transformation =====');
  await exercise4();

  print('\n===== EXERCISE 5: Factory Constructors & Cache =====');
  exercise5();
}

/* ---------------------------------------------------
   EXERCISE 1 – Product Model & Repository
   Goal: Futures and Streams
--------------------------------------------------- */

class Product {
  final int id;
  final String name;
  final double price;

  Product(this.id, this.name, this.price);

  @override
  String toString() => 'Product(id: $id, name: $name, price: $price)';
}

class ProductRepository {
  final List<Product> _products = [];
  final StreamController<Product> _controller =
  StreamController<Product>.broadcast();

  // Future: return all products
  Future<List<Product>> getAll() async {
    await Future.delayed(Duration(milliseconds: 300)); // simulate delay
    return _products;
  }

  // Stream: emit new product in real time
  Stream<Product> liveAdded() => _controller.stream;

  void addProduct(Product product) {
    _products.add(product);
    _controller.add(product); // emit to stream listeners
  }
}

Future<void> exercise1() async {
  final repo = ProductRepository();

  // Listen to live stream
  repo.liveAdded().listen((product) {
    print('Live added: $product');
  });

  repo.addProduct(Product(1, 'Laptop', 1200));
  repo.addProduct(Product(2, 'Mouse', 25));

  final allProducts = await repo.getAll();
  print('All products: $allProducts');
}

/* ---------------------------------------------------
   EXERCISE 2 – User Repository with JSON
   Goal: JSON serialization / deserialization
--------------------------------------------------- */

class User {
  final String name;
  final String email;

  User(this.name, this.email);

  factory User.fromJson(Map<String, dynamic> json) {
    return User(json['name'], json['email']);
  }

  @override
  String toString() => 'User(name: $name, email: $email)';
}

Future<List<User>> fetchUsers() async {
  await Future.delayed(Duration(milliseconds: 300)); // simulate API call

  // Simulated JSON response
  final jsonString = '''
  [
    {"name": "Alice", "email": "alice@example.com"},
    {"name": "Bob", "email": "bob@example.com"}
  ]
  ''';

  final List decoded = jsonDecode(jsonString);
  return decoded.map((e) => User.fromJson(e)).toList();
}

Future<void> exercise2() async {
  final users = await fetchUsers();
  users.forEach(print);
}

/* ---------------------------------------------------
   EXERCISE 3 – Async + Microtask Debugging
   Goal: Event loop vs microtask queue
--------------------------------------------------- */

void exercise3() {
  print('Start');

  scheduleMicrotask(() {
    print('Microtask 1');
  });

  Future(() {
    print('Event task 1');
  });

  scheduleMicrotask(() {
    print('Microtask 2');
  });

  print('End');

}

/* ---------------------------------------------------
   EXERCISE 4 – Stream Transformation
   Goal: map() and where()
--------------------------------------------------- */

Future<void> exercise4() async {
  final stream = Stream.fromIterable([1, 2, 3, 4, 5]);

  await stream
      .map((n) => n * n)          // square values
      .where((n) => n.isEven)     // keep even numbers
      .forEach((value) {
    print('Stream value: $value');
  });
}

/* ---------------------------------------------------
   EXERCISE 5 – Factory Constructors & Cache
   Goal: Singleton using factory constructor
--------------------------------------------------- */

class Settings {
  static final Settings _instance = Settings._internal();

  Settings._internal(); // private constructor

  factory Settings() {
    return _instance;
  }
}

void exercise5() {
  final a = Settings();
  final b = Settings();

  print('Same instance: ${identical(a, b)}'); // true
}
