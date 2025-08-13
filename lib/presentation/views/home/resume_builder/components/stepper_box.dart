part of 'library_resume_builder.dart';

class StepperBox extends StatelessWidget {
  const StepperBox({
    super.key,
    required this.step,
    required this.boxColor,
    required this.textColor,
  });

  final num step;
  final Color boxColor;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(seconds: 1),
      curve: Curves.easeInOut,
      alignment: Alignment.center,
      height: 46.h,
      width: 46.w,
      decoration: BoxDecoration(color: boxColor, shape: BoxShape.circle),
      child: Text(
        step.toString(),
        style: TextStyle(
            fontWeight: FontWeight.w600, fontSize: 16.sp, color: textColor),
      ),
    );
  }
}
