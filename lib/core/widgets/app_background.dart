import 'package:flutter/material.dart';

class AppBackground extends StatelessWidget {
  const AppBackground({
    required this.child,
    this.backgroundColor = AppBackgroundColors.paper,
    this.lineColor = AppBackgroundColors.grid,
    this.lineWidth = 1,
    this.showGridFromTop = true,
    super.key,
  });

  final Widget child;
  final Color backgroundColor;
  final Color lineColor;
  final double lineWidth;
  final bool showGridFromTop;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: backgroundColor,
      child: Stack(
        fit: StackFit.expand,
        children: [
          CustomPaint(
            painter: AppBackgroundPainter(
              lineColor: lineColor,
              lineWidth: lineWidth,
              showGridFromTop: showGridFromTop,
            ),
          ),
          child,
        ],
      ),
    );
  }
}

class AppBackgroundScaffold extends StatelessWidget {
  const AppBackgroundScaffold({
    required this.body,
    this.backgroundColor = AppBackgroundColors.paper,
    this.lineColor = AppBackgroundColors.grid,
    this.lineWidth = 1,
    this.showGridFromTop = false,
    this.appBar,
    this.bottomNavigationBar,
    this.floatingActionButton,
    this.resizeToAvoidBottomInset,
    super.key,
  });

  final Widget body;
  final Color backgroundColor;
  final Color lineColor;
  final double lineWidth;
  final bool showGridFromTop;
  final PreferredSizeWidget? appBar;
  final Widget? bottomNavigationBar;
  final Widget? floatingActionButton;
  final bool? resizeToAvoidBottomInset;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: appBar,
      bottomNavigationBar: bottomNavigationBar,
      floatingActionButton: floatingActionButton,
      resizeToAvoidBottomInset: resizeToAvoidBottomInset,
      body: AppBackground(
        backgroundColor: backgroundColor,
        lineColor: lineColor,
        lineWidth: lineWidth,
        showGridFromTop: showGridFromTop,
        child: body,
      ),
    );
  }
}

class AppBackgroundPainter extends CustomPainter {
  const AppBackgroundPainter({
    this.lineColor = AppBackgroundColors.grid,
    this.lineWidth = 1,
    this.showGridFromTop = false,
  });

  final Color lineColor;
  final double lineWidth;
  final bool showGridFromTop;

  static const List<double> _verticalStops = [0.18, 0.215, 0.427];
  static const List<double> _horizontalStops = [
    0.368,
    0.41,
    0.544,
    0.603,
    0.638,
    0.759,
    0.842,
    0.879,
  ];

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = lineColor
      ..strokeWidth = lineWidth;

    final horizontalStart = showGridFromTop
        ? 0.0
        : size.height * _horizontalStops.first;
    final verticalEnd = size.height * 0.995;

    for (final stop in _verticalStops) {
      final x = size.width * stop;
      canvas.drawLine(
        Offset(x, horizontalStart),
        Offset(x, verticalEnd),
        paint,
      );
    }

    final horizontalStops = showGridFromTop
        ? const [0.12, 0.24, ..._horizontalStops]
        : _horizontalStops;

    for (final stop in horizontalStops) {
      final y = size.height * stop;
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant AppBackgroundPainter oldDelegate) {
    return oldDelegate.lineColor != lineColor ||
        oldDelegate.lineWidth != lineWidth ||
        oldDelegate.showGridFromTop != showGridFromTop;
  }
}

class AppBackgroundColors {
  const AppBackgroundColors._();

  static const Color paper = Color(0xFFFFFFFF);
  static const Color grid = Color(0xFFFBF1D7);
}
