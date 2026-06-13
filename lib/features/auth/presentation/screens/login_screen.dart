import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/glass_card.dart';
import '../../../../core/widgets/morphing_button.dart';
import '../../../../core/widgets/shake_widget.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailCtrl    = TextEditingController();
  final _passwordCtrl = TextEditingController();
  bool _obscure   = true;
  bool _shake     = false;
  ButtonState _btnState = ButtonState.idle;

  void _login() async {
    setState(() => _btnState = ButtonState.loading);
    await Future.delayed(const Duration(milliseconds: 1500));
    if (_emailCtrl.text.isEmpty || _passwordCtrl.text.isEmpty) {
      setState(() { _btnState = ButtonState.idle; _shake = true; });
      Future.delayed(const Duration(milliseconds: 400), () {
        if (mounted) setState(() => _shake = false);
      });
    } else {
      setState(() => _btnState = ButtonState.success);
      await Future.delayed(const Duration(milliseconds: 800));
      if (mounted) context.go('/home');
    }
  }

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.deepBackground,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                Text('تسجيل الدخول',
                    style: Theme.of(context).textTheme.headlineLarge)
                    .animate().fadeIn(duration: 400.ms).slideY(begin: 0.1, end: 0, duration: 400.ms),
                const SizedBox(height: 8),
                Text('أهلاً بك مجدداً',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.textMuted))
                    .animate(delay: 80.ms).fadeIn(duration: 400.ms),
                const SizedBox(height: 40),
                ShakeWidget(
                  shake: _shake,
                  child: GlassCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        TextField(
                          controller: _emailCtrl,
                          keyboardType: TextInputType.emailAddress,
                          textDirection: TextDirection.ltr,
                          style: const TextStyle(color: AppColors.textPrimary),
                          decoration: const InputDecoration(
                            hintText: 'البريد الإلكتروني',
                            prefixIcon: Icon(Icons.email_outlined,
                                color: AppColors.textMuted, size: 20),
                          ),
                        ),
                        const SizedBox(height: 12),
                        TextField(
                          controller: _passwordCtrl,
                          obscureText: _obscure,
                          textDirection: TextDirection.ltr,
                          style: const TextStyle(color: AppColors.textPrimary),
                          decoration: InputDecoration(
                            hintText: 'كلمة المرور',
                            prefixIcon: const Icon(Icons.lock_outline,
                                color: AppColors.textMuted, size: 20),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscure ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                                color: AppColors.textMuted,
                                size: 20,
                              ),
                              onPressed: () => setState(() => _obscure = !_obscure),
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: TextButton(
                            onPressed: () {},
                            child: Text('نسيت كلمة المرور؟',
                                style: Theme.of(context).textTheme.bodySmall
                                    ?.copyWith(color: AppColors.textMuted)),
                          ),
                        ),
                        const SizedBox(height: 8),
                        MorphingButton(
                          label: 'تسجيل الدخول',
                          state: _btnState,
                          onPressed: _login,
                        ),
                        const SizedBox(height: 12),
                        OutlinedButton.icon(
                          onPressed: () {},
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: AppColors.borderDefault),
                            foregroundColor: AppColors.textPrimary,
                            minimumSize: const Size(double.infinity, 52),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          icon: const Icon(Icons.fingerprint, size: 22),
                          label: const Text('تسجيل بالبصمة'),
                        ),
                      ],
                    ),
                  ),
                ).animate(delay: 200.ms)
                    .fadeIn(duration: 400.ms)
                    .slideY(begin: 0.1, end: 0, duration: 400.ms)
                    .scale(begin: const Offset(0.96, 0.96), end: const Offset(1, 1), duration: 400.ms),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('ليس لديك حساب؟',
                        style: Theme.of(context).textTheme.bodySmall),
                    TextButton(
                      onPressed: () => context.go('/register'),
                      child: const Text('إنشاء حساب',
                          style: TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.w600)),
                    ),
                  ],
                ).animate(delay: 300.ms).fadeIn(duration: 400.ms),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
