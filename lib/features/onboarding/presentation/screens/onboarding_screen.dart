import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/morphing_button.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});
  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _ctrl = PageController();
  int _page = 0;

  final _pages = [
    _OnboardingPage(
      icon: Icons.nfc_rounded,
      title: 'Tap. Pay. Done.',
      subtitle: 'ادفع بلمسة واحدة باستخدام بطاقتك أو هاتفك — بدون انتظار وبدون نقد.',
    ),
    _OnboardingPage(
      icon: Icons.tag_rounded,
      title: 'معرّفك السداسي',
      subtitle: 'رقم مكوّن من 6 أرقام فقط يُعرّفك لأي شخص — استلم المال في ثوانٍ.',
    ),
    _OnboardingPage(
      icon: Icons.shield_rounded,
      title: 'أمان بنكي حقيقي',
      subtitle: 'تشفير AES-256 وحماية متعددة الطبقات في كل عملية دفع.',
    ),
  ];

  void _next() {
    if (_page < 2) {
      _ctrl.nextPage(
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeOutCubic,
      );
    } else {
      context.go('/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.deepBackground,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: _ctrl,
                onPageChanged: (i) => setState(() => _page = i),
                itemCount: _pages.length,
                itemBuilder: (_, i) => _pages[i],
              ),
            ),
            // Page indicator — animated lines
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(3, (i) {
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    curve: Curves.easeOutCubic,
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: i == _page ? 40 : 8,
                    height: 4,
                    decoration: BoxDecoration(
                      color: i == _page
                          ? AppColors.textPrimary
                          : AppColors.textDisabled,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  );
                }),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 8, 24, 32),
              child: MorphingButton(
                label: _page < 2 ? 'التالي' : 'ابدأ الآن',
                onPressed: _next,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _OnboardingPage extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  const _OnboardingPage({required this.icon, required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 96,
            height: 96,
            decoration: BoxDecoration(
              color: AppColors.glassLight,
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.borderDefault),
            ),
            child: Icon(icon, size: 48, color: AppColors.textPrimary),
          )
              .animate()
              .fadeIn(duration: 400.ms)
              .slideY(begin: 0.1, end: 0, duration: 400.ms),
          const SizedBox(height: 32),
          Text(
            title,
            style: Theme.of(context).textTheme.headlineLarge,
            textAlign: TextAlign.center,
          )
              .animate(delay: 80.ms)
              .fadeIn(duration: 400.ms)
              .slideY(begin: 0.05, end: 0, duration: 400.ms),
          const SizedBox(height: 16),
          Text(
            subtitle,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.textMuted,
                  height: 1.6,
                ),
            textAlign: TextAlign.center,
          )
              .animate(delay: 160.ms)
              .fadeIn(duration: 400.ms)
              .slideY(begin: 0.05, end: 0, duration: 400.ms),
        ],
      ),
    );
  }
}
