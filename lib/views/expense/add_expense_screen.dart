import 'package:flutter/material.dart';

class AddExpenseResult {
  final String title;
  final int amount;
  final String type; // "income" or "expense"
  final String category;

  const AddExpenseResult({
    required this.title,
    required this.amount,
    required this.type,
    required this.category,
  });
}

class AddExpenseScreen extends StatefulWidget {
  const AddExpenseScreen({super.key});

  @override
  State<AddExpenseScreen> createState() => _AddExpenseScreenState();
}

class _AddExpenseScreenState extends State<AddExpenseScreen> {
  final titleCtrl = TextEditingController();
  final amountCtrl = TextEditingController();

  String type = "expense";
  String category = "Food";

  final categories = const [
    "Food",
    "Transport",
    "Utility",
    "Shopping",
    "Health",
    "Salary",
    "Other",
  ];

  @override
  void dispose() {
    titleCtrl.dispose();
    amountCtrl.dispose();
    super.dispose();
  }

  void _save() {
    final title = titleCtrl.text.trim();
    final amount = int.tryParse(amountCtrl.text.trim()) ?? 0;

    if (title.isEmpty || amount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter valid title & amount")),
      );
      return;
    }

    Navigator.pop(
      context,
      AddExpenseResult(
        title: title,
        amount: amount,
        type: type,
        category: category,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: const Color(0xFFF7FAFC),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text("Add Transaction", style: TextStyle(fontWeight: FontWeight.w900)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _card(
              child: Column(
                children: [
                  _segmented(),
                  const SizedBox(height: 12),
                  _field(titleCtrl, "Title", "e.g. Groceries"),
                  const SizedBox(height: 10),
                  _field(amountCtrl, "Amount", "e.g. 520", number: true),
                  const SizedBox(height: 10),
                  _dropdown(),
                ],
              ),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton.icon(
                onPressed: _save,
                icon: const Icon(Icons.check_rounded),
                label: const Text("Save", style: TextStyle(fontWeight: FontWeight.w900)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF004D40),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _card({required Widget child}) => Container(
    padding: const EdgeInsets.all(14),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(18),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.05),
          blurRadius: 18,
          offset: const Offset(0, 10),
        )
      ],
    ),
    child: child,
  );

  Widget _segmented() => Container(
    padding: const EdgeInsets.all(6),
    decoration: BoxDecoration(
      color: const Color(0xFFF2F6F7),
      borderRadius: BorderRadius.circular(16),
    ),
    child: Row(
      children: [
        Expanded(child: _chip("Expense", "expense", icon: Icons.arrow_downward_rounded)),
        const SizedBox(width: 8),
        Expanded(child: _chip("Income", "income", icon: Icons.arrow_upward_rounded)),
      ],
    ),
  );

  Widget _chip(String text, String value, {required IconData icon}) {
    final active = type == value;
    return GestureDetector(
      onTap: () => setState(() => type = value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 160),
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: active ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(14),
          boxShadow: active
              ? [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 16,
              offset: const Offset(0, 8),
            )
          ]
              : null,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 18, color: active ? const Color(0xFF004D40) : Colors.black45),
            const SizedBox(width: 6),
            Text(
              text,
              style: TextStyle(
                fontWeight: FontWeight.w900,
                color: active ? const Color(0xFF004D40) : Colors.black45,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _field(TextEditingController c, String label, String hint, {bool number = false}) => TextField(
    controller: c,
    keyboardType: number ? TextInputType.number : TextInputType.text,
    decoration: InputDecoration(
      labelText: label,
      hintText: hint,
      filled: true,
      fillColor: const Color(0xFFF7FAFC),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide.none,
      ),
    ),
  );

  Widget _dropdown() => DropdownButtonFormField<String>(
    value: category,
    items: categories.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
    onChanged: (v) => setState(() => category = v ?? category),
    decoration: InputDecoration(
      labelText: "Category",
      filled: true,
      fillColor: const Color(0xFFF7FAFC),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide.none,
      ),
    ),
  );
}