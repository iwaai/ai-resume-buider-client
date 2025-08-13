import 'package:flutter/material.dart';
import 'package:second_shot/presentation/theme/theme_utils/app_colors.dart';
import 'package:second_shot/utils/extensions.dart';

class DialogSelectionTile extends StatelessWidget {
  final String text;
  final bool selected;
  final Function() onTap;
  const DialogSelectionTile(
      {super.key,
      required this.text,
      required this.selected,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: selected
                ? AppColors.secondaryColor
                : AppColors.grey.withOpacity(.15)),
        child: Text(text,
            textAlign: TextAlign.center,
            style: context.textTheme.titleMedium!.copyWith(
                color:
                    selected ? AppColors.primaryColor : AppColors.blackColor)),
      ),
    );
  }
}
