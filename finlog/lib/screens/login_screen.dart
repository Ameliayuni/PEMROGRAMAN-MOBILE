import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  String _errorMessage = '';
  bool _isLoading = false;
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final result = await authProvider.login(
      _emailController.text.trim(),
      _passwordController.text.trim(),
    );

    setState(() {
      _isLoading = false;
    });

    if (result['success'] == true) {
      Navigator.pushReplacementNamed(context, '/main');
    } else {
      setState(() => _errorMessage = result['message'] ?? 'Login gagal');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 250, 252, 253),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 60),
                Center(
                  child: SizedBox(
                    width: 100,
                    height: 100,
                    child: Image.asset(
                      'assets/images/finlog_logo.png',
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) => Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: const Icon(Icons.account_balance_wallet, size: 40, color: Colors.white),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                const Text('Selamat Datang🤍', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.black87)),
                const SizedBox(height: 8),
                const Text('Masuk untuk melakukan catatan hari ini', style: TextStyle(fontSize: 16, color: Color.fromARGB(255, 22, 17, 17))),
                const SizedBox(height: 40),

                if (_errorMessage.isNotEmpty)
                  Container(
                    padding: const EdgeInsets.all(12),
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: Colors.red.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.red.withOpacity(0.3)),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.error, color: Colors.red, size: 20),
                        const SizedBox(width: 10),
                        Expanded(child: Text(_errorMessage, style: const TextStyle(color: Colors.red))),
                      ],
                    ),
                  ),

                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(labelText: 'Email', prefixIcon: Icon(Icons.email), border: OutlineInputBorder()),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) => (value == null || value.isEmpty) ? 'Email tidak boleh kosong' : null,
                ),
                const SizedBox(height: 16),

                TextFormField(
                  controller: _passwordController,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    prefixIcon: const Icon(Icons.lock),
                    suffixIcon: IconButton(icon: Icon(_obscurePassword ? Icons.visibility : Icons.visibility_off), onPressed: () => setState(() => _obscurePassword = !_obscurePassword)),
                    border: const OutlineInputBorder(),
                  ),
                  obscureText: _obscurePassword,
                  validator: (value) {
                    if (value == null || value.isEmpty) return 'Password tidak boleh kosong';
                    if (value.length < 6) return 'Password minimal 6 karakter';
                    return null;
                  },
                ),
                const SizedBox(height: 24),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _handleLogin,
                    style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 16)),
                    child: _isLoading
                        ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2, valueColor: AlwaysStoppedAnimation<Color>(Color.fromARGB(255, 170, 206, 240))))
                        : const Text('Masuk'),
                  ),
                ),
                const SizedBox(height: 16),

                TextButton(onPressed: _isLoading ? null : () => Navigator.pushNamed(context, '/register'), child: const Text('Belum punya akun? Daftar di sini')),

                const SizedBox(height: 30),
                const Text('Hallo', style: TextStyle(fontSize: 14, color: Color.fromARGB(255, 19, 16, 16), fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                const Text('Selamat Melakukan Catatan keuangan Harian😊', textAlign: TextAlign.center, style: TextStyle(fontSize: 12, color: Color.fromARGB(255, 20, 17, 17))),
              ],
            ),
          ),
        ),
      ),
    );
  }
}