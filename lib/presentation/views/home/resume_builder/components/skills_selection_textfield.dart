part of 'library_resume_builder.dart';

class SkillsSelectionTexField extends StatelessWidget {
  const SkillsSelectionTexField(
      {super.key, required this.libraryModels, required this.skillsList});

  final List<LibraryModel> libraryModels;
  final List<String> skillsList;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: AppColors.blackColor),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(
                    skillsList.isEmpty ? 1 : skillsList.length, (i) {
                  return skillsList.isEmpty
                      ? const Text('     Select Soft Skills')
                      : Text(
                          '     ${skillsList[i]}    |',
                          style: context.textTheme.titleMedium?.copyWith(
                              color: AppColors.primaryColor,
                              fontWeight: FontWeight.w600),
                        );
                }),
              ),
            ),
          ),
          InkWell(
            onTap: () => SkillSelectionDialog(
              models: libraryModels,
            ).showCustomDialog(context),
            child: Container(
              padding: EdgeInsets.all(9.sp),
              margin: EdgeInsets.all(2.sp).copyWith(left: 0),
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
        ],
      ),
    );
  }
}
