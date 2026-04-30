import 'package:flutter/material.dart';
import '../core/theme.dart';

/// Logo animado de barras de waveform (igual al del Figma)
class WaveformLogo extends StatefulWidget {
  final double size;
  final bool animate;

  const WaveformLogo({super.key, this.size = 40, this.animate = true});

  @override
  State<WaveformLogo> createState() => _WaveformLogoState();
}

class _WaveformLogoState extends State<WaveformLogo>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    if (widget.animate) _ctrl.repeat(reverse: true);
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
      builder: (_, __) {
        return CustomPaint(
          size: Size(widget.size * 1.4, widget.size),
          painter: _WaveformPainter(_ctrl.value),
        );
      },
    );
  }
}

class _WaveformPainter extends CustomPainter {
  final double t;
  _WaveformPainter(this.t);

  // Alturas relativas de cada barra [0..1]
  static const _baseHeights = [0.4, 0.6, 0.9, 0.7, 1.0, 0.75, 0.5, 0.35, 0.55];
  static const _phases      = [0.0, 0.3, 0.6, 0.2, 0.8, 0.4,  0.9, 0.1,  0.5];

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.primary
      ..strokeCap = StrokeCap.round
      ..strokeWidth = size.width / _baseHeights.length * 0.45;

    final barWidth  = size.width / _baseHeights.length;
    final halfStroke = paint.strokeWidth / 2;

    for (int i = 0; i < _baseHeights.length; i++) {
      final wave = 0.15 * _sin(t + _phases[i]);
      final h    = (_baseHeights[i] + wave).clamp(0.2, 1.0) * size.height;
      final x    = barWidth * i + barWidth / 2;
      final cy   = size.height / 2;

      canvas.drawLine(
        Offset(x, cy - h / 2 + halfStroke),
        Offset(x, cy + h / 2 - halfStroke),
        paint,
      );
    }
  }

  double _sin(double v) => (v * 2 * 3.14159).abs() % (2 * 3.14159) < 3.14159
      ? (v * 2 * 3.14159 % 3.14159) / 3.14159 * 2 - 1
      : 1 - (v * 2 * 3.14159 % 3.14159) / 3.14159 * 2;

  @override
  bool shouldRepaint(_WaveformPainter old) => old.t != t;
}