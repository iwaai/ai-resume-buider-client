import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:second_shot/blocs/app/app_bloc.dart';
import 'package:second_shot/models/subscription_model.dart';
import 'package:second_shot/presentation/views/auth/Components/subscription_plan_benefits.dart';
import 'package:second_shot/utils/extensions.dart';

import '../../../theme/theme_utils/app_colors.dart';

class SubscriptionsPlansWidget extends StatelessWidget {
  const SubscriptionsPlansWidget({
    super.key,
    required this.isSelected,
    required this.productDetails,
  });

  final bool isSelected;
  final ProductDetails productDetails;
  String get title => productDetails.title.toLowerCase().contains('1 year')
      ? 'Yearly'
      : 'Monthly';
  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
      padding: EdgeInsets.all(16.sp),
      decoration: BoxDecoration(
        gradient: isSelected
            ? AppColors.primaryGradient
            : const LinearGradient(colors: [
                AppColors.whiteColor,
                AppColors.whiteColor,
              ]),
        color: isSelected ? AppColors.primaryColor : AppColors.whiteColor,
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: isSelected
                ? CrossAxisAlignment.start
                : CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AnimatedDefaultTextStyle(
                      duration: const Duration(milliseconds: 500),
                      style: context.textTheme.titleLarge!.copyWith(
                          color: isSelected
                              ? AppColors.whiteColor
                              : AppColors.primaryColor),
                      child: Text(
                        title,
                        maxLines: 2,
                      ),
                    ),
                    AnimatedDefaultTextStyle(
                      duration: const Duration(milliseconds: 500),
                      style: context.textTheme.titleMedium!.copyWith(
                          color: isSelected
                              ? AppColors.secondaryColor
                              : AppColors.primaryColor),
                      child: Text(
                        productDetails.price,
                        style: context.textTheme.titleMedium?.copyWith(
                            color: isSelected
                                ? AppColors.secondaryColor
                                : AppColors.primaryColor),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                height: 18.h,
                width: 18.w,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: isSelected
                        ? AppColors.whiteColor
                        : AppColors.primaryColor,
                    width: 2,
                  ),
                  shape: BoxShape.circle,
                ),
                child: Container(
                  margin: EdgeInsets.all(2.0.sp),
                  decoration: BoxDecoration(
                    color:
                        isSelected ? AppColors.whiteColor : Colors.transparent,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ],
          ),
          AnimatedCrossFade(
              sizeCurve: Curves.easeInOut,
              duration: const Duration(milliseconds: 1000),
              crossFadeState: !isSelected
                  ? CrossFadeState.showFirst
                  : CrossFadeState.showSecond,
              firstChild: const SizedBox.shrink(),
              secondChild: Column(
                children: [
/*
                  isSelected
                      ? Text(
                          'For $title Unlock These Benefits Today!',
                          style: context.textTheme.bodyLarge?.copyWith(
                              color: AppColors.whiteColor,
                              fontWeight: FontWeight.bold),
                        )
                      : const SizedBox.shrink(),
*/
                  SizedBox(height: 4.h),
                  SubscriptionPlanBenefits(
                      duration: productDetails.title
                                  .toLowerCase()
                                  .contains('1 Month') ||
                              productDetails.title
                                  .toLowerCase()
                                  .contains('month')
                          ? '1 Month'
                          : '1 Year',
                      selectedPlanIndex: 7),
                ],
              )),
        ],
      ),
    );
  }
}

class CurrentPlanWidget extends StatelessWidget {
  const CurrentPlanWidget({
    super.key,
    required this.productDetails,
  });

  final SubscriptionModel? productDetails;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
      padding: EdgeInsets.all(16.sp),
      decoration: BoxDecoration(
        gradient: AppColors.primaryGradient,
        color: AppColors.primaryColor,
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AnimatedDefaultTextStyle(
                      duration: const Duration(milliseconds: 500),
                      style: context.textTheme.titleLarge!
                          .copyWith(color: AppColors.whiteColor),
                      child: Text(
                        title(context),
                        maxLines: 2,
                      ),
                    ),
                    if (context
                            .read<AppBloc>()
                            .state
                            .user
                            .currentSubscriptionPlan !=
                        'access-code')
                      AnimatedDefaultTextStyle(
                        duration: const Duration(milliseconds: 500),
                        style: context.textTheme.titleMedium!
                            .copyWith(color: AppColors.secondaryColor),
                        child: Text(
                          "\$ ${productDetails?.subscriptionProduct.price ?? "00"}",
                          style: context.textTheme.titleMedium
                              ?.copyWith(color: AppColors.secondaryColor),
                        ),
                      ),
                  ],
                ),
              ),
              Container(
                height: 18.h,
                width: 18.w,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: AppColors.whiteColor,
                    width: 2,
                  ),
                  shape: BoxShape.circle,
                ),
                child: Container(
                  margin: EdgeInsets.all(2.0.sp),
                  decoration: const BoxDecoration(
                    color: AppColors.whiteColor,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 4.h),
          SubscriptionPlanBenefits(
            selectedPlanIndex: 7,
            duration: (productDetails?.subscriptionProduct.productName ?? "")
                    .contains('month')
                ? '1 Month'
                : '1 Year',
          ),
        ],
      ),
    );
  }

  String title(BuildContext context) {
    String title = '';
    if ((productDetails?.subscriptionProduct.productName ?? "")
        .toString()
        .contains('yearly_plan')) {
      title = 'Yearly Plan';
    }
    if ((productDetails?.subscriptionProduct.productName ?? "")
        .toString()
        .contains('monthly_plan')) {
      title = 'Monthly Plan';
    }
    if (context.read<AppBloc>().state.user.currentSubscriptionPlan ==
        'access-code') {
      title = 'Access Code';
    }

    return title;
  }
}
