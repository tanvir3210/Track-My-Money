import 'package:flutter/material.dart';
import 'profile_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const teal = Color(0xFF004D40);
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: CustomScrollView(
        slivers: [
          _buildHeader(context, teal),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Row(children: [
                _statCard("Income", "৳ 60k", Icons.arrow_upward, Colors.green),
                const SizedBox(width: 15),
                _statCard("Expense", "৳ 15k", Icons.arrow_downward, Colors.red),
              ]),
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
                  (context, i) => _itemTile("Item ${i + 1}", "Shop", "500", Icons.shopping_bag, teal),
              childCount: 5,
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showSheet(context, teal),
        backgroundColor: teal,
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text("Add", style: TextStyle(color: Colors.white)),
      ),
    );
  }


  Widget _buildHeader(BuildContext context, Color col) => SliverAppBar(
    expandedHeight: 180, pinned: true, backgroundColor: col, elevation: 0,
    actions: [IconButton(icon: const Icon(Icons.account_circle, color: Colors.white, size: 28), onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (c) => const ProfileScreen())))],
    flexibleSpace: FlexibleSpaceBar(
      background: Container(
        decoration: BoxDecoration(gradient: LinearGradient(colors: [col, const Color(0xFF00796B)]), borderRadius: const BorderRadius.vertical(bottom: Radius.circular(30))),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          const Text("Total Balance", style: TextStyle(color: Colors.white70)),
          const Text("৳ 45,250", style: TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold)),
        ]),
      ),
    ),
  );


  Widget _statCard(String label, String val, IconData icon, Color col) => Expanded(
    child: Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15), boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)]),
      child: Row(children: [
        Icon(icon, size: 16, color: col),
        const SizedBox(width: 8),
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(label, style: const TextStyle(fontSize: 10, color: Colors.grey)),
          Text(val, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
        ]),
      ]),
    ),
  );

  // Transection item
  Widget _itemTile(String t, String s, String p, IconData i, Color col) => Card(
    margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
    child: ListTile(
      leading: CircleAvatar(backgroundColor: col.withOpacity(0.1), child: Icon(i, color: col, size: 20)),
      title: Text(t, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
      subtitle: Text(s, style: const TextStyle(fontSize: 12)),
      trailing: Text("-৳$p", style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
    ),
  );

  // Add expense from
  void _showSheet(BuildContext context, Color col) => showModalBottomSheet(
    context: context, isScrollControlled: true,
    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(25))),
    builder: (c) => Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(c).viewInsets.bottom + 20, top: 20, left: 20, right: 20),
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        const Text("New Expense", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 15),
        _inputField("Description", Icons.edit),
        const SizedBox(height: 10),
        _inputField("Amount", Icons.money, isNum: true),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: () => Navigator.pop(c),
          style: ElevatedButton.styleFrom(backgroundColor: col, minimumSize: const Size(double.infinity, 50), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
          child: const Text("Save", style: TextStyle(color: Colors.white)),
        ),
      ]),
    ),
  );

  Widget _inputField(String label, IconData icon, {bool isNum = false}) => TextField(
    keyboardType: isNum ? TextInputType.number : TextInputType.text,
    decoration: InputDecoration(labelText: label, prefixIcon: Icon(icon, size: 20), border: OutlineInputBorder(borderRadius: BorderRadius.circular(12))),
  );
}