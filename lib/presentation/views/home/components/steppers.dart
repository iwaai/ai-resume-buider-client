part of '../resume_builder/components/library_resume_builder.dart';

class Steppers extends StatelessWidget {
  Steppers(
      {super.key, required this.selectedStep, this.isAwardsScreen = false});

  final num selectedStep;
  final bool isAwardsScreen;

  late final List<num> stepValues;
  late final List<String> stepLabels;

  // Cache the step values and labels
  void getStepValues() {
    if (!isAwardsScreen) {
      if (selectedStep < 4) {
        stepValues = [1, 2, 3];
        stepLabels = [
          'Information',
          'Objective',
          'Education',
        ];
      } else if (selectedStep < 6) {
        stepValues = [4, 5, 6];
        stepLabels = [
          '  Licenses',
          'Skills',
          'Work Experience',
        ];
      } else if (selectedStep < 9) {
        stepValues = [6, 7, 8];
        stepLabels = [
          'Work Experience',
          'Volunteer',
          'Honors   ',
        ];
      }
    } else {
      if (selectedStep < 4) {
        stepValues = [1, 2, 3];
        stepLabels = [
          '   Rookie',
          'Game Time',
          'MVP    ',
        ];
      } else if (selectedStep < 7) {
        stepValues = [3, 4, 5];
        stepLabels = [
          '     MVP',
          'Career Champion',
          'Hall of Fame',
        ];
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Get the step values only once
    getStepValues();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.0.w),
          child: Row(
            children: [
              _buildStepperBox(1),
              _buildStepperLine(1),
              _buildStepperBox(2),
              _buildStepperLine(2),
              _buildStepperBox(3),
            ],
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(
            3,
            (i) => _buildTextLabel(i),
          ),
        ),
      ],
    );
  }

  Widget _buildStepperBox(int stepPosition) {
    num step = stepValues[stepPosition - 1];
    Color boxColor = selectedStep == step
        ? AppColors.secondaryColor
        : selectedStep > step
            ? AppColors.primaryColor
            : AppColors.stepsNonSelectedColor;

    Color textColor =
        selectedStep == step ? AppColors.primaryColor : AppColors.whiteColor;

    return StepperBox(
      boxColor: boxColor,
      step: step,
      textColor: textColor,
    );
  }

  Widget _buildStepperLine(int stepPosition) {
    return StepperLine(
      value: selectedStep > stepValues[stepPosition - 1] ? 1 : 0,
    );
  }

  Widget _buildTextLabel(int i) {
    final step = stepValues[i];
    AlignmentGeometry alignment = Alignment.center;

    if (i == 0) {
      alignment = Alignment.centerLeft;
    } else if (i == 2) {
      alignment = Alignment.centerRight;
    }

    return Expanded(
      child: Container(
        margin: EdgeInsets.only(top: 8.h),
        padding: stepLabels[i] == 'Skills'
            ? EdgeInsets.symmetric(horizontal: 16.w)
            : null,
        alignment: alignment,
        child: AnimatedDefaultTextStyle(
          duration: const Duration(seconds: 1),
          style: TextStyle(
            fontWeight: FontWeight.w500,
            color: selectedStep > step - 1
                ? AppColors.stepsSelectedColor
                : AppColors.blackColor,
          ),
          child: Text(stepLabels[i]),
        ),
      ),
    );
  }
}
