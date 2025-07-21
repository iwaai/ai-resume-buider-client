import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:second_shot/presentation/components/components_barrels.dart';
import 'package:second_shot/presentation/components/scaffold_wrapper.dart';
import 'package:second_shot/utils/constants/assets.dart';
import 'package:second_shot/utils/extensions.dart';

class CommonDialogScreen extends StatefulWidget {
  static const routeName = '/CommonDialogScreen';

  const CommonDialogScreen({
    super.key,
    required this.title,
    required this.description,
    this.image,
    this.navigate = true,
    this.nextScreen,
    this.widget,
    this.imageSize = 120,
  });

  final String title, description;
  final String? image;
  final bool navigate;
  final String? nextScreen;
  final Widget? widget;
  final double imageSize;

  @override
  State<CommonDialogScreen> createState() => _CommonDialogScreenState();
}

class _CommonDialogScreenState extends State<CommonDialogScreen> {
  @override
  void initState() {
    super.initState();

    if (widget.navigate) {
      if (widget.nextScreen != null) {
        Future.delayed(const Duration(seconds: 2))
            .then((value) => context.go(widget.nextScreen!));
      } else {
        Future.delayed(const Duration(seconds: 2))
            .then((value) => context.pop());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldWrapper(
      child: Scaffold(
        body: Container(
          alignment: Alignment.center,
          padding: EdgeInsets.symmetric(horizontal: 61.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                widget.image ?? AssetConstants.tickMarkIcon,
                height: (widget.imageSize).h,
                width: (widget.imageSize).w,
              ),
              SizedBox(
                height: 42.h,
              ),
              Text(
                widget.title,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 28.sp,
                ),
              ),
              SizedBox(
                height: 12.h,
              ),
              SizedBox(
                width: double.infinity,
                child: Text(
                  textAlign: TextAlign.center,
                  widget.description,
                  maxLines: 3,
                  style: context.textTheme.titleLarge!
                      .copyWith(fontWeight: FontWeight.w500),
                ),
              ),
              if (widget.widget != null) widget.widget!,
            ],
          ),
        ),
      ),
    );
  }
}
