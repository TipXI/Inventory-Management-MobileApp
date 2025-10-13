import 'package:flutter/material.dart';
import '../../utils/constants.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Good morning, Alex",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 4),
                        Text(
                          "Here's your inventory overview",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                  CircleAvatar(
                    radius: 20,
                    backgroundColor: kPrimaryColor.withOpacity(0.1),
                    child: const Icon(Icons.person, color: kPrimaryColor),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // Stats cards
              Row(
                children: [
                  Expanded(
                    child: _buildStatCard(
                        "Inbound Orders", "24", "+12%", Colors.blue),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildStatCard(
                        "Outbound Orders", "18", "+8%", Colors.green),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // Quick actions
              const Text("Quick Actions",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child:
                        _buildQuickAction(Icons.qr_code_scanner, "Scan Code"),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildQuickAction(
                        Icons.add_circle_outline, "Add Product"),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // Recent Activity
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Recent Activity",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  Text("View All",
                      style: TextStyle(
                          color: kPrimaryColor, fontWeight: FontWeight.w500)),
                ],
              ),
              const SizedBox(height: 12),
              _buildActivityCard(
                  Icons.check_circle_outline,
                  "Received shipment #INV-2024-001",
                  "2 hours ago",
                  Colors.green),
              _buildActivityCard(
                  Icons.warning_amber_outlined,
                  "Low stock alert: Product ABC123",
                  "4 hours ago",
                  Colors.orange),

              const SizedBox(height: 24),

              // Expiry alerts
              Container(
                decoration: BoxDecoration(
                  color: Colors.red[50],
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    const Icon(Icons.error_outline, color: Colors.red),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Expiry Alerts",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.red)),
                          Text("5 products expiring within 7 days"),
                        ],
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)),
                      ),
                      child: const Text("Review Items"),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard(
      String title, String value, String change, Color color) {
    return Container(
      width: 160,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text(title,
              style:
                  const TextStyle(fontWeight: FontWeight.w500, fontSize: 14)),
          const SizedBox(height: 8),
          Text(value,
              style: TextStyle(
                  fontSize: 28, fontWeight: FontWeight.bold, color: color)),
          Text(change, style: TextStyle(color: color)),
        ],
      ),
    );
  }

  Widget _buildQuickAction(IconData icon, String label) {
    return Container(
      width: 150,
      padding: const EdgeInsets.symmetric(vertical: 20),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Icon(icon, size: 30, color: Colors.blue),
          const SizedBox(height: 8),
          Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  Widget _buildActivityCard(
      IconData icon, String text, String time, Color color) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 2)],
      ),
      child: Row(
        children: [
          Icon(icon, color: color),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(text,
                    style: const TextStyle(
                        fontWeight: FontWeight.w500, fontSize: 14)),
                Text(time,
                    style: const TextStyle(color: Colors.grey, fontSize: 12)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
