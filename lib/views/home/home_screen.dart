import '../profile/profile_screen.dart';
import '../expense/add_expense_screen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String userName = "Farhan";
  String userEmail = "farhan@gmail.com";

  List<AddExpenseResult> transactions = [
    const AddExpenseResult(title: "Groceries", amount: 520, type: "expense", category: "Food"),
    const AddExpenseResult(title: "Salary", amount: 35000, type: "income", category: "Salary"),
  ];

  @override
  void initState() {
    super.initState();
    _loadSavedData();
  }

  // ✅ ডাটা লোড করার ফাংশন
  Future<void> _loadSavedData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      userName = prefs.getString('user_name') ?? "Farhan";
      userEmail = prefs.getString('user_email') ?? "farhan@gmail.com";

      final String? txData = prefs.getString('transactions_list');
      if (txData != null) {
        final List<dynamic> decodedList = jsonDecode(txData);
        transactions = decodedList.map((item) => AddExpenseResult(
          title: item['title'],
          amount: item['amount'],
          type: item['type'],
          category: item['category'],
        )).toList();
      }
    });
  }

  // ✅ ডাটা সেভ করার ফাংশন
  Future<void> _saveData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_name', userName);
    await prefs.setString('user_email', userEmail);

    final List<Map<String, dynamic>> txMapList = transactions.map((tx) => {
      'title': tx.title,
      'amount': tx.amount,
      'type': tx.type,
      'category': tx.category,
    }).toList();

    await prefs.setString('transactions_list', jsonEncode(txMapList));
  }

  int get totalIncome => transactions
      .where((t) => t.type == "income")
      .fold(0, (sum, item) => sum + item.amount);

  int get totalExpense => transactions
      .where((t) => t.type == "expense")
      .fold(0, (sum, item) => sum + item.amount);

  int get balance => totalIncome - totalExpense;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7FAFC),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 14, 16, 90),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _topBar(),
              const SizedBox(height: 16),
              _balanceCard(balance),
              const SizedBox(height: 14),
              Row(
                children: [
                  Expanded(child: _MiniStat(title: "Income", amount: "৳ $totalIncome", up: true)),
                  const SizedBox(width: 12),
                  Expanded(child: _MiniStat(title: "Expense", amount: "৳ $totalExpense", up: false)),
                ],
              ),
              const SizedBox(height: 18),
              _sectionTitle("Recent Transactions", action: "See all"),
              const SizedBox(height: 10),

              // ✅ Empty State লজিক এখানে যোগ করা হয়েছে
              transactions.isEmpty
                  ? Center(
                child: Column(
                  children: [
                    const SizedBox(height: 60),
                    Icon(Icons.account_balance_wallet_outlined, size: 80, color: Colors.grey.withValues(alpha: 0.5)),
                    const SizedBox(height: 16),
                    const Text("No transactions yet!", style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold, fontSize: 18)),
                    const Text("Add your first expense or income", style: TextStyle(color: Colors.grey)),
                  ],
                ),
              )
                  : ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: transactions.length,
                itemBuilder: (context, index) {
                  final actualIndex = transactions.length - 1 - index;
                  final tx = transactions[actualIndex];

                  return Dismissible(
                    key: Key(tx.title + actualIndex.toString()),
                    direction: DismissDirection.endToStart,
                    background: Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      padding: const EdgeInsets.only(right: 20),
                      decoration: BoxDecoration(
                        color: Colors.redAccent.withValues(alpha: 0.8),
                        borderRadius: BorderRadius.circular(18),
                      ),
                      alignment: Alignment.centerRight,
                      child: const Icon(Icons.delete_sweep_rounded, color: Colors.white, size: 28),
                    ),
                    onDismissed: (direction) {
                      setState(() {
                        transactions.removeAt(actualIndex);
                      });
                      _saveData();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("${tx.title} deleted"), backgroundColor: Colors.redAccent),
                      );
                    },
                    child: _TxItem(
                      title: tx.title,
                      category: tx.category,
                      amount: "${tx.type == "income" ? "+" : "-"}৳ ${tx.amount}",
                      time: "Just now",
                      down: tx.type == "expense",
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final res = await Navigator.push<AddExpenseResult>(
            context,
            MaterialPageRoute(builder: (_) => const AddExpenseScreen()),
          );

          if (res != null) {
            setState(() {
              transactions.add(res);
            });
            _saveData();
          }
        },
        backgroundColor: const Color(0xFF004D40),
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add_rounded),
        label: const Text("Add"),
      ),
    );
  }

  Widget _topBar() {
    return Row(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Good evening, $userName 👋",
                style: TextStyle(color: Colors.black.withValues(alpha: 0.55), fontWeight: FontWeight.w600)),
            const SizedBox(height: 2),
            const Text("Track My Money", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900)),
          ],
        ),
        const Spacer(),
        GestureDetector(
          onTap: () async {
            // ✅ প্রোফাইল থেকে ডাটা ফিরিয়ে আনার জন্য async/await ব্যবহার করা হয়েছে
            final res = await Navigator.push<Map<String, String>>(
              context,
              MaterialPageRoute(
                builder: (_) => ProfileScreen(name: userName, email: userEmail),
              ),
            );

            if (res != null) {
              setState(() {
                userName = res["name"] ?? userName;
                userEmail = res["email"] ?? userEmail;
              });
              _saveData(); // আপডেট হওয়ার পর স্থায়ীভাবে সেভ হবে
            }
          },
          child: Container(
            height: 44, width: 44,
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14)),
            child: const Icon(Icons.person_rounded, color: Color(0xFF004D40)),
          ),
        ),
      ],
    );
  }

  Widget _balanceCard(int currentBalance) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF004D40), Color(0xFF0B6B5E), Color(0xFF4DB6AC)],
        ),
        borderRadius: BorderRadius.circular(22),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.account_balance_wallet_rounded, color: Colors.white),
              SizedBox(width: 12),
              Expanded(child: Text("Total Balance", style: TextStyle(color: Colors.white70, fontWeight: FontWeight.w700))),
            ],
          ),
          const SizedBox(height: 14),
          Text("৳ $currentBalance", style: const TextStyle(fontSize: 34, fontWeight: FontWeight.w900, color: Colors.white)),
        ],
      ),
    );
  }

  Widget _sectionTitle(String title, {required String action}) {
    return Row(
      children: [
        Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w900)),
        const Spacer(),
        Text(action, style: const TextStyle(color: Color(0xFF004D40), fontWeight: FontWeight.w800)),
      ],
    );
  }
}

class _MiniStat extends StatelessWidget {
  final String title, amount; final bool up;
  const _MiniStat({required this.title, required this.amount, required this.up});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(18)),
      child: Row(
        children: [
          Icon(up ? Icons.arrow_upward_rounded : Icons.arrow_downward_rounded,
              color: up ? const Color(0xFF0B6B5E) : const Color(0xFFD84C4C)),
          const SizedBox(width: 12),
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(title, style: TextStyle(color: Colors.black.withValues(alpha: 0.55), fontWeight: FontWeight.w700)),
            Text(amount, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w900)),
          ]),
        ],
      ),
    );
  }
}

class _TxItem extends StatelessWidget {
  final String title, category, amount, time; final bool down;
  const _TxItem({required this.title, required this.category, required this.amount, required this.time, required this.down});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(18)),
      child: Row(
        children: [
          Icon(down ? Icons.shopping_bag_rounded : Icons.payments_rounded,
              color: down ? const Color(0xFFD84C4C) : const Color(0xFF0B6B5E)),
          const SizedBox(width: 12),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(title, style: const TextStyle(fontWeight: FontWeight.w900)),
            Text("$category • $time", style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.grey)),
          ])),
          Text(amount, style: TextStyle(fontWeight: FontWeight.w900, color: down ? const Color(0xFFD84C4C) : const Color(0xFF0B6B5E))),
        ],
      ),
    );
  }
}