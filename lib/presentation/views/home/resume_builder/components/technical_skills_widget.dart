part of 'library_resume_builder.dart';

class TechnicalSkillsWidget extends StatelessWidget {
  TechnicalSkillsWidget({super.key});

  final OutlineInputBorder outlineInputBorder = OutlineInputBorder(
    borderRadius: BorderRadius.circular(10.r),
  );

  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreateResumeBloc, CreateResumeState>(
      builder: (context, state) {
        List<String> skillList = state.createResumeModel.technicalSkills ?? [];
        return Padding(
          padding: EdgeInsets.only(bottom: 10.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _controller,
                decoration: InputDecoration(
                  hintText: 'Add Technical Skills',
                  suffixIcon: InkWell(
                    onTap: () {
                      if (_controller.text.isNotEmpty) {
                        final skill = _controller.text.trim();
                        if (skillList.length < 10) {
                          if (skillList.contains(skill)) {
                            SnackbarsType.error(
                                context, 'Skill already added!');
                          } else {
                            skillList.add(skill);
                            final model = state.createResumeModel.copyWith(
                              technicalSkills: skillList,
                            );
                            context
                                .read<CreateResumeBloc>()
                                .add(UpdateResumeDataEvent(
                                  createResumeModel: model,
                                ));
                            // _controller.clear();
                          }
                        } else {
                          SnackbarsType.error(
                              context, 'You can only add 10 skills max!');
                        }
                      } else {
                        SnackbarsType.error(
                            context, 'Please add a technical skill first!');
                      }
                    },
                    child: Container(
                      padding: EdgeInsets.all(9.sp),
                      margin: EdgeInsets.all(3.5.sp).copyWith(left: 0),
                      decoration: BoxDecoration(
                        color: AppColors.primaryColor,
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: const Icon(
                        Icons.add,
                        color: AppColors.whiteColor,
                      ),
                    ),
                  ),
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                  border: outlineInputBorder,
                  focusedBorder: outlineInputBorder.copyWith(
                      borderSide:
                          const BorderSide(color: AppColors.primaryColor)),
                ),
              ),
              SizedBox(height: 10.h),
              Wrap(
                spacing: 8.w,
                children: List.generate(
                    skillList.length,
                    (i) => Container(
                          padding: EdgeInsets.all(8.sp),
                          margin: EdgeInsets.only(bottom: 8.h),
                          decoration: BoxDecoration(
                              color: AppColors.primaryColor,
                              borderRadius: BorderRadius.circular(8.r)),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                skillList[i],
                                style: const TextStyle(
                                    color: AppColors.whiteColor,
                                    fontWeight: FontWeight.w500),
                              ),
                              SizedBox(width: 10.w),
                              InkWell(
                                onTap: () {
                                  skillList.removeAt(i);
                                  final model =
                                      state.createResumeModel.copyWith(
                                    technicalSkills: skillList,
                                  );
                                  context
                                      .read<CreateResumeBloc>()
                                      .add(UpdateResumeDataEvent(
                                        createResumeModel: model,
                                      ));
                                },
                                child: Icon(
                                  size: 18.sp,
                                  Icons.delete,
                                  color: Colors.red,
                                ),
                              )
                            ],
                          ),
                        )),
              )
            ],
          ),
        );
      },
    );
  }
}
