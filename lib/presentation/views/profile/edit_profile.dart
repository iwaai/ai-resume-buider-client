import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:second_shot/blocs/app/app_bloc.dart';
import 'package:second_shot/blocs/auth/auth_bloc.dart';
import 'package:second_shot/presentation/components/components_barrels.dart';
import 'package:second_shot/presentation/components/user_pfp.dart';
import 'package:second_shot/presentation/theme/theme_utils/app_colors.dart';
import 'package:second_shot/presentation/views/auth/Components/number_formate.dart';
import 'package:second_shot/services/local_storage.dart';
import 'package:second_shot/utils/constants/constant.dart';
import 'package:second_shot/utils/constants/result.dart';
import 'package:second_shot/utils/extensions.dart';

import '../../../utils/constants/validators.dart';

class EditProfile extends StatelessWidget {
  EditProfile({super.key});
  final _formkey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    final user = context.read<AppBloc>().state.user;
    String address = user.address;
    String name = user.name;
    return BlocProvider.value(
      value: context.read<AuthBloc>()
        ..add(SelectState(user.state))
        ..add(SelectCity(user.city)),
      child: ScaffoldWrapper(
        child: Scaffold(
          appBar: const CustomAppBar(
            title: 'Edit Profile',
          ),
          body: BlocConsumer<AuthBloc, AuthState>(listener: (context, state) {
            if (state.result.event is UpdateUser &&
                state.result.status == ResultStatus.error) {
              SnackbarsType.error(context, state.result.message);
            }

            if (state.result.event is UpdateUser &&
                state.result.status == ResultStatus.successful) {
              SnackbarsType.success(context, state.result.message);
              context.read<AppBloc>().add(SetUser(user: LocalStorage().user!));
              context.pop();
            }
          }, builder: (context, state) {
            final stateCities = context.read<AuthBloc>().stateCityData;

            return CustomScrollView(
              slivers: [
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: Form(
                    key: _formkey,
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.0.w),
                      child: Column(
                        children: [
                          SizedBox(
                            height: 22.h,
                          ),
                          Row(
                            children: [
                              state.image == null
                                  ? UserPfp(
                                      radius: 40.r,
                                    )
                                  : CircleAvatar(
                                      backgroundColor:
                                          AppColors.userBackgroundGreenColor,
                                      backgroundImage:
                                          FileImage(File(state.image!.path)),
                                      radius: 40.sp,
                                    ),
                              SizedBox(
                                width: 16.w,
                              ),
                              Text(
                                'Change Profile',
                                style: context.textTheme.bodyLarge!.copyWith(
                                    color: AppColors.blackColor,
                                    fontWeight: FontWeight.w500),
                              ),
                              const Spacer(),
                              TextButton(
                                onPressed: () {
                                  showUploadBottomSheet(context);
                                },
                                child: Text(
                                  'Upload',
                                  style: context.textTheme.bodyLarge!.copyWith(
                                      color: AppColors.uploadButtonColor,
                                      fontWeight: FontWeight.w500),
                                ),
                              )
                            ],
                          ),
                          SizedBox(
                            height: 28.h,
                          ),
                          EditProfileTextfield(
                            characterLimit: 30,
                            textInputType: TextInputType.name,
                            textInputFormatters: [NameInputFormatter()],
                            title: 'Full Name',
                            hintText: 'Enter your name',
                            initialValue: user.name,
                            onChanged: (v) {
                              name = v.trim();
                            },
                          ),
                          SizedBox(
                            height: 6.h,
                          ),
                          EditProfileTextfield(
                            readOnly: true,
                            textInputType: TextInputType.emailAddress,
                            title: 'Email',
                            hintText: 'Enter your email',
                            initialValue: user.email,
                            onChanged: (v) {
                              print(v);
                            },
                          ),
                          if (user.phone.isNotEmpty) ...[
                            SizedBox(
                              height: 6.h,
                            ),
                            EditProfileTextfield(
                              readOnly: true,
                              textInputFormatters: [
                                FilteringTextInputFormatter.digitsOnly, //
                                PhoneNumberFormatter()
                              ],
                              textInputType: TextInputType.phone,
                              title: 'Phone',
                              hintText: 'Enter your phone',
                              initialValue: user.phone.toUSPhoneNumber(),
                              onChanged: (v) {
                                print(v);
                              },
                            ),
                          ],
                          SizedBox(
                            height: 6.h,
                          ),
                          EditProfileDropDown(
                            validator: validateField,
                            options: stateCities.keys.toList()
                              ..sort((a, b) => a.compareTo(b)),
                            title: 'State',
                            hintText: 'Select State',
                            value: state.selectedState,
                            onChanged: (v) {
                              context
                                  .read<AuthBloc>()
                                  .add(SelectState(v ?? ""));
                            },
                          ),
                          SizedBox(
                            height: 6.h,
                          ),
                          EditProfileDropDown(
                            validator: validateField,
                            options: List.of(state.cities)
                              ..sort((a, b) => a.compareTo(b)),
                            title: 'City',
                            hintText: 'Select City',
                            value: state.selectedCity,
                            onChanged: (v) {
                              context.read<AuthBloc>().add(SelectCity(v ?? ""));
                            },
                          ),
                          SizedBox(
                            height: 6.h,
                          ),
                          EditProfileTextfield(
                            title: 'School or Organization',
                            hintText: 'Enter your School or Organization',
                            initialValue: user.address,
                            // validator: validateField,
                            onChanged: (v) {
                              address = v.trim();
                            },
                          ),
                          const Spacer(),
                          SizedBox(
                            height: 12.h,
                          ),
                          PrimaryButton(
                              loading: state.loading,
                              onPressed: () {
                                if (_formkey.currentState?.validate() ??
                                    false) {
                                  context.read<AuthBloc>().add(
                                      UpdateUser(address: address, name: name));
                                }
                              },
                              text: 'Save'),
                          SizedBox(
                            height: 12.h,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            );
          }),
        ),
      ),
    );
  }

  void showUploadBottomSheet(BuildContext context) {
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
