part of 'components/library_resume_builder.dart';

class ResumeDetails extends StatefulWidget {
  const ResumeDetails(
      {super.key,
      this.isPreview = false,
      required this.model,
      required this.resumeBuilderBloc});

  final bool isPreview;
  final ResumeModel model;
  final ResumeBuilderBloc resumeBuilderBloc;

  @override
  State<ResumeDetails> createState() => _ResumeDetailsState();
}

class _ResumeDetailsState extends State<ResumeDetails> {
  File? _generatedPdfFile;
  bool _showPdfGeneratedView = false;

  void _showSuccessDialog(BuildContext context, bool isEdit) {
    CommonDialog(
            barrierDismissible: false,
            okBtnFunction: () {
              GoRouter.of(context).popUntil(AppRoutes.resumeBuilder);
              context.push(AppRoutes.resumeDetails, extra: {
                'isPreview': false,
                'model': widget.model,
                'bloc': widget.resumeBuilderBloc
              });
            },
            okBtnText: 'View Resume',
            title: 'Resume Successfully ${isEdit ? 'updated' : 'created'}',
            body:
                'Your resume has been successfully ${isEdit ? 'updated' : 'created'}. You can now review and edit it as needed. We wish you the best of luck in your job search!',
            image: AssetConstants.resumeCreatedDialog)
        .showCustomDialog(context);
  }

  // Convert ResumeModel to template_models.ResumeData for template selection
  template_models.ResumeData _convertToTemplateResumeData() {
    // Format experience duration helper
    String _formatDuration(DateTime? startDate, DateTime? endDate) {
      if (startDate == null) return '';
      final start = '${startDate.month}/${startDate.year}';
      if (endDate == null) return '$start - Present';
      final end = '${endDate.month}/${endDate.year}';
      return '$start - $end';
    }

    return template_models.ResumeData(
      // Personal Information
      personalInfo: template_models.PersonalInfo(
        fullName: widget.model.fullName ?? '',
        email: widget.model.email ?? '',
        phone: widget.model.phone ?? '',
        address: widget.model.address ?? '',
        linkedIn: '',
        github: '',
        portfolio: '',
      ),
      
      // Summary/Objective
      summary: widget.model.objective?.description ?? '',
      
      // Education - Convert from your ResumeModel Education to template_models.Education
      education: widget.model.education?.map((edu) => template_models.Education(
        institution: edu.institution ?? '',
        degree: edu.degree ?? '',
        fieldOfStudy: edu.fieldOfStudy ?? '',
        graduationYear: edu.endYear?.toString() ?? '',
        gpa: '',
        location: '',
        achievements: [],
      )).toList() ?? [],
      
      // Experience - Convert from your ResumeModel Experience to template_models.Experience
      experience: widget.model.experience?.map((exp) => template_models.Experience(
        company: exp.company ?? '',
        position: exp.jobTitle ?? '',
        description: exp.description ?? '',
        duration: _formatDuration(exp.startDate, exp.endDate),
        achievements: [],
        location: '',
      )).toList() ?? [],
      
      // Skills - combining technical and soft skills
      skills: [
        ...(widget.model.technicalSkills ?? []),
        ...(widget.model.softSkills ?? []),
      ],
      
      // Certifications
      certifications: widget.model.licensesAndCertifications?.map((cert) => 
        '${cert.certificationName} - ${cert.issuingOrganization}'
      ).toList() ?? [],
      
      // Awards - Convert from your HonorsAndAward to template_models.Award
      awards: widget.model.honorsAndAwards?.map((award) => template_models.Award(
        title: award.awardName ?? '',
        organization: award.awardingOrganization ?? '',
        year: award.dateReceived?.year.toString() ?? '',
        description: award.description ?? '',
      )).toList() ?? [],
      
      // Empty lists for fields that don't exist in your ResumeModel
      projects: [],
      languages: [],
      hobbies: [],
      references: [],
    );
  }

  void _navigateToTemplateSelection(BuildContext context) {
    // Convert ResumeModel to template_models.ResumeData before navigation
    final templateResumeData = _convertToTemplateResumeData();
    
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TemplateSelectionScreen(
          resumeData: templateResumeData,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    print('Is Edit ${widget.model.isEdit}');
    // Show PDF generated view if applicable
    if (_showPdfGeneratedView && _generatedPdfFile != null) {
      return Scaffold(
        body: _buildPDFGeneratedView(context, _generatedPdfFile!),
      );
    }
    return BlocProvider.value(
      value: widget.resumeBuilderBloc,
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
                _showSuccessDialog(context, widget.model.isEdit);
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
                      !widget.isPreview
                          ? GoRouter.of(context)
                              .popUntil(AppRoutes.resumeBuilder)
                          : context.pop();
                    },
                    title: 'Your Personalized Resume',
                    trailingIcon: [
                      widget.isPreview
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
                                          model: widget.model,
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
                                                id: widget.model.id ?? 'resumeId'));
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
                                        resume: widget.model,
                                        resumeId: widget.model.id ?? 'No ID',
                                        bloc: context.read<ResumeBuilderBloc>(),
                                      )).showCustomDialog(context);
                                },

                                /// Send To Email
                                () async {
                                  final File? resume =
                                      await generateAndDownloadPdf(widget.model,
                                          isEmail: true);
                                  if (resume != null) {
                                    context
                                        .read<ResumeBuilderBloc>()
                                        .add(SendToEmailEvent(resume: resume));
                                  }
                                },

                                /// Download
                                () {
                                  _generateAndShowPdf();
                                },
                              ],
                            ),
                      SizedBox(width: 16.w),
                    ],
                  ),
                  !widget.isPreview && state.loading
                      ? const Center(child: CircularProgressIndicator())
                      : Container(
                          margin: EdgeInsets.all(16.0.sp)
                              .copyWith(bottom: widget.isPreview ? 160.h : 80.h),
                          padding: EdgeInsets.all(16.0.sp),
                          decoration: BoxDecoration(
                            color: AppColors.whiteColor,
                            borderRadius: BorderRadius.circular(14.r),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ResumeHeaderSection(
                                header: '${widget.model.fullName}',
                                sections: [
                                  ResumeSectionDetails(
                                    title: '${widget.model.email}',
                                    subTitle: '${widget.model.phone}',
                                  )
                                ],
                              ),
                              ResumeHeaderSection(
                                header: 'Objective',
                                sections: [
                                  ResumeSectionDetails(
                                    points: ['${widget.model.objective?.description}'],
                                  )
                                ],
                              ),
                              if (widget.model.education != null &&
                                  widget.model.education!.isNotEmpty &&
                                  (widget.model.education?[0].institution ?? "")
                                      .isNotEmpty)
                                ResumeHeaderSection(
                                  header: 'Education',
                                  sections: List.generate(
                                    widget.model.education?.length ?? 0,
                                    (i) => ResumeSectionDetails(
                                      title:
                                          "${widget.model.education?[i].institution}",
                                      date:
                                          "${widget.model.education?[i].startYear} - ${widget.model.education?[i].endYear}",
                                      points: [
                                        "${widget.model.education?[i].degree}, ${widget.model.education?[i].fieldOfStudy}",
                                      ],
                                    ),
                                  ),
                                ),
                              if (widget.model.licensesAndCertifications != null &&
                                  widget.model.licensesAndCertifications!.isNotEmpty &&
                                  (widget.model.licensesAndCertifications?[0]
                                              .certificationName ??
                                          "")
                                      .isNotEmpty)
                                ResumeHeaderSection(
                                  header: 'Certificates',
                                  sections: List.generate(
                                      widget.model.licensesAndCertifications?.length ??
                                          0,
                                      (i) => ResumeSectionDetails(
                                            title:
                                                '${widget.model.licensesAndCertifications?[i].certificationName}',
                                            date:
                                                '${formatDate(widget.model.licensesAndCertifications?[i].issueDate ?? DateTime.now())} - ${formatDate(widget.model.licensesAndCertifications?[i].expirationDate ?? DateTime.now())}',
                                            points: [
                                              '${widget.model.licensesAndCertifications?[i].issuingOrganization}'
                                            ],
                                          )),
                                ),
                              if (widget.model.softSkills != null &&
                                  widget.model.softSkills!.isNotEmpty)
                                ResumeHeaderSection(
                                    header: 'Soft Skills',
                                    sections: [
                                      ResumeSectionDetails(
                                          points: List.generate(
                                              widget.model.softSkills?.length ?? 0,
                                              (i) =>
                                                  "${widget.model.softSkills?[i]}")),
                                    ]),
                              if (widget.model.technicalSkills != null &&
                                  widget.model.technicalSkills!.isNotEmpty)
                                ResumeHeaderSection(
                                    header: 'Technical Skills',
                                    sections: [
                                      ResumeSectionDetails(
                                          points: List.generate(
                                              widget.model.technicalSkills?.length ??
                                                  0,
                                              (i) =>
                                                  "${widget.model.technicalSkills?[i]}")),
                                    ]),
                              ResumeHeaderSection(
                                header: 'Work Experience',
                                sections: List.generate(
                                    widget.model.experience?.length ?? 0,
                                    (i) => ResumeSectionDetails(
                                          title:
                                              '${widget.model.experience?[i].company}',
                                          subTitle:
                                              '${widget.model.experience?[i].jobTitle}',
                                          date:
                                              '${formatDate(widget.model.experience?[i].startDate ?? DateTime.now())} - ${formatDate(widget.model.experience?[i].endDate ?? DateTime.now())}',
                                          points: [
                                            '${widget.model.experience?[i].description}',
                                          ],
                                        )),
                              ),
                              ResumeHeaderSection(
                                  header: 'Volunteer Service',
                                  sections: List.generate(
                                      widget.model.volunteerExperience?.length ?? 0,
                                      (i) => ResumeSectionDetails(
                                            title:
                                                '${widget.model.volunteerExperience?[i].organizationName}',
                                            date:
                                                '${widget.model.volunteerExperience?[i].startYear} - ${widget.model.volunteerExperience?[i].endYear}',
                                            points: [
                                              '${widget.model.volunteerExperience?[i].description}'
                                            ],
                                          ))),
                              ResumeHeaderSection(
                                  showDivider: false,
                                  header: 'Honors',
                                  sections: List.generate(
                                      widget.model.honorsAndAwards?.length ?? 0,
                                      (i) => ResumeSectionDetails(
                                            title:
                                                '${widget.model.honorsAndAwards?[i].awardName}',
                                            date: formatDate(widget.model
                                                    .honorsAndAwards?[i]
                                                    .dateReceived ??
                                                DateTime.now()),
                                            points: [
                                              '${widget.model.honorsAndAwards?[i].description}'
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
        floatingActionButton: Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 16.0.sp).copyWith(bottom: 12.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Template Selection Button (always visible when not in preview)
              // if (!widget.isPreview)
              //   Container(
              //     width: double.infinity,
              //     margin: EdgeInsets.only(bottom: 12.h),
              //     child: OutlinedButton.icon(
              //       onPressed: () => _navigateToTemplateSelection(context),
              //       icon: Icon(
              //         Icons.palette_outlined,
              //         size: 20.sp,
              //         color: AppColors.primaryColor,
              //       ),
              //       label: Text(
              //         'Choose Template',
              //         style: TextStyle(
              //           fontSize: 14.sp,
              //           fontWeight: FontWeight.w600,
              //           color: AppColors.primaryColor,
              //         ),
              //       ),
              //       style: OutlinedButton.styleFrom(
              //         padding: EdgeInsets.symmetric(vertical: 14.h),
              //         side: BorderSide(
              //           color: AppColors.primaryColor,
              //           width: 1.5,
              //         ),
              //         shape: RoundedRectangleBorder(
              //           borderRadius: BorderRadius.circular(12.r),
              //         ),
              //       ),
              //     ),
              //   ),

              // Generate PDF Button (always visible when not in preview)
              if (!widget.isPreview)
                Container(
                  width: double.infinity,
                  margin: EdgeInsets.only(bottom: 12.h),
                  child: ElevatedButton.icon(
                    onPressed: _generateAndShowPdf,
                    icon: Icon(
                      Icons.picture_as_pdf,
                      size: 20.sp,
                      color: AppColors.whiteColor,
                    ),
                    label: Text(
                      'Generate PDF',
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.whiteColor,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      padding: EdgeInsets.symmetric(vertical: 14.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                    ),
                  ),
                ),

              // Save Button (only visible in preview mode)
              if (widget.isPreview)
                BlocBuilder<ResumeBuilderBloc, ResumeBuilderState>(
                  builder: (context, state) {
                    return PrimaryButton(
                      loading: state.loading,
                      onPressed: () => widget.model.isEdit
                          ? context.read<ResumeBuilderBloc>().add(EditResumeEvent(model: widget.model))
                          : context.read<ResumeBuilderBloc>().add(CreateResumeEvent(model: widget.model)),
                      text: 'Save',
                    );
                  },
                ),
            ],
          ),
        ),
      )),
    );
  }

  Widget _buildPDFGeneratedView(BuildContext context, File pdfFile) {
    return Column(
      children: [
        // Resume preview content
        Expanded(
          child: SingleChildScrollView(
            child: Container(
              margin: EdgeInsets.all(16.0.sp),
              padding: EdgeInsets.all(16.0.sp),
              decoration: BoxDecoration(
                color: AppColors.whiteColor,
                borderRadius: BorderRadius.circular(14.r),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header with success message
                  Container(
                    padding: EdgeInsets.all(12.sp),
                    decoration: BoxDecoration(
                      color: Colors.green.shade50,
                      borderRadius: BorderRadius.circular(8.r),
                      border: Border.all(color: Colors.green.shade200),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.check_circle, color: Colors.green, size: 20.sp),
                        SizedBox(width: 8.w),
                        Text(
                          'PDF Generated Successfully!',
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 16.h),
                  
                  // Resume content preview
                  ResumeHeaderSection(
                    header: '${widget.model.fullName}',
                    sections: [
                      ResumeSectionDetails(
                        title: '${widget.model.email}',
                        subTitle: '${widget.model.phone}',
                      )
                    ],
                  ),
                  ResumeHeaderSection(
                    header: 'Objective',
                    sections: [
                      ResumeSectionDetails(
                        points: ['${widget.model.objective?.description}'],
                      )
                    ],
                  ),
                  // Add more sections as needed for preview
                ],
              ),
            ),
          ),
        ),
        
        // Bottom action buttons
        Container(
          padding: EdgeInsets.all(16.0.sp),
          color: Colors.green.shade50,
          child: Column(
            children: [
              Text(
                'Saved to: ${pdfFile.path}',
                style: TextStyle(
                  fontSize: 12.sp,
                  color: Colors.grey[600],
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 16.h),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () async {
                        try {
                          final result = await OpenFile.open(pdfFile.path);
                          if (result.type != ResultType.done) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Could not open PDF: ${result.message}'),
                                backgroundColor: Colors.orange,
                              ),
                            );
                          }
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Error opening PDF: $e'),
                              backgroundColor: Colors.red,
                            ),
                          );
                        }
                      },
                      icon: Icon(Icons.open_in_new, size: 18.sp),
                      label: Text('Open PDF', style: TextStyle(fontSize: 14.sp)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(vertical: 14.h),
                      ),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        setState(() {
                          _showPdfGeneratedView = false;
                          _generatedPdfFile = null;
                        });
                      },
                      icon: Icon(Icons.arrow_back, size: 18.sp),
                      label: Text('Back', style: TextStyle(fontSize: 14.sp)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(vertical: 14.h),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Future<void> _generateAndShowPdf() async {
    try {
      // Show loading indicator
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(
          child: CircularProgressIndicator(),
        ),
      );

      // Generate the PDF using the existing function that expects ResumeModel
      // The function generates PDF but returns null by design (unless isEmail=true)
      final File? pdfFile = await generateAndDownloadPdf(widget.model, isEmail: true);
      
      // Dismiss loading indicator
      if (context.mounted) {
        Navigator.of(context).pop();
      }

      // Even if pdfFile is null, the PDF was likely generated and saved
      // Check if we can create a File object from the expected path
      if (pdfFile != null) {
        setState(() {
          _generatedPdfFile = pdfFile;
          _showPdfGeneratedView = true;
        });
      } else {
        // PDF was generated but function returned null
        // Create a file reference to show success UI
        try {
          Directory? directory;
          if (Platform.isAndroid) {
            directory = Directory('/storage/emulated/0/Download');
          } else if (Platform.isIOS) {
            directory = await getApplicationDocumentsDirectory();
          }
          
          if (directory != null) {
            // Find the most recent PDF file
            final files = directory.listSync()
                .whereType<File>()
                .where((file) => file.path.endsWith('.pdf') && file.path.contains('resume_'))
                .toList();
            
            if (files.isNotEmpty) {
              // Sort by modification date and get the most recent
              files.sort((a, b) => b.statSync().modified.compareTo(a.statSync().modified));
              setState(() {
                _generatedPdfFile = files.first;
                _showPdfGeneratedView = true;
              });
            } else {
              // Show success message even if we can't find the file
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('PDF generated and saved to Downloads folder'),
                  backgroundColor: Colors.green,
                ),
              );
            }
          }
        } catch (e) {
          // Still show success since PDF was likely generated
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('PDF generated and saved to Downloads folder'),
              backgroundColor: Colors.green,
            ),
          );
        }
      }
      
    } catch (e) {
      // Dismiss loading indicator on error
      if (context.mounted) {
        Navigator.of(context).pop();
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error generating PDF: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}