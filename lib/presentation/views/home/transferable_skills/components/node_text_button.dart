part of 'library_transferable_skills.dart';

class GreenNode extends StatelessWidget {
  const GreenNode({
    super.key,
    required this.alignment,
    required this.text,
    required this.margin,
    required this.onNodePress,
    this.model,
  });

  final AlignmentGeometry alignment;
  final String text;
  final EdgeInsetsGeometry margin;
  final Function(TapUpDetails) onNodePress;
  final dynamic model;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: alignment,
      child: GestureDetector(
        onTapUp: onNodePress,
        child: Container(
          margin: margin,
          alignment: Alignment.center,
          height: 45,
          width: 45,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            // border: Border.all(color: Colors.red),
          ),
          child: Container(
            alignment: Alignment.center,
            height: 22,
            width: 22,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              // border: Border.all(color: Colors.blue),
            ),
            child: SkillText(
              color: AppColors.primaryColor,
              skillName:
                  text == 'Null' ? '- - - -' : text.replaceAll(' ', '\n'),
              fontSize: 5.0,
            ),
          ),
        ),
      ),
    );
  }
}
