import 'package:flutter/animation.dart';

class MotionTokens {
  // ── Durations ──────────────────────────────────────────
  static const Duration instant  = Duration(milliseconds: 100);
  static const Duration fast     = Duration(milliseconds: 200);
  static const Duration normal   = Duration(milliseconds: 350);
  static const Duration slow     = Duration(milliseconds: 500);
  static const Duration dramatic = Duration(milliseconds: 700);

  // ── Curves ─────────────────────────────────────────────
  static const Curve standard   = Curves.easeOutCubic;
  static const Curve emphasized = Curves.easeInOut;
  static const Curve overshoot  = Curves.elasticOut;
  static const Curve quickIn    = Curves.easeIn;

  // ── Stagger ────────────────────────────────────────────
  static const Duration staggerItem    = Duration(milliseconds: 50);
  static const Duration staggerSection = Duration(milliseconds: 80);
}
