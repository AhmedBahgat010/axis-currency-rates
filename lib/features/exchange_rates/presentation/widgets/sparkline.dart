import 'package:flutter/material.dart';

class SparklineWidget extends StatelessWidget {
  final List<double> data;
  final Color lineColor;
  final double strokeWidth;

  const SparklineWidget({
    super.key,
    required this.data,
    required this.lineColor,
    this.strokeWidth = 2.0,
  });

  @override
  Widget build(BuildContext context) {
    if (data.isEmpty) {
      return const SizedBox.shrink();
    }

    return CustomPaint(
      painter: _SparklinePainter(
        data: data,
        lineColor: lineColor,
        strokeWidth: strokeWidth,
      ),
      child: const SizedBox.expand(),
    );
  }
}

class _SparklinePainter extends CustomPainter {
  final List<double> data;
  final Color lineColor;
  final double strokeWidth;

  _SparklinePainter({
    required this.data,
    required this.lineColor,
    required this.strokeWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (data.length < 2) return;

    double minVal = data.reduce((a, b) => a < b ? a : b);
    double maxVal = data.reduce((a, b) => a > b ? a : b);

    // Add slight padding to range
    if (minVal == maxVal) {
      minVal -= 1;
      maxVal += 1;
    }

    final double range = maxVal - minVal;
    final double stepX = size.width / (data.length - 1);

    final Path path = Path();
    final Path fillPath = Path();

    for (int i = 0; i < data.length; i++) {
      final double x = i * stepX;
      final double normalizedY = (data[i] - minVal) / range;
      final double y = size.height - (normalizedY * (size.height - 4)) - 2;

      if (i == 0) {
        path.moveTo(x, y);
        fillPath.moveTo(x, size.height);
        fillPath.lineTo(x, y);
      } else {
        path.lineTo(x, y);
        fillPath.lineTo(x, y);
      }
    }

    fillPath.lineTo(size.width, size.height);
    fillPath.close();

    // Gradient fill under the sparkline
    final Paint fillPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          lineColor.withOpacity(0.25),
          lineColor.withOpacity(0.0),
        ],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height))
      ..style = PaintingStyle.fill;

    canvas.drawPath(fillPath, fillPaint);

    final Paint linePaint = Paint()
      ..color = lineColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    canvas.drawPath(path, linePaint);
  }

  @override
  bool shouldRepaint(covariant _SparklinePainter oldDelegate) {
    return oldDelegate.data != data || oldDelegate.lineColor != lineColor;
  }
}
