import 'package:flutter/material.dart';
import '../../utils/constants.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class OutboundListScreen extends StatefulWidget {
  const OutboundListScreen({super.key});

  @override
  State<OutboundListScreen> createState() => _OutboundListScreenState();
}

class _OutboundListScreenState extends State<OutboundListScreen> {
  String selectedFilter = "All";

  final List<Map<String, dynamic>> orders = [
    {
      "id": "ORD-2024-089",
      "customer": "Tech Retailers Inc.",
      "ordered": 45,
      "prepared": 0,
      "status": "Open",
      "priority": "High",
      "date": "Today"
    },
    {
      "id": "ORD-2024-088",
      "customer": "MegaStore LLP",
      "ordered": 32,
      "prepared": 18,
      "status": "In Progress",
      "date": "Yesterday"
    },
    {
      "id": "ORD-2024-087",
      "customer": "City Shoppers",
      "ordered": 28,
      "prepared": 28,
      "status": "Completed",
      "date": "2 days ago"
    },
    {
      "id": "ORD-2024-086",
      "customer": "Downtown Boutique",
      "ordered": 67,
      "prepared": 0,
      "status": "Open",
      "priority": "Overdue",
      "date": "3 days ago"
    },
  ];

  List<Map<String, dynamic>> get filteredOrders {
    if (selectedFilter == "All") return orders;
    return orders.where((ord) => ord["status"] == selectedFilter).toList();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          title: const Text(
            "Outbound Orders",
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
          centerTitle: false,
          actions: [
            IconButton(
              icon: const Icon(Icons.add_circle_outline,
                  color: kPrimaryColor, size: 28),
              onPressed: () {
                _showAddOrderForm(context);
              },
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Outgoing Orders",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              Text(
                "Manage outgoing shipments",
                style: TextStyle(color: Colors.grey[600]),
              ),
              const SizedBox(height: 16),

              // Toggle buttons
              _buildFilterTabs(),

              const SizedBox(height: 16),

              // Order list
              Expanded(
                child: ListView.builder(
                  itemCount: filteredOrders.length,
                  itemBuilder: (context, index) {
                    final order = filteredOrders[index];
                    return _buildOrderCard(order, context);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showAddOrderForm(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    final TextEditingController customerController = TextEditingController();
    final TextEditingController orderedController = TextEditingController();
    String selectedStatus = "Open";
    String selectedPriority = "Normal";

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) {
        return Padding(
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: 20,
            bottom: MediaQuery.of(context).viewInsets.bottom + 20,
          ),
          child: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Add New Outbound Order",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(Icons.close),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: customerController,
                    decoration: const InputDecoration(
                      labelText: "Customer Name",
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) =>
                        value!.isEmpty ? "Please enter customer name" : null,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: orderedController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: "Total Items",
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) =>
                        value!.isEmpty ? "Enter total items count" : null,
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<String>(
                    value: selectedStatus,
                    items: ["Open", "In Progress", "Completed"]
                        .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                        .toList(),
                    decoration: const InputDecoration(
                      labelText: "Status",
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (value) => selectedStatus = value!,
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<String>(
                    value: selectedPriority,
                    items: ["Normal", "High", "Overdue"]
                        .map((p) => DropdownMenuItem(value: p, child: Text(p)))
                        .toList(),
                    decoration: const InputDecoration(
                      labelText: "Priority",
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (value) => selectedPriority = value!,
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: kPrimaryColor,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      onPressed: () {
                        if (formKey.currentState!.validate()) {
                          setState(() {
                            orders.insert(0, {
                              "id":
                                  "ORD-${DateTime.now().year}-${orders.length + 90}",
                              "customer": customerController.text,
                              "ordered":
                                  int.tryParse(orderedController.text) ?? 0,
                              "prepared": 0,
                              "status": selectedStatus,
                              "priority": selectedPriority,
                              "date": "Today"
                            });
                          });
                          Navigator.pop(context);
                        }
                      },
                      child: const Text(
                        "Save Order",
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildFilterTabs() {
    final filters = ["All", "Open", "In Progress", "Completed"];

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: filters.map((filter) {
        final isActive = selectedFilter == filter;
        return Expanded(
          child: GestureDetector(
            onTap: () => setState(() => selectedFilter = filter),
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 4),
              padding: const EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                color: isActive
                    ? kPrimaryColor.withOpacity(0.1)
                    : Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                    color: isActive ? kPrimaryColor : Colors.transparent),
              ),
              child: Center(
                child: Text(
                  filter,
                  style: TextStyle(
                    color: isActive ? kPrimaryColor : Colors.grey[700],
                    fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
                  ),
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildOrderCard(Map<String, dynamic> order, BuildContext context) {
    Color statusColor;
    String buttonText;

    switch (order["status"]) {
      case "Open":
        statusColor = Colors.orange;
        buttonText = "Start Packing";
        break;
      case "In Progress":
        statusColor = Colors.blue;
        buttonText = "Continue";
        break;
      case "Completed":
        statusColor = Colors.green;
        buttonText = "View Details";
        break;
      default:
        statusColor = Colors.grey;
        buttonText = "View";
    }

    double progress = order["ordered"] == 0
        ? 0
        : order["prepared"] / order["ordered"];

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 2)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header: Status + Date
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8)),
                child: Text(order["status"],
                    style: TextStyle(
                        color: statusColor,
                        fontWeight: FontWeight.w500,
                        fontSize: 12)),
              ),
              Text(order["date"],
                  style: const TextStyle(color: Colors.grey, fontSize: 12)),
            ],
          ),
          const SizedBox(height: 8),

          // Customer name
          Text(order["customer"],
              style:
                  const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 4),

          // Items summary
          Text(
              "Ordered: ${order["ordered"]} items • Prepared: ${order["prepared"]} items",
              style: const TextStyle(color: Colors.grey)),

          const SizedBox(height: 8),

          // Progress bar (for In Progress or Completed)
          if (order["status"] != "Open")
            Column(
              children: [
                LinearProgressIndicator(
                  value: progress,
                  color: statusColor,
                  backgroundColor: Colors.grey[200],
                ),
                const SizedBox(height: 4),
                Align(
                    alignment: Alignment.centerRight,
                    child: Text("${(progress * 100).round()}% Complete",
                        style:
                            const TextStyle(color: Colors.grey, fontSize: 12))),
              ],
            ),

          const SizedBox(height: 12),

          // Action button
          Align(
            alignment: Alignment.centerRight,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: statusColor,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8)),
              onPressed: () => _showOrderDetails(context, order),
              child: Text(buttonText),
            ),
          )
        ],
      ),
    );
  }

  void _showOrderDetails(BuildContext context, Map<String, dynamic> order) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Order #${order["id"]}",
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18)),
                    IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(Icons.close)),
                  ],
                ),
                const SizedBox(height: 8),
                Text("Customer: ${order["customer"]}",
                    style: const TextStyle(fontSize: 16)),
                const SizedBox(height: 4),
                Text(
                    "Ordered Items: ${order["ordered"]} • Prepared: ${order["prepared"]}",
                    style: const TextStyle(color: Colors.grey)),
                const SizedBox(height: 20),

                // Actions
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pop(context);
                    _showScanProductScreen(context, order);
                  },
                  icon: const Icon(Icons.qr_code_scanner),
                  label: const Text("Scan Product to Pack"),
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 48),
                    backgroundColor: kPrimaryColor,
                    foregroundColor: Colors.white,
                  ),
                ),
                const SizedBox(height: 10),

                OutlinedButton.icon(
                  onPressed: () {
                    Navigator.pop(context); // close order details
                    _showAddProductForm(context, order);
                  },
                  icon: const Icon(Icons.add_circle_outline),
                  label: const Text("Add Product Manually"),
                  style: OutlinedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 48),
                      side: const BorderSide(color: Colors.grey)),
                ),

                const SizedBox(height: 20),

                const Divider(),
                const Text("Products",
                    style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 12),

                // Example products
                if (order["products"] != null &&
                    order["products"].isNotEmpty)
                  ...order["products"].map<Widget>((p) {
                    return _buildProductTile(
                      p["name"],
                      "Qty: ${p["quantity"]} | Loc: ${p["location"]} | Status: ${p["status"]}",
                      p["status"],
                    );
                  }).toList()
                else
                  const Text(
                    "No products packed yet.",
                    style: TextStyle(color: Colors.grey),
                  ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showAddProductForm(BuildContext context, Map<String, dynamic> order) {
    final formKey = GlobalKey<FormState>();
    final TextEditingController nameController = TextEditingController();
    final TextEditingController qtyController = TextEditingController();
    final TextEditingController locationController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) {
        return Padding(
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: 20,
            bottom: MediaQuery.of(context).viewInsets.bottom + 20,
          ),
          child: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Add Product",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(Icons.close),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: nameController,
                    decoration: const InputDecoration(
                      labelText: "Product Name",
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) =>
                        value!.isEmpty ? "Please enter product name" : null,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: qtyController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: "Quantity",
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) =>
                        value!.isEmpty ? "Enter quantity" : null,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: locationController,
                    decoration: const InputDecoration(
                      labelText: "Storage Area",
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) =>
                        value!.isEmpty ? "Enter area" : null,
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: kPrimaryColor,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      onPressed: () {
                        if (formKey.currentState!.validate()) {
                          // Add product to this order’s list
                          setState(() {
                            order["products"] ??= [];
                            order["products"].add({
                              "name": nameController.text,
                              "quantity": qtyController.text,
                              "location": locationController.text,
                              "status": "Packed",
                            });
                          });

                          Navigator.pop(context);

                          // Reopen order details to reflect new product
                          Future.delayed(const Duration(milliseconds: 200), () {
                            _showOrderDetails(context, order);
                          });
                        }
                      },
                      child: const Text(
                        "Save Product",
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _showScanProductScreen(
      BuildContext context, Map<String, dynamic> order) {
    String? scannedCode;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => Scaffold(
          appBar: AppBar(
            title: const Text("Scan Product"),
            backgroundColor: kPrimaryColor,
          ),
          body: Stack(
            children: [
              MobileScanner(
                onDetect: (barcodeCapture) {
                  final Barcode barcode = barcodeCapture.barcodes.first;
                  if (barcode.rawValue == null) return;

                  scannedCode = barcode.rawValue!;
                  Navigator.pop(context);

                  // Simulate product autofill
                  Future.delayed(const Duration(milliseconds: 300), () {
                    _showAddProductFormWithPrefill(
                        context, order, scannedCode!);
                  });
                },
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  padding: const EdgeInsets.all(16),
                  color: Colors.black.withOpacity(0.5),
                  child: const Text(
                    "Align barcode within the frame to scan",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showAddProductFormWithPrefill(
      BuildContext context, Map<String, dynamic> order, String code) {
    final formKey = GlobalKey<FormState>();
    final TextEditingController nameController =
        TextEditingController(text: "Scanned Product ($code)");
    final TextEditingController qtyController =
        TextEditingController(text: "1");
    final TextEditingController locationController =
        TextEditingController(text: "Dispatch Dock");

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) {
        return Padding(
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: 20,
            bottom: MediaQuery.of(context).viewInsets.bottom + 20,
          ),
          child: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Confirm Scanned Product",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: nameController,
                    decoration: const InputDecoration(
                        labelText: "Product Name",
                        border: OutlineInputBorder()),
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: qtyController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                        labelText: "Quantity", border: OutlineInputBorder()),
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: locationController,
                    decoration: const InputDecoration(
                        labelText: "Storage Area",
                        border: OutlineInputBorder()),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: kPrimaryColor,
                          padding: const EdgeInsets.symmetric(vertical: 14)),
                      onPressed: () {
                        if (formKey.currentState!.validate()) {
                          setState(() {
                            order["products"] ??= [];
                            order["products"].add({
                              "name": nameController.text,
                              "quantity": qtyController.text,
                              "location": locationController.text,
                              "status": "Packed",
                            });
                          });
                          Navigator.pop(context);
                          Future.delayed(const Duration(milliseconds: 300), () {
                            _showOrderDetails(context, order);
                          });
                        }
                      },
                      child: const Text("Save Product",
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildProductTile(String name, String info, String status) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(name,
                  style: const TextStyle(
                      fontWeight: FontWeight.w500, fontSize: 14)),
              Text(info, style: const TextStyle(color: Colors.grey)),
            ],
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
                color: Colors.orange[100],
                borderRadius: BorderRadius.circular(6)),
            child: Text(status,
                style: const TextStyle(color: Colors.orange, fontSize: 12)),
          ),
        ],
      ),
    );
  }
}
