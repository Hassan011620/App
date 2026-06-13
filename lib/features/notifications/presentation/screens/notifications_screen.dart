import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/glass_card.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final notifications = [
      _Notification(
        title: 'تم استقبال تحويل',
        subtitle: '500.00 SDG من محمد أحمد',
        icon: Icons.arrow_downward_rounded,
        time: 'منذ ساعة',
        color: AppColors.success,
      ),
      _Notification(
        title: 'تم الدفع بنجاح',
        subtitle: '85.00 SDG في متجر الأمين',
        icon: Icons.arrow_upward_rounded,
        time: 'منذ ساعتين',
        color: AppColors.error,
      ),
      _Notification(
        title: 'تنبيه أمان',
        subtitle: 'تم تسجيل دخول جديد من جهاز آخر',
        icon: Icons.security_rounded,
        time: 'منذ يوم',
        color: AppColors.scheduled,
      ),
    ];

    return Scaffold(
      backgroundColor: AppColors.deepBackground,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new,
              color: AppColors.textPrimary, size: 20),
          onPressed: () => context.go('/home'),
        ),
        title: const Text('إشعاراتي'),
      ),
      body: SafeArea(
        child: ListView.separated(
          padding: const EdgeInsets.all(20),
          itemCount: notifications.length,
          separatorBuilder: (_, __) => const SizedBox(height: 12),
          itemBuilder: (_, i) => _NotificationTile(notification: notifications[i]),
        ),
      ),
    );
  }
}

class _Notification {
  final String title;
  final String subtitle;
  final IconData icon;
  final String time;
  final Color color;

  _Notification({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.time,
    required this.color,
  });
}

class _NotificationTile extends StatelessWidget {
  final _Notification notification;
  const _NotificationTile({required this.notification});

  @override
  Widget build(BuildContext context) {
    return GlassCard.light(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: notification.color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              notification.icon,
              color: notification.color,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  notification.title,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const SizedBox(height: 4),
                Text(
                  notification.subtitle,
                  style: Theme.of(context).textTheme.bodySmall,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          Text(
            notification.time,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: AppColors.textMuted,
            ),
          ),
        ],
      ),
    );
  }
}
