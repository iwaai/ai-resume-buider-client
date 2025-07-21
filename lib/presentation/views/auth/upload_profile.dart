import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:second_shot/blocs/app/app_bloc.dart';
import 'package:second_shot/blocs/auth/auth_bloc.dart';
import 'package:second_shot/presentation/components/components_barrels.dart';
import 'package:second_shot/presentation/router/route_constants.dart';
import 'package:second_shot/presentation/theme/theme_utils/app_colors.dart';
import 'package:second_shot/services/local_storage.dart';
import 'package:second_shot/utils/constants/assets.dart';
import 'package:second_shot/utils/constants/constant.dart';
import 'package:second_shot/utils/constants/result.dart';
import 'package:second_shot/utils/constants/validators.dart';
import 'package:second_shot/utils/extensions.dart';

class UploadProfilePictureScreen extends StatelessWidget {
  UploadProfilePictureScreen({super.key});

  final nameController = TextEditingController();
  final addressCotnroller = TextEditingController();
  final _formkey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: context.read<AuthBloc>()..add(LoadStates()),
      child: ScaffoldWrapper(
        child: Scaffold(
          body: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: Constant.horizontalPadding,
            ),
            child: BlocConsumer<AuthBloc, AuthState>(
              listener: (context, state) {
                if (state.result.event is PickImage &&
                    state.result.status == ResultStatus.error) {
                  SnackbarsType.error(context, state.result.message);
                }

                if (state.result.event is UploadProfile &&
                    state.result.status == ResultStatus.error) {
                  SnackbarsType.error(context, state.result.message);
                }
                if (state.result.event is UploadProfile &&
                    state.result.status == ResultStatus.successful) {
                  LocalStorage().clearDialogs();
                  context.read<AuthBloc>().add(GetUserProfile());

                  context.push(AppRoutes.successScreen,
                      extra: 'profileCompleted');
                }
              },
              builder: (context, state) {
                final stateCities = context.read<AuthBloc>().stateCityData;
                final user = context.read<AppBloc>().state.user;
                return state.loading && stateCities.isEmpty
                    ? const Center(
                        child: CircularProgressIndicator(),
                      )
                    : Column(
                        children: [
                          Expanded(
                            child: SingleChildScrollView(
                              child: Form(
                                key: _formkey,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Constant.verticalSpace(60.h),
                                    Text(
                                      "Complete Profile Details",
                                      style: context.textTheme.bodyLarge
                                          ?.copyWith(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 18.sp),
                                    ),
                                    Constant.verticalSpace(24.h),
                                    GestureDetector(
                                      onTap: () {
                                        showBottomSheet(context);
                                      },
                                      child: Center(
                                          child: state.image?.path != null
                                              ? CircleAvatar(
                                                  radius: 50,
                                                  backgroundImage: FileImage(
                                                      File(state.image?.path ??
                                                          '')),
                                                )
                                              : Container(
                                                  decoration:
                                                      const BoxDecoration(
                                                          color: Colors.white,
                                                          shape:
                                                              BoxShape.circle),
                                                  padding:
                                                      const EdgeInsets.all(30),
                                                  child: Image.asset(
                                                    AssetConstants
                                                        .userProfileIcon,
                                                    width: 40.w,
                                                    height: 40.h,
                                                  ),
                                                )),
                                    ),
                                    Constant.verticalSpace(12.h),
                                    Text(
                                      "Upload Image",
                                      style: context.textTheme.bodyMedium
                                          ?.copyWith(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 16.sp,
                                              color: AppColors.lightBlueColor),
                                    ),
                                    Constant.verticalSpace(40.h),
                                    PrimaryTextField(
                                      readOnly: true,
                                      fillColor:
                                          AppColors.grey.withOpacity(0.2),
                                      initialValue: user.name,
                                      // controller: nameController,
                                      hintText: "Full Name",
                                      // validator: validateName,
                                    ),
                                    Column(
                                      children: [
                                        PrimaryDropdown(
                                          validator: validateField,
                                          initialValue: state.selectedState,
                                          onChanged: (s) {
                                            context
                                                .read<AuthBloc>()
                                                .add(SelectState(s ?? ""));
                                          },
                                          hintText: "Select State",
                                          hintColor: AppColors.blackColor
                                              .withOpacity(0.8),
                                          options: stateCities.keys.toList()
                                            ..sort((a, b) => a.compareTo(b)),
                                        ),
                                        PrimaryDropdown(
                                          initialValue: state.selectedCity,
                                          hintText: "Select City",
                                          hintColor: AppColors.blackColor
                                              .withOpacity(0.8),
                                          options: List.of(state.cities)
                                            ..sort((a, b) => a.compareTo(b)),
                                          validator: validateField,
                                          onChanged: (city) {
                                            context
                                                .read<AuthBloc>()
                                                .add(SelectCity(city ?? ""));
                                            debugPrint("City $city");
                                          },
                                        )
                                      ],
                                    ),
                                    if (user.phone.isNotEmpty)
                                      PrimaryTextField(
                                        readOnly: true,
                                        fillColor:
                                            AppColors.grey.withOpacity(0.2),
                                        initialValue: formatPhoneNumber(context
                                            .read<AppBloc>()
                                            .state
                                            .user
                                            .phone
                                            .replaceAll('+1', '')),
                                        hintText: "(123) 456-7890",
                                        prefixIcon: Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 12.w),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Image.asset(
                                                AssetConstants.flagIcon,
                                                width: 24.w,
                                                height: 16.h,
                                              ),
                                              const Text(" +1  "),
                                              SizedBox(
                                                height: 20.h,
                                                child: const VerticalDivider(
                                                  color: Colors.grey,
                                                  thickness:
                                                      1, // Divider thickness
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                        // validator: validateMobile,
                                      ),
                                    PrimaryTextField(
                                      hintText: "School / Organization",
                                      controller: addressCotnroller,
                                      // validator: validateField,
                                      characterLimit: 150,
                                    ),
                                    Constant.verticalSpace(20),
                                    // PrimaryButton(
                                    //   loading: state.loading,
                                    //   onPressed: () {
                                    //     if (state.image == null) {
                                    //       SnackbarsType.error(
                                    //           context, "Image is Required");
                                    //     }
                                    //     if (_formkey.currentState!.validate() &&
                                    //         state.image != null) {
                                    //       debugPrint(
                                    //           "city ${state.selectedCity}");
                                    //       debugPrint(
                                    //           "state ${state.selectedState}");
                                    //       context.read<AuthBloc>().add(
                                    //             UploadProfile(
                                    //               address:
                                    //                   addressCotnroller.text,
                                    //             ),
                                    //           );
                                    //     }
                                    //   },
                                    //   text: "Confirm",
                                    //   textSize: 16.sp,
                                    //   fontWeight: FontWeight.w500,
                                    // ),
                                    // Constant.verticalSpace(20),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          PrimaryButton(
                            loading: state.loading,
                            onPressed: () {
                              // if (state.image == null) {
                              //   SnackbarsType.error(
                              //       context, "Image is Required");
                              // }
                              if (_formkey.currentState!.validate()) {
                                debugPrint("city ${state.selectedCity}");
                                debugPrint("state ${state.selectedState}");
                                context.read<AuthBloc>().add(
                                      UploadProfile(
                                        address: addressCotnroller.text,
                                      ),
                                    );
                              }
                            },
                            text: "Confirm",
                            textSize: 16.sp,
                            fontWeight: FontWeight.w500,
                          ),
                          Constant.verticalSpace(20),
                        ],
                      );
              },
            ),
          ),
        ),
      ),
    );
  }

  void showBottomSheet(BuildContext context) {
    showModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(50), topRight: Radius.circular(20))),
        builder: (context) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CustomPickerButton(
                  title: "Take Photo",
                  ontap: () {
                    context.read<AuthBloc>().add(PickImage(fromCamera: true));
                    context.pop(context);
                  },
                  topLeft: 5,
                  topRight: 5,
                ),
                const SizedBox(height: 0.3),
                CustomPickerButton(
                  title: "From Gallery",
                  ontap: () {
                    context.read<AuthBloc>().add(PickImage(fromCamera: false));
                    context.pop(context);
                  },
                  bottomLeft: 5,
                  bottomRight: 5,
                ),
                const SizedBox(height: 5),
                CustomPickerButton(
                  title: "Cancel",
                  ontap: () {
                    context.pop();
                  },
                  topLeft: 5,
                  topRight: 5,
                  bottomLeft: 5,
                  bottomRight: 5,
                )
              ],
            ),
          );
        });
  }
}
