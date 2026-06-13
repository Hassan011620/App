import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/glass_card.dart';
import '../../../../core/widgets/slot_machine_counter.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _hidden = false;
  double _balance = 12450.75;

  final _txns = [
    _Txn('متجر الأمين', 'دفع NFC', -85.00, '08:32', true),
    _Txn('محمد أحمد', 'تحويل واردة', 500.00, 'أمس', false),
    _Txn('فاتورة الكهرباء', 'دفع خدمة', -230.00, 'أمس', true),
    _Txn('سلمى علي', 'تحويل واردة', 150.00, 'الاثنين', false),
    _Txn('السوق المركزي', 'دفع QR', -62.50, 'الاثنين', true),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.deepBackground,
      body: SafeArea(
        child: RefreshIndicator(
          color: AppColors.textPrimary,
          backgroundColor: AppColors.elevatedSurface,
          onRefresh: () async {
            await Future.delayed(const Duration(milliseconds: 1200));
            setState(() => _balance = 12450.75 + (DateTime.now().second * 0.5));
          },
          child: CustomScrollView(
            slivers: [
              // ── AppBar ─────────────────────────────────────
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
                  child: Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: const BoxDecoration(
                          color: AppColors.glassMedium,
                          shape: BoxShape.circle,
                          border: Border.fromBorderSide(
                              BorderSide(color: AppColors.borderDefault)),
                        ),
                        child: const Icon(Icons.person_rounded,
                            color: AppColors.textMuted, size: 20),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('مرحباً،',
                              style: Theme.of(context).textTheme.bodySmall),
                          Text('محمد عبدالله',
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineSmall
                                  ?.copyWith(fontSize: 16)),
                        ],
                      ),
                      const Spacer(),
                      IconButton(
                        onPressed: () => context.go('/notifications'),
                        icon: Stack(
                          clipBehavior: Clip.none,
                          children: [
                            const Icon(Icons.notifications_outlined,
                                color: AppColors.textPrimary, size: 24),
                            Positioned(
                              right: -2,
                              top: -2,
                              child: Container(
                                width: 8,
                                height: 8,
                                decoration: const BoxDecoration(
                                  color: AppColors.error,
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ).animate().fadeIn(duration: 400.ms),
              ),

              // ── Balance Card ───────────────────────────────
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
                  child: _BalanceCard(
                    balance: _balance,
                    hidden: _hidden,
                    onToggleHide: () => setState(() => _hidden = !_hidden),
                  ),
                ).animate(delay: 80.ms)
                    .fadeIn(duration: 400.ms)
                    .slideY(begin: 0.05, end: 0, duration: 400.ms),
              ),

              // ── Quick Actions ──────────────────────────────
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _QuickAction(icon: Icons.arrow_upward_rounded,  label: 'إرسال',    onTap: () => context.go('/send')),
                      _QuickAction(icon: Icons.arrow_downward_rounded, label: 'استلام',   onTap: () => context.go('/receive')),
                      _QuickAction(icon: Icons.qr_code_scanner,        label: 'مسح QR',   onTap: () {}),
                      _QuickAction(icon: Icons.nfc_rounded,            label: 'دفع NFC',  onTap: () => context.go('/nfc-pay')),
                    ],
                  ),
                ).animate(delay: 160.ms)
                    .fadeIn(duration: 400.ms)
                    .slideY(begin: 0.05, end: 0, duration: 400.ms),
              ),

              // ── Recent Transactions ────────────────────────
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 28, 20, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('المعاملات الأخيرة',
                          style: Theme.of(context).textTheme.headlineSmall),
                      TextButton(
                        onPressed: () {},
                        child: const Text('عرض الكل',
                            style: TextStyle(
                                color: AppColors.textMuted, fontSize: 13)),
                      ),
                    ],
                  ),
                ).animate(delay: 200.ms).fadeIn(duration: 400.ms),
              ),

              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (ctx, i) => Padding(
                    padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
                    child: _TxnRow(txn: _txns[i]),
                  ).animate(delay: Duration(milliseconds: 240 + i * 40))
                      .fadeIn(duration: 300.ms)
                      .slideX(begin: 0.03, end: 0, duration: 300.ms),
                  childCount: _txns.length,
                ),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 100)),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Balance Card ─────────────────────────────────────────────
class _BalanceCard extends StatelessWidget {
  final double balance;
  final bool hidden;
  final VoidCallback onToggleHide;

  const _BalanceCard({
    required this.balance,
    required this.hidden,
    required this.onToggleHide,
  });

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      padding: const EdgeInsets.all(24),
      shadows: [
        BoxShadow(
          color: Colors.white.withOpacity(0.05),
          blurRadius: 30,
          offset: const Offset(0, 10),
        ),
      ],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('الرصيد الإجمالي',
                  style: Theme.of(context).textTheme.bodySmall),
              GestureDetector(
                onTap: onToggleHide,
                child: Icon(
                  hidden ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                  color: AppColors.textMuted,
                  size: 18,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          SlotMachineCounter(
            value: balance,
            hidden: hidden,
            style: Theme.of(context).textTheme.displayMedium,
          ),
          const SizedBox(height: 16),
          // Mini chart placeholder
          SizedBox(
            height: 48,
            child: CustomPaint(painter: _MiniChartPainter()),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              const Icon(Icons.arrow_upward_rounded,
                  color: AppColors.success, size: 14),
              const SizedBox(width: 4),
              Text('12.3% مقارنة بالشهر الماضي',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.success,
                      )),
            ],
          ),
        ],
      ),
    );
  }
}

class _MiniChartPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final pts = [0.6, 0.4, 0.7, 0.3, 0.8, 0.5, 0.9];
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.6)
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final path = Path();
    for (int i = 0; i < pts.length; i++) {
      final x = i / (pts.length - 1) * size.width;
      final y = size.height - pts[i] * size.height;
      if (i == 0) path.moveTo(x, y); else path.lineTo(x, y);
    }
    canvas.drawPath(path, paint);

    final dotPaint = Paint()
      ..color = Colors.white.withOpacity(0.8)
      ..style = PaintingStyle.fill;
    for (int i = 0; i < pts.length; i++) {
      final x = i / (pts.length - 1) * size.width;
      final y = size.height - pts[i] * size.height;
      canvas.drawCircle(Offset(x, y), 2.5, dotPaint);
    }
  }

  @override
  bool shouldRepaint(_) => false;
}

// ── Quick Action ──────────────────────────────────────────────
class _QuickAction extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  const _QuickAction({required this.icon, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        onTap();
      },
      child: Column(
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 100),
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: AppColors.glassLight,
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.borderDefault),
            ),
            child: Icon(icon, color: AppColors.textPrimary, size: 26),
          ),
          const SizedBox(height: 8),
          Text(label, style: Theme.of(context).textTheme.labelLarge?.copyWith(fontSize: 11)),
        ],
      ),
    );
  }
}

// ── Transaction Row ───────────────────────────────────────────
class _Txn {
  final String name;
  final String type;
  final double amount;
  final String time;
  final bool isDebit;
  const _Txn(this.name, this.type, this.amount, this.time, this.isDebit);
}

class _TxnRow extends StatelessWidget {
  final _Txn txn;
  const _TxnRow({super.key, required this.txn});

  @override
  Widget build(BuildContext context) {
    final color = txn.isDebit ? AppColors.error : AppColors.success;
    final sign  = txn.isDebit ? '-' : '+';

    return GlassCard.light(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              txn.isDebit ? Icons.arrow_upward_rounded : Icons.arrow_downward_rounded,
              color: color,
              size: 18,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(txn.name, style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontSize: 14)),
                const SizedBox(height: 2),
                Text(txn.type, style: Theme.of(context).textTheme.bodySmall),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '$sign${txn.amount.abs().toStringAsFixed(2)} SDG',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: color,
                  fontFeatures: const [FontFeature.tabularFigures()],
                ),
              ),
              const SizedBox(height: 2),
              Text(txn.time, style: Theme.of(context).textTheme.bodySmall),
            ],
          ),
        ],
      ),
    );
  }
}
