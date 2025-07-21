import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:second_shot/models/registration_data_model.dart';
import 'package:second_shot/utils/extensions.dart';

import '../theme/theme_utils/app_colors.dart';

class PrimaryDropdown extends StatelessWidget {
  PrimaryDropdown({
    super.key,
    required this.hintText,
    this.hintColor,
    this.height,
    this.width,
    this.textFieldColor,
    this.prefixIcon,
    this.suffixIcon,
    this.validator,
    this.onChanged,
    this.borderColor,
    this.elevation,
    required this.options,
    this.bottomPadding,
    this.isEnabled = true, // New parameter for enabled state
    this.initialValue,
    this.autoValidateMode,
    this.dropDownMenuHeight,
    this.hintTextSize,
    this.maxHeightAfterOpen,
  });

  final String hintText;
  final double? elevation;
  final Color? hintColor;
  final Color? textFieldColor;
  final Icon? prefixIcon;
  final IconButton? suffixIcon; // Input type for keyboard
  final String? Function(String?)? validator; // Validator function
  final double? height;
  final double? hintTextSize;
  final double? dropDownMenuHeight;
  final double? width;
  final double? bottomPadding;
  final Color? borderColor;
  final void Function(String?)? onChanged;
  final List<dynamic> options;
  final String? initialValue;
  final AutovalidateMode? autoValidateMode;
  final bool isEnabled;
  final double? maxHeightAfterOpen;

  // Nullable initial value
  final OutlineInputBorder outlineInputBorder = OutlineInputBorder(
    borderSide: BorderSide(color: AppColors.borderGrey),
    borderRadius: BorderRadius.circular(10.r),
  );

  final OutlineInputBorder errorBorder = OutlineInputBorder(
    borderSide: const BorderSide(color: Colors.red),
    borderRadius: BorderRadius.circular(10.r),
  );

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height ?? null,
      width: width ?? double.infinity,
      child: Padding(
        padding: EdgeInsets.only(bottom: bottomPadding ?? 16.0.h),
        child: ButtonTheme(
          alignedDropdown: true,
          child: DropdownSearch<String>(
            enabled: isEnabled,
            popupProps: PopupProps.menu(
                showSelectedItems: true,
                scrollbarProps: ScrollbarProps(
                  thumbColor: Colors.transparent,
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                ),
                itemBuilder: (context, v, _, __) {
                  return Container(
                    margin: EdgeInsets.symmetric(horizontal: 16.w),
                    decoration: BoxDecoration(
                      border: Border(
                          bottom: v != options.last
                              ? BorderSide(
                                  color: AppColors.grey.withOpacity(.25),
                                )
                              : BorderSide.none),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 12.h),
                    alignment: Alignment.centerLeft,
                    child: Row(
                      children: [
                        Expanded(
                          flex: 3,
                          child: Text(v,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: context.textTheme.bodyLarge!),
                        ),
                        const Spacer(
                          flex: 1,
                        ),
                        Container(
                          height: 16,
                          width: 16,
                          padding: EdgeInsets.all(2.sp),
                          decoration: BoxDecoration(
                              border: Border.all(color: AppColors.primaryColor),
                              shape: BoxShape.circle),
                          child: initialValue != v
                              ? null
                              : const CircleAvatar(
                                  radius: 6,
                                  backgroundColor: AppColors.primaryColor,
                                ),
                        )
                      ],
                    ),
                  );
                },
                constraints:
                    BoxConstraints(maxHeight: maxHeightAfterOpen ?? 150.h),
                menuProps: MenuProps(
                  color: AppColors.redColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  elevation: elevation ?? 1.0,
                  margin: EdgeInsets.only(top: 8.h),
                ),
                fit: FlexFit.loose),
            decoratorProps: DropDownDecoratorProps(
              decoration: InputDecoration(
                hintText: hintText,
                hintMaxLines: 1,
                hintStyle: context.textTheme.bodyLarge!.copyWith(
                    fontSize: hintTextSize,
                    color: hintColor ?? AppColors.blackColor),
                prefixIcon: prefixIcon,
                suffixIcon: suffixIcon,
                fillColor: isEnabled
                    ? (textFieldColor ?? Colors.transparent)
                    : Colors.grey.withOpacity(.5),
                filled: true,
                contentPadding: EdgeInsets.only(right: 5.w, left: 16.w),
                focusedBorder: outlineInputBorder.copyWith(
                  borderSide: const BorderSide(color: AppColors.primaryColor),
                ),
                enabledBorder: outlineInputBorder.copyWith(
                  borderSide: BorderSide(color: AppColors.grey),
                ),
                border: outlineInputBorder.copyWith(
                  borderSide: BorderSide(color: AppColors.grey),
                ),
                disabledBorder: outlineInputBorder,
                focusedErrorBorder: errorBorder,
                errorBorder: errorBorder,
              ),
            ),
            dropdownBuilder: (context, v) {
              return DropdownMenuItem<String>(
                value: v,
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text((v ?? "").toString(),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: context.textTheme.bodyLarge!),
                ),
              );
            },
            autoValidateMode:
                autoValidateMode ?? AutovalidateMode.onUserInteraction,
            selectedItem: (initialValue?.isEmpty ?? true) ? null : initialValue,
            validator: validator,
            items: (filter, loadProps) {
              return options.map((e) => e.toString()).toList();
            },
            onChanged: isEnabled ? onChanged : null,
          ),
        ),
      ),
    );
  }
}

class PrimaryDropdownForObjects<T extends RegistrationFormDataModel>
    extends StatelessWidget {
  PrimaryDropdownForObjects({
    super.key,
    required this.hintText,
    this.hintColor,
    this.height,
    this.width,
    this.textFieldColor,
    this.prefixIcon,
    this.suffixIcon,
    this.validator,
    this.onChanged,
    this.borderColor,
    this.elevation,
    required this.options,
    this.bottomPadding,
    this.isEnabled = true,
    this.initialValue,
    this.autoValidateMode,
    this.dropDownMenuHeight,
    this.hintTextSize,
  });

  final String hintText;
  final double? elevation;
  final Color? hintColor;
  final Color? textFieldColor;
  final Icon? prefixIcon;
  final IconButton? suffixIcon;
  final String? Function(String?)? validator;
  final double? height;
  final double? hintTextSize;
  final double? dropDownMenuHeight;
  final double? width;
  final double? bottomPadding;
  final Color? borderColor;
  final void Function(T?)? onChanged; // Changed to return id
  final List<T> options; // List of RegistrationFormDataModel objects
  final String? initialValue; // Changed to accept the id
  final AutovalidateMode? autoValidateMode;
  final bool isEnabled;

  final OutlineInputBorder outlineInputBorder = OutlineInputBorder(
    borderSide: BorderSide(color: AppColors.borderGrey),
    borderRadius: BorderRadius.circular(10),
  );

  final OutlineInputBorder errorBorder = OutlineInputBorder(
    borderSide: const BorderSide(color: Colors.red),
    borderRadius: BorderRadius.circular(10),
  );

  @override
  Widget build(BuildContext context) {
    final temp = options.where((e) => e.id == initialValue).toList();
    final selected = temp.isEmpty ? null : temp.first;
    return SizedBox(
      height: height ?? null,
      width: width ?? double.infinity,
      child: Padding(
        padding: EdgeInsets.only(bottom: bottomPadding ?? 16.0),
        child: ButtonTheme(
          alignedDropdown: true,
          child: DropdownSearch<T>(
            compareFn: (oldVal, newVal) {
              return oldVal != newVal;
            },
            enabled: isEnabled,
            popupProps: PopupProps.menu(
              showSelectedItems: true,
              scrollbarProps: ScrollbarProps(
                thumbColor: Colors.transparent,
                padding: const EdgeInsets.symmetric(vertical: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              itemBuilder: (context, item, _, __) {
                return Container(
                  decoration: BoxDecoration(
                    border: Border(
                        bottom: item != options.last
                            ? BorderSide(
                                color: AppColors.grey.withOpacity(.25),
                              )
                            : BorderSide.none),
                  ),
                  padding:
                      EdgeInsets.symmetric(vertical: 16.h, horizontal: 16.w),
                  alignment: Alignment.centerLeft,
                  child: Row(
                    children: [
                      Expanded(
                        flex: 3,
                        child: Text(item.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: context.textTheme.bodyLarge!),
                      ),
                      const Spacer(
                        flex: 1,
                      ),
                      Container(
                        height: 16,
                        width: 16,
                        padding: EdgeInsets.all(2.sp),
                        decoration: BoxDecoration(
                            border: Border.all(color: AppColors.primaryColor),
                            shape: BoxShape.circle),
                        child: initialValue != item.id
                            ? null
                            : const CircleAvatar(
                                radius: 6,
                                backgroundColor: AppColors.primaryColor,
                              ),
                      )
                    ],
                  ),
                );
              },
              constraints:
                  BoxConstraints(maxHeight: dropDownMenuHeight ?? 150.h),
              menuProps: MenuProps(
                color: AppColors.redColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.r),
                ),
                elevation: elevation ?? 1.0,
                margin: EdgeInsets.only(top: 8.h),
              ),
              fit: FlexFit.loose,
            ),
            decoratorProps: DropDownDecoratorProps(
              decoration: InputDecoration(
                hintText: hintText,
                hintMaxLines: 1,
                hintStyle: context.textTheme.bodyLarge!.copyWith(
                    fontSize: hintTextSize,
                    color: hintColor ?? AppColors.blackColor),
                prefixIcon: prefixIcon,
                suffixIcon: suffixIcon,
                fillColor: isEnabled
                    ? (textFieldColor ?? Colors.transparent)
                    : Colors.grey.withOpacity(.5),
                filled: true,
                contentPadding: EdgeInsets.only(right: 5.w, left: 16.w),
                focusedBorder: outlineInputBorder.copyWith(
                  borderSide: const BorderSide(color: AppColors.primaryColor),
                ),
                enabledBorder: outlineInputBorder.copyWith(
                  borderSide: BorderSide(color: AppColors.grey),
                ),
                border: outlineInputBorder.copyWith(
                  borderSide: BorderSide(color: AppColors.grey),
                ),
                disabledBorder: outlineInputBorder,
                focusedErrorBorder: errorBorder,
                errorBorder: errorBorder,
              ),
            ),
            dropdownBuilder: (context, item) {
              return item == null
                  ? Text(hintText,
                      style: context.textTheme.bodyLarge!
                          .copyWith(color: hintColor ?? Colors.grey))
                  : Text(item.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: context.textTheme.bodyLarge);
            },
            autoValidateMode:
                autoValidateMode ?? AutovalidateMode.onUserInteraction,
            selectedItem: selected,
            validator: (value) => validator?.call(value?.id),
            items: (_, __) => options,
            onChanged: isEnabled
                ? (item) => onChanged?.call(item) // Return the id
                : null,
          ),
        ),
      ),
    );
  }
}
