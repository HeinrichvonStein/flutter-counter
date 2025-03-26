/// A model class to represent the counter object
class Counter {
  /// The counter value
  final int counter;

  /// The username of the user
  final String username;

  Counter({required this.counter, required this.username});

  factory Counter.fromJson(Map<String, dynamic> json) {
    return Counter(counter: json['counter'] as int, username: json['username'] as String);
  }
}
