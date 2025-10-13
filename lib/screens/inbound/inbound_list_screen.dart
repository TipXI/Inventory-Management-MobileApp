import 'package:flutter/material.dart';
import '../../utils/constants.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class InboundListScreen extends StatefulWidget {
  const InboundListScreen({super.key});

  @override
  State<InboundListScreen> createState() => _InboundListScreenState();
}

class _InboundListScreenState extends State<InboundListScreen> {
  String selectedFilter = "All";

  final List<Map<String, dynamic>> invoices = [
    {
      "id": "INV-2024-045",
      "supplier": "ABC Suppliers Ltd.",
      "expected": 45,
      "received": 0,
      "status": "Open",
      "priority": "High",
      "date": "Today"
    },
    {
      "id": "INV-2024-044",
      "supplier": "XYZ Distribution Co.",
      "expected": 32,
      "received": 18,
      "status": "In Progress",
      "date": "Yesterday"
    },
    {
      "id": "INV-2024-043",
      "supplier": "Global Logistics Inc.",
      "expected": 28,
      "received": 28,
      "status": "Completed",
      "date": "2 days ago"
    },
    {
      "id": "INV-2024-042",
      "supplier": "Premium Wholesale",
      "expected": 67,
      "received": 0,
      "status": "Open",
      "priority": "Overdue",
      "date": "3 days ago"
    },
  ];

  List<Map<String, dynamic>> get filteredInvoices {
    if (selectedFilter == "All") return invoices;
    return invoices.where((inv) => inv["status"] == selectedFilter).toList();
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
            "Inbound Stock",
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
          centerTitle: false,
          actions: [
            IconButton(
              icon: const Icon(Icons.add_circle_outline,
                  color: kPrimaryColor, size: 28),
              onPressed: () {
                _showAddInvoiceForm(context);
              },
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Inbound Invoices",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              Text(
                "Manage incoming shipments",
                style: TextStyle(color: Colors.grey[600]),
              ),
              const SizedBox(height: 16),

              // Toggle buttons
              _buildFilterTabs(),

              const SizedBox(height: 16),

              // Invoice list
              Expanded(
                child: ListView.builder(
                  itemCount: filteredInvoices.length,
                  itemBuilder: (context, index) {
                    final invoice = filteredInvoices[index];
                    return _buildInvoiceCard(invoice, context);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showAddInvoiceForm(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    final TextEditingController supplierController = TextEditingController();
    final TextEditingController expectedController = TextEditingController();
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
                        "Add New Inbound Invoice",
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
                    controller: supplierController,
                    decoration: const InputDecoration(
                      labelText: "Supplier Name",
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) =>
                        value!.isEmpty ? "Please enter supplier name" : null,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: expectedController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: "Expected Items",
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) =>
                        value!.isEmpty ? "Enter expected items count" : null,
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
                            invoices.insert(0, {
                              "id":
                                  "INV-${DateTime.now().year}-${invoices.length + 50}",
                              "supplier": supplierController.text,
                              "expected":
                                  int.tryParse(expectedController.text) ?? 0,
                              "received": 0,
                              "status": selectedStatus,
                              "priority": selectedPriority,
                              "date": "Today"
                            });
                          });
                          Navigator.pop(context);
                        }
                      },
                      child: const Text(
                        "Save Invoice",
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

  Widget _buildInvoiceCard(Map<String, dynamic> invoice, BuildContext context) {
    Color statusColor;
    String buttonText;

    switch (invoice["status"]) {
      case "Open":
        statusColor = Colors.orange;
        buttonText = "Start Receiving";
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

    double progress = invoice["expected"] == 0
        ? 0
        : invoice["received"] / invoice["expected"];

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
                child: Text(invoice["status"],
                    style: TextStyle(
                        color: statusColor,
                        fontWeight: FontWeight.w500,
                        fontSize: 12)),
              ),
              Text(invoice["date"],
                  style: const TextStyle(color: Colors.grey, fontSize: 12)),
            ],
          ),
          const SizedBox(height: 8),

          // Supplier name
          Text(invoice["supplier"],
              style:
                  const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 4),

          // Items summary
          Text(
              "Expected: ${invoice["expected"]} items • Received: ${invoice["received"]} items",
              style: const TextStyle(color: Colors.grey)),

          const SizedBox(height: 8),

          // Progress bar (for In Progress or Completed)
          if (invoice["status"] != "Open")
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
              onPressed: () => _showInvoiceDetails(context, invoice),
              child: Text(buttonText),
            ),
          )
        ],
      ),
    );
  }

  void _showInvoiceDetails(BuildContext context, Map<String, dynamic> invoice) {
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
                    Text("Invoice #${invoice["id"]}",
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18)),
                    IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(Icons.close)),
                  ],
                ),
                const SizedBox(height: 8),
                Text("Supplier: ${invoice["supplier"]}",
                    style: const TextStyle(fontSize: 16)),
                const SizedBox(height: 4),
                Text(
                    "Expected Items: ${invoice["expected"]} • Received: ${invoice["received"]}",
                    style: const TextStyle(color: Colors.grey)),
                const SizedBox(height: 20),

                // Actions
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pop(context);
                    _showScanProductScreen(context, invoice);
                  },
                  icon: const Icon(Icons.qr_code_scanner),
                  label: const Text("Scan Product"),
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 48),
                    backgroundColor: kPrimaryColor,
                    foregroundColor: Colors.white,
                  ),
                ),
                const SizedBox(height: 10),

                OutlinedButton.icon(
                  onPressed: () {
                    Navigator.pop(context); // close invoice details
                    _showAddProductForm(context, invoice);
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
                if (invoice["products"] != null &&
                    invoice["products"].isNotEmpty)
                  invoice["products"].map<Widget>((p) {
                    return _buildProductTile(
                      p["name"],
                      "Qty: ${p["quantity"]} | Loc: ${p["location"]} | Exp: ${p["expiry"]}",
                      p["status"],
                    );
                  }).toList()
                else
                  const Text(
                    "No products added yet.",
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

  void _showAddProductForm(BuildContext context, Map<String, dynamic> invoice) {
    final formKey = GlobalKey<FormState>();
    final TextEditingController nameController = TextEditingController();
    final TextEditingController qtyController = TextEditingController();
    final TextEditingController locationController = TextEditingController();
    final TextEditingController expiryController = TextEditingController();

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
                      labelText: "Storage Location",
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) =>
                        value!.isEmpty ? "Enter location" : null,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: expiryController,
                    readOnly: true,
                    decoration: const InputDecoration(
                      labelText: "Expiry Date",
                      border: OutlineInputBorder(),
                      suffixIcon: Icon(Icons.calendar_today),
                    ),
                    onTap: () async {
                      final DateTime? picked = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime.now(),
                        lastDate:
                            DateTime.now().add(const Duration(days: 365 * 5)),
                      );
                      if (picked != null) {
                        expiryController.text =
                            "${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";
                      }
                    },
                    validator: (value) =>
                        value!.isEmpty ? "Please select expiry date" : null,
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
                          // Add product to this invoice’s list
                          setState(() {
                            invoice["products"] ??= [];
                            invoice["products"].add({
                              "name": nameController.text,
                              "quantity": qtyController.text,
                              "location": locationController.text,
                              "expiry": expiryController.text,
                              "status": "Pending",
                            });
                          });

                          Navigator.pop(context);

                          // Reopen invoice details to reflect new product
                          Future.delayed(const Duration(milliseconds: 200), () {
                            _showInvoiceDetails(context, invoice);
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
      BuildContext context, Map<String, dynamic> invoice) {
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
                        context, invoice, scannedCode!);
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
      BuildContext context, Map<String, dynamic> invoice, String code) {
    final formKey = GlobalKey<FormState>();
    final TextEditingController nameController =
        TextEditingController(text: "Scanned Product ($code)");
    final TextEditingController qtyController =
        TextEditingController(text: "1");
    final TextEditingController locationController =
        TextEditingController(text: "Receiving Dock");
    final TextEditingController expiryController = TextEditingController();

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
                        labelText: "Storage Location",
                        border: OutlineInputBorder()),
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: expiryController,
                    readOnly: true,
                    decoration: const InputDecoration(
                      labelText: "Expiry Date",
                      border: OutlineInputBorder(),
                      suffixIcon: Icon(Icons.calendar_today),
                    ),
                    onTap: () async {
                      final picked = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime.now(),
                        lastDate:
                            DateTime.now().add(const Duration(days: 365 * 5)),
                      );
                      if (picked != null) {
                        expiryController.text =
                            "${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";
                      }
                    },
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
                            invoice["products"] ??= [];
                            invoice["products"].add({
                              "name": nameController.text,
                              "quantity": qtyController.text,
                              "location": locationController.text,
                              "expiry": expiryController.text,
                              "status": "Pending",
                            });
                          });
                          Navigator.pop(context);
                          Future.delayed(const Duration(milliseconds: 300), () {
                            _showInvoiceDetails(context, invoice);
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
