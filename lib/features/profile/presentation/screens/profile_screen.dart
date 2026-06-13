import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/glass_card.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

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
        title: const Text('حسابي'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined, color: AppColors.textPrimary, size: 22),
            onPressed: () {},
          ),
        ],
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            // Avatar + name
            Center(
              child: Column(
                children: [
                  Container(
                    width: 80, height: 80,
                    decoration: const BoxDecoration(
                      color: AppColors.glassMedium,
                      shape: BoxShape.circle,
                      border: Border.fromBorderSide(
                        BorderSide(color: AppColors.borderDefault, width: 1.5),
                      ),
                    ),
                    child: const Icon(Icons.person_rounded, color: AppColors.textMuted, size: 40),
                  ),
                  const SizedBox(height: 12),
                  Text('محمد عبدالله',
                      style: Theme.of(context).textTheme.headlineMedium),
                  const SizedBox(height: 4),
                  GestureDetector(
                    onTap: () {
                      Clipboard.setData(const ClipboardData(text: '482197'));
                      HapticFeedback.selectionClick();
                    },
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('482 197',
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  letterSpacing: 4,
                                  color: AppColors.textMuted,
                                )),
                        const SizedBox(width: 6),
                        const Icon(Icons.copy_outlined, size: 14, color: AppColors.textDisabled),
                      ],
                    ),
                  ),
                ],
              ),
            ).animate().fadeIn(duration: 400.ms),
            const SizedBox(height: 28),
            // Stats row
            GlassCard(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _Stat('إرسال', '147', Icons.arrow_upward_rounded, AppColors.error),
                  _divider(),
                  _Stat('استلام', '93', Icons.arrow_downward_rounded, AppColors.success),
                  _divider(),
                  _Stat('NFC', '38', Icons.nfc_rounded, AppColors.info),
                ],
              ),
            ).animate(delay: 80.ms).fadeIn(duration: 400.ms).slideY(begin: 0.05, end: 0, duration: 400.ms),
            const SizedBox(height: 20),
            // Settings sections
            _SectionLabel('الحساب'),
            ...[
              _SettingRow(Icons.person_outline, 'معلوماتي الشخصية', onTap: () {}),
              _SettingRow(Icons.lock_outline, 'كلمة المرور والأمان', onTap: () {}),
              _SettingRow(Icons.fingerprint, 'البصمة والوجه', onTap: () {}),
              _SettingRow(Icons.notifications_outlined, 'إشعارات', onTap: () {}),
            ].asMap().entries.map((e) => e.value
                .animate(delay: Duration(milliseconds: 120 + e.key * 40))
                .fadeIn(duration: 300.ms)
                .slideX(begin: 0.02, end: 0, duration: 300.ms)),
            _SectionLabel('الخصوصية والأمان'),
            ...[
              _SettingRow(Icons.history_rounded, 'سجل العمليات', onTap: () {}),
              _SettingRow(Icons.block_rounded, 'الجهاز والوصول', onTap: () {}),
            ].asMap().entries.map((e) => e.value
                .animate(delay: Duration(milliseconds: 260 + e.key * 40))
                .fadeIn(duration: 300.ms)
                .slideX(begin: 0.02, end: 0, duration: 300.ms)),
            _SectionLabel('عام'),
            ...[
              _SettingRow(Icons.language_outlined, 'اللغة', trailing: 'العربية', onTap: () {}),
              _SettingRow(Icons.dark_mode_outlined, 'المظهر', trailing: 'داكن', onTap: () {}),
              _SettingRow(Icons.help_outline, 'المساعدة والدعم', onTap: () {}),
            ].asMap().entries.map((e) => e.value
                .animate(delay: Duration(milliseconds: 340 + e.key * 40))
                .fadeIn(duration: 300.ms)
                .slideX(begin: 0.02, end: 0, duration: 300.ms)),
            const SizedBox(height: 16),
            // Logout
            OutlinedButton.icon(
              onPressed: () => context.go('/login'),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: AppColors.error),
                foregroundColor: AppColors.error,
                minimumSize: const Size(double.infinity, 52),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              icon: const Icon(Icons.logout_rounded, size: 18),
              label: const Text('تسجيل الخروج'),
            ).animate(delay: 480.ms).fadeIn(duration: 300.ms),
            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }

  Widget _divider() => Container(
    width: 1, height: 36, color: AppColors.borderSubtle,
  );
}

class _Stat extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;
  const _Stat(this.label, this.value, this.icon, this.color);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: color, size: 18),
        const SizedBox(height: 4),
        Text(value, style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontSize: 20)),
        const SizedBox(height: 2),
        Text(label, style: Theme.of(context).textTheme.bodySmall),
      ],
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String text;
  const _SectionLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20, bottom: 8, right: 4),
      child: Text(text,
          style: Theme.of(context).textTheme.labelMedium?.copyWith(
                letterSpacing: 1,
                color: AppColors.textMuted,
              )),
    );
  }
}

class _SettingRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String? trailing;
  final VoidCallback onTap;
  const _SettingRow(this.icon, this.label, {this.trailing, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: GlassCard.light(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        onTap: onTap,
        child: Row(
          children: [
            Icon(icon, color: AppColors.textMuted, size: 20),
            const SizedBox(width: 12),
            Expanded(
              child: Text(label, style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontSize: 14)),
            ),
            if (trailing != null)
              Text(trailing!,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.textMuted)),
            const SizedBox(width: 4),
            const Icon(Icons.chevron_right_rounded, color: AppColors.textDisabled, size: 18),
          ],
        ),
      ),
    );
  }
}
