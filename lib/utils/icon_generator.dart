import 'dart:ui' as ui;
import 'dart:typed_data';
import 'package:flutter/material.dart';

class IconGenerator {
  static Future<Uint8List> generateAppIcon() async {
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);
    const size = 512.0;

    // 绘制LifeFlow图标
    _drawLifeFlowIcon(canvas, Size(size, size));

    final picture = recorder.endRecording();
    final image = await picture.toImage(size.toInt(), size.toInt());
    final byteData = await image.toByteData(format: ui.ImageByteFormat.png);

    return byteData!.buffer.asUint8List();
  }

  static void _drawLifeFlowIcon(Canvas canvas, Size size) {
    final paint = Paint();
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width * 0.4;

    // 背景渐变
    final gradient = RadialGradient(
      colors: [
        const Color(0xFF6B73FF),
        const Color(0xFF9B59B6),
      ],
      stops: const [0.0, 1.0],
    );

    paint.shader = gradient.createShader(
      Rect.fromCircle(center: center, radius: radius),
    );

    // 绘制圆形背景
    canvas.drawCircle(center, radius, paint);

    // 绘制内部图案 - 代表生活和流程
    paint.shader = null;
    paint.color = Colors.white;
    paint.style = PaintingStyle.fill;

    // 绘制L字母
    final textPainter = TextPainter(
      text: TextSpan(
        text: 'L',
        style: TextStyle(
          fontSize: radius * 0.8,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      textDirection: TextDirection.ltr,
    );

    textPainter.layout();
    textPainter.paint(
      canvas,
      Offset(
        center.dx - textPainter.width / 2,
        center.dy - textPainter.height / 2,
      ),
    );

    // 添加装饰性圆点表示流程
    paint.color = Colors.white.withValues(alpha: 0.7);
    for (int i = 0; i < 4; i++) {
      final angle = (i * 90) * (3.14159 / 180);
      final dotCenter = Offset(
        center.dx + (radius * 0.6) * (angle.isNaN ? 0 : (angle / (3.14159 / 2)).round()),
        center.dy + (radius * 0.6) * (angle.isNaN ? 0 : (angle / (3.14159 / 2)).round()),
      );
      canvas.drawCircle(dotCenter, 4, paint);
    }
  }
}

// 使用示例:
/*
Future<void> saveIcon() async {
  final iconData = await IconGenerator.generateAppIcon();
  final file = File('assets/icons/app_icon.png');
  await file.writeAsBytes(iconData);
}
*/