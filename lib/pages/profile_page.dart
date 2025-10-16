// profilepage.dart
// A complete ProfilePage module for a stock app.
// Self-contained Flutter widget that demonstrates: 
// - User header with avatar and membership tier
// - Portfolio summary with sparkline
// - Asset allocation pie chart (CustomPainter)
// - Top holdings list
// - Notification & alert settings
// - Account & security settings
// - Community / learning cards
// - Support & app info section
// - Light/Dark theme adaptive styling

import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> with SingleTickerProviderStateMixin {
  bool isDark = false;
  Color brandColor = Colors.indigoAccent;
  bool pushNotifications = true;
  bool emailNotifications = false;
  bool twoFactor = true;

  // Mock portfolio data
  final double portfolioValue = 125430.72;
  final double dailyChangePercent = 1.84; // +1.84%
  final List<double> sparklineData = [100000, 101200, 100800, 102000, 101500, 123000, 125430];

  // Mock asset allocation
  final Map<String, double> allocation = {
    'Tech': 38,
    'Finance': 22,
    'Healthcare': 14,
    'Energy': 10,
    'Cash': 16,
  };

  // Mock top holdings
  final List<Map<String, dynamic>> topHoldings = [
    {'ticker': 'AAPL', 'name': 'Apple Inc.', 'shares': 42, 'value': 63000, 'change': 2.1},
    {'ticker': 'MSFT', 'name': 'Microsoft', 'shares': 18, 'value': 24000, 'change': -0.5},
    {'ticker': 'AMZN', 'name': 'Amazon', 'shares': 6, 'value': 12000, 'change': 1.7},
  ];

  late AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(vsync: this, duration: const Duration(seconds: 2))..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  String formatCurrency(double value) {
    // Simple currency formatter for demo
    return '\$' + value.toStringAsFixed(2).replaceAllMapped(RegExp(r"\B(?=(\d{3})+(?!\d))"), (m) => ',');
  }

  @override
  Widget build(BuildContext context) {
    final bg = isDark ? const Color(0xFF0D0F12) : const Color(0xFFF7F9FC);
    final cardBg = isDark ? const Color(0xFF121417) : Colors.white;
    final textColor = isDark ? Colors.white : Colors.black87;

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        backgroundColor: bg,
        elevation: 0,
        title: Text('Profile', style: TextStyle(color: brandColor, fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            icon: Icon(isDark ? Icons.light_mode : Icons.dark_mode, color: textColor),
            onPressed: () => setState(() => isDark = !isDark),
            tooltip: 'Toggle theme',
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header
              _buildHeader(cardBg, textColor),
              const SizedBox(height: 16),

              // Portfolio summary card
              _buildPortfolioCard(cardBg, textColor),
              const SizedBox(height: 12),

              // Grid: Asset allocation & top holdings
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child: _buildAllocationCard(cardBg, textColor)),
                  const SizedBox(width: 12),
                  Expanded(child: _buildTopHoldingsCard(cardBg, textColor)),
                ],
              ),

              const SizedBox(height: 12),

              // Notifications & Account Settings
              _buildSettingsCard(cardBg, textColor),

              const SizedBox(height: 12),

              // Community & Learning
              _buildCommunityCard(cardBg, textColor),

              const SizedBox(height: 12),

              // Support & App info
              _buildSupportCard(cardBg, textColor),

              const SizedBox(height: 24),

              // Logout Button
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: () {
                  // Handle logout
                },
                child: const Text('Log out', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(Color cardBg, Color textColor) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 12, offset: const Offset(0, 6))],
      ),
      child: Row(
        children: [
          Stack(
            alignment: Alignment.bottomRight,
            children: [
              CircleAvatar(radius: 36, backgroundColor: brandColor, child: const Icon(Icons.person, size: 36, color: Colors.white)),
              Positioned(
                right: 0,
                bottom: 0,
                child: ScaleTransition(
                  scale: Tween(begin: 0.9, end: 1.15).animate(CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut)),
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                    child: Icon(Icons.workspace_premium, size: 16, color: brandColor),
                  ),
                ),
              )
            ],
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Alex Morgan', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: textColor)),
                const SizedBox(height: 6),
                Row(children: [
                  Text('@alex.m', style: TextStyle(color: textColor.withOpacity(0.7))),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(color: brandColor.withOpacity(0.12), borderRadius: BorderRadius.circular(8)),
                    child: Text('Pro', style: TextStyle(color: brandColor, fontWeight: FontWeight.w600)),
                  )
                ]),
                const SizedBox(height: 8),
                Row(
                  children: [
                    _smallInfo('Portfolio', formatCurrency(portfolioValue)),
                    const SizedBox(width: 12),
                    _smallInfo('Since', 'Jan 2021'),
                  ],
                )
              ],
            ),
          ),
          IconButton(onPressed: () {}, icon: const Icon(Icons.edit), tooltip: 'Edit profile'),
        ],
      ),
    );
  }

  Widget _smallInfo(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _buildPortfolioCard(Color cardBg, Color textColor) {
    final changePositive = dailyChangePercent >= 0;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 12, offset: const Offset(0, 6))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Portfolio Value', style: TextStyle(color: textColor.withOpacity(0.7))),
                  const SizedBox(height: 6),
                  Text(formatCurrency(portfolioValue), style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: textColor)),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text('Daily', style: TextStyle(color: textColor.withOpacity(0.7))),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Icon(changePositive ? Icons.arrow_upward : Icons.arrow_downward, color: changePositive ? Colors.greenAccent : Colors.redAccent),
                      const SizedBox(width: 4),
                      Text('${dailyChangePercent.toStringAsFixed(2)}%', style: TextStyle(color: changePositive ? Colors.greenAccent : Colors.redAccent, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 60,
            child: CustomPaint(
              painter: SparklinePainter(sparklineData, accentColor: brandColor),
              child: Container(),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(backgroundColor: brandColor, padding: const EdgeInsets.symmetric(vertical: 12), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                  onPressed: () {},
                  icon: const Icon(Icons.add),
                  label: const Text('Add Funds'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 12), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                  onPressed: () {},
                  child: const Text('Withdraw'),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildAllocationCard(Color cardBg, Color textColor) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: cardBg, borderRadius: BorderRadius.circular(16), boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10, offset: const Offset(0, 6))]),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text('Asset Allocation', style: TextStyle(fontWeight: FontWeight.bold, color: textColor)),
            Text('View', style: TextStyle(color: textColor.withOpacity(0.6))),
          ],),
          const SizedBox(height: 12),
          SizedBox(
            height: 160,
            child: Row(
              children: [
                Expanded(
                  child: CustomPaint(
                    painter: PieChartPainter(allocation, colors: _generatePalette(allocation.length)),
                    child: Container(),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: allocation.entries.map((e) {
                      final idx = allocation.keys.toList().indexOf(e.key);
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 6),
                        child: Row(
                          children: [
                            Container(width: 12, height: 12, decoration: BoxDecoration(color: _generatePalette(allocation.length)[idx], borderRadius: BorderRadius.circular(3))),
                            const SizedBox(width: 8),
                            Expanded(child: Text('${e.key}')), 
                            Text('${e.value.toStringAsFixed(0)}%'),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildTopHoldingsCard(Color cardBg, Color textColor) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: cardBg, borderRadius: BorderRadius.circular(16), boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10, offset: const Offset(0, 6))]),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text('Top Holdings', style: TextStyle(fontWeight: FontWeight.bold, color: textColor)),
            Text('See all', style: TextStyle(color: textColor.withOpacity(0.6))),
          ]),
          const SizedBox(height: 12),
          ...topHoldings.map((h) => ListTile(
            contentPadding: EdgeInsets.zero,
            dense: true,
            leading: CircleAvatar(backgroundColor: brandColor.withOpacity(0.12), child: Text(h['ticker'], style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: brandColor))),
            title: Text(h['name'], style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
            subtitle: Text('${h['shares']} shares • ${formatCurrency(h['value'].toDouble())}'),
            trailing: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('${h['change'].toStringAsFixed(2)}%', style: TextStyle(color: (h['change'] >= 0) ? Colors.greenAccent : Colors.redAccent, fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Icon(Icons.chevron_right, size: 18)
              ],
            ),
          )).toList()
        ],
      ),
    );
  }

  Widget _buildSettingsCard(Color cardBg, Color textColor) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: cardBg, borderRadius: BorderRadius.circular(16), boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10, offset: const Offset(0, 6))]),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Notifications & Settings', style: TextStyle(fontWeight: FontWeight.bold, color: textColor)),
          const SizedBox(height: 12),
          SwitchListTile(
            value: pushNotifications,
            onChanged: (v) => setState(() => pushNotifications = v),
            title: const Text('Push Notifications'),
            subtitle: const Text('Receive instant alerts for price changes and news'),
            secondary: const Icon(Icons.notifications_active),
          ),
          SwitchListTile(
            value: emailNotifications,
            onChanged: (v) => setState(() => emailNotifications = v),
            title: const Text('Email Notifications'),
            subtitle: const Text('Monthly statements and marketing emails'),
            secondary: const Icon(Icons.email),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.lock_outline),
            title: const Text('Security & 2FA'),
            subtitle: Text(twoFactor ? 'Two-factor enabled' : 'Two-factor disabled'),
            trailing: Switch(value: twoFactor, onChanged: (v) => setState(() => twoFactor = v)),
          ),
          ListTile(
            leading: const Icon(Icons.account_balance_wallet_outlined),
            title: const Text('Linked accounts'),
            subtitle: const Text('Bank and broker accounts'),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.palette_outlined),
            title: const Text('Brand color'),
            subtitle: const Text('Customize the app accent color'),
            onTap: () async {
              // For demo: toggle between two accent colors
              setState(() => brandColor = (brandColor == Colors.indigoAccent) ? Colors.deepPurpleAccent : Colors.indigoAccent);
            },
          )
        ],
      ),
    );
  }

  Widget _buildCommunityCard(Color cardBg, Color textColor) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: cardBg, borderRadius: BorderRadius.circular(16), boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10, offset: const Offset(0, 6))]),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('Community & Learning', style: TextStyle(fontWeight: FontWeight.bold, color: textColor)),
        const SizedBox(height: 12),
        Row(children: [
          Expanded(child: _miniCard(icon: Icons.school, title: 'Courses', subtitle: '3 in progress')),
          const SizedBox(width: 8),
          Expanded(child: _miniCard(icon: Icons.people, title: 'Following', subtitle: '12 investors')),
        ]),
        const SizedBox(height: 8),
        _miniCard(icon: Icons.emoji_events, title: 'Achievements', subtitle: '5 badges'),
      ]),
    );
  }

  Widget _miniCard({required IconData icon, required String title, required String subtitle}) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), color: Colors.grey.withOpacity(0.06)),
      child: Row(children: [
        Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: brandColor.withOpacity(0.12), borderRadius: BorderRadius.circular(8)), child: Icon(icon, color: brandColor)),
        const SizedBox(width: 10),
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(title, style: const TextStyle(fontWeight: FontWeight.bold)), Text(subtitle, style: const TextStyle(fontSize: 12, color: Colors.grey))])
      ]),
    );
  }

  Widget _buildSupportCard(Color cardBg, Color textColor) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: cardBg, borderRadius: BorderRadius.circular(16), boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10, offset: const Offset(0, 6))]),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('Support & App', style: TextStyle(fontWeight: FontWeight.bold, color: textColor)),
        const SizedBox(height: 8),
        ListTile(leading: const Icon(Icons.help_outline), title: const Text('Help & FAQs'), onTap: () {}),
        ListTile(leading: const Icon(Icons.feedback_outlined), title: const Text('Send feedback'), onTap: () {}),
        ListTile(leading: const Icon(Icons.info_outline), title: const Text('App version'), subtitle: const Text('v1.3.0')),
      ]),
    );
  }

  List<Color> _generatePalette(int n) {
    final base = [Colors.blueAccent, Colors.green, Colors.orangeAccent, Colors.redAccent, Colors.purpleAccent, Colors.teal];
    return List.generate(n, (i) => base[i % base.length]);
  }
}

// Simple sparkline custom painter
class SparklinePainter extends CustomPainter {
  final List<double> points;
  final Color accentColor;
  SparklinePainter(this.points, {this.accentColor = Colors.indigoAccent});

  @override
  void paint(Canvas canvas, Size size) {
    final paintLine = Paint()
      ..color = accentColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.6
      ..strokeCap = StrokeCap.round;

    final paintFill = Paint()
      ..color = accentColor.withOpacity(0.12)
      ..style = PaintingStyle.fill;

    if (points.isEmpty) return;

    final minVal = points.reduce(min);
    final maxVal = points.reduce(max);
    final scaleY = (maxVal - minVal) == 0 ? 1.0 : (size.height / (maxVal - minVal));
    final stepX = size.width / (points.length - 1);

    final path = Path();
    for (int i = 0; i < points.length; i++) {
      final dx = i * stepX;
      final dy = size.height - ((points[i] - minVal) * scaleY);
      if (i == 0) path.moveTo(dx, dy);
      else path.lineTo(dx, dy);
    }

    final pathFill = Path.from(path);
    pathFill.lineTo(size.width, size.height);
    pathFill.lineTo(0, size.height);
    pathFill.close();

    canvas.drawPath(pathFill, paintFill);
    canvas.drawPath(path, paintLine);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

// Simple pie chart painter
class PieChartPainter extends CustomPainter {
  final Map<String, double> data;
  final List<Color> colors;
  PieChartPainter(this.data, {required this.colors});

  @override
  void paint(Canvas canvas, Size size) {
    final total = data.values.fold(0.0, (a, b) => a + b);
    double startRadian = -pi / 2;
    final rect = Rect.fromLTWH(0, 0, size.width, size.height);
    final paint = Paint()..style = PaintingStyle.fill;
    final center = Offset(size.width / 2, size.height / 2);
    final radius = min(size.width, size.height) / 2.2;

    int idx = 0;
    for (var entry in data.entries) {
      final sweep = (entry.value / total) * 2 * pi;
      paint.color = colors[idx % colors.length];
      canvas.drawArc(Rect.fromCircle(center: center, radius: radius), startRadian, sweep, true, paint);
      startRadian += sweep;
      idx++;
    }

    // draw inner circle for donut look
    final innerPaint = Paint()..color = Colors.white;
    canvas.drawCircle(center, radius * 0.6, innerPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
