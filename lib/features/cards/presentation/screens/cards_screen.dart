import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/glass_card.dart';

class CardsScreen extends StatefulWidget {
  const CardsScreen({super.key});
  @override
  State<CardsScreen> createState() => _CardsScreenState();
}

class _CardsScreenState extends State<CardsScreen> {
  final _cards = [
    _CardData('•••• 4821', '12/27', false, 'MIFARE DESFire EV2'),
    _CardData('•••• 9034', '08/26', false, 'MIFARE DESFire EV2'),
    _CardData('•••• 2217', '03/25', true,  'MIFARE DESFire EV3'),
  ];
  int _flipped = -1;

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
        title: const Text('بطاقاتي'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_rounded, color: AppColors.textPrimary),
            onPressed: () {},
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Card Stack
            SizedBox(
              height: 220,
              child: Stack(
                alignment: Alignment.center,
                clipBehavior: Clip.none,
                children: List.generate(_cards.length, (i) {
                  final offsets = [0.0, -16.0, -32.0];
                  final scales  = [1.0, 0.95, 0.90];
                  final rotations = [0.0, 0.017, -0.017];
                  return Positioned(
                    top: offsets[i],
                    child: Transform.scale(
                      scale: scales[i],
                      child: Transform.rotate(
                        angle: rotations[i],
                        child: _CardWidget(
                          data: _cards[i],
                          flipped: _flipped == i,
                          onFlip: () {
                            HapticFeedback.lightImpact();
                            setState(() => _flipped = _flipped == i ? -1 : i);
                          },
                        ).animate(delay: Duration(milliseconds: i * 80))
                            .fadeIn(duration: 400.ms)
                            .slideY(begin: 0.1, end: 0, duration: 400.ms),
                      ),
                    ),
                  );
                }).reversed.toList(),
              ),
            ),
            const SizedBox(height: 32),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text('جميع البطاقات',
                  style: Theme.of(context).textTheme.headlineSmall),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: _cards.length,
                separatorBuilder: (_, __) => const SizedBox(height: 8),
                itemBuilder: (_, i) => GlassCard.light(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Row(
                    children: [
                      Container(
                        width: 40, height: 28,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0x33FFFFFF), Color(0x11FFFFFF)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(color: AppColors.borderDefault),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(_cards[i].number, style: Theme.of(context).textTheme.bodyLarge),
                            Text(_cards[i].chipType, style: Theme.of(context).textTheme.bodySmall),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: (_cards[i].frozen ? AppColors.scheduled : AppColors.success).withOpacity(0.15),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          _cards[i].frozen ? 'مجمّدة' : 'نشطة',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: _cards[i].frozen ? AppColors.scheduled : AppColors.success,
                          ),
                        ),
                      ),
                    ],
                  ),
                ).animate(delay: Duration(milliseconds: 200 + i * 60))
                    .fadeIn(duration: 300.ms)
                    .slideX(begin: 0.03, end: 0, duration: 300.ms),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CardData {
  final String number;
  final String expiry;
  final bool frozen;
  final String chipType;
  const _CardData(this.number, this.expiry, this.frozen, this.chipType);
}

class _CardWidget extends StatefulWidget {
  final _CardData data;
  final bool flipped;
  final VoidCallback onFlip;
  const _CardWidget({super.key, required this.data, required this.flipped, required this.onFlip});

  @override
  State<_CardWidget> createState() => _CardWidgetState();
}

class _CardWidgetState extends State<_CardWidget> with SingleTickerProviderStateMixin {
  late AnimationController _flipCtrl;
  late Animation<double> _flipAnim;

  @override
  void initState() {
    super.initState();
    _flipCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 500));
    _flipAnim = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _flipCtrl, curve: Curves.easeInOut));
  }

  @override
  void didUpdateWidget(_CardWidget old) {
    super.didUpdateWidget(old);
    if (widget.flipped && !old.flipped) _flipCtrl.forward();
    if (!widget.flipped && old.flipped) _flipCtrl.reverse();
  }

  @override
  void dispose() { _flipCtrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onFlip,
      child: AnimatedBuilder(
        animation: _flipAnim,
        builder: (_, __) {
          final isBack = _flipAnim.value > 0.5;
          return Transform(
            alignment: Alignment.center,
            transform: Matrix4.identity()
              ..setEntry(3, 2, 0.001)
              ..rotateY(_flipAnim.value * 3.14159),
            child: Container(
              width: 280,
              height: 170,
              decoration: BoxDecoration(
                color: AppColors.glassHeavy,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.borderDefault, width: 1.5),
              ),
              child: isBack
                  ? Transform(
                      alignment: Alignment.center,
                      transform: Matrix4.identity()..rotateY(3.14159),
                      child: _CardBack(data: widget.data),
                    )
                  : _CardFront(data: widget.data),
            ),
          );
        },
      ),
    );
  }
}

class _CardFront extends StatelessWidget {
  final _CardData data;
  const _CardFront({required this.data});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 36, height: 28,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0x33FFFFFF), Color(0x11FFFFFF)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(color: AppColors.borderDefault),
                ),
              ),
              if (data.frozen)
                const Icon(Icons.ac_unit_rounded, color: AppColors.scheduled, size: 20),
            ],
          ),
          const Spacer(),
          Text(data.number,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
                letterSpacing: 3,
                fontFeatures: [FontFeature.tabularFigures()],
              )),
          const SizedBox(height: 4),
          Row(
            children: [
              Text('انتهاء: ${data.expiry}',
                  style: const TextStyle(fontSize: 11, color: AppColors.textMuted)),
              const Spacer(),
              const Icon(Icons.nfc_rounded, color: AppColors.textMuted, size: 18),
            ],
          ),
        ],
      ),
    );
  }
}

class _CardBack extends StatelessWidget {
  final _CardData data;
  const _CardBack({required this.data});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('آخر 3 عمليات', style: Theme.of(context).textTheme.bodySmall),
          const SizedBox(height: 8),
          _miniTxn(context, 'متجر الأمين', '-85.00 SDG'),
          _miniTxn(context, 'محمد أحمد', '+500.00 SDG'),
          _miniTxn(context, 'فاتورة كهرباء', '-230.00 SDG'),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: AppColors.scheduled),
                    foregroundColor: AppColors.scheduled,
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  child: Text(data.frozen ? 'إلغاء تجميد' : 'تجميد', style: const TextStyle(fontSize: 12)),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: OutlinedButton(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: AppColors.error),
                    foregroundColor: AppColors.error,
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  child: const Text('إبلاغ فقدان', style: TextStyle(fontSize: 12)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _miniTxn(BuildContext context, String name, String amount) {
    final isDebit = amount.startsWith('-');
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(name, style: const TextStyle(fontSize: 11, color: AppColors.textMuted)),
          Text(amount, style: TextStyle(
            fontSize: 11, fontWeight: FontWeight.w600,
            color: isDebit ? AppColors.error : AppColors.success,
          )),
        ],
      ),
    );
  }
}
