part of 'library_resume_builder.dart';

class AddMoreButton extends StatelessWidget {
  const AddMoreButton({
    super.key,
    required this.step,
    required this.onTap,
  });

  final int step;
  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: onTap,
          child: Text(
            'Add More',
            style: context.textTheme.titleLarge?.copyWith(
                color: AppColors.primaryColor, fontWeight: FontWeight.w500),
          ),
        ),
        const Divider(),
      ],
    );
  }

  // String _textRenderer(int index) {
  //   switch (step) {
  //     case 3:
  //       return 'Education';
  //     case 4:
  //       return 'Experience';
  //     case 5:
  //       return 'Licenses & Certifications';
  //     case 6:
  //       return 'Skills';
  //     default:
  //       return '';
  //   }
  // }
}
