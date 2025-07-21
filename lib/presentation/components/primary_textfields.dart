import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:second_shot/utils/extensions.dart';

import '../theme/theme_utils/app_colors.dart';

class PrimaryTextField extends StatefulWidget {
  const PrimaryTextField(
      {super.key,
      required this.hintText,
      this.hintColor,
      this.initialValue,
      this.height,
      this.width,
      this.prefixIcon,
      this.suffixIcon,
      this.validator,
      this.controller,
      this.inputType,
      this.obscureText = false,
      this.borderColor,
      this.onChanged,
      this.maxLines,
      this.minLines,
      this.onTap,
      this.isPassword = false,
      this.bottomPadding,
      this.characterLimit,
      this.inputFormatters,
      this.radius,
      this.enabled,
      this.readOnly = false,
      this.fillColor = Colors.transparent,
      this.onSuffixPressed,
      this.hintTextSize,
      this.suffixWidget,
      this.textCapitalization = TextCapitalization.sentences,
      this.onFieldSubmit});

  final String hintText;
  final String? initialValue;
  final Color? hintColor;
  final Widget? prefixIcon;
  final IconData? suffixIcon;
  final Widget? suffixWidget;
  final TextInputType? inputType;
  final String? Function(String?)? validator;
  final TextEditingController? controller;
  final double? height;
  final double? width;
  final double? hintTextSize;
  final double? bottomPadding;
  final bool obscureText;
  final bool? enabled;
  final double? radius;
  final bool readOnly;
  final bool isPassword;
  final Color? borderColor;
  final void Function(String)? onChanged;
  final void Function(String)? onFieldSubmit;
  final void Function()? onTap;
  final void Function()? onSuffixPressed;
  final int? maxLines, minLines, characterLimit;
  final List<TextInputFormatter>? inputFormatters;
  final Color fillColor;
  final TextCapitalization textCapitalization;

  @override
  State<PrimaryTextField> createState() => _PrimaryTextFieldState();
}

class _PrimaryTextFieldState extends State<PrimaryTextField> {
  final OutlineInputBorder outlineInputBorder = OutlineInputBorder(
    borderRadius: BorderRadius.circular(10.r),
  );

  final OutlineInputBorder focusInputBorder = OutlineInputBorder(
    borderRadius: BorderRadius.circular(10.r),
  );

  final OutlineInputBorder errorBorder = OutlineInputBorder(
    borderSide: const BorderSide(color: Colors.red),
    borderRadius: BorderRadius.circular(10.r),
  );

  bool _hidePassword = true;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: widget.bottomPadding ?? 16.h),
      child: TextFormField(
        textCapitalization: widget.textCapitalization,
        onFieldSubmitted: widget.onFieldSubmit,
        initialValue: widget.initialValue,
        inputFormatters: widget.inputFormatters,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        readOnly: widget.readOnly,
        onTapOutside: (event) {
          FocusManager.instance.primaryFocus?.unfocus();
        },
        style:
            context.textTheme.bodyLarge!.copyWith(color: AppColors.blackColor),
        onTap: widget.onTap,
        onChanged: widget.onChanged,
        controller: widget.controller,
        validator: widget.validator,
        keyboardType: widget.inputType,
        obscureText: widget.obscureText ? _hidePassword : false,
        maxLines: widget.maxLines ?? 1,
        minLines: widget.maxLines ?? 1,
        enabled: widget.enabled ?? true,

        // inputFormatters: widget.inputFormatters ?? [],
        maxLength: widget.characterLimit,
        decoration: InputDecoration(
          suffix: widget.suffixWidget,
          labelStyle: TextStyle(fontWeight: FontWeight.w400, fontSize: 16.sp),
          hintText: widget.hintText,
          hintStyle: context.textTheme.bodyLarge!.copyWith(
            color: widget.hintColor ?? AppColors.blackColor,
          ),
          errorMaxLines: 2,
          prefixIcon: widget.prefixIcon,
          // suffixIcon: widget.suffixIcon,
          suffixIcon: widget.isPassword
              ? GestureDetector(
                  child: _hidePassword
                      ? const Icon(Icons.visibility_off,
                          color: AppColors.blackColor)
                      : const Icon(Icons.visibility,
                          color: AppColors.blackColor),
                  onTap: () {
                    setState(() {
                      _hidePassword = !_hidePassword;
                    });
                  },
                )
              : widget.suffixIcon != null && widget.onSuffixPressed != null
                  ? GestureDetector(
                      onTap: widget.onSuffixPressed,
                      child: Icon(widget.suffixIcon,
                          color: Theme.of(context).primaryColor),
                    )
                  : null,
          fillColor: widget.enabled == true
              ? Colors.grey.withOpacity(.5)
              : widget.fillColor,
          filled: true,
          contentPadding:
              EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
          focusedBorder: outlineInputBorder.copyWith(
              borderSide: BorderSide(
                  color: widget.borderColor != null
                      ? widget.borderColor!
                      : AppColors.primaryColor)),

          enabledBorder: outlineInputBorder.copyWith(
              borderSide: BorderSide(
                  color: widget.borderColor != null
                      ? widget.borderColor!
                      : AppColors.blackColor.withOpacity(0.5))),
          border: outlineInputBorder.copyWith(
              borderSide: BorderSide(
                  color: widget.borderColor != null
                      ? widget.borderColor!
                      : AppColors.blackColor.withOpacity(0.5))),
          disabledBorder: outlineInputBorder,
          focusedErrorBorder: errorBorder,
          errorBorder: errorBorder,
          counterText: '',
        ),
      ),
    );
  }
}

// suffixIcon: widget.isPassword
//               ? GestureDetector(
//                   child: _hidePassword
//                       ? Icon(Icons.visibility_off_outlined,
//                           color: Theme.of(context).primaryColor)
//                       : Icon(Icons.visibility_outlined,
//                           color: Theme.of(context).primaryColor),
//                   onTap: () {
//                     setState(() {
//                       _hidePassword = !_hidePassword;
//                     });
//                   },
//                 )
//               : widget.suffixIcon != null && widget.onSuffixPressed != null
//                   ? GestureDetector(
//                       onTap: widget.onSuffixPressed,
//                       child: Icon(widget.suffixIcon,
//                           color: Theme.of(context).primaryColor),
//                     )
//                   : null,
