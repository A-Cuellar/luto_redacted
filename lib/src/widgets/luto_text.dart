import 'dart:ui';
import 'package:flutter/material.dart';
import '../core/luto_guard.dart';
import '../core/luto_enums.dart';
import 'dart:math';

/// Core widget that displays sensitive text and hides it when [LutoController]
/// is obscured.
///
/// It automatically finds the nearest [LutoGuard] controller via
/// `LutoGuard.of(context)` and rebuilds when the controller value changes.
///
/// No layout shift: when hidden with a custom [obscuredBuilder], it keeps the
/// original text size with a transparent placeholder and overlays the builder.
///
/// Example:
/// ```dart
/// LutoText(
///   'ES91 2100 0418 4502',
///   lutoStyle: LutoStyle.blackBar,
/// )
/// ```
class LutoText extends StatelessWidget {
  /// The sensitive data to display / protect.
  final String data;

  /// Optional text style for the data.
  final TextStyle? style;

  /// Visual style used when obscured.
  ///
  /// See [LutoStyle] for options like blackBar, blur, shredded, etc.
  final LutoStyle lutoStyle;

  /// Optional custom widget to show when obscured instead of built-in styles.
  ///
  /// If provided, it will be shown filling the exact size of [data].
  final Widget? obscuredBuilder;

  /// Color of the black bar when [lutoStyle] is [LutoStyle.blackBar].
  final Color barColor;

  /// Creates a text widget that can be redacted.
  const LutoText(
    this.data, {
    super.key,
    this.style,
    this.lutoStyle = LutoStyle.blur,
    this.obscuredBuilder,
    this.barColor = Colors.black,
  });

  @override
  Widget build(BuildContext context) {
    final controller = LutoGuard.of(context);
    return ValueListenableBuilder<bool>(
      valueListenable: controller,
      builder: (context, isObscured, _) {
        if (isObscured && obscuredBuilder != null) {
          return Stack(
            children: [
              //Texto invisible para reservar el espacio exacto
              Text('$data ', style: style?.copyWith(color: Colors.transparent)),
              Positioned.fill(child: obscuredBuilder!),
            ],
          );
        }

        if (!isObscured) {
          return Text(data, style: style);
        }

        switch (lutoStyle) {
          case LutoStyle.blackBar:
            return _BlackBar(text: data, style: style, color: barColor);
          case LutoStyle.shredded:
            return _Shredded(text: data, style: style);
          case LutoStyle.blur:
            return _Blurred(child: Text(data, style: style));
          case LutoStyle.noise:
            return _Noisy(text: data, style: style);
          case LutoStyle.cubism:
            return _Cubist(text: data, style: style);
        }
      },
    );
  }
}

class _BlackBar extends StatelessWidget {
  final String text;
  final TextStyle? style;
  final Color color;
  const _BlackBar({required this.text, this.style, required this.color});

  @override
  Widget build(BuildContext context) {
    final textPainter = TextPainter(
      text: TextSpan(
        text: text,
        style: style ?? DefaultTextStyle.of(context).style,
      ),
      textDirection: TextDirection.ltr,
    )..layout();

    return Stack(
      children: [
        Text(
          text,
          style: style?.copyWith(color: style?.color?.withValues(alpha: 0.2)),
        ),
        Positioned.fill(
          child: Container(
            width: textPainter.width,
            height: (style?.fontSize ?? 16) * 1.15,
            color: color,
          ),
        ),
      ],
    );
  }
}

class _Blurred extends StatelessWidget {
  final Widget child;
  const _Blurred({required this.child});

  @override
  Widget build(BuildContext context) {
    return ImageFiltered(
      imageFilter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
      child: child,
    );
  }
}

class _Shredded extends StatelessWidget {
  final String text;
  final TextStyle? style;
  const _Shredded({required this.text, this.style});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Text(
          text,
          style: style?.copyWith(color: style?.color?.withValues(alpha: 0.2)),
        ),
        Positioned.fill(child: CustomPaint(painter: _ShredPainter())),
      ],
    );
  }
}

class _ShredPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;
    for (double i = 0; i < size.width; i += 6) {
      canvas.drawLine(Offset(i, 0), Offset(i + 4, size.height), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _Noisy extends StatelessWidget {
  final String text;
  final TextStyle? style;

  const _Noisy({required this.text, this.style});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Text(
          text,
          style: style?.copyWith(color: style?.color?.withValues(alpha: 0.2)),
        ),
        Positioned.fill(
          child: CustomPaint(painter: _NoisePainter(dotCount: 2000)),
        ),
      ],
    );
  }
}

class _NoisePainter extends CustomPainter {
  final List<Offset> points;
  final List<double> sizes;
  final List<Color> colors;
  final int dotCount;

  _NoisePainter({required this.dotCount})
    : points = List.generate(
        dotCount,
        (_) => Offset(Random().nextDouble(), Random().nextDouble()),
      ),
      sizes = List.generate(dotCount, (_) => Random().nextDouble() + 1.0),
      colors = List.generate(
        dotCount,
        (_) => _grays[Random().nextInt(_grays.length)],
      );

  static const List<Color> _grays = [
    Color(0xFF000000),
    Color(0xFF424242),
    Color(0xFF727272),
    Color(0xFFA0A0A0),
    Color(0xFFC0C0C1),
  ];

  @override
  void paint(Canvas canvas, Size size) {
    final bgPaint = Paint()..color = const Color.fromARGB(120, 255, 255, 255);
    canvas.drawRect(Offset.zero & size, bgPaint);

    for (int i = 0; i < dotCount; i++) {
      final x = points[i].dx * size.width;
      final y = points[i].dy * size.height;

      // Ya no hay Random aquí
      final paint = Paint()
        ..color = colors[i]
        ..style = PaintingStyle.fill;
      canvas.drawRect(Rect.fromLTWH(x, y, sizes[i], sizes[i]), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _Cubist extends StatelessWidget {
  final String text;
  final TextStyle? style;
  const _Cubist({required this.text, this.style});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Text(
          text,
          style: style?.copyWith(color: style?.color?.withValues(alpha: 0.2)),
        ),
        Positioned.fill(
          child: CustomPaint(painter: _CubismPainter(dotCount: 120)),
        ),
      ],
    );
  }
}

class _CubismPainter extends CustomPainter {
  final List<Offset> points;
  final List<Color> colors;
  final List<double> radius;
  final List<bool> isCircle; // true = círculo, false = cuadrado

  _CubismPainter({required int dotCount})
    : points = List.generate(
        dotCount,
        (_) => Offset(Random().nextDouble(), Random().nextDouble()),
      ),
      colors = List.generate(
        dotCount,
        (_) => _palette[Random().nextInt(_palette.length)],
      ),
      radius = List.generate(
        dotCount,
        (_) => Random().nextDouble() * 2.5 + 0.8,
      ),
      isCircle = List.generate(dotCount, (_) => Random().nextBool());

  // Paleta tuya, en static const para no crearla cada vez
  static const List<Color> _palette = [
    Color(0xFF000000),
    Color(0xFF212121),
    Color(0xFF616161),
    Color(0xFF4FADBC),
    Color(0xFFF29696),
    Color(0xFF13653F),
    Color(0xFFBDBDBD),
    Color(0xFF12c234),
    Color(0xFFC31515),
    Color(0xFFC1D357),
    Color(0xFFBE369C),
    Color(0xFF5A3062),
    Color(0xFFBB8C28),
    Color(0xFFB3D151),
  ];

  @override
  void paint(Canvas canvas, Size size) {
    // Fondo base
    final bgPaint = Paint()..color = const Color.fromARGB(80, 245, 243, 243);
    canvas.drawRect(Offset.zero & size, bgPaint);

    for (int i = 0; i < points.length; i++) {
      final offset = Offset(
        points[i].dx * size.width,
        points[i].dy * size.height,
      );
      final paint = Paint()
        ..color = colors[i].withValues(alpha: 0.7)
        ..style = PaintingStyle.fill;

      if (isCircle[i]) {
        canvas.drawCircle(offset, radius[i], paint);
      } else {
        canvas.drawRect(
          Rect.fromCenter(
            center: offset,
            width: radius[i] * 2,
            height: radius[i] * 2,
          ),
          paint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
