part of 'library_resume_builder.dart';

class StepperLine extends StatelessWidget {
  const StepperLine({
    super.key,
    required this.value,
  });

  final double value;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: TweenAnimationBuilder(
        tween: Tween<double>(begin: 0, end: value),
        duration: const Duration(seconds: 1), // Duration for smooth transition
        curve: Curves.easeInOut, // Animation curve for smooth transition
        builder: (context, double animatedValue, child) {
          return LinearProgressIndicator(
            backgroundColor: AppColors.stepsNonSelectedColor,
            minHeight: 1.5.h,
            color: AppColors.primaryColor,
            value: animatedValue,
          );
        },
      ),
    );
  }
}
