import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/glass_card.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});
  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  final _notifs = [
    _Notif('دفع ناجح', 'تم خصم 85.00 SDG من محفظتك في متجر الأمين', '08:32', false, Icons.check_circle_outline),
    _Notif('مبلغ واردة', 'استلمت 500.00 SDG من محمد أحمد', 'أمس 14:20', false, Icons.arrow_downward_rounded),
    _Notif('تنبيه أمني', 'تم تسجيل الدخول من جهاز جديد', 'أمس 09:15', true, Icons.security_outlined),
    _Notif('دفع ناجح', 'تم خصم 230.00 SDG فاتورة الكهرباء', 'الاثنين 11:05', true, Icons.bolt_outlined),
    _Notif('تذكير', 'تحويلك المجدول لسلمى علي سيتم غداً', 'الأحد 20:00', true, Icons.schedule_outlined),
  ];

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
        title: const Text('الإشعارات'),
        actions: [
          TextButton(
            onPressed: () => setState(() {
              for (final n in _notifs) n.read = true;
            }),
            child: const Text('تحديد الكل مقروء',
                style: TextStyle(color: AppColors.textMuted, fontSize: 12)),
          ),
        ],
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          children: [
            _section('اليوم', _notifs.where((n) => !n.isYesterday && !n.isOlder).toList(), 0),
            _section('أمس', _notifs.where((n) => n.isYesterday).toList(), 100),
            _section('هذا الأسبوع', _notifs.where((n) => n.isOlder).toList(), 200),
            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }

  Widget _section(String title, List<_Notif> items, int baseDelay) {
    if (items.isEmpty) return const SizedBox.shrink();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 24, bottom: 12),
          child: Text(title,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.textMuted,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1,
                  )),
        ),
        ...items.asMap().entries.map((e) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: GestureDetector(
                onTap: () => setState(() => e.value.read = true),
                child: AnimatedOpacity(
                  duration: const Duration(milliseconds: 300),
                  opacity: e.value.read ? 0.5 : 1.0,
                  child: GlassCard.light(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                    child: Row(
                      children: [
                        Container(
                          width: 40, height: 40,
                          decoration: BoxDecoration(
                            color: AppColors.glassMedium,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(e.value.icon, color: AppColors.textPrimary, size: 20),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(e.value.title,
                                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontSize: 14)),
                              const SizedBox(height: 2),
                              Text(e.value.body,
                                  style: Theme.of(context).textTheme.bodySmall,
                                  maxLines: 2, overflow: TextOverflow.ellipsis),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(e.value.time,
                                style: Theme.of(context).textTheme.bodySmall?.copyWith(fontSize: 10)),
                            const SizedBox(height: 4),
                            if (!e.value.read)
                              Container(
                                width: 7, height: 7,
                                decoration: const BoxDecoration(
                                  color: AppColors.info,
                                  shape: BoxShape.circle,
                                ),
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ).animate(delay: Duration(milliseconds: baseDelay + e.key * 50))
                  .fadeIn(duration: 300.ms)
                  .slideX(begin: 0.02, end: 0, duration: 300.ms),
            )),
      ],
    );
  }
}

class _Notif {
  final String title;
  final String body;
  final String time;
  bool read;
  final IconData icon;
  _Notif(this.title, this.body, this.time, this.read, this.icon);
  bool get isYesterday => time.startsWith('أمس');
  bool get isOlder => time.startsWith('الاثنين') || time.startsWith('الأحد');
}
