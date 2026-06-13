import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/glass_card.dart';
import '../../../../core/widgets/nfc_ripples_widget.dart';

enum _PayState { idle, success, error }

class NfcPayScreen extends StatefulWidget {
  const NfcPayScreen({super.key});
  @override
  State<NfcPayScreen> createState() => _NfcPayScreenState();
}

class _NfcPayScreenState extends State<NfcPayScreen>
    with SingleTickerProviderStateMixin {
  _PayState _state = _PayState.idle;
  late AnimationController _glowCtrl;

  @override
  void initState() {
    super.initState();
    _glowCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _glowCtrl.dispose();
    super.dispose();
  }

  void _simulateSuccess() async {
    setState(() => _state = _PayState.success);
    HapticFeedback.heavyImpact();
    await Future.delayed(const Duration(milliseconds: 200));
    HapticFeedback.mediumImpact();
    await Future.delayed(const Duration(milliseconds: 1200));
    if (mounted) context.go('/home');
  }

  void _simulateError() async {
    setState(() => _state = _PayState.error);
    HapticFeedback.heavyImpact();
    await Future.delayed(const Duration(milliseconds: 200));
    HapticFeedback.heavyImpact();
    await Future.delayed(const Duration(milliseconds: 200));
    HapticFeedback.heavyImpact();
    await Future.delayed(const Duration(milliseconds: 2000));
    if (mounted) setState(() => _state = _PayState.idle);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.deepBackground,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: AppColors.textPrimary, size: 20),
          onPressed: () => context.go('/home'),
        ),
        title: const Text('دفع NFC'),
      ),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 24),
            // Amount
            GlassCard(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Column(
                children: [
                  Text('المبلغ', style: Theme.of(context).textTheme.bodySmall),
                  const SizedBox(height: 4),
                  Text('85.00 SDG',
                      style: Theme.of(context).textTheme.displayMedium?.copyWith(
                            fontFeatures: const [FontFeature.tabularFigures()],
                          )),
                  Text('متجر الأمين', style: Theme.of(context).textTheme.bodySmall),
                ],
              ),
            )
                .animate()
                .fadeIn(duration: 400.ms)
                .slideY(begin: 0.05, end: 0, duration: 400.ms),
            const SizedBox(height: 48),
            // Virtual Card
            Expanded(
              child: Center(
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // Ripples behind card
                    if (_state == _PayState.idle)
                      NfcRipples(size: 80),
                    // Card
                    _VirtualCard(state: _state, glowCtrl: _glowCtrl)
                        .animate()
                        .custom(
                          duration: 500.ms,
                          curve: Curves.elasticOut,
                          builder: (_, val, child) => Transform(
                            alignment: Alignment.center,
                            transform: Matrix4.identity()
                              ..setEntry(3, 2, 0.001)
                              ..rotateY((1 - val) * 1.5708),
                            child: child,
                          ),
                        ),
                  ],
                ),
              ),
            ),
            // Status message
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: _state == _PayState.idle
                  ? Text(
                      'قرّب بطاقتك أو هاتفك',
                      key: const ValueKey('idle'),
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium
                          ?.copyWith(color: AppColors.textMuted),
                    )
                  : _state == _PayState.success
                      ? Text(
                          '✓ تمت العملية بنجاح',
                          key: const ValueKey('success'),
                          style: Theme.of(context)
                              .textTheme
                              .bodyLarge
                              ?.copyWith(color: AppColors.success),
                        )
                      : Text(
                          '✕ فشلت العملية — حاول مجدداً',
                          key: const ValueKey('error'),
                          style: Theme.of(context)
                              .textTheme
                              .bodyLarge
                              ?.copyWith(color: AppColors.error),
                        ),
            ),
            const SizedBox(height: 32),
            // Demo buttons
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: _state != _PayState.idle ? null : _simulateError,
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: AppColors.error),
                        foregroundColor: AppColors.error,
                        minimumSize: const Size(0, 52),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                      child: const Text('محاكاة فشل'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _state != _PayState.idle ? null : _simulateSuccess,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.success,
                        foregroundColor: Colors.white,
                        minimumSize: const Size(0, 52),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                        elevation: 0,
                      ),
                      child: const Text('محاكاة نجاح'),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}

class _VirtualCard extends StatelessWidget {
  final _PayState state;
  final AnimationController glowCtrl;

  const _VirtualCard({required this.state, required this.glowCtrl});

  @override
  Widget build(BuildContext context) {
    Color borderColor;
    switch (state) {
      case _PayState.success:
        borderColor = AppColors.success;
        break;
      case _PayState.error:
        borderColor = AppColors.error;
        break;
      case _PayState.idle:
        borderColor = AppColors.borderDefault;
    }

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      width: 280,
      height: 170,
      decoration: BoxDecoration(
        color: AppColors.glassHeavy,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: borderColor, width: 1.5),
        boxShadow: state == _PayState.success
            ? [BoxShadow(color: AppColors.success.withOpacity(0.3), blurRadius: 30)]
            : state == _PayState.error
                ? [BoxShadow(color: AppColors.error.withOpacity(0.3), blurRadius: 30)]
                : null,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Stack(
          children: [
            // Scan line
            if (state == _PayState.idle)
              NfcScanLines(cardHeight: 170),
            // Card content
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Chip
                      AnimatedBuilder(
                        animation: glowCtrl,
                        builder: (_, __) => Container(
                          width: 36,
                          height: 28,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Colors.white.withOpacity(0.2 + glowCtrl.value * 0.15),
                                Colors.white.withOpacity(0.1),
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(4),
                            border: Border.all(color: AppColors.borderDefault),
                          ),
                        ),
                      ),
                      Icon(Icons.nfc_rounded,
                          color: Colors.white.withOpacity(0.6), size: 28),
                    ],
                  ),
                  const Spacer(),
                  // State overlay
                  Center(
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      child: state == _PayState.success
                          ? Container(
                              width: 56,
                              height: 56,
                              decoration: BoxDecoration(
                                color: AppColors.success.withOpacity(0.2),
                                shape: BoxShape.circle,
                                border: Border.all(color: AppColors.success),
                              ),
                              child: const Icon(Icons.check_rounded,
                                  color: AppColors.success, size: 30),
                            )
                          : state == _PayState.error
                              ? Container(
                                  width: 56,
                                  height: 56,
                                  decoration: BoxDecoration(
                                    color: AppColors.error.withOpacity(0.2),
                                    shape: BoxShape.circle,
                                    border: Border.all(color: AppColors.error),
                                  ),
                                  child: const Icon(Icons.close_rounded,
                                      color: AppColors.error, size: 30),
                                )
                              : const SizedBox.shrink(),
                    ),
                  ),
                  const Spacer(),
                  Text('•••• •••• •••• 4821',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            letterSpacing: 2,
                            fontFeatures: const [FontFeature.tabularFigures()],
                          )),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
