import 'package:flutter/material.dart';
import '../theme/motion_tokens.dart';

class SlotMachineCounter extends StatefulWidget {
  final double value;
  final String currency;
  final TextStyle? style;
  final bool hidden;

  const SlotMachineCounter({
    super.key,
    required this.value,
    this.currency = 'SDG',
    this.style,
    this.hidden = false,
  });

  @override
  State<SlotMachineCounter> createState() => _SlotMachineCounterState();
}

class _SlotMachineCounterState extends State<SlotMachineCounter> {
  late double _oldValue;

  @override
  void initState() {
    super.initState();
    _oldValue = widget.value;
  }

  @override
  void didUpdateWidget(SlotMachineCounter old) {
    super.didUpdateWidget(old);
    if (old.value != widget.value) {
      _oldValue = old.value;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.hidden) {
      return Text(
        '●●●●●',
        style: widget.style ?? const TextStyle(fontSize: 36, fontWeight: FontWeight.w700),
      );
    }

    return TweenAnimationBuilder<double>(
      tween: Tween(begin: _oldValue, end: widget.value),
      duration: MotionTokens.slow,
      curve: MotionTokens.standard,
      builder: (_, val, __) => Text(
        '${widget.currency} ${val.toStringAsFixed(2)}',
        style: widget.style ?? const TextStyle(
          fontSize: 36,
          fontWeight: FontWeight.w700,
          fontFeatures: [FontFeature.tabularFigures()],
        ),
      ),
    );
  }
}
