import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/supabase/supabase_client.dart';

class AuthScreen extends ConsumerStatefulWidget {
  const AuthScreen({super.key});

  @override
  ConsumerState<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends ConsumerState<AuthScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoginMode = true;
  bool _isLoading = false;
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: AppColors.error),
    );
  }

  Future<void> _handleAuth() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      _showError('Заполните все поля');
      return;
    }

    setState(() => _isLoading = true);
    try {
      final supabase = ref.read(supabaseClientProvider);
      if (_isLoginMode) {
        await supabase.auth
            .signInWithPassword(email: email, password: password);
      } else {
        await supabase.auth.signUp(email: email, password: password);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text('Проверьте почту для подтверждения'),
                backgroundColor: AppColors.accent),
          );
        }
      }
    } on AuthException catch (e) {
      _showError(e.message);
    } catch (e) {
      _showError('Произошла ошибка: $e');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const BackButton(color: AppColors.textPrimary),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              const Text(
                'Dokki',
                style: TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                  color: AppColors.accent,
                  fontFamily: 'Inter',
                  letterSpacing: -1,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                _isLoginMode ? 'Вход в систему' : 'Создать аккаунт',
                style: const TextStyle(
                  fontSize: 16,
                  color: AppColors.textSecondary,
                  fontFamily: 'Inter',
                ),
              ),
              const SizedBox(height: 48),
              _buildLabel('Email'),
              const SizedBox(height: 8),
              _buildTextField(
                _emailController,
                hint: 'example@mail.com',
                prefixIcon: const Icon(Icons.email_outlined,
                    color: AppColors.textSecondary),
              ),
              const SizedBox(height: 20),
              _buildLabel('Пароль'),
              const SizedBox(height: 8),
              _buildTextField(
                _passwordController,
                obscureText: _obscurePassword,
                hint: '••••••••',
                prefixIcon: const Icon(Icons.lock_outline,
                    color: AppColors.textSecondary),
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscurePassword ? Icons.visibility_off : Icons.visibility,
                    color: AppColors.textSecondary,
                  ),
                  onPressed: () =>
                      setState(() => _obscurePassword = !_obscurePassword),
                ),
              ),
              if (_isLoginMode)
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {},
                    child: const Text('Забыли пароль?',
                        style: TextStyle(
                            color: AppColors.accent, fontFamily: 'Inter')),
                  ),
                ),
              const SizedBox(height: 40),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _handleAuth,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.accent,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    elevation: 0,
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          height: 24,
                          width: 24,
                          child: CircularProgressIndicator(
                              color: AppColors.surface, strokeWidth: 2))
                      : Text(
                          _isLoginMode ? 'ВОЙТИ' : 'ЗАРЕГИСТРИРОВАТЬСЯ',
                          style: const TextStyle(
                            color: AppColors.surface,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            fontFamily: 'Inter',
                            letterSpacing: 1,
                          ),
                        ),
                ),
              ),
              if (_isLoginMode) ...[
                const SizedBox(height: 24),
                Row(children: [
                  const Expanded(child: Divider(color: AppColors.border)),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text('или',
                        style: TextStyle(
                            color: AppColors.textSecondary,
                            fontFamily: 'Inter')),
                  ),
                  const Expanded(child: Divider(color: AppColors.border)),
                ]),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: OutlinedButton.icon(
                    icon: Image.network('https://www.google.com/favicon.ico',
                        height: 20),
                    label: const Text('Войти через Google',
                        style: TextStyle(
                            color: AppColors.textPrimary, fontFamily: 'Inter')),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: AppColors.border),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                    onPressed: () {},
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: OutlinedButton.icon(
                    icon: const Icon(Icons.apple, color: AppColors.textPrimary),
                    label: const Text('Sign in with Apple',
                        style: TextStyle(
                            color: AppColors.textPrimary, fontFamily: 'Inter')),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: AppColors.border),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                    onPressed: () {},
                  ),
                ),
              ],
              const SizedBox(height: 24),
              TextButton(
                onPressed: () => setState(() => _isLoginMode = !_isLoginMode),
                child: Text(
                  _isLoginMode
                      ? 'Нет аккаунта? Регистрация'
                      : 'Уже есть аккаунт? Войти',
                  style: const TextStyle(
                    color: AppColors.accent,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Inter',
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        text,
        style: const TextStyle(
            color: AppColors.textSecondary, fontSize: 14, fontFamily: 'Inter'),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller,
      {bool obscureText = false,
      String? hint,
      Widget? suffixIcon,
      Widget? prefixIcon}) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      style: const TextStyle(color: AppColors.textPrimary, fontFamily: 'Inter'),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle:
            TextStyle(color: AppColors.textSecondary.withValues(alpha: 0.5)),
        isDense: true,
        contentPadding:
            const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide:
              BorderSide(color: AppColors.textSecondary.withValues(alpha: 0.3)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.accent, width: 2),
        ),
      ),
    );
  }
}
