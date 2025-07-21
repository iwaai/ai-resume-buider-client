import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:second_shot/presentation/theme/theme_utils/app_colors.dart';
import 'package:second_shot/utils/constants/assets.dart';

class ThreeDotsMenu extends StatelessWidget {
  const ThreeDotsMenu({
    super.key,
    required this.menuItems,
    required this.menuActions,
  });

  final List<String> menuItems;
  final List<VoidCallback> menuActions;

  @override
  Widget build(BuildContext context) {
    assert(menuItems.length == menuActions.length,
        'The number of menu items and actions must be the same.');

    return PopupMenuButton<String>(
      popUpAnimationStyle: AnimationStyle(),
      position: PopupMenuPosition.under,
      color: AppColors.whiteColor,
      elevation: 1,
      padding: EdgeInsets.zero,
      menuPadding: EdgeInsets.zero.copyWith(top: 10.h),
      onSelected: (value) => _handleOnTap(value),
      itemBuilder: (context) => List.generate(
        menuItems.length,
        (i) => popUpMenuItems(menuItems[i], i),
      ),
      child: Image.asset(
        AssetConstants.threeDotsMenu,
        height: 20.h,
        width: 20.w,
      ),
    );
  }

  PopupMenuItem<String> popUpMenuItems(String name, int index) {
    return PopupMenuItem<String>(
      value: name,
      padding: EdgeInsets.symmetric(horizontal: 6.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(name),
          if (index != menuItems.length - 1) const Divider(),
        ],
      ),
    );
  }

  void _handleOnTap(String value) {
    final index = menuItems.indexOf(value);
    if (index != -1) {
      menuActions[index]();
    }
  }
}
