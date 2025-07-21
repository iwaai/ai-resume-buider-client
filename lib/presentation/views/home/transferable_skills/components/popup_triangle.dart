part of 'library_transferable_skills.dart';

class CustomTriangle extends CustomPainter {
  const CustomTriangle();

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.skillPopupColor
      ..style = PaintingStyle.fill;

    canvas.drawPath(getTrianglePath(size.width, size.height), paint);
  }

  Path getTrianglePath(double x, double y) {
    return Path()
      ..moveTo(0, y)
      ..lineTo(x / 2, 0)
      ..lineTo(x, y)
      ..close();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
