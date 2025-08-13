part of 'library_transferable_skills.dart';

class SkillText extends StatelessWidget {
  const SkillText({
    super.key,
    required this.skillName,
    this.fontSize,
    this.fontWeight,
    this.color,
  });

  final String skillName;
  final double? fontSize;
  final FontWeight? fontWeight;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Text(
      overflow: TextOverflow.ellipsis,
      textAlign: TextAlign.center,
      skillName,
      style: TextStyle(
          color: color ?? Colors.white,
          fontSize: fontSize ?? 7.5,
          fontWeight: fontWeight ?? FontWeight.bold),
    );
  }
}
