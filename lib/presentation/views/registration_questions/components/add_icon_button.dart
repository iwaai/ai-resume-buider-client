import 'package:flutter/material.dart';
import 'package:second_shot/presentation/theme/theme_utils/app_colors.dart';

class AddIconButton extends StatelessWidget {
  final Function() onTap;
  const AddIconButton({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onTap();
      },
      child: Container(
        height: 40,
        width: 40,
        decoration: BoxDecoration(
          gradient: AppColors.primaryGradient,
          borderRadius: BorderRadius.circular(10),
        ),
        child: const Icon(
          Icons.add,
          color: AppColors.whiteColor,
        ),
      ),
    );
  }
}
