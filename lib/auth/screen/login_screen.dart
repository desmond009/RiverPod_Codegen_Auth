import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'providers.dart';
import 'signup_screen.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _email = TextEditingController();
  final _password = TextEditingController();
  
  bool _isLoading = false;
  bool _obscureText = true;

    Future<void> _login() async {
      await ref.read(authControllerProvider.notifier)
          .signIn(
            _email.text.trim(),
            _password.text.trim(),
          );
    }

    void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Login Failed"),
        content: Text(message.contains('invalid-credential') 
          ? "The email or password you entered is incorrect. Please try again." 
          : message),
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

      ref.listen(authControllerProvider, (_, next) {
      next.whenOrNull(
        error: (e, _) {
          showDialog(
            context: context,
            builder: (_) => AlertDialog(
              title: const Text("Error"),
              content: Text(e.toString()),
            ),
          );
        },
      );
    });

    final authState = ref.watch(authControllerProvider);

    return Scaffold(
      appBar: AppBar(title: const Text("Login")),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Welcome Back",
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
                  icon: Icon(
                    _obscureText ? Icons.visibility_off : Icons.visibility,
                  ),
                  onPressed: () {
                    setState(() {
                      _obscureText = !_obscureText;
                    });
                  },
                ),
              ),
            ),

            const SizedBox(height: 30),
            authState.isLoading
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: _login,
                    child: const Text("Login"),
                  ),

            TextButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const SignupScreen()),
                );
              },
              child: const Text("Don't have an account? Sign Up"),
            ),
          ],
        ),
      ),
    );
  }
}