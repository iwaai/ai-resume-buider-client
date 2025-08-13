import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:second_shot/presentation/components/common_dialogue_2.dart';
import 'package:second_shot/presentation/components/primary_button.dart';
import 'package:second_shot/presentation/router/route_constants.dart';
import 'package:second_shot/presentation/theme/theme_utils/app_colors.dart';
import 'package:second_shot/utils/constants/assets.dart';

class Constant {
  static const verticalPadding = 16.0;
  static const horizontalPadding = 16.0;

  static verticalSpace(double vertical) {
    return SizedBox(
      height: vertical,
    );
  }

  static horizontalSpace(double horizontal) {
    return SizedBox(
      width: horizontal,
    );
  }

  static showSubscriptionDialog(BuildContext context,
      {bool isTransferable = false}) {
    CommonDialog(
      title: "Get Full Access",
      body: isTransferable == false
          ? "Buy a subscription to unlock this feature and enjoy exclusive benefits."
          : "The free version only shows one skill and its nodes. Subscribe now to unlock the full transferable skills map.",
      imageHeight: 104.w,
      okBtnText: "Buy Now",
      okBtnFunction: () {
        context.push(AppRoutes.subscriptionScreen);
        context.pop();
      },
      isRowButton: true,
      image: AssetConstants.accessIcon,
      additionalButton: Expanded(
        child: PrimaryButton(
          buttonColor: AppColors.grey.withOpacity(0.4),
          textColor: AppColors.blackColor,
          onPressed: () => context.pop(),
          text: 'Cancel',
        ),
      ),
    ).showCustomDialog(context);
  }

  static showComingSoonDialog(
    BuildContext context,
  ) {
    CommonDialog(
      title: "Coming Soon",
      body: 'You will be notified when this module will become available.',
      imageHeight: 104.w,
      okBtnText: "Close",
      okBtnFunction: () {
        context.pop();
      },
      isRowButton: true,
      image: AssetConstants.comingSoonIcon,
    ).showCustomDialog(context);
  }

  ///Goal statuses

  static const String completed = "Completed";
  static const String inProgress = "In Progress";
  static const String notStartedYet = "Not Started yet";

  ///Api Feature Restriction
  static const String accessDeniedMessage = "Access denied.";

  static String formatPhoneNumber(String? phone) {
    if (phone == null || phone.isEmpty) return "";

    // Remove non-numeric characters
    String digits = phone.replaceAll(RegExp(r'\D'), '');

    // Remove leading +1 if present
    if (digits.startsWith("1") && digits.length == 11) {
      digits = digits.substring(1);
    }

    // Format into (123) 456-7890
    if (digits.length == 10) {
      return "(${digits.substring(0, 3)}) ${digits.substring(3, 6)}-${digits.substring(6)}";
    }

    return phone; // Return as-is if length is incorrect
  }
}

String formatDate(DateTime date) {
  return DateFormat('MMMM dd, yyyy').format(date);
}

String formatDate1(String dateString) {
  DateTime date = DateTime.parse(dateString); // Convert string to DateTime
  return DateFormat('MMMM dd, yyyy').format(date); // Format it to "hh:mm AM/PM"
}

String formatDate2(String date) {
  DateTime date1 = DateTime.parse(date);
  return DateFormat('MMMM dd, yyyy').format(date1);
}

String formatTime(DateTime date) {
  return DateFormat('hh:mm').format(date);
}

TextInputFormatter get nameFormatter {
  return FilteringTextInputFormatter(RegExp("[a-zA-Z .]"), allow: true);
}

TextInputFormatter get phoneFormatter {
  return FilteringTextInputFormatter(RegExp("[0-9]"), allow: true);
}

String sanitizePhoneNumber(String phone) {
  return phone.replaceAll(
      RegExp(r'[()\-\s]'), ''); // Remove (, ), -, and spaces
}

class PhoneNumberFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    String digits =
        newValue.text.replaceAll(RegExp(r'\D'), ''); // Remove non-digits

    if (digits.length > 10) {
      digits = digits.substring(0, 10); // Limit to 10 digits
    }

    String formatted = _formatNumber(digits);

    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }

  String _formatNumber(String digits) {
    if (digits.isEmpty) return "";
    if (digits.length <= 3) return "( $digits";
    if (digits.length <= 6) {
      return "( ${digits.substring(0, 3)} ) ${digits.substring(3)}";
    }
    return "( ${digits.substring(0, 3)} ) ${digits.substring(3, 6)}-${digits.substring(6)}";
  }
}

String formatPhoneNumber(String digits) {
  // Ensure only digits are processed
  digits = digits.replaceAll(RegExp(r'\D'), '');

  if (digits.length != 10) return digits; // Return as is if not 10 digits

  return "( ${digits.substring(0, 3)} ) ${digits.substring(3, 6)}-${digits.substring(6)}";
}

int subscriptionIndex = 1;

String formatChatTime(DateTime dateTime) {
  return DateFormat('hh:mma').format(dateTime).toLowerCase();
}
