part of '../components/library_resume_builder.dart';

class Step2Objective extends StatelessWidget {
  Step2Objective({super.key});

  TextEditingController objective = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreateResumeBloc, CreateResumeState>(
      builder: (context, state) {
        final createResumeModel = state.createResumeModel;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Keep It Short and Focused',
              style: context.textTheme.titleLarge,
            ),
            const Text(
                'Your resume objective should be brief—about 1-2 sentences long. It should clearly state what position you’re aiming for and how you can add value to the company.'),
            SizedBox(height: 10.h),
            PrimaryTextField(
              characterLimit: 300,
              validator: (value) => validateFieldName(value, 'Objective'),
              controller: objective = TextEditingController(
                  text: createResumeModel.objective?.description),
              hintText:
                  'e.g. seeking a marketing coordinator position where I can apply my content creation and social media skills to drive brand growth and engagement.',
              maxLines: 7,
            ),
            TextButton(
              onPressed: () {
                context.read<CreateResumeBloc>().add(StepDecrement());
              },
              child: const Text(
                'Back',
                style: TextStyle(
                  color: AppColors.primaryColor,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
            TipsWidget(
              step: state.step,
            ),
            SizedBox(height: 8.h),
            PrimaryButton(
              onPressed: () {
                if (objective.text.isEmpty) {
                  SnackbarsType.error(context, 'Please fill required fields!');
                } else {
                  context.read<CreateResumeBloc>().add(StepIncrement());
                  final model = createResumeModel.copyWith(
                      objective: Objective(description: objective.text));
                  context
                      .read<CreateResumeBloc>()
                      .add(UpdateResumeDataEvent(createResumeModel: model));
                }
              },
              text: 'Next',
            ),
          ],
        );
      },
    );
  }
}
