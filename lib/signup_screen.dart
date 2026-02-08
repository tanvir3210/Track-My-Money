import 'package:flutter/material.dart';

class SignupScreen extends StatelessWidget {
  const SignupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(colors: [Color(0xFF004D40), Color(0xFF4DB6AC)]),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("Create Account", style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white)),
            const SizedBox(height: 10),
            const Text("Start your journey with us!", style: TextStyle(color: Colors.white70)),
            const SizedBox(height: 40),
            _input("Full Name", Icons.person, false),
            const SizedBox(height: 15),
            _input("Email", Icons.email, false),
            const SizedBox(height: 15),
            _input("Password", Icons.lock, true),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              ),
              child: const Text("Sign Up", style: TextStyle(color: Color(0xFF004D40), fontWeight: FontWeight.bold)),
            ),
            TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Already have an account? Login", style: TextStyle(color: Colors.white70))
            ),
          ],
        ),
      ),
    );
  }

  Widget _input(String hint, IconData icon, bool pass) {
    return TextField(
      obscureText: pass,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.white60),
        prefixIcon: Icon(icon, color: Colors.white),
        filled: true,
        fillColor: Colors.white.withOpacity(0.2),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none),
      ),
    );
  }
}