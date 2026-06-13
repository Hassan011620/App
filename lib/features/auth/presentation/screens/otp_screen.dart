import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/morphing_button.dart';

class OtpScreen extends StatefulWidget {
  final String phone;
  const OtpScreen({super.key, required this.phone});
  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final _controllers = List.generate(6, (_) => TextEditingController());
  final _focuses      = List.generate(6, (_) => FocusNode());
  int _seconds = 60;
  Timer? _timer;
  ButtonState _btnState = ButtonState.idle;
  bool _shakeAll = false;
  List<bool> _filled = List.filled(6, false);

  @override
  void initState() {
    super.initState();
    _startTimer();
    WidgetsBinding.instance.addPostFrameCallback((_) => _focuses[0].requestFocus());
  }

  void _startTimer() {
    _timer?.cancel();
    _seconds = 60;
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (!mounted) { t.cancel(); return; }
      setState(() {
        if (_seconds > 0) _seconds--; else t.cancel();
      });
    });
  }

  void _onDigit(int idx, String val) {
    if (val.isNotEmpty) {
      setState(() => _filled[idx] = true);
      if (idx < 5) {
        _focuses[idx + 1].requestFocus();
      } else {
        _focuses[idx].unfocus();
        _verify();
      }
    } else {
      setState(() => _filled[idx] = false);
      if (idx > 0) _focuses[idx - 1].requestFocus();
    }
  }

  void _verify() async {
    setState(() => _btnState = ButtonState.loading);
    await Future.delayed(const Duration(milliseconds: 1200));
    final code = _controllers.map((c) => c.text).join();
    if (code == '123456') {
      setState(() => _btnState = ButtonState.success);
      HapticFeedback.mediumImpact();
      for (int i = 0; i < 6; i++) {
        await Future.delayed(const Duration(milliseconds: 40));
        if (mounted) setState(() => _filled[i] = true);
      }
      await Future.delayed(const Duration(milliseconds: 600));
      if (mounted) context.go('/home');
    } else {
      setState(() { _btnState = ButtonState.idle; _shakeAll = true; });
      HapticFeedback.heavyImpact();
      await Future.delayed(const Duration(milliseconds: 350));
      if (mounted) setState(() => _shakeAll = false);
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    for (final c in _controllers) c.dispose();
    for (final f in _focuses) f.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.deepBackground,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: AppColors.textPrimary, size: 20),
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 24),
              Text('التحقق من الهاتف', style: Theme.of(context).textTheme.headlineLarge)
                  .animate().fadeIn(duration: 400.ms),
              const SizedBox(height: 8),
              Text('أدخل الرمز المُرسَل إلى ${widget.phone.isNotEmpty ? widget.phone : "هاتفك"}',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.textMuted))
                  .animate(delay: 60.ms).fadeIn(duration: 400.ms),
              const SizedBox(height: 48),
              // OTP Fields
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(6, (i) {
                  return _OtpBox(
                    controller: _controllers[i],
                    focusNode: _focuses[i],
                    filled: _filled[i],
                    shake: _shakeAll,
                    onChanged: (v) => _onDigit(i, v),
                  ).animate(delay: Duration(milliseconds: 200 + i * 50))
                      .fadeIn(duration: 300.ms)
                      .slideY(begin: 0.1, end: 0, duration: 300.ms);
                }),
              ),
              const SizedBox(height: 32),
              // Timer
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 200),
                child: _seconds > 0
                    ? Text(
                        'إعادة الإرسال بعد 00:${_seconds.toString().padLeft(2, '0')}',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodySmall,
                      )
                    : TextButton(
                        onPressed: _startTimer,
                        child: const Text('إعادة إرسال الرمز',
                            style: TextStyle(color: AppColors.textPrimary)),
                      ),
              ).animate(delay: 500.ms).fadeIn(duration: 300.ms),
              const SizedBox(height: 40),
              MorphingButton(
                label: 'تأكيد',
                state: _btnState,
                onPressed: _verify,
              ).animate(delay: 600.ms).fadeIn(duration: 400.ms).slideY(begin: 0.1, end: 0, duration: 400.ms),
              const SizedBox(height: 16),
              Text('💡 للتجربة: أدخل 123456',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.textDisabled)),
            ],
          ),
        ),
      ),
    );
  }
}

class _OtpBox extends StatefulWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final bool filled;
  final bool shake;
  final ValueChanged<String> onChanged;

  const _OtpBox({
    required this.controller,
    required this.focusNode,
    required this.filled,
    required this.shake,
    required this.onChanged,
  });

  @override
  State<_OtpBox> createState() => _OtpBoxState();
}

class _OtpBoxState extends State<_OtpBox> with SingleTickerProviderStateMixin {
  late AnimationController _shakeCtrl;

  @override
  void initState() {
    super.initState();
    _shakeCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 300));
  }

  @override
  void didUpdateWidget(_OtpBox old) {
    super.didUpdateWidget(old);
    if (widget.shake && !old.shake) _shakeCtrl.forward(from: 0);
  }

  @override
  void dispose() { _shakeCtrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _shakeCtrl,
      builder: (_, child) => Transform.translate(
        offset: Offset(
          TweenSequence<double>([
            TweenSequenceItem(tween: Tween(begin: 0, end: 6), weight: 1),
            TweenSequenceItem(tween: Tween(begin: 6, end: -6), weight: 2),
            TweenSequenceItem(tween: Tween(begin: -6, end: 0), weight: 1),
          ]).evaluate(CurvedAnimation(parent: _shakeCtrl, curve: Curves.linear)),
          0,
        ),
        child: child,
      ),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        width: 48,
        height: 56,
        decoration: BoxDecoration(
          color: AppColors.glassLight,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: widget.focusNode.hasFocus
                ? AppColors.borderGlow
                : widget.shake
                    ? AppColors.error.withOpacity(0.7)
                    : AppColors.borderDefault,
            width: widget.focusNode.hasFocus ? 1.5 : 1,
          ),
        ),
        child: TextField(
          controller: widget.controller,
          focusNode: widget.focusNode,
          textAlign: TextAlign.center,
          keyboardType: TextInputType.number,
          maxLength: 1,
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
          decoration: const InputDecoration(
            counterText: '',
            border: InputBorder.none,
            contentPadding: EdgeInsets.zero,
          ),
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          onChanged: widget.onChanged,
        ),
      ),
    );
  }
}
