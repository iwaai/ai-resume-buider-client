part of 'components/library_resume_builder.dart';

class AddResume extends StatelessWidget {
  AddResume({super.key});

  Widget widgetRenderer(int step, ResumeBuilderBloc resumeBuilderBloc) {
    switch (step) {
      case 1:
        return Step1Information();
      case 2:
        return Step2Objective();
      case 3:
        return const Step3Education();
      case 4:
        return const Step4Licences();
      case 5:
        return const Step5Skills();
      case 6:
        return const Step6Experience();
      case 7:
        return const Step7Volunteer();
      case 8:
        return Step8Honors(
          resumeBuilderBloc: resumeBuilderBloc,
        );
      default:
        return const SizedBox.shrink();
    }
  }

  final ScrollController _scrollController = ScrollController();

  void triggerScrollToTop() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        0.0,
        duration: const Duration(milliseconds: 0), // Smooth animation
        curve: Curves.easeOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final resumeBuilderBloc =
        GoRouterState.of(context).extra as ResumeBuilderBloc;
    return BlocProvider(
      create: (context) =>
          CreateResumeBloc(resumeBuilderBloc: resumeBuilderBloc)
            ..add(FillDataForEditEvent(model: resumeBuilderBloc.state.model)),
      child: BlocBuilder<CreateResumeBloc, CreateResumeState>(
        buildWhen: (p, n) => p.step != n.step,
        builder: (context, state) {
          // triggerScrollToTop();
          debugPrint('Parent Called:');
          return ScaffoldWrapper(
            child: Scaffold(
              appBar: PreferredSize(
                  preferredSize: const Size(0, 50),
                  child: CustomAppBar(
                    onClick: () {
                      context.pop();
                    },
                    title: 'Create Resume',
                  )),
              body: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0.w),
                child: CustomScrollView(
                  controller: _scrollController,
                  slivers: [
                    SliverFillRemaining(
                      hasScrollBody: false,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Steppers(selectedStep: state.step),
                          SizedBox(height: 16.h),
                          StepperHeaderText(step: state.step),
                          widgetRenderer(state.step, resumeBuilderBloc),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
