import 'package:flutter/material.dart';
import '../models/stock_model.dart';

class StockDetailsPage extends StatefulWidget {
  final Stock stock;

  const StockDetailsPage({super.key, required this.stock});

  @override
  State<StockDetailsPage> createState() => _StockDetailsPageState();
}

class _StockDetailsPageState extends State<StockDetailsPage> {
  bool isFavorited = false;

  @override
  Widget build(BuildContext context) {
    final stock = widget.stock;

    return Scaffold(
      backgroundColor: const Color(0xFFF6F8FB),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        title: Text("${stock.name} Details", style: const TextStyle(color: Colors.black)),
        iconTheme: const IconThemeData(color: Colors.black),
        actions: [
          IconButton(
            icon: Icon(isFavorited ? Icons.star : Icons.star_border, color: Colors.orange),
            onPressed: () => setState(() => isFavorited = !isFavorited),
          )
        ],
      ),
      body: Scrollbar(
        thickness: 6.0,
        radius: const Radius.circular(10),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(stock),
              const SizedBox(height: 20),
              _buildStatsSection(stock),
              const SizedBox(height: 20),
              _buildDescriptionSection(),
              const SizedBox(height: 20),
              _buildChartPlaceholder(),
              const SizedBox(height: 20),
              _buildTradeActionButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(Stock stock) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.blue[50],
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.shade100.withOpacity(0.4),
            blurRadius: 8,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 28,
            backgroundColor: Colors.blue.shade100,
            child: const Icon(Icons.show_chart, size: 30, color: Colors.blue),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(stock.name,
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text(
                  "Price: \$${stock.price.toStringAsFixed(2)}",
                  style: const TextStyle(fontSize: 16),
                ),
                Text(
                  "Change: ${stock.change.toStringAsFixed(2)}%",
                  style: TextStyle(
                    fontSize: 16,
                    color: stock.change >= 0 ? Colors.green : Colors.red,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildStatsSection(Stock stock) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Key Stats",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.shade300,
                blurRadius: 6,
                offset: const Offset(0, 3),
              )
            ],
          ),
          child: Column(
            children: [
              _buildStatRow("Open", "\$${(stock.price - 1).toStringAsFixed(2)}"),
              _buildStatRow("High", "\$${(stock.price + 3).toStringAsFixed(2)}"),
              _buildStatRow("Low", "\$${(stock.price - 2).toStringAsFixed(2)}"),
              _buildStatRow("Volume", "1.5M"),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStatRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(fontSize: 16, color: Colors.black54)),
          Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildDescriptionSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        Text("Company Overview",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        SizedBox(height: 10),
        Text(
          "This stock belongs to a leading company in the tech sector, known for innovation and high market potential. Investors are closely watching its growth trend and volatility as it remains a strong performer in the portfolio.",
          style: TextStyle(fontSize: 15, color: Colors.black87),
        )
      ],
    );
  }

  Widget _buildChartPlaceholder() {
    return Container(
      height: 180,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: const Center(
        child: Text("📊 Chart View Coming Soon...",
            style: TextStyle(fontSize: 16, color: Colors.grey)),
      ),
    );
  }

  Widget _buildTradeActionButton() {
    return Center(
      child: ElevatedButton.icon(
        onPressed: () {
          // Navigate to Trade Page
          Navigator.pushNamed(context, '/trade', arguments: widget.stock);
        },
        icon: const Icon(Icons.shopping_cart_checkout),
        label: const Text("Trade Stock"),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.orange,
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }
}
