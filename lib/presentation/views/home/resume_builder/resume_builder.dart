part of 'components/library_resume_builder.dart';

class ResumeBuilder extends StatefulWidget {
  const ResumeBuilder({super.key});

  @override
  State<ResumeBuilder> createState() => _ResumeBuilderState();
}

class _ResumeBuilderState extends State<ResumeBuilder> {
  @override
  void initState() {
    super.initState();
    const InitialDialogRenderer(screen: AppRoutes.resumeBuilder)
        .showInitialDialog(context);
  }

  String formatDateString(String dateStr) {
    DateTime dateTime = DateTime.parse(dateStr);
    var formatter = DateFormat('MMM dd, yyyy');
    return formatter.format(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    final libBloc = GoRouterState.of(context).extra as MyLibraryBloc;
    return BlocProvider(
      create: (context) {
        return ResumeBuilderBloc(libraryBloc: libBloc..add(GetDataEvent()))
          ..add(GetMyResumeEvent());
      },
      child: ScaffoldWrapper(
          child: Scaffold(
        appBar: const CustomAppBar(title: 'My Resume'),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Builder(builder: (context) {
                return InkWell(
                  onTap: () => context.push(
                    AppRoutes.addResume,
                    extra: context.read<ResumeBuilderBloc>()
                      ..add(SelectAResume(model: ResumeModel.initial())),
                  ),
                  child: Text('Create New Resume',
                      style: context.textTheme.labelLarge?.copyWith(
                          fontWeight: FontWeight.w600, letterSpacing: 0)),
                );
              }),
              BlocConsumer<ResumeBuilderBloc, ResumeBuilderState>(
                listener: (context, state) {
                  if ((state.result.event is GetMyResumeEvent ||
                          state.result.event is CreateResumeEvent ||
                          state.result.event is SendToEmailEvent ||
                          state.result.event is SendToSupportPeopleEvent ||
                          state.result.event is DeleteResumeEvent) &&
                      state.result.status == ResultStatus.error &&
                      state.result.message
                          .contains(Constant.accessDeniedMessage)) {
                    SnackbarsType.error(context, state.result.message);
                    context.pushReplacement(AppRoutes.homeScreen);
                  }
                  if (state.result.status == ResultStatus.successful &&
                      state.result.event is DeleteResumeEvent) {
                    // context.pop();
                    SnackbarsType.success(
                        context, 'Resume Deleted Successfully!');
                  } else if (state.result.status == ResultStatus.error &&
                      state.result.event is DeleteResumeEvent) {
                    SnackbarsType.error(context,
                        'Could not delete resume, Please check your internet');
                  }
                },
                builder: (context, state) {
                  final model = state.models;
                  return Expanded(
                    child: state.loading
                        ? const Center(
                            child: CircularProgressIndicator(
                              color: AppColors.secondaryColor,
                            ),
                          )
                        : state.loading == false && state.models.isEmpty
                            ? const Center(
                                child: Text(
                                  'The Resume Builder will prompt you with questions to build your resume. All you have to do is answer the questions that the resume builder will format your resume for you.',
                                  textAlign: TextAlign.center,
                                ),
                              )
                            : GridView.builder(
                                padding: EdgeInsets.only(top: 18.h),
                                itemCount: model.length,
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  crossAxisSpacing: 8.0.w,
                                  mainAxisSpacing: 10.0.h,
                                  childAspectRatio: .60.sp,
                                ),
                                itemBuilder: (context, index) {
                                  return InkWell(
                                    onTap: () => {
                                      context.read<ResumeBuilderBloc>().add(
                                          SelectAResume(
                                              model: state.models[index])),
                                      context.push(AppRoutes.resumeDetails,
                                          extra: {
                                            'isPreview': false,
                                            'model': model[index],
                                            'bloc': context
                                                .read<ResumeBuilderBloc>()
                                          })
                                    },
                                    child: Container(
                                      padding: EdgeInsets.all(12.sp),
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(12.r),
                                          color: AppColors.resumeBoxColor),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.end,
                                            children: [
                                              Expanded(
                                                child: Text(
                                                  formatDateString(model[index]
                                                      .createdAt
                                                      .toString()),
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: context
                                                      .textTheme.titleMedium,
                                                ),
                                              ),
                                              ThreeDotsMenu(
                                                menuItems: const [
                                                  'Edit',
                                                  'Delete'
                                                ],
                                                menuActions: [
                                                  () {
                                                    context
                                                        .read<
                                                            ResumeBuilderBloc>()
                                                        .add(
                                                          SelectAResume(
                                                            model: state
                                                                .models[index],
                                                          ),
                                                        );
                                                    context.push(
                                                        AppRoutes.addResume,
                                                        extra: context.read<
                                                            ResumeBuilderBloc>());
                                                  },
                                                  () {
                                                    CommonDialog(
                                                      customDialog:
                                                          DeleteDialog(
                                                        onDelete: () {
                                                          context
                                                              .read<
                                                                  ResumeBuilderBloc>()
                                                              .add(DeleteResumeEvent(
                                                                  id: model[index]
                                                                          .id ??
                                                                      'resumeId'));
                                                          context.pop();
                                                        },
                                                        text: 'Delete Resume',
                                                        body:
                                                            'Are you sure you want to delete your resume?',
                                                      ),
                                                    ).showCustomDialog(context);
                                                  }
                                                ],
                                              )
                                            ],
                                          ),
                                          SizedBox(height: 10.h),
                                          Expanded(
                                            child: Container(
                                              decoration: const BoxDecoration(
                                                image: DecorationImage(
                                                    fit: BoxFit.fill,
                                                    image: AssetImage(
                                                        AssetConstants
                                                            .dummyResumeTemplate)),
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                  );
                },
              )
            ],
          ),
        ),
      )),
    );
  }
}
