import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class NfcRipples extends StatefulWidget {
  final double size;
  const NfcRipples({super.key, this.size = 80});

  @override
  State<NfcRipples> createState() => _NfcRipplesState();
}

class _NfcRipplesState extends State<NfcRipples>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _ctrl,
      builder: (_, __) => SizedBox(
        width: widget.size + 120,
        height: widget.size + 120,
        child: Stack(
          alignment: Alignment.center,
          children: List.generate(3, (i) {
            final p = (_ctrl.value + i * 0.333) % 1.0;
            final r = widget.size / 2 + p * 60;
            return Opacity(
              opacity: (0.3 * (1 - p)).clamp(0.0, 1.0),
              child: Container(
                width: r * 2,
                height: r * 2,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppColors.textPrimary,
                    width: 1.5,
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}

class NfcScanLines extends StatefulWidget {
  final double cardHeight;
  const NfcScanLines({super.key, this.cardHeight = 160});

  @override
  State<NfcScanLines> createState() => _NfcScanLinesState();
}

class _NfcScanLinesState extends State<NfcScanLines>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _ctrl,
      builder: (_, __) => Positioned(
        top: _ctrl.value * widget.cardHeight,
        left: 0,
        right: 0,
        child: Container(
          height: 2,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.transparent,
                Colors.white.withOpacity(0.8),
                Colors.transparent,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
