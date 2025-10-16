import 'package:flutter/material.dart';

class NotificationsPage extends StatelessWidget {
  final List<Map<String, dynamic>> notifications = [
    {
      "icon": Icons.trending_up,
      "title": "Stock Surge!",
      "message": "Your stock XYZ increased by 5.2% today.",
      "time": "10 mins ago"
    },
    {
      "icon": Icons.shopping_cart,
      "title": "Order Executed",
      "message": "Your order for 15 shares of ABC has been completed.",
      "time": "1 hour ago"
    },
    {
      "icon": Icons.warning_amber,
      "title": "Price Alert",
      "message": "BTC dropped below ₹25,00,000. Review your watchlist.",
      "time": "2 hrs ago"
    },
    {
      "icon": Icons.notifications,
      "title": "Daily Digest",
      "message": "Your daily market summary is ready.",
      "time": "Today"
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF1c1c1e), Color(0xFF2c2c2e), Color(0xFF3a3a3c)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: const Text("Notifications"),
          backgroundColor: Colors.black87,
          centerTitle: true,
          elevation: 10,
        ),
        body: ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: notifications.length,
          itemBuilder: (context, index) {
            final notification = notifications[index];
            return NotificationCard(notification: notification);
          },
        ),
      ),
    );
  }
}

class NotificationCard extends StatelessWidget {
  final Map<String, dynamic> notification;

  const NotificationCard({super.key, required this.notification});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6,
      margin: const EdgeInsets.symmetric(vertical: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      color: Colors.grey[900]?.withOpacity(0.8),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        leading: CircleAvatar(
          backgroundColor: Colors.blueAccent.withOpacity(0.9),
          child: Icon(notification['icon'], color: Colors.white),
        ),
        title: Text(
          notification['title'],
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(
          notification['message'],
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 15,
          ),
        ),
        trailing: Text(
          notification['time'],
          style: const TextStyle(color: Colors.white54, fontSize: 12),
        ),
      ),
    );
  }
}
