part of 'library_resume_builder.dart';

class SkillSelectionDialog extends StatelessWidget {
  const SkillSelectionDialog({super.key, required this.models});

  final List<LibraryModel> models;

  void showCustomDialog(BuildContext context) {
    List<String> selectedIndices = [];
    TextEditingController valueController = TextEditingController();

    showDialog(
      context: context,
      builder: (_) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.r),
          ),
          insetPadding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Container(
            height: 450.h,
            padding: EdgeInsets.symmetric(horizontal: 16.sp)
                .copyWith(top: 26.h, bottom: 16.h),
            child: StatefulBuilder(builder: (_, setState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Select Transferable Skills',
                    style:
                        context.textTheme.titleLarge?.copyWith(fontSize: 18.sp),
                  ),
                  const Text(
                      textAlign: TextAlign.center,
                      'These are the transferable skills you saved to your library. Select any to add them directly to your resume!'),
                  Expanded(
                    child: ListView.separated(
                      padding: EdgeInsets.only(top: 24.h, bottom: 12.h),
                      separatorBuilder: (context, index) =>
                          SizedBox(height: 14.h),
                      itemCount: models.length,
                      itemBuilder: (context, index) {
                        final CustomLibraryModel? model =
                            models[index].getLibraryModel;
                        bool isSelected =
                            selectedIndices.contains(model?.title);
                        return InkWell(
                          onTap: () {
                            setState(() {
                              isSelected
                                  ? selectedIndices.removeWhere((e) => e
                                      .toLowerCase()
                                      .contains(
                                          (model?.title ?? "").toLowerCase()))
                                  : selectedIndices
                                      .add(model?.title ?? 'No Value');
                            });
                          },
                          child: Container(
                            padding: EdgeInsets.only(
                                bottom: 16.h,
                                left: 16.w,
                                top: 10.h,
                                right: 10.w),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(14.r),
                              color: isSelected
                                  ? AppColors.primaryColor
                                  : AppColors.tSkillsButtonGrey,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        '${model?.title}',
                                        style: context.textTheme.titleLarge
                                            ?.copyWith(
                                          color: isSelected
                                              ? AppColors.whiteColor
                                              : AppColors.blackColor,
                                        ),
                                      ),
                                    ),
                                    Align(
                                      alignment: Alignment.topRight,
                                      child: Container(
                                        height: 18.h,
                                        width: 18.w,
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                            color: isSelected
                                                ? AppColors.whiteColor
                                                : AppColors.grey
                                                    .withOpacity(0.5),
                                            width: 2,
                                          ),
                                          shape: BoxShape.circle,
                                        ),
                                        child: Container(
                                          margin: EdgeInsets.all(2.0.sp),
                                          decoration: BoxDecoration(
                                            color: isSelected
                                                ? AppColors.whiteColor
                                                : Colors.transparent,
                                            shape: BoxShape.circle,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 5.h),
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        '${model?.description}',
                                        style: context.textTheme.titleMedium
                                            ?.copyWith(
                                          color: isSelected
                                              ? AppColors.whiteColor
                                              : AppColors.tSkillsTextGrey,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  PrimaryTextField(
                    controller: valueController,
                    hintText: 'Add New Skill',
                    suffixIcon: Icons.add,
                    onSuffixPressed: () {
                      if (valueController.text.isEmpty) {
                        return;
                      }
                      if (selectedIndices.contains(valueController.text)) {
                        // FocusScope.of(context).unfocus();
                        valueController.clear();
                        return;
                      }
                      setState(() {
                        selectedIndices.add(valueController.text);
                      });
                      // FocusScope.of(context).unfocus();
                      valueController.clear();
                    },
                  ),
                  PrimaryButton(
                      borderRadius: 6.r,
                      onPressed: () {
                        if (selectedIndices.isNotEmpty) {
                          final modal = context
                              .read<CreateResumeBloc>()
                              .state
                              .createResumeModel
                              .copyWith(
                                softSkills: selectedIndices,
                              );
                          context.read<CreateResumeBloc>().add(
                              UpdateResumeDataEvent(createResumeModel: modal));
                          context.pop();
                        } else {
                          SnackbarsType.error(
                              context, 'Please select at least one skill!');
                        }
                      },
                      text: 'Add Skills')
                ],
              );
            }),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return const Dialog();
  }
}
