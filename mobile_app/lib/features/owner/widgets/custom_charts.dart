import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../../core/theme/owner_theme.dart';
import '../../../data/models/analytics_models.dart';

class SalesTrendAreaChart extends StatelessWidget {
  final List<DailySalesData> data;

  const SalesTrendAreaChart({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 230,
      width: double.infinity,
      child: CustomPaint(
        painter: _SalesAreaPainter(data),
      ),
    );
  }
}

class _SalesAreaPainter extends CustomPainter {
  final List<DailySalesData> data;
  _SalesAreaPainter(this.data);

  @override
  void paint(Canvas canvas, Size size) {
    const leftPad = 56.0;
    const bottomPad = 28.0;
    const topPad = 16.0;
    const rightPad = 16.0;

    final chartW = size.width - leftPad - rightPad;
    final chartH = size.height - topPad - bottomPad;
    const maxVal = 9.0;

    final gridPaint = Paint()
      ..color = OwnerColors.surfaceContainerHigh
      ..strokeWidth = 1;

    final textPainter = TextPainter(textDirection: TextDirection.ltr);

    final labels = ['Rp 9 Jt', 'Rp 6 Jt', 'Rp 3 Jt', 'Rp 0'];
    for (int i = 0; i < labels.length; i++) {
      final y = topPad + (chartH / 3) * i;
      canvas.drawLine(Offset(leftPad, y), Offset(size.width - rightPad, y), gridPaint);

      textPainter.text = TextSpan(
        text: labels[i],
        style: const TextStyle(color: OwnerColors.outline, fontSize: 11),
      );
      textPainter.layout();
      textPainter.paint(canvas, Offset(leftPad - textPainter.width - 8, y - 6));
    }

    if (data.isEmpty) return;

    final grossPoints = <Offset>[];
    final netPoints = <Offset>[];

    for (int i = 0; i < data.length; i++) {
      final x = leftPad + (chartW / (data.length - 1)) * i;
      final yGross = topPad + chartH * (1 - (data[i].grossMillion / maxVal));
      final yNet = topPad + chartH * (1 - (data[i].netMillion / maxVal));
      grossPoints.add(Offset(x, yGross));
      netPoints.add(Offset(x, yNet));

      textPainter.text = TextSpan(
        text: data[i].isPeak ? '${data[i].dayLabel} ★' : data[i].dayLabel,
        style: TextStyle(
          color: data[i].isPeak ? OwnerColors.primary : OwnerColors.onSurfaceVariant,
          fontSize: 11,
          fontWeight: data[i].isPeak ? FontWeight.bold : FontWeight.w500,
        ),
      );
      textPainter.layout();
      textPainter.paint(canvas, Offset(x - textPainter.width / 2, topPad + chartH + 8));
    }

    final grossAreaPath = Path()..moveTo(grossPoints.first.dx, topPad + chartH);
    for (final p in grossPoints) {
      grossAreaPath.lineTo(p.dx, p.dy);
    }
    grossAreaPath.lineTo(grossPoints.last.dx, topPad + chartH);
    grossAreaPath.close();

    final grossFillPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          OwnerColors.primary.withValues(alpha: 0.28),
          OwnerColors.primary.withValues(alpha: 0.0),
        ],
      ).createShader(Rect.fromLTWH(leftPad, topPad, chartW, chartH));
    canvas.drawPath(grossAreaPath, grossFillPaint);

    final netLinePaint = Paint()
      ..color = OwnerColors.tertiary
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    final netPath = Path()..moveTo(netPoints.first.dx, netPoints.first.dy);
    for (int i = 1; i < netPoints.length; i++) {
      netPath.lineTo(netPoints[i].dx, netPoints[i].dy);
    }
    canvas.drawPath(netPath, netLinePaint);

    final grossLinePaint = Paint()
      ..color = OwnerColors.primary
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    final grossPath = Path()..moveTo(grossPoints.first.dx, grossPoints.first.dy);
    for (int i = 1; i < grossPoints.length; i++) {
      grossPath.lineTo(grossPoints[i].dx, grossPoints[i].dy);
    }
    canvas.drawPath(grossPath, grossLinePaint);

    for (int i = 0; i < grossPoints.length; i++) {
      final p = grossPoints[i];
      if (data[i].isPeak) {
        canvas.drawCircle(p, 11, Paint()..color = OwnerColors.primary.withValues(alpha: 0.18));
        canvas.drawCircle(p, 6, Paint()..color = OwnerColors.primary);
        canvas.drawCircle(p, 2.5, Paint()..color = Colors.white);
      } else {
        canvas.drawCircle(p, 4.5, Paint()..color = Colors.white);
        canvas.drawCircle(
          p,
          4.5,
          Paint()
            ..color = OwnerColors.primary
            ..style = PaintingStyle.stroke
            ..strokeWidth = 2,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class DonutPaymentChart extends StatelessWidget {
  final double primaryPercent;
  final String centerTitle;
  final String centerSubtitle;
  final Color primaryColor;
  final Color secondaryColor;
  final double size;

  const DonutPaymentChart({
    super.key,
    required this.primaryPercent,
    required this.centerTitle,
    required this.centerSubtitle,
    this.primaryColor = OwnerColors.primary,
    this.secondaryColor = OwnerColors.secondary,
    this.size = 104,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CustomPaint(
            size: Size(size, size),
            painter: _DonutPainter(
              primaryRatio: primaryPercent / 100,
              primaryColor: primaryColor,
              secondaryColor: secondaryColor,
            ),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                centerTitle,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: primaryColor,
                ),
              ),
              Text(
                centerSubtitle,
                style: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: OwnerColors.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _DonutPainter extends CustomPainter {
  final double primaryRatio;
  final Color primaryColor;
  final Color secondaryColor;

  _DonutPainter({
    required this.primaryRatio,
    required this.primaryColor,
    required this.secondaryColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final strokeWidth = size.width * 0.14;
    final rect = Offset(strokeWidth / 2, strokeWidth / 2) &
        Size(size.width - strokeWidth, size.height - strokeWidth);

    final bgPaint = Paint()
      ..color = secondaryColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;

    final fgPaint = Paint()
      ..color = primaryColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(rect, 0, math.pi * 2, false, bgPaint);
    canvas.drawArc(rect, -math.pi / 2, math.pi * 2 * primaryRatio, false, fgPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}