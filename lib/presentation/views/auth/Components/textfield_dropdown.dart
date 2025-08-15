// import 'package:dropdown_textfield/dropdown_textfield.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:second_shot/presentation/theme/theme_utils/app_colors.dart';

// class DropdownFieldExample extends StatefulWidget {
//   const DropdownFieldExample(
//       {Key? key, required this.items, required this.hintText})
//       : super(key: key);

//   final List<String> items;
//   final String hintText;

//   @override
//   _DropdownFieldExampleState createState() => _DropdownFieldExampleState();
// }

// class _DropdownFieldExampleState extends State<DropdownFieldExample> {
//   late SingleValueDropDownController _controller;

//   @override
//   void initState() {
//     super.initState();
//     _controller = SingleValueDropDownController();
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: EdgeInsets.symmetric(vertical: 8.h),
//       child: DropDownTextField(
//         controller: _controller,
//         textFieldDecoration: InputDecoration(
//           border: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(12.r),
//             borderSide: BorderSide(color: AppColors.borderColor),
//           ),
//           // enabledBorder: OutlineInputBorder(
//           //   borderRadius: BorderRadius.circular(12.r),
//           //   borderSide: BorderSide(color: Colors.grey),
//           // ),
//           focusedBorder: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(12.r),
//             borderSide: BorderSide(color: AppColors.primaryColor),
//           ),
//           hintText: widget.hintText,
//         ),
//         dropDownItemCount: widget.items.length,
//         clearOption: false,
//         dropDownList: widget.items
//             .map((item) => DropDownValueModel(name: item, value: item))
//             .toList(),
//         onChanged: (value) {
//           if (value != null && value is DropDownValueModel) {
//             print('Selected: ${value.value}');
//           }
//         },
//       ),
//     );
//   }
// }
