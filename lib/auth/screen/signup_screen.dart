import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'providers.dart';
import 'login_screen.dart'; // Import to navigate back to Login

class SignupScreen extends ConsumerStatefulWidget {
  const SignupScreen({super.key});

  @override
  ConsumerState<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends ConsumerState<SignupScreen> {
  final _email = TextEditingController();
  final _password = TextEditingController();
  
  bool _isLoading = false;
  bool _obscureText = true; 

  Future<void> _handleSignup() async {
    setState(() => _isLoading = true);
    try {
      await ref.read(authRepositoryProvider).signUp(
            email: _email.text.trim(),
            password: _password.text.trim(),
          );
      
      if (mounted) {
        // This removes the SignupScreen and reveals the AuthGate's new state
        Navigator.of(context).pop(); 
      }
    } catch (e) {
      if (mounted) {
        _showErrorDialog(e.toString());
        setState(() => _isLoading = false);
      }
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Signup Failed"),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Sign Up")),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Create Account",
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 30),
            
            TextField(
              controller: _email,
              decoration: const InputDecoration(
                labelText: "Email",
                prefixIcon: Icon(Icons.email),
              ),
            ),
            const SizedBox(height: 15),
            
            TextField(
              controller: _password,
              obscureText: _obscureText,
              decoration: InputDecoration(
                labelText: "Password",
                prefixIcon: const Icon(Icons.lock),
                suffixIcon: IconButton(
                  icon: Icon(_obscureText ? Icons.visibility_off : Icons.visibility),
                  onPressed: () => setState(() => _obscureText = !_obscureText),
                ),
              ),
            ),
            const SizedBox(height: 30),
            
            _isLoading
                ? const CircularProgressIndicator()
                : SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _handleSignup,
                      child: const Text("Sign Up"),
                    ),
                  ),
            
            TextButton(
              onPressed: () {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (_) => const LoginScreen()),
                );
              },
              child: const Text("Already have an account? Login"),
            ),
          ],
        ),
      ),
    );
  }
}