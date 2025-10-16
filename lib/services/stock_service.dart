import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:web_socket_channel/io.dart';
import '../models/stock_model.dart';

class StockService {
  final String apiKey = "cuuera9r01qlidi3kiugcuuera9r01qlidi3kiv0"; // Replace with your actual API key
  final String socketUrl = "wss://ws.finnhub.io?token=cuuera9r01qlidi3kiugcuuera9r01qlidi3kiv0";
  final String baseUrl = "https://finnhub.io/api/v1/quote";
  late IOWebSocketChannel channel;
  final Map<String, List<double>> stockTrends = {};

  // Fetch a single stock using an API (for initial load)
  Future<Stock?> fetchStock(String symbol) async {
    final String url = "$baseUrl?symbol=$symbol&token=$apiKey";

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return Stock(
          name: symbol,
          price: data['c'].toDouble(),
          change: data['d'].toDouble(),
          trend: [], // No trend data initially
        );
      } else {
        if (kDebugMode) {
          print("Failed to fetch stock data: ${response.statusCode}");
        }
        return null;
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error fetching stock: $e");
      }
      return null;
    }
  }

  // Connect to WebSocket for real-time stock updates
  void connect(List<String> stockSymbols, Function(Stock) onStockUpdate) {
    channel = IOWebSocketChannel.connect(socketUrl);

    for (String symbol in stockSymbols) {
      channel.sink.add(jsonEncode({"type": "subscribe", "symbol": symbol}));
    }

    channel.stream.listen((message) {
      final data = jsonDecode(message);
      if (data["type"] == "trade") {
        for (var trade in data["data"]) {
          String symbol = trade["s"];
          double price = trade["p"];

          stockTrends.putIfAbsent(symbol, () => []);
          stockTrends[symbol]!.add(price);
          if (stockTrends[symbol]!.length > 10) {
            stockTrends[symbol]!.removeAt(0);
          }

          Stock stock = Stock(
            name: symbol,
            price: price,
            trend: stockTrends[symbol]!, change: 0.0,
          );

          onStockUpdate(stock);
        }
      }
    });
  }

  // Disconnect from WebSocket when not needed
  void disconnect() {
    channel.sink.close();
  }
}
