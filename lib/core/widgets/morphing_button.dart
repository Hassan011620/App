import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme/app_colors.dart';
import '../theme/motion_tokens.dart';

enum ButtonState { idle, loading, success, error }

class MorphingButton extends StatefulWidget {
  final String label;
  final VoidCallback? onPressed;
  final ButtonState state;
  final Color backgroundColor;
  final Color foregroundColor;

  const MorphingButton({
    super.key,
    required this.label,
    this.onPressed,
    this.state = ButtonState.idle,
    this.backgroundColor = AppColors.textPrimary,
    this.foregroundColor = AppColors.deepBackground,
  });

  @override
  State<MorphingButton> createState() => _MorphingButtonState();
}

class _MorphingButtonState extends State<MorphingButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _checkController;

  @override
  void initState() {
    super.initState();
    _checkController = AnimationController(
      vsync: this,
      duration: MotionTokens.slow,
    );
  }

  @override
  void didUpdateWidget(MorphingButton old) {
    super.didUpdateWidget(old);
    if (widget.state == ButtonState.success && old.state != ButtonState.success) {
      _checkController.forward(from: 0);
      HapticFeedback.mediumImpact();
    }
  }

  @override
  void dispose() {
    _checkController.dispose();
    super.dispose();
  }

  bool get _isLoading => widget.state == ButtonState.loading;
  bool get _isSuccess => widget.state == ButtonState.success;
  bool get _isError   => widget.state == ButtonState.error;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: MotionTokens.normal,
      curve: MotionTokens.standard,
      width: _isLoading || _isSuccess || _isError ? 56 : double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: _isLoading || _isSuccess ? null : widget.onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: _isSuccess
              ? AppColors.success
              : _isError
                  ? AppColors.error
                  : widget.backgroundColor,
          foregroundColor: widget.foregroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
              _isLoading || _isSuccess || _isError ? 28 : 12,
            ),
          ),
          minimumSize: const Size(56, 56),
          padding: EdgeInsets.zero,
          elevation: 0,
        ),
        child: AnimatedSwitcher(
          duration: MotionTokens.fast,
          child: _isLoading
              ? const SizedBox(
                  width: 22,
                  height: 22,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: AppColors.deepBackground,
                  ),
                )
              : _isSuccess
                  ? AnimatedBuilder(
                      animation: _checkController,
                      builder: (_, __) => CustomPaint(
                        size: const Size(24, 24),
                        painter: _CheckPainter(_checkController.value),
                      ),
                    )
                  : _isError
                      ? const Icon(Icons.close, color: Colors.white, size: 22)
                      : Text(widget.label),
        ),
      ),
    );
  }
}

class _CheckPainter extends CustomPainter {
  final double progress;
  _CheckPainter(this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..strokeWidth = 2.5
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    final path = Path();
    // M(0.2,0.5) → L(0.45,0.75) → L(0.8,0.25)
    final p1 = Offset(size.width * 0.2, size.height * 0.5);
    final p2 = Offset(size.width * 0.45, size.height * 0.75);
    final p3 = Offset(size.width * 0.8, size.height * 0.25);

    if (progress < 0.5) {
      final t = progress / 0.5;
      path.moveTo(p1.dx, p1.dy);
      path.lineTo(
        p1.dx + (p2.dx - p1.dx) * t,
        p1.dy + (p2.dy - p1.dy) * t,
      );
    } else {
      final t = (progress - 0.5) / 0.5;
      path.moveTo(p1.dx, p1.dy);
      path.lineTo(p2.dx, p2.dy);
      path.lineTo(
        p2.dx + (p3.dx - p2.dx) * t,
        p2.dy + (p3.dy - p2.dy) * t,
      );
    }
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(_CheckPainter old) => old.progress != progress;
}
