import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:plataforma_daniela/core/styles/brand_colors.dart';
import 'package:plataforma_daniela/core/widgets/app_background.dart';
import 'package:plataforma_daniela/core/widgets/brand_logo.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _auth = FirebaseAuth.instance;
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (!mounted) return;
    setState(() => _isLoading = true);

    try {
      await _auth.signInWithEmailAndPassword(email: _emailController.text.trim(), password: _passwordController.text.trim());
      if (mounted) {
        Navigator.pushReplacementNamed(context, '/booking');
      }
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;
      String userMessage;

      // --- LÓGICA DE ERRO MELHORADA ---
      switch (e.code) {
        case 'user-not-found':
          userMessage = 'Nenhum utilizador encontrado com este email.';
          break;
        case 'wrong-password':
          userMessage = 'Palavra-passe incorreta. Tente novamente.';
          break;
        case 'invalid-email':
          userMessage = 'O formato do email é inválido.';
          break;
        case 'invalid-credential':
          userMessage = 'As credenciais fornecidas estão incorretas.';
          break;
        default:
          userMessage = 'Ocorreu um erro ao tentar iniciar a sessão.';
          debugPrint('Firebase Auth Error: ${e.code}'); // Para nos ajudar a depurar
      }

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(userMessage), backgroundColor: Colors.red));
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),
      body: Stack(
        children: [
          const Positioned.fill(child: AppBackground()),
          Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 400),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const BrandLogo(size: 60),
                      const SizedBox(height: 24),
                      const Text('Bem-vindo(a) de volta', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      const Text('Acesse a sua conta para continuar.', style: TextStyle(color: Colors.grey)),
                      const SizedBox(height: 32),
                      TextField(
                        controller: _emailController,
                        decoration: const InputDecoration(
                          labelText: 'Email',
                          prefixIcon: Icon(Icons.email_outlined),
                          border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
                        ),
                        keyboardType: TextInputType.emailAddress,
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: _passwordController,
                        decoration: const InputDecoration(
                          labelText: 'Senha',
                          prefixIcon: Icon(Icons.lock_outline),
                          border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
                        ),
                        obscureText: true,
                      ),
                      const SizedBox(height: 24),
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: _isLoading ? null : _login,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: BrandColors.charcoal,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          child: _isLoading ? const CircularProgressIndicator(color: Colors.white) : const Text('Entrar', style: TextStyle(fontSize: 16)),
                        ),
                      ),
                      const SizedBox(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text('Não tem uma conta?'),
                          TextButton(
                            onPressed: () => Navigator.pushNamed(context, '/register'),
                            child: const Text('Cadastre-se', style: TextStyle(fontWeight: FontWeight.bold)),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
