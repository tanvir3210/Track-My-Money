import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  final String name;
  final String email;

  const ProfileScreen({
    super.key,
    required this.name,
    required this.email,
  });

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late String currentName;
  late String currentEmail;

  @override
  void initState() {
    super.initState();
    currentName = widget.name;
    currentEmail = widget.email;
  }


  void _goBack() {
    Navigator.pop(context, {
      "name": currentName,
      "email": currentEmail,
    });
  }

  @override
  Widget build(BuildContext context) {
    const green = Color(0xFF004D40);

    return Scaffold(
      backgroundColor: const Color(0xFFF7FAFC),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: _goBack, // ✅ ডাটা নিয়ে ব্যাক করবে
        ),
        title: const Text("Profile", style: TextStyle(fontWeight: FontWeight.w900, color: Colors.black)),
        centerTitle: true,
      ),
      body: PopScope(

        canPop: false,
        onPopInvokedWithResult: (didPop, result) {
          if (didPop) return;
          _goBack();
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              _card(
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 28,
                      backgroundColor: green.withOpacity(.12),
                      child: const Icon(Icons.person_rounded, color: green, size: 34),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(currentName, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w900)),
                          const SizedBox(height: 2),
                          Text(currentEmail, style: const TextStyle(color: Colors.black54, fontWeight: FontWeight.w600)),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: () async {
                        final result = await showDialog<Map<String, String>>(
                          context: context,
                          builder: (ctx) {
                            final nameCtrl = TextEditingController(text: currentName);
                            final emailCtrl = TextEditingController(text: currentEmail);

                            return AlertDialog(
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                              title: const Text("Edit profile"),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  TextField(controller: nameCtrl, decoration: const InputDecoration(labelText: "Name")),
                                  TextField(controller: emailCtrl, decoration: const InputDecoration(labelText: "Email")),
                                ],
                              ),
                              actions: [
                                TextButton(onPressed: () => Navigator.pop(ctx), child: const Text("Cancel")),
                                ElevatedButton(
                                  onPressed: () {
                                    // ডায়ালগ থেকে ডাটা ফেরত নেওয়া
                                    Navigator.pop(ctx, {
                                      "name": nameCtrl.text.trim(),
                                      "email": emailCtrl.text.trim(),
                                    });
                                  },
                                  child: const Text("Save"),
                                ),
                              ],
                            );
                          },
                        );

                        if (result != null) {
                          setState(() {
                            currentName = result["name"]!;
                            currentEmail = result["email"]!;
                          });
                        }
                      },
                      icon: const Icon(Icons.edit_rounded),
                      color: green,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),
              _card(
                child: Column(
                  children: [
                    _tile(icon: Icons.lock_rounded, title: "Change password", onTap: () {}),
                    _divider(),
                    _tile(icon: Icons.settings_rounded, title: "Settings", onTap: () {}),
                    _divider(),
                    _tile(icon: Icons.help_rounded, title: "Help & support", onTap: () {}),
                  ],
                ),
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: OutlinedButton.icon(
                  onPressed: () => Navigator.pop(context), // লগআউট শুধু বের করে দিবে
                  icon: const Icon(Icons.logout_rounded),
                  label: const Text("Logout", style: TextStyle(fontWeight: FontWeight.w900)),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.red,
                    side: BorderSide(color: Colors.red.withOpacity(.35)),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }


  Widget _divider() => const Padding(padding: EdgeInsets.symmetric(horizontal: 10), child: Divider(height: 1));
  Widget _card({required Widget child}) => Container(
    padding: const EdgeInsets.all(14),
    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(18),
      boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 18, offset: const Offset(0, 10))],
    ),
    child: child,
  );
  Widget _tile({required IconData icon, required String title, required VoidCallback onTap}) =>
      ListTile(dense: true, contentPadding: const EdgeInsets.symmetric(horizontal: 6),
        leading: Icon(icon), title: Text(title, style: const TextStyle(fontWeight: FontWeight.w800)),
        trailing: const Icon(Icons.chevron_right_rounded), onTap: onTap,
      );
}