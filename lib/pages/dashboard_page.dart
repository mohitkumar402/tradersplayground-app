import 'package:flutter/material.dart';
import '../services/stock_service.dart';
import '../models/stock_model.dart';
import 'trade_page.dart'; // ✅ Import TradePage
import 'stock_details_page.dart';


class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  DashboardPageState createState() => DashboardPageState();
}

class DashboardPageState extends State<DashboardPage> {
  final StockService stockService = StockService();
  List<Stock> stocks = [];
  bool isLoading = true;
  int currentLimit = 20; // ✅ Load 20 initially
  List<String> stockSymbols = [
    "AAPL", "TSLA", "GOOGL", "MSFT", "AMZN", "NFLX", "NVDA", "META",
    "BABA", "BRK.A", "JPM", "V", "DIS", "PYPL", "ADBE", "INTC", "CSCO",
    "PEP", "KO", "PFE", "MRNA", "NKE", "AMD", "XOM", "CVX", "WMT", "T",
  ];

  @override
  void initState() {
    super.initState();
    fetchMarketData();
  }

  Future<void> fetchMarketData() async {
    setState(() => isLoading = true);

    // ✅ Fetch stock data in parallel instead of one-by-one
    List<Stock?> fetchedStocks = await Future.wait(
      stockSymbols.sublist(0, currentLimit).map(stockService.fetchStock),
    );

    setState(() {
      stocks = fetchedStocks.whereType<Stock>().toList();
      isLoading = false;
    });
  }

  void loadMore() {
    setState(() {
      if (currentLimit + 10 <= stockSymbols.length) {
        currentLimit += 10; // Load 10 more
      } else {
        currentLimit = stockSymbols.length; // Load remaining
      }
    });
    fetchMarketData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(Icons.currency_bitcoin, size: 30),
                SizedBox(width: 10),
                Text("Traders Playground"),
              ],
            ),
            Row(
              children: [
                SizedBox(width: 10),
                SizedBox(
                  width: 200,
                  height: 35,
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Search...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 10),
                IconButton(
                  icon: Icon(Icons.help_outline),
                  onPressed: () {
                    // Redirect to help page
                  },
                ),
              ],
            )
          ],
        ),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Column(
              children: [
                // **Balance & View More Section**
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(Icons.currency_bitcoin, size: 30),
                          Text(
                            "Available Balance",
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            "USDT: \$5000.00",
                            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.green),
                          ),
                        ],
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
                        onPressed: () {
                          // Implement navigation
                        },
                        child: Text("View More"),
                      )
                    ],
                  ),
                ),

                // **Market Overview Section**
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Market Overview",
                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),

                // **Stock List Section**
                Expanded(
                  child: ListView.builder(
                   itemCount: stocks.length,
                   itemBuilder: (context, index) {
                     Stock stock = stocks[index];
                      return Card(
                       elevation: 4,
                       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      child: ListTile(
                         leading: Icon(
                             stock.change > 0 ? Icons.trending_up : Icons.trending_down, 
                             size: 40, 
                             color: stock.change > 0 ? Colors.green : Colors.red,
                           ),
                         title: Text(stock.name, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                         subtitle: Text(
                           "Price: \$${stock.price} (${stock.change}%)",
                           style: TextStyle(fontSize: 16, color: stock.change > 0 ? Colors.green : Colors.red),
                          ),
                         trailing: Row(
                           mainAxisSize: MainAxisSize.min,
                           children: [
                            ElevatedButton(
                               style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                                onPressed: () {
                // ✅ Navigate to Trade Page
                                   Navigator.push(
                                   context,
                                     MaterialPageRoute(builder: (context) => TradePage(stock: stock)),
                                   );
                                 },
                               child: Text("Trade"),
                              ),
                              SizedBox(width: 8), // Space between buttons
                              ElevatedButton(
                                  style: ElevatedButton.styleFrom(backgroundColor: Colors.grey),
                                  onPressed: () {
                          // ✅ Navigate to Stock Details Page
                                 Navigator.push(
                                    context,
                                   MaterialPageRoute(builder: (context) => StockDetailsPage(stock: stock)),
                                 );
                               },
                               child: Text("View"),
                             ),
                           ],
                         ),
                      ),
                    );
                 },
              ),

                    
                ),

                // **Load More Button**
                if (currentLimit < stockSymbols.length)
                  Center(
                    child: ElevatedButton(
                      onPressed: loadMore,
                      child: Text("Load More"),
                    ),
                  ),
              ],
            ),
    );
  }
}
