import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/glass_card.dart';

class ReceiveScreen extends StatefulWidget {
  const ReceiveScreen({super.key});
  @override
  State<ReceiveScreen> createState() => _ReceiveScreenState();
}

class _ReceiveScreenState extends State<ReceiveScreen> {
  bool _copied = false;
  static const _alias = '482 197';
  static const _qrData = 'nfcpay://pay?alias=482197&name=محمد';

  void _copy() {
    Clipboard.setData(const ClipboardData(text: '482197'));
    HapticFeedback.selectionClick();
    setState(() => _copied = true);
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) setState(() => _copied = false);
    });
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
        title: const Text('استلام'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 16),
              Text('شارك رمز QR أو معرّفك السداسي',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.textMuted))
                  .animate().fadeIn(duration: 300.ms),
              const SizedBox(height: 32),
              // QR Card
              GlassCard(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: QrImageView(
                        data: _qrData,
                        version: QrVersions.auto,
                        size: 200,
                        backgroundColor: Colors.white,
                        eyeStyle: const QrEyeStyle(
                          eyeShape: QrEyeShape.square,
                          color: Color(0xFF0A0A0A),
                        ),
                        dataModuleStyle: const QrDataModuleStyle(
                          dataModuleShape: QrDataModuleShape.square,
                          color: Color(0xFF0A0A0A),
                        ),
                      ),
                    )
                        .animate()
                        .scale(begin: const Offset(0.8, 0.8), end: const Offset(1, 1),
                            duration: 400.ms, curve: Curves.easeOutCubic)
                        .fadeIn(duration: 400.ms),
                    const SizedBox(height: 24),
                    // Alias
                    GestureDetector(
                      onTap: _copy,
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                        decoration: BoxDecoration(
                          color: _copied
                              ? AppColors.success.withOpacity(0.1)
                              : AppColors.glassLight,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: _copied ? AppColors.success : AppColors.borderDefault,
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              _alias,
                              style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 8,
                                color: _copied ? AppColors.success : AppColors.textPrimary,
                                fontFeatures: const [FontFeature.tabularFigures()],
                              ),
                            ),
                            const SizedBox(width: 12),
                            AnimatedSwitcher(
                              duration: const Duration(milliseconds: 200),
                              child: Icon(
                                _copied ? Icons.check_rounded : Icons.copy_outlined,
                                key: ValueKey(_copied),
                                color: _copied ? AppColors.success : AppColors.textMuted,
                                size: 20,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ).animate(delay: 200.ms).fadeIn(duration: 300.ms),
                    if (_copied)
                      Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Text('تم النسخ!',
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(color: AppColors.success))
                            .animate().fadeIn(duration: 200.ms),
                      ),
                  ],
                ),
              ).animate(delay: 80.ms)
                  .fadeIn(duration: 400.ms)
                  .slideY(begin: 0.05, end: 0, duration: 400.ms),
              const SizedBox(height: 24),
              // Share buttons
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {},
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: AppColors.borderDefault),
                        foregroundColor: AppColors.textPrimary,
                        minimumSize: const Size(0, 52),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      icon: const Icon(Icons.share_outlined, size: 18),
                      label: const Text('مشاركة'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {},
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: AppColors.borderDefault),
                        foregroundColor: AppColors.textPrimary,
                        minimumSize: const Size(0, 52),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      icon: const Icon(Icons.link_outlined, size: 18),
                      label: const Text('رابط دفع'),
                    ),
                  ),
                ],
              ).animate(delay: 300.ms).fadeIn(duration: 300.ms).slideY(begin: 0.05, end: 0, duration: 300.ms),
            ],
          ),
        ),
      ),
    );
  }
}
