class Stock {
  final String name;
  final double price;
  final double change; // Add this field
  final List<double> trend;

  Stock({
    required this.name,
    required this.price,
    required this.change, // Initialize change
    required this.trend,
  });

  factory Stock.fromJson(Map<String, dynamic> json, String symbol) {
    return Stock(
      name: symbol,
      price: json['c'].toDouble(),
      change: json['d'].toDouble(), // Assign change
      trend: [],
    );
  }
}
