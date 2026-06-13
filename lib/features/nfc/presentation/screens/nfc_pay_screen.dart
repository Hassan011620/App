import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/glass_card.dart';

class NfcPayScreen extends StatefulWidget {
  const NfcPayScreen({super.key});

  @override
  State<NfcPayScreen> createState() => _NfcPayScreenState();
}

class _NfcPayScreenState extends State<NfcPayScreen> {
  bool _isScanning = false;

  void _startScanning() {
    setState(() => _isScanning = true);
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) setState(() => _isScanning = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.deepBackground,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new,
              color: AppColors.textPrimary, size: 20),
          onPressed: () => context.go('/home'),
        ),
        title: const Text('دفع NFC'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 40),
              Text(
                'ضع البطاقة أو الهاتف بالقرب',
                style: Theme.of(context).textTheme.headlineSmall,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 60),
              GlassCard(
                padding: const EdgeInsets.all(40),
                child: Column(
                  children: [
                    AnimatedScale(
                      scale: _isScanning ? 1.1 : 1.0,
                      duration: const Duration(milliseconds: 600),
                      child: Icon(
                        Icons.nfc_rounded,
                        size: 120,
                        color: _isScanning
                            ? AppColors.success
                            : AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      _isScanning ? 'جاري البحث...' : 'في انتظار البطاقة',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ],
                ),
              ),
              const Spacer(),
              ElevatedButton(
                onPressed: _startScanning,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.textPrimary,
                  padding: const EdgeInsets.all(16),
                ),
                child: const Text('ابدأ القراءة'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
