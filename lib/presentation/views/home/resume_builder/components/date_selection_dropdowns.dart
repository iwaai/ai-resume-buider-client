part of 'library_resume_builder.dart';

class DateSelectionDropdowns extends StatelessWidget {
  const DateSelectionDropdowns({
    super.key,
    required this.titleDropdown1,
    required this.titleDropdown2,
    required this.hintTextDropdown1,
    required this.hintTextDropdown2,
    required this.onChangedDropdown1,
    required this.onChangedDropdown2,
    required this.optionsDropdown1,
    required this.optionsDropdown2,
    this.showOptionalText1 = false,
    this.optionalText1,
    this.optionalTextColor1,
    this.showOptionalText2 = false,
    this.optionalText2,
    this.optionalTextColor2,
    this.optionalTextSize1,
    this.optionalTextSize2,
    this.initialValue1,
    this.initialValue2,
    this.isEnabled1 = true,
    this.isEnabled2 = true,
  });

  final String titleDropdown1;
  final String titleDropdown2;
  final String hintTextDropdown1;
  final String hintTextDropdown2;
  final String? optionalText1;
  final Color? optionalTextColor1;
  final bool showOptionalText1;
  final String? optionalText2;
  final Color? optionalTextColor2;
  final bool showOptionalText2;
  final double? optionalTextSize1;
  final double? optionalTextSize2;
  final String? initialValue1;
  final String? initialValue2;
  final bool isEnabled1;
  final bool isEnabled2;

  final Function(String?) onChangedDropdown1;
  final Function(String?) onChangedDropdown2;
  final List<String> optionsDropdown1;
  final List<String> optionsDropdown2;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: EditProfileDropDown(
              isEnabled: isEnabled1,
              value: initialValue1,
              optionalTextSize: optionalTextSize1,
              optionalText: optionalText1,
              optionalTextColor: optionalTextColor1,
              showOptionalText: showOptionalText1,
              title: titleDropdown1,
              hintText: hintTextDropdown1,
              onChanged: onChangedDropdown1,
              options: optionsDropdown1),
        ),
        SizedBox(width: 8.w),
        Expanded(
          child: EditProfileDropDown(
              isEnabled: isEnabled2,
              value: initialValue2,
              optionalTextSize: optionalTextSize2,
              optionalText: optionalText2,
              optionalTextColor: optionalTextColor2,
              showOptionalText: showOptionalText2,
              title: titleDropdown2,
              hintText: hintTextDropdown2,
              onChanged: onChangedDropdown2,
              options: optionsDropdown2),
        ),
      ],
    );
  }
}
