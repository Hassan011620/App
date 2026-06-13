import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/glass_card.dart';
import '../../../../core/widgets/morphing_button.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});
  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _nameCtrl  = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _passCtrl  = TextEditingController();
  final _confCtrl  = TextEditingController();
  bool _obscure1 = true;
  bool _obscure2 = true;
  ButtonState _btnState = ButtonState.idle;

  int _strength = 0; // 0=weak 1=medium 2=strong

  void _checkStrength(String v) {
    int s = 0;
    if (v.length >= 8) s++;
    if (RegExp(r'[A-Z]').hasMatch(v) && RegExp(r'[0-9]').hasMatch(v)) s++;
    if (RegExp(r'[!@#\$%^&*]').hasMatch(v)) s++;
    setState(() => _strength = s.clamp(0, 2));
  }

  void _register() async {
    setState(() => _btnState = ButtonState.loading);
    await Future.delayed(const Duration(milliseconds: 1500));
    setState(() => _btnState = ButtonState.success);
    await Future.delayed(const Duration(milliseconds: 800));
    if (mounted) context.go('/otp?phone=');
  }

  Color get _strengthColor => [AppColors.error, AppColors.pending, AppColors.success][_strength];
  String get _strengthLabel => ['ضعيفة', 'متوسطة', 'قوية'][_strength];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.deepBackground,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 24),
              Text('إنشاء حساب', style: Theme.of(context).textTheme.headlineLarge)
                  .animate().fadeIn(duration: 400.ms),
              const SizedBox(height: 32),
              GlassCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _field(_nameCtrl,  'الاسم الكامل',       Icons.person_outline),
                    const SizedBox(height: 12),
                    _field(_emailCtrl, 'البريد الإلكتروني',  Icons.email_outlined,
                        type: TextInputType.emailAddress, ltr: true),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _passCtrl,
                      obscureText: _obscure1,
                      onChanged: _checkStrength,
                      textDirection: TextDirection.ltr,
                      style: const TextStyle(color: AppColors.textPrimary),
                      decoration: InputDecoration(
                        hintText: 'كلمة المرور',
                        prefixIcon: const Icon(Icons.lock_outline, color: AppColors.textMuted, size: 20),
                        suffixIcon: IconButton(
                          icon: Icon(_obscure1 ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                              color: AppColors.textMuted, size: 20),
                          onPressed: () => setState(() => _obscure1 = !_obscure1),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    // Strength bar
                    if (_passCtrl.text.isNotEmpty) ...[
                      Row(
                        children: [
                          Expanded(
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              height: 3,
                              decoration: BoxDecoration(
                                color: _strengthColor,
                                borderRadius: BorderRadius.circular(2),
                              ),
                              width: (_strength + 1) / 3,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(_strengthLabel,
                              style: TextStyle(fontSize: 11, color: _strengthColor)),
                        ],
                      ),
                      const SizedBox(height: 8),
                    ],
                    TextField(
                      controller: _confCtrl,
                      obscureText: _obscure2,
                      textDirection: TextDirection.ltr,
                      style: const TextStyle(color: AppColors.textPrimary),
                      decoration: InputDecoration(
                        hintText: 'تأكيد كلمة المرور',
                        prefixIcon: const Icon(Icons.lock_outline, color: AppColors.textMuted, size: 20),
                        suffixIcon: IconButton(
                          icon: Icon(_obscure2 ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                              color: AppColors.textMuted, size: 20),
                          onPressed: () => setState(() => _obscure2 = !_obscure2),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    MorphingButton(
                      label: 'إنشاء الحساب',
                      state: _btnState,
                      onPressed: _register,
                    ),
                  ],
                ),
              ).animate(delay: 150.ms)
                  .fadeIn(duration: 400.ms)
                  .slideY(begin: 0.08, end: 0, duration: 400.ms),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('لديك حساب بالفعل؟', style: Theme.of(context).textTheme.bodySmall),
                  TextButton(
                    onPressed: () => context.go('/login'),
                    child: const Text('تسجيل الدخول',
                        style: TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.w600)),
                  ),
                ],
              ).animate(delay: 250.ms).fadeIn(duration: 400.ms),
            ],
          ),
        ),
      ),
    );
  }

  Widget _field(TextEditingController ctrl, String hint, IconData icon,
      {TextInputType type = TextInputType.text, bool ltr = false}) {
    return TextField(
      controller: ctrl,
      keyboardType: type,
      textDirection: ltr ? TextDirection.ltr : TextDirection.rtl,
      style: const TextStyle(color: AppColors.textPrimary),
      decoration: InputDecoration(
        hintText: hint,
        prefixIcon: Icon(icon, color: AppColors.textMuted, size: 20),
      ),
    );
  }
}
