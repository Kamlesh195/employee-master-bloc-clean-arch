import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/theme_cubit.dart';
import 'home_screen.dart';
import '../../core/widgets/glass_container.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  void _login() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
      if (mounted) {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (_) => const HomeScreen()));
      }
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(e.message ?? 'Login failed'),
        backgroundColor: Colors.redAccent,
        behavior: SnackBarBehavior.floating,
      ));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Widget _buildFormFields(bool isDark) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextFormField(
            controller: _emailController,
            style: TextStyle(color: isDark ? Colors.white : Colors.black87),
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
                prefixIcon: Icon(Icons.email_outlined,
                    color: isDark ? Colors.white54 : Colors.black54),
                labelText: 'Email',
                labelStyle:
                    TextStyle(color: isDark ? Colors.white54 : Colors.black54),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                        color: isDark ? Colors.white24 : Colors.black12)),
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                        color: isDark ? Colors.white24 : Colors.black12)),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                        color: isDark
                            ? Colors.blueAccent
                            : const Color(0xFF1E3C72),
                        width: 2))),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Email is required';
              }
              if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                  .hasMatch(value)) {
                return 'Enter a valid email address';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _passwordController,
            obscureText: true,
            style: TextStyle(color: isDark ? Colors.white : Colors.black87),
            decoration: InputDecoration(
                prefixIcon: Icon(Icons.lock_outline,
                    color: isDark ? Colors.white54 : Colors.black54),
                labelText: 'Password',
                labelStyle:
                    TextStyle(color: isDark ? Colors.white54 : Colors.black54),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                        color: isDark ? Colors.white24 : Colors.black12)),
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                        color: isDark ? Colors.white24 : Colors.black12)),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                        color: isDark
                            ? Colors.blueAccent
                            : const Color(0xFF1E3C72),
                        width: 2))),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Password is required';
              }
              if (value.length < 6) {
                return 'Password must be at least 6 characters';
              }
              return null;
            },
          ),
          const SizedBox(height: 32),
          _isLoading
              ? CircularProgressIndicator(
                  color: isDark ? Colors.blueAccent : const Color(0xFF1E3C72))
              : ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      backgroundColor:
                          isDark ? Colors.blueAccent : const Color(0xFF1E3C72),
                      foregroundColor: Colors.white,
                      elevation: 2),
                  onPressed: _login,
                  child: const Text('LOGIN',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.0)),
                ),
        ],
      ),
    );
  }

  Widget _buildDesktopLoginForm(bool isDark) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 400),
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        color: isDark ? const Color(0xFF1E293B) : Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.business_center,
                  size: 60,
                  color: isDark ? Colors.white : const Color(0xFF1E3C72)),
              const SizedBox(height: 16),
              Text("Employee Master",
                  style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : const Color(0xFF1E3C72))),
              const SizedBox(height: 8),
              Text("Authenticate to access your administrative workspace.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 14,
                      color: isDark ? Colors.white70 : Colors.black54)),
              const SizedBox(height: 32),
              _buildFormFields(isDark),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLeftPanel() {
    return Container(
      decoration: const BoxDecoration(
          gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0xFF0F2027), Color(0xFF1E3C72), Color(0xFF2A5298)],
      )),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(40.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withValues(alpha: 0.1)),
                child: const Icon(Icons.dashboard_customize_outlined,
                    size: 80, color: Colors.white),
              ),
              const SizedBox(height: 40),
              const Text("Global Workforce\nIntelligence\nHub.",
                  style: TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                      height: 1.2,
                      color: Colors.white)),
              const SizedBox(height: 20),
              const Text(
                  "Empower your organization with enterprise-grade employee lifecycle management. Secure, robust, and designed specifically for high-performing administrative operations.",
                  style: TextStyle(
                      fontSize: 18, height: 1.5, color: Colors.white70)),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(isDark ? Icons.light_mode : Icons.dark_mode,
                color: isDark ? Colors.amber : const Color(0xFF1E3C72)),
            onPressed: () {
              context.read<ThemeCubit>().toggleTheme();
            },
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: LayoutBuilder(builder: (context, constraints) {
        if (constraints.maxWidth > 800) {
          // Web / Desktop Split Screen
          return Row(
            children: [
              Expanded(flex: 5, child: _buildLeftPanel()),
              Expanded(
                  flex: 5,
                  child: Container(
                    color: isDark
                        ? const Color(0xFF0F172A)
                        : const Color(0xFFF3F6F9),
                    child: Center(child: _buildDesktopLoginForm(isDark)),
                  ))
            ],
          );
        } else {
          // Mobile View with Gradient and Glassmorphism
          return Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: isDark
                    ? [const Color(0xFF0F2027), const Color(0xFF2C5364)]
                    : [
                        const Color(0xFF4A90E2).withValues(alpha: 0.15),
                        const Color(0xFF003366).withValues(alpha: 0.05)
                      ],
              ),
            ),
            child: SafeArea(
              child: Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 24.0, vertical: 40.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.business_center,
                          size: 70,
                          color:
                              isDark ? Colors.white : const Color(0xFF1E3C72)),
                      const SizedBox(height: 16),
                      Text("Employee Master",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: isDark
                                  ? Colors.white
                                  : const Color(0xFF1E3C72))),
                      const SizedBox(height: 8),
                      Text("Authentication Required",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 15,
                              color: isDark ? Colors.white70 : Colors.black54)),
                      const SizedBox(height: 40),
                      GlassContainer(
                        child: Padding(
                          padding: const EdgeInsets.all(24.0),
                          child: _buildFormFields(isDark),
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ),
          );
        }
      }),
    );
  }
}
