import 'package:flutter/material.dart';
import '../models/stock_model.dart';

class StockCard extends StatelessWidget {
  final Stock stock;
  final VoidCallback? onRemove;

  const StockCard({super.key, required this.stock, this.onRemove});

  @override
  Widget build(BuildContext context) {
    bool isRising = stock.trend.length > 1 && 
                    stock.trend.last > stock.trend[stock.trend.length - 2];

    return Card(
      margin: const EdgeInsets.all(8),
      child: ListTile(
        leading: Icon(
          isRising ? Icons.arrow_upward : Icons.arrow_downward,
          color: isRising ? Colors.red : Colors.green,
        ),
        title: Text(stock.name, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text("\$${stock.price.toStringAsFixed(2)}"),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (int i = 1; i < stock.trend.length; i++)
              Container(
                width: 5,
                height: 20,
                margin: const EdgeInsets.symmetric(horizontal: 1),
                decoration: BoxDecoration(
                  color: stock.trend[i] > stock.trend[i - 1] ? Colors.red : Colors.green,
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
            if (onRemove != null)
              IconButton(
                icon: const Icon(Icons.remove_circle, color: Colors.red),
                onPressed: onRemove,
              ),
          ],
        ),
      ),
    );
  }
}
