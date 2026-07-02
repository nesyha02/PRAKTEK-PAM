import 'package:flutter/material.dart';
import 'services/auth_service.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});
  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  final AuthService _authService = AuthService();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;
  void _handleRegister() async {
    setState(() => _isLoading = true);
    try {
      final credential = await _authService.register(
        _emailController.text.trim(),
        _passwordController.text.trim(),
      );
      _showSnackBar("Register Success! User: ${credential.user?.email}");
    } catch (e) {
      _showSnackBar("Register Failed: ${e.toString()}");
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _handleLogin() async {
    setState(() => _isLoading = true);
    try {
      final credential = await _authService.login(
        _emailController.text.trim(),
        _passwordController.text.trim(),
      );
      _showSnackBar("Login Success! Welcome ${credential.user?.email}");
    } catch (e) {
      _showSnackBar("Login Failed: ${e.toString()}");
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Firebase Auth Test UI')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Test Register & Login',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _passwordController,
                  decoration: const InputDecoration(
                    labelText: 'Password',
                    border: OutlineInputBorder(),
                  ),
                  obscureText: true, // Menyembunyikan password
                ),
                const SizedBox(height: 20),
                _isLoading
                    ? const CircularProgressIndicator()
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          ElevatedButton(
                            onPressed: _handleLogin,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                              foregroundColor: Colors.white,
                            ),
                            child: const Text('LOGIN'),
                          ),
                          const SizedBox(height: 8),
                          OutlinedButton(
                            onPressed: _handleRegister,
                            child: const Text('REGISTER'),
                          ),
                        ],
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
