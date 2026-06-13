import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/glass_card.dart';
import '../../../../core/widgets/morphing_button.dart';

class SendScreen extends StatefulWidget {
  const SendScreen({super.key});
  @override
  State<SendScreen> createState() => _SendScreenState();
}

class _SendScreenState extends State<SendScreen> {
  int _step = 1;
  final _aliasCtrl  = TextEditingController();
  String _amount    = '0';
  bool _verified    = false;
  ButtonState _verifyState = ButtonState.idle;
  ButtonState _sendState   = ButtonState.idle;

  final _numpad = ['1','2','3','4','5','6','7','8','9','.','0','⌫'];

  void _onNumpad(String v) {
    setState(() {
      if (v == '⌫') {
        if (_amount.length > 1) _amount = _amount.substring(0, _amount.length - 1);
        else _amount = '0';
      } else if (v == '.' && _amount.contains('.')) {
        return;
      } else if (_amount == '0' && v != '.') {
        _amount = v;
      } else {
        if (_amount.contains('.') && _amount.split('.')[1].length >= 2) return;
        _amount += v;
      }
    });
    HapticFeedback.selectionClick();
  }

  void _verify() async {
    if (_aliasCtrl.text.length != 6) return;
    setState(() => _verifyState = ButtonState.loading);
    await Future.delayed(const Duration(milliseconds: 1200));
    setState(() {
      _verifyState = ButtonState.success;
      _verified    = true;
    });
    await Future.delayed(const Duration(milliseconds: 600));
    setState(() => _step = 2);
  }

  void _send() async {
    setState(() => _sendState = ButtonState.loading);
    await Future.delayed(const Duration(milliseconds: 1500));
    setState(() => _sendState = ButtonState.success);
    HapticFeedback.mediumImpact();
    await Future.delayed(const Duration(milliseconds: 900));
    if (mounted) context.go('/home');
  }

  @override
  void dispose() {
    _aliasCtrl.dispose();
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
          onPressed: () {
            if (_step == 2) setState(() { _step = 1; _verified = false; });
            else context.go('/home');
          },
        ),
        title: Text(_step == 1 ? 'إرسال — التحقق من المستلم' : 'إرسال — المبلغ'),
      ),
      body: SafeArea(
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 350),
          child: _step == 1 ? _buildStep1() : _buildStep2(),
        ),
      ),
    );
  }

  Widget _buildStep1() {
    return Padding(
      key: const ValueKey(1),
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('أدخل المعرف السداسي للمستلم',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.textMuted))
              .animate().fadeIn(duration: 300.ms),
          const SizedBox(height: 24),
          GlassCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextField(
                  controller: _aliasCtrl,
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  maxLength: 6,
                  style: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 12,
                    color: AppColors.textPrimary,
                  ),
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  decoration: const InputDecoration(
                    counterText: '',
                    hintText: '000000',
                    hintStyle: TextStyle(
                      fontSize: 32,
                      letterSpacing: 12,
                      color: AppColors.textDisabled,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                MorphingButton(
                  label: 'تحقق من المستلم',
                  state: _verifyState,
                  onPressed: _verify,
                ),
              ],
            ),
          ).animate(delay: 80.ms).fadeIn(duration: 300.ms).slideY(begin: 0.05, end: 0, duration: 300.ms),
          const SizedBox(height: 12),
          Text('❌ لا يمكن البحث بالاسم أو رقم الهاتف',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.textDisabled))
              .animate(delay: 200.ms).fadeIn(duration: 300.ms),
        ],
      ),
    );
  }

  Widget _buildStep2() {
    return Padding(
      key: const ValueKey(2),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Recipient card
          GlassCard.light(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                Container(
                  width: 44, height: 44,
                  decoration: const BoxDecoration(
                    color: AppColors.glassMedium,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.person_rounded, color: AppColors.textMuted, size: 22),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('م●●●● ع●●●●',
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontSize: 15)),
                      Text('●●●●●● 42  |  ${_aliasCtrl.text}',
                          style: Theme.of(context).textTheme.bodySmall),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.edit_outlined, color: AppColors.textMuted, size: 18),
                  onPressed: () => setState(() { _step = 1; _verified = false; }),
                ),
              ],
            ),
          ).animate().fadeIn(duration: 300.ms).slideY(begin: -0.05, end: 0, duration: 300.ms),
          const SizedBox(height: 24),
          // Amount display
          GlassCard(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
            child: Column(
              children: [
                Text(
                  '$_amount SDG',
                  style: Theme.of(context).textTheme.displayLarge?.copyWith(
                        fontFeatures: const [FontFeature.tabularFigures()],
                      ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 4),
                Text('الرصيد المتاح: 12,450.75 SDG',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.textMuted)),
              ],
            ),
          ).animate(delay: 60.ms).fadeIn(duration: 300.ms),
          const SizedBox(height: 16),
          // Numpad
          Expanded(
            child: GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: 1.8,
                mainAxisSpacing: 8,
                crossAxisSpacing: 8,
              ),
              itemCount: 12,
              itemBuilder: (_, i) {
                final v = _numpad[i];
                return GestureDetector(
                  onTap: () => _onNumpad(v),
                  child: GlassCard.light(
                    padding: EdgeInsets.zero,
                    child: Center(
                      child: v == '⌫'
                          ? const Icon(Icons.backspace_outlined,
                              color: AppColors.textPrimary, size: 20)
                          : Text(v,
                              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 22,
                                  )),
                    ),
                  ),
                );
              },
            ).animate(delay: 100.ms).fadeIn(duration: 300.ms),
          ),
          const SizedBox(height: 12),
          MorphingButton(
            label: 'إرسال',
            state: _sendState,
            onPressed: _amount != '0' ? _send : null,
          ).animate(delay: 150.ms).fadeIn(duration: 300.ms),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}
