import 'dart:ui';
import 'package:flutter/material.dart';
import '../home/home_screen.dart';
import 'signup_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final email = TextEditingController();
  final pass = TextEditingController();
  bool hide = true, remember = true;

  @override
  void dispose() {
    email.dispose();
    pass.dispose();
    super.dispose();
  }

  void _login() {
    final e = email.text.trim();
    final p = pass.text.trim();

    if (e.isEmpty || p.isEmpty) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(const SnackBar(content: Text("Email & Password required")));
      return;
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const HomeScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        body: Stack(children: [
          _bg(),
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(18),
                child: Column(
                  children: [
                    _header(),
                    const SizedBox(height: 18),
                    _glassCard(context),
                    const SizedBox(height: 14),
                    Text(
                      "By continuing you agree to Terms & Privacy.",
                      style: TextStyle(color: Colors.white.withOpacity(.75), fontSize: 12),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ]),
      ),
    );
  }

  Widget _bg() => Container(
    decoration: const BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0xFF004D40), Color(0xFF0B6B5E), Color(0xFF4DB6AC)],
      ),
    ),
    child: Stack(children: const [
      Positioned(top: -80, right: -80, child: _Glow(220)),
      Positioned(bottom: -120, left: -90, child: _Glow(260)),
    ]),
  );

  Widget _header() => Column(children: [
    Container(
      height: 64,
      width: 64,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(.18),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white.withOpacity(.25)),
      ),
      child: const Icon(Icons.account_balance_wallet_rounded, color: Colors.white, size: 34),
    ),
    const SizedBox(height: 12),
    const Text(
      "Track My Money",
      style: TextStyle(fontSize: 26, fontWeight: FontWeight.w900, color: Colors.white),
    ),
    const SizedBox(height: 4),
    Text("Smart expense tracking, beautifully.", style: TextStyle(color: Colors.white.withOpacity(.85))),
  ]);

  Widget _glassCard(BuildContext context) => ClipRRect(
    borderRadius: BorderRadius.circular(22),
    child: BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(.12),
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: Colors.white.withOpacity(.22)),
          boxShadow: [
            BoxShadow(blurRadius: 30, offset: const Offset(0, 16), color: Colors.black.withOpacity(.18)),
          ],
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          const Text(
            "Welcome back",
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: Colors.white),
          ),
          const SizedBox(height: 6),
          Text(
            "Sign in to continue tracking your money.",
            style: TextStyle(color: Colors.white.withOpacity(.80), fontSize: 13.5),
          ),
          const SizedBox(height: 18),

          _field(
            ctrl: email,
            label: "Email",
            hint: "you@example.com",
            icon: Icons.mail_rounded,
            type: TextInputType.emailAddress,
          ),
          const SizedBox(height: 12),
          _field(
            ctrl: pass,
            label: "Password",
            hint: "••••••••",
            icon: Icons.lock_rounded,
            obscure: hide,
            suffix: IconButton(
              onPressed: () => setState(() => hide = !hide),
              icon: Icon(
                hide ? Icons.visibility_rounded : Icons.visibility_off_rounded,
                color: Colors.white.withOpacity(.85),
              ),
            ),
          ),
          const SizedBox(height: 10),

          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Row(children: [
              SizedBox(
                height: 22,
                width: 22,
                child: Checkbox(
                  value: remember,
                  onChanged: (v) => setState(() => remember = v ?? true),
                  side: BorderSide(color: Colors.white.withOpacity(.8)),
                  checkColor: const Color(0xFF004D40),
                  activeColor: Colors.white,
                ),
              ),
              const SizedBox(width: 10),
              Text(
                "Remember me",
                style: TextStyle(color: Colors.white.withOpacity(.85), fontWeight: FontWeight.w700),
              ),
            ]),
            TextButton(
              onPressed: () {},
              style: TextButton.styleFrom(foregroundColor: Colors.white),
              child: const Text("Forgot?", style: TextStyle(fontWeight: FontWeight.w700)),
            ),
          ]),
          const SizedBox(height: 8),

          ElevatedButton(
            onPressed: _login,
            style: ElevatedButton.styleFrom(
              elevation: 0,
              backgroundColor: Colors.white,
              foregroundColor: const Color(0xFF004D40),
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            ),
            child: const Text("Login", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900)),
          ),

          const SizedBox(height: 14),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Text("New here? ", style: TextStyle(color: Colors.white.withOpacity(.80))),
            GestureDetector(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => const SignupScreen()));
              },
              child: const Text(
                "Create account",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w900,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ]),
        ]),
      ),
    ),
  );

  Widget _field({
    required TextEditingController ctrl,
    required String label,
    required String hint,
    required IconData icon,
    bool obscure = false,
    TextInputType? type,
    Widget? suffix,
  }) =>
      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(label, style: TextStyle(color: Colors.white.withOpacity(.90), fontWeight: FontWeight.w800)),
        const SizedBox(height: 8),
        TextField(
          controller: ctrl,
          obscureText: obscure,
          keyboardType: type,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: Colors.white.withOpacity(.55)),
            prefixIcon: Icon(icon, color: Colors.white.withOpacity(.9)),
            suffixIcon: suffix,
            filled: true,
            fillColor: Colors.white.withOpacity(.14),
            contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: Colors.white.withOpacity(.18)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: Colors.white, width: 1.2),
            ),
          ),
        ),
      ]);
}

class _Glow extends StatelessWidget {
  final double s;
  const _Glow(this.s);
  @override
  Widget build(BuildContext context) => Container(
    height: s,
    width: s,
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      gradient: RadialGradient(colors: [
        Colors.white.withOpacity(.18),
        Colors.white.withOpacity(0),
      ]),
    ),
  );
}