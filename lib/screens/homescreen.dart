
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/stock_service.dart';
import '../models/stock_model.dart';
import '../widgets/stock_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  final StockService stockService = StockService();
  List<Stock> stocks = [];
  List<Stock> filteredStocks = [];
  List<String> watchlist = [];
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadWatchlist();
  }

  void loadWatchlist() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      watchlist = prefs.getStringList("watchlist") ?? ["AAPL", "TSLA", "GOOGL", "MSFT", "AMZN", "NFLX", "NVDA", "META", "BABA", "BRK.A",
      "JPM", "V", "DIS", "PYPL", "ADBE", "INTC", "CSCO", "PEP", "KO", "PFE",
      "MRNA", "NKE", "AMD", "XOM", "CVX", "WMT", "T", "UNH", "BAC", "MA",
      "PG", "GS", "LLY", "TMO", "AVGO", "ABT", "CRM", "COST", "DHR", "NEE",
      "MCD", "HON", "TXN", "VZ", "UPS", "ACN", "CMCSA", "QCOM", "ORCL", "IBM",
      "BLK", "MDT", "LMT", "SBUX", "LIN", "ISRG", "CVS", "RTX", "NOW", "LOW",
      "AMAT", "BKNG", "TGT", "SPGI", "GE", "ADP", "INTU", "SCHW", "CAT", "MMM",
      "C", "FIS", "AXP", "GILD", "SYK", "USB", "ZTS", "DE", "DUK", "SO",
      "BDX", "TJX", "CL", "BSX", "PGR", "PNC", "CCI", "HUM", "TFC", "WM",
      "NSC", "CB", "CI", "EL", "SHW", "ITW", "LRCX", "D", "ECL", "APD",
      "HCA", "AON", "MET", "ICE", "FDX", "EW", "MCO", "PSA", "ADSK", "MAR",
      "CSX", "ROP", "DOW", "IDXX", "MSCI", "EMR", "EQIX", "NOC", "PEG", "FTNT",
      "CME", "MNST", "TRV", "F", "PPG", "MS", "VLO", "CLX", "OXY", "NEM",
      "DVN", "REGN", "KMB", "HLT", "EOG", "PH", "DLR", "MCHP", "TEL", "XEL",
      "ALL", "AIG", "PRU", "DXCM", "AZO", "AMP", "AFL", "SRE", "SBAC", "SNPS",
      "RSG", "EXC", "STZ", "BAX", "LHX", "RMD", "DTE", "TDG", "HES", "CMG",
      "WELL", "ZBH", "BXP", "CHD", "MTD", "EQR", "VICI", "IFF", "LEN", "EFX",
      "AVB", "CAG", "VRSN", "CTAS", "WY", "CDNS", "FANG", "PAYX", "OTIS", "LUV",
      "WMB", "AWK", "ETN", "HIG", "TXT", "PCAR", "OKE", "XYL", "AEE", "DOV",
      "PPL", "TYL", "CE", "PEG", "BF.B", "NDAQ", "NTAP", "WEC", "BALL", "HOLX",
      "TSCO", "JKHY", "FAST", "EXPD", "PTC", "BBY", "HSY", "CINF", "KEYS", "FE",
      "EVRG", "CMS", "ROK", "DRE", "PNR", "CMSA", "MLM", "ARE", "GWW", "VMC",
      "FTV", "STE", "IDXX", "IP", "ODFL", "WAB", "MTB", "LH", "BIO", "CTLT",
      "TROW", "UAL", "AES", "LNT", "ETR", "PPG", "ZBRA", "TRGP", "CBOE", "HWM",
      "WTW", "BKR", "RJF", "JNPR", "RHI", "PFG", "FRT", "WRB", "BWA", "SNA",
      "LYB", "CFG", "VTR", "PEAK", "NRG", "EXR", "PKI", "CHRW", "RCL", "ULTA",
      "FOXA", "FOX", "IPG", "MOH", "NVR", "LYV", "JBHT", "GPC", "AAL", "NI",
      "HST", "PNW", "ATO", "MKC", "ALK", "MAS", "SEE", "LEG", "AAP", "LDOS",
      "EIX", "ROL", "UHS", "WDC", "PNR", "HEI", "WHR", "REG", "SRCL", "MHK",
      "L", "BF.A", "EMN", "FMC", "TXT", "ETR", "HOG", "SJM", "HRL", "HAS",
      "CMA", "ZION", "NWL", "IVZ", "KIM", "PBCT", "UNM", "PWR", "RE", "AIV",
      "LKQ", "VNO", "PNC-P", "PNC-Q", "PNC-R", "PNC-S", "PNC-T", "PNC-U", "PNC-V", "PNC-W",
      "PNC-X", "PNC-Y", "PNC-Z", "PNC-AA", "PNC-BB", "PNC-CC", "PNC-DD", "PNC-EE", "PNC-FF", "PNC-GG"
    ];
      stockService.connect(watchlist, updateStockData);
    });
  }
  //  void loadMore() {
    // setState(() {
      // if (currentLimit + 20 <= watchlist.length) {
        // currentLimit += 20;
      // } else {
        // currentLimit = watchlist.length; // Load all remaining stocks
      // }
    // });
  // }


  void saveWatchlist() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setStringList("watchlist", watchlist);
  }

  void updateStockData(Stock updatedStock) {
    setState(() {
      int index = stocks.indexWhere((s) => s.name == updatedStock.name);
      if (index != -1) {
        stocks[index] = updatedStock;
      } else {
        stocks.add(updatedStock);
      }
      filterStocks();
    });
  }

  void filterStocks() {
    String query = searchController.text.toUpperCase();
    setState(() {
      filteredStocks = stocks.where((stock) => stock.name.contains(query)).toList();
    });
  }

  void addStockToWatchlist(String symbol) {
    setState(() {
      if (!watchlist.contains(symbol)) {
        watchlist.add(symbol);
        saveWatchlist();
        stockService.connect([symbol], updateStockData);
      }
    });
  }

  void removeStockFromWatchlist(String symbol) {
    setState(() {
      watchlist.remove(symbol);
      saveWatchlist();
      stocks.removeWhere((stock) => stock.name == symbol);
      filterStocks();
    });
  }

  @override
  void dispose() {
    stockService.disconnect();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Live Stock Market")),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                hintText: "Search Stocks...",
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
              onChanged: (value) => filterStocks(),
            ),
          ),
          ElevatedButton(
            onPressed: () => setState(() {}),
            child: Text("🔄 Refresh Stocks"),
          ),
          Expanded(
            child: stocks.isEmpty
                ? Center(child: CircularProgressIndicator())
                : ListView.builder(
                    itemCount: filteredStocks.length,
                    itemBuilder: (context, index) {
                      return StockCard(
                        stock: filteredStocks[index],
                        onRemove: () => removeStockFromWatchlist(filteredStocks[index].name),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
