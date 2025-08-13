part of 'components/library_resume_builder.dart';

class ResumeDetails extends StatelessWidget {
  const ResumeDetails(
      {super.key,
      this.isPreview = false,
      required this.model,
      required this.resumeBuilderBloc});

  final bool isPreview;
  final ResumeModel model;
  final ResumeBuilderBloc resumeBuilderBloc;

  void _showSuccessDialog(BuildContext context, bool isEdit) {
    CommonDialog(
            barrierDismissible: false,
            okBtnFunction: () {
              GoRouter.of(context).popUntil(AppRoutes.resumeBuilder);
              context.push(AppRoutes.resumeDetails, extra: {
                'isPreview': false,
                'model': model,
                'bloc': resumeBuilderBloc
              });
            },
            okBtnText: 'View Resume',
            title: 'Resume Successfully ${isEdit ? 'updated' : 'created'}',
            body:
                'Your resume has been successfully ${isEdit ? 'updated' : 'created'}. You can now review and edit it as needed. We wish you the best of luck in your job search!',
            image: AssetConstants.resumeCreatedDialog)
        .showCustomDialog(context);
  }

  @override
  Widget build(BuildContext context) {
    print('Is Edit ${model.isEdit}');
    return BlocProvider.value(
      value: resumeBuilderBloc,
      child: ScaffoldWrapper(
          child: Scaffold(
        body: SingleChildScrollView(
          child: BlocConsumer<ResumeBuilderBloc, ResumeBuilderState>(
            listener: (context, state) {
              if (state.result.status == ResultStatus.successful &&
                  state.result.event is DeleteResumeEvent) {
                context.pop();
                SnackbarsType.success(context, 'Resume Deleted Successfully!');
              } else if (state.result.status == ResultStatus.successful &&
                  state.result.event is DeleteResumeEvent) {
                SnackbarsType.error(context,
                    'Could not delete resume, Please check your internet!');
              }
              if (state.result.status == ResultStatus.successful &&
                      state.result.event is CreateResumeEvent ||
                  state.result.event is EditResumeEvent) {
                _showSuccessDialog(context, model.isEdit);
              }
              if (state.result.status == ResultStatus.successful &&
                  state.result.event is SendToSupportPeopleEvent) {
                SnackbarsType.success(
                    context, 'Resume sent to support people!');
                context.pop();
              }
              if (state.result.status == ResultStatus.successful &&
                  state.result.event is SendToEmailEvent) {
                SnackbarsType.success(context, 'Resume sent to email!');
              }
              if (state.result.status == ResultStatus.error &&
                  state.result.event is SendToSupportPeopleEvent) {
                SnackbarsType.error(context, state.result.message);
                context.pop();
              }
            },
            buildWhen: (p, n) => false,
            builder: (context, state) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  CustomAppBar(
                    onClick: () {
                      !isPreview
                          ? GoRouter.of(context)
                              .popUntil(AppRoutes.resumeBuilder)
                          : context.pop();
                    },
                    title: 'Your Personalized Resume',
                    trailingIcon: [
                      isPreview
                          ? InkWell(
                              onTap: () {
                                context.pop();
                              },
                              child: Image.asset(
                                AssetConstants.editPenIcon,
                                height: 20.h,
                                width: 20.w,
                              ),
                            )
                          : ThreeDotsMenu(
                              menuItems: const [
                                'Edit',
                                'Delete',
                                'Share',
                                'Email it to Yourself',
                                'Download Resume'
                              ],
                              menuActions: [
                                /// Edit
                                () {
                                  context.read<ResumeBuilderBloc>().add(
                                        SelectAResume(
                                          model: model,
                                        ),
                                      );
                                  context.push(AppRoutes.addResume,
                                      extra: context.read<ResumeBuilderBloc>());
                                },

                                /// Delete
                                () {
                                  CommonDialog(
                                    customDialog: DeleteDialog(
                                      onDelete: () {
                                        context.read<ResumeBuilderBloc>().add(
                                            DeleteResumeEvent(
                                                id: model.id ?? 'resumeId'));
                                        context.pop();
                                      },
                                      text: 'Delete Resume',
                                      body:
                                          'Are you sure you want to delete your resume?',
                                    ),
                                  ).showCustomDialog(context);
                                },

                                /// Support People
                                () async {
                                  CommonDialog(
                                      isSupport: true,
                                      customDialog: SupportPeopleDialog(
                                        resume: model,
                                        resumeId: model.id ?? 'No ID',
                                        bloc: context.read<ResumeBuilderBloc>(),
                                      )).showCustomDialog(context);
                                },

                                /// Send To Email
                                () async {
                                  final File? resume =
                                      await generateAndDownloadPdf(model,
                                          isEmail: true);
                                  if (resume != null) {
                                    context
                                        .read<ResumeBuilderBloc>()
                                        .add(SendToEmailEvent(resume: resume));
                                  }
                                },

                                /// Download
                                () {
                                  CommonDialog(
                                      customDialog: DownloadDialog(
                                    resumeModel: model,
                                  )).showCustomDialog(context);
                                },
                              ],
                            ),
                      SizedBox(width: 16.w),
                    ],
                  ),
                  !isPreview && state.loading
                      ? const Center(child: CircularProgressIndicator())
                      : Container(
                          margin: EdgeInsets.all(16.0.sp)
                              .copyWith(bottom: isPreview ? 90.h : null),
                          padding: EdgeInsets.all(16.0.sp),
                          decoration: BoxDecoration(
                            color: AppColors.whiteColor,
                            borderRadius: BorderRadius.circular(14.r),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ResumeHeaderSection(
                                header: '${model.fullName}',
                                sections: [
                                  ResumeSectionDetails(
                                    title: '${model.email}',
                                    subTitle: '${model.phone}',
                                  )
                                ],
                              ),
                              ResumeHeaderSection(
                                header: 'Objective',
                                sections: [
                                  ResumeSectionDetails(
                                    points: ['${model.objective?.description}'],
                                  )
                                ],
                              ),
                              if (model.education != null &&
                                  model.education!.isNotEmpty &&
                                  (model.education?[0].institution ?? "")
                                      .isNotEmpty)
                                ResumeHeaderSection(
                                  header: 'Education',
                                  sections: List.generate(
                                    model.education?.length ?? 0,
                                    (i) => ResumeSectionDetails(
                                      title:
                                          "${model.education?[i].institution}",
                                      date:
                                          "${model.education?[i].startYear} - ${model.education?[i].endYear}",
                                      points: [
                                        "${model.education?[i].degree}, ${model.education?[i].fieldOfStudy}",
                                      ],
                                    ),
                                  ),
                                ),
                              if (model.licensesAndCertifications != null &&
                                  model.licensesAndCertifications!.isNotEmpty &&
                                  (model.licensesAndCertifications?[0]
                                              .certificationName ??
                                          "")
                                      .isNotEmpty)
                                ResumeHeaderSection(
                                  header: 'Certificates',
                                  sections: List.generate(
                                      model.licensesAndCertifications?.length ??
                                          0,
                                      (i) => ResumeSectionDetails(
                                            title:
                                                '${model.licensesAndCertifications?[i].certificationName}',
                                            date:
                                                '${formatDate(model.licensesAndCertifications?[i].issueDate ?? DateTime.now())} - ${formatDate(model.licensesAndCertifications?[i].expirationDate ?? DateTime.now())}',
                                            points: [
                                              '${model.licensesAndCertifications?[i].issuingOrganization}'
                                            ],
                                          )),
                                ),
                              if (model.softSkills != null &&
                                  model.softSkills!.isNotEmpty)
                                ResumeHeaderSection(
                                    header: 'Soft Skills',
                                    sections: [
                                      ResumeSectionDetails(
                                          points: List.generate(
                                              model.softSkills?.length ?? 0,
                                              (i) =>
                                                  "${model.softSkills?[i]}")),
                                    ]),
                              if (model.technicalSkills != null &&
                                  model.technicalSkills!.isNotEmpty)
                                ResumeHeaderSection(
                                    header: 'Technical Skills',
                                    sections: [
                                      ResumeSectionDetails(
                                          points: List.generate(
                                              model.technicalSkills?.length ??
                                                  0,
                                              (i) =>
                                                  "${model.technicalSkills?[i]}")),
                                    ]),
                              ResumeHeaderSection(
                                header: 'Work  Experience',
                                sections: List.generate(
                                    model.experience?.length ?? 0,
                                    (i) => ResumeSectionDetails(
                                          title:
                                              '${model.experience?[i].company}',
                                          subTitle:
                                              '${model.experience?[i].jobTitle}',
                                          date:
                                              '${formatDate(model.experience?[i].startDate ?? DateTime.now())} - ${formatDate(model.experience?[i].endDate ?? DateTime.now())}',
                                          points: [
                                            '${model.experience?[i].description}',
                                          ],
                                        )),
                              ),
                              ResumeHeaderSection(
                                  header: 'Volunteer Service',
                                  sections: List.generate(
                                      model.volunteerExperience?.length ?? 0,
                                      (i) => ResumeSectionDetails(
                                            title:
                                                '${model.volunteerExperience?[i].organizationName}',
                                            date:
                                                '${model.volunteerExperience?[i].startYear} - ${model.volunteerExperience?[i].endYear}',
                                            points: [
                                              '${model.volunteerExperience?[i].description}'
                                            ],
                                          ))),
                              ResumeHeaderSection(
                                  showDivider: false,
                                  header: 'Honors',
                                  sections: List.generate(
                                      model.honorsAndAwards?.length ?? 0,
                                      (i) => ResumeSectionDetails(
                                            title:
                                                '${model.honorsAndAwards?[i].awardName}',
                                            date: formatDate(model
                                                    .honorsAndAwards?[i]
                                                    .dateReceived ??
                                                DateTime.now()),
                                            points: [
                                              '${model.honorsAndAwards?[i].description}'
                                            ],
                                          ))),
                            ],
                          ),
                        ),
                ],
              );
            },
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: isPreview
            ? Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0.sp)
                    .copyWith(bottom: 12.h),
                child: BlocBuilder<ResumeBuilderBloc, ResumeBuilderState>(
                  builder: (context, state) {
                    return PrimaryButton(
                        loading: state.loading,
                        onPressed: () => model.isEdit
                            ? context
                                .read<ResumeBuilderBloc>()
                                .add(EditResumeEvent(model: model))
                            : context
                                .read<ResumeBuilderBloc>()
                                .add(CreateResumeEvent(model: model)),
                        text: 'Save');
                  },
                ),
              )
            : const SizedBox.shrink(),
      )),
    );
  }
}
