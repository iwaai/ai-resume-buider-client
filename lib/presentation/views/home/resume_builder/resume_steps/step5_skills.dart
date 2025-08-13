part of '../components/library_resume_builder.dart';

class Step5Skills extends StatelessWidget {
  const Step5Skills({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreateResumeBloc, CreateResumeState>(
      builder: (context, state) {
        final libraryBloc =
            context.read<CreateResumeBloc>().resumeBuilderBloc?.libraryBloc;
        List<LibraryModel> skillList = [];
        if (libraryBloc != null) skillList = libraryBloc.state.models;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SkillsSelectionTexField(
              libraryModels: skillList ?? [],
              skillsList: state.createResumeModel.softSkills ?? [],
            ),
            const Divider(),
            StepperHeaderText(step: -1),
            TechnicalSkillsWidget(),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                InkWell(
                  onTap: () {
                    context.read<CreateResumeBloc>().add(StepDecrement());
                  },
                  child: const Text(
                    'Back',
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: AppColors.primaryColor,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
                SizedBox(height: 8.h),
                TipsWidget(
                  step: state.step,
                ),
                SizedBox(height: 8.h),
                PrimaryButton(
                  onPressed: () {
                    // if (state.createResumeModel.softSkills == null ||
                    //     state.createResumeModel.technicalSkills == null ||
                    //     state.createResumeModel.softSkills!.isEmpty ||
                    //     state.createResumeModel.technicalSkills!.isEmpty) {
                    //   SnackbarsType.error(context,
                    //       'Please add at least one soft skill and one technical skill!');
                    // } else {
                    context.read<CreateResumeBloc>().add(StepIncrement());
                    // }
                  },
                  text: 'Next',
                ),
                SizedBox(height: 8.h),
                PrimaryButton(
                  fontWeight: FontWeight.w600,
                  borderColor: AppColors.stepsNonSelectedColor,
                  buttonColor: Colors.transparent,
                  textColor: AppColors.blackColor,
                  onPressed: () {
                    final model = state.createResumeModel
                        .copyWith(softSkills: [], technicalSkills: []);
                    context
                        .read<CreateResumeBloc>()
                        .add(UpdateResumeDataEvent(createResumeModel: model));
                    context.read<CreateResumeBloc>().add(StepIncrement());
                  },
                  text: 'Skip',
                ),
                SizedBox(height: 10.h),
              ],
            ),
          ],
        );
      },
    );
  }
}
