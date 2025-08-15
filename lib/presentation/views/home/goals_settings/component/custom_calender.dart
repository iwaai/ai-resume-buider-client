import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:intl/intl.dart';
import 'package:second_shot/presentation/theme/theme_utils/app_colors.dart';
import 'package:second_shot/utils/constants/assets.dart';
import 'package:second_shot/utils/constants/constant.dart';
import 'package:second_shot/utils/extensions.dart';

class CustomCalendar extends StatefulWidget {
  final DateTime? minimumDate;
  final DateTime? maximumDate;
  final DateTime? initialStartDate;
  final Color primaryColor;
  final Function(DateTime)? onDateSelected;
  final Function() onCancelClick;

  const CustomCalendar({
    super.key,
    this.initialStartDate,
    this.onDateSelected,
    this.minimumDate,
    this.maximumDate,
    required this.onCancelClick,
    required this.primaryColor,
  });

  @override
  CustomCalendarState createState() => CustomCalendarState();
}

class CustomCalendarState extends State<CustomCalendar> {
  List<DateTime> dateList = <DateTime>[];
  DateTime currentMonthDate = DateTime.now();
  DateTime? selectedDate;

  @override
  void initState() {
    setListOfDate(currentMonthDate);
    if (widget.initialStartDate != null) {
      selectedDate = widget.initialStartDate;
    }
    super.initState();
  }

  void setListOfDate(DateTime monthDate) {
    dateList.clear();
    final DateTime newDate = DateTime(monthDate.year, monthDate.month, 0);
    int previousMothDay = 0;
    if (newDate.weekday < 7) {
      previousMothDay = newDate.weekday;
      for (int i = 1; i <= previousMothDay; i++) {
        dateList.add(newDate.subtract(Duration(days: previousMothDay - i)));
      }
    }
    for (int i = 0; i < (42 - previousMothDay); i++) {
      dateList.add(newDate.add(Duration(days: i + 1)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragEnd: (DragEndDetails details) {
        if (details.velocity.pixelsPerSecond.dx > 0) {
          // Swiped right (go to previous month)
          setState(() {
            currentMonthDate = DateTime(
              currentMonthDate.year,
              currentMonthDate.month - 1,
            );
            setListOfDate(currentMonthDate);
          });
        } else if (details.velocity.pixelsPerSecond.dx < 0) {
          // Swiped left (go to next month)
          setState(() {
            currentMonthDate = DateTime(
              currentMonthDate.year,
              currentMonthDate.month + 1,
            );
            setListOfDate(currentMonthDate);
          });
        }
      },
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(
              left: 12.0,
              right: 16,
              top: 12,
              bottom: 12,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SizedBox(
                  width: 20,
                ),
                Row(
                  children: <Widget>[
                    Padding(
                      padding:
                          EdgeInsets.only(right: 12.w, top: 12.h, bottom: 12.h),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(24.0)),
                          onTap: () {
                            setState(() {
                              currentMonthDate = DateTime(currentMonthDate.year,
                                  currentMonthDate.month, 0);
                              setListOfDate(currentMonthDate);
                            });
                          },
                          child: const Icon(
                            Icons.keyboard_arrow_left,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ),
                    Center(
                      child: Text(
                        DateFormat('MMMM   yyyy').format(currentMonthDate),
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    Padding(
                      padding:
                          EdgeInsets.only(left: 12.w, top: 12.h, bottom: 12.h),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(24.0)),
                          onTap: () {
                            setState(() {
                              currentMonthDate = DateTime(currentMonthDate.year,
                                  currentMonthDate.month + 2, 0);
                              setListOfDate(currentMonthDate);
                            });
                          },
                          child: const Icon(
                            Icons.keyboard_arrow_right,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                // TextButton(
                //   onPressed: () {
                //     try {
                //       widget.onCancelClick();
                //       Navigator.pop(context);
                //     } catch (_) {}
                //   },
                //   child: Image.asset(
                //     AssetConstants.crossIcon,
                //     color: AppColors.primaryColor,
                //     width: 15.w,
                //     height: 15.h,
                //   ),
                // )
                GestureDetector(
                  onTap: () {
                    try {
                      widget.onCancelClick();
                      Navigator.pop(context);
                    } catch (_) {}
                  },
                  child: Image.asset(
                    AssetConstants.crossIcon,
                    color: AppColors.primaryColor,
                    width: 15.w,
                    height: 15.h,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 8, left: 8, bottom: 8),
            child: Row(
              children: getDaysNameUI(),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 8, left: 8),
            child: Column(
              children: getDaysNoUI(),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> getDaysNameUI() {
    final List<Widget> listUI = <Widget>[];
    for (int i = 0; i < 7; i++) {
      listUI.add(
        Expanded(
          child: Center(
            child: Text(
              DateFormat('EEE').format(dateList[i]),
              style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                  color: AppColors.grey),
            ),
          ),
        ),
      );
    }
    return listUI;
  }

  List<Widget> getDaysNoUI() {
    final List<Widget> noList = <Widget>[];
    int count = 0;

    for (int i = 0; i < dateList.length / 7; i++) {
      final List<Widget> listUI = <Widget>[];

      for (int j = 0; j < 7; j++) {
        final DateTime date = dateList[count];
        bool isBeforeToday =
            date.isBefore(DateTime.now().subtract(const Duration(days: 1)));
        listUI.add(
          Expanded(
            child: AspectRatio(
              aspectRatio: 1.0,
              child: Stack(
                children: <Widget>[
                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius:
                          const BorderRadius.all(Radius.circular(32.0)),
                      onTap: () {
                        if (currentMonthDate.month == date.month) {
                          final DateTime today = DateTime.now();
                          if (date.isAfter(today) || _isSameDay(date, today)) {
                            if (widget.minimumDate != null &&
                                widget.maximumDate != null) {
                              final DateTime newMinimumDate = DateTime(
                                  widget.minimumDate!.year,
                                  widget.minimumDate!.month,
                                  widget.minimumDate!.day - 1);
                              final DateTime newMaximumDate = DateTime(
                                  widget.maximumDate!.year,
                                  widget.maximumDate!.month,
                                  widget.maximumDate!.day + 1);
                              if (date.isAfter(newMinimumDate) &&
                                  date.isBefore(newMaximumDate)) {
                                onDateClick(date);
                              }
                            } else if (widget.minimumDate != null) {
                              final DateTime newMinimumDate = DateTime(
                                  widget.minimumDate!.year,
                                  widget.minimumDate!.month,
                                  widget.minimumDate!.day - 1);
                              if (date.isAfter(newMinimumDate)) {
                                onDateClick(date);
                              }
                            } else if (widget.maximumDate != null) {
                              final DateTime newMaximumDate = DateTime(
                                  widget.maximumDate!.year,
                                  widget.maximumDate!.month,
                                  widget.maximumDate!.day + 1);
                              if (date.isBefore(newMaximumDate)) {
                                onDateClick(date);
                              }
                            } else {
                              onDateClick(date);
                            }
                          }
                        }
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(2),
                        child: Container(
                          decoration: BoxDecoration(
                            color: _isSameDay(date, selectedDate ?? DateTime(0))
                                ? widget.primaryColor
                                : Colors.transparent,
                            borderRadius:
                                const BorderRadius.all(Radius.circular(32.0)),
                            border: Border.all(
                              color:
                                  _isSameDay(date, selectedDate ?? DateTime(0))
                                      ? Colors.white
                                      : Colors.transparent,
                              width: 1,
                            ),
                            boxShadow:
                                _isSameDay(date, selectedDate ?? DateTime(0))
                                    ? <BoxShadow>[
                                        BoxShadow(
                                          color: Colors.grey.withOpacity(0.6),
                                          blurRadius: 4,
                                          offset: const Offset(0, 0),
                                        ),
                                      ]
                                    : null,
                          ),
                          child: Center(
                              child: Text(
                            '${date.day}',
                            style: TextStyle(
                              color: isBeforeToday
                                  ? j == 6
                                      ? Colors.red
                                      : AppColors.grey
                                  : _isSameDay(
                                          date, selectedDate ?? DateTime(0))
                                      ? AppColors.secondaryColor
                                      : currentMonthDate.month == date.month
                                          ? j == 6
                                              ? Colors.red
                                              : widget.primaryColor
                                          : j == 6
                                              ? Colors.red
                                              : AppColors.grey.withOpacity(0.6),
                              fontSize: MediaQuery.of(context).size.width > 360
                                  ? 18
                                  : 16,
                              fontWeight:
                                  _isSameDay(date, selectedDate ?? DateTime(0))
                                      ? FontWeight.bold
                                      : FontWeight.normal,
                            ),
                          )),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 6,
                    right: 0,
                    left: 6,
                    child: Container(
                      height: 6,
                      width: 6,
                      decoration: BoxDecoration(
                        color: DateTime.now().day == date.day &&
                                DateTime.now().month == date.month &&
                                DateTime.now().year == date.year
                            ? _isSameDay(date, selectedDate ?? DateTime(0))
                                ? Colors.white
                                : widget.primaryColor
                            : Colors.transparent,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );

        count += 1;
      }

      noList.add(
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: listUI,
        ),
      );
    }

    return noList;
  }

  bool _isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  void onDateClick(DateTime date) {
    setState(() {
      if (selectedDate != null && _isSameDay(date, selectedDate!)) {
        // If the same date is clicked again, deselect it
        selectedDate = null;
      } else {
        selectedDate = date;
      }
    });

    if (widget.onDateSelected != null && selectedDate != null) {
      widget.onDateSelected!(selectedDate!);
    }
  }
}

class CustomDateRangePicker extends StatefulWidget {
  final DateTime minimumDate;
  final DateTime maximumDate;
  final bool barrierDismissible;
  final DateTime? initialStartDate;
  final Color primaryColor;
  final Color backgroundColor;
  final Function(DateTime, DateTime) onApplyClick;
  final Function() onCancelClick;

  const CustomDateRangePicker({
    super.key,
    this.initialStartDate,
    required this.primaryColor,
    required this.backgroundColor,
    required this.onApplyClick,
    this.barrierDismissible = true,
    required this.minimumDate,
    required this.maximumDate,
    required this.onCancelClick,
  });

  @override
  CustomDateRangePickerState createState() => CustomDateRangePickerState();
}

class CustomDateRangePickerState extends State<CustomDateRangePicker>
    with TickerProviderStateMixin {
  AnimationController? animationController;
  DateTime? selectedDate;

  @override
  void initState() {
    animationController = AnimationController(
        duration: const Duration(milliseconds: 400), vsync: this);
    selectedDate = widget.initialStartDate;
    animationController?.forward();
    super.initState();
  }

  @override
  void dispose() {
    animationController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: InkWell(
          splashColor: Colors.transparent,
          focusColor: Colors.transparent,
          highlightColor: Colors.transparent,
          hoverColor: Colors.transparent,
          onTap: () {
            if (widget.barrierDismissible) {
              Navigator.pop(context);
            }
          },
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Container(
                decoration: BoxDecoration(
                  color: widget.backgroundColor,
                  borderRadius: const BorderRadius.all(Radius.circular(24.0)),
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        offset: const Offset(4, 4),
                        blurRadius: 8.0),
                  ],
                ),
                child: InkWell(
                  borderRadius: const BorderRadius.all(Radius.circular(24.0)),
                  onTap: () {},
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      CustomCalendar(
                        minimumDate: widget.minimumDate,
                        maximumDate: widget.maximumDate,
                        initialStartDate: widget.initialStartDate,
                        primaryColor: widget.primaryColor,
                        onDateSelected: (DateTime date) {
                          setState(() {
                            selectedDate = date;
                          });
                        },
                        onCancelClick: widget.onCancelClick,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 16, right: 16, bottom: 16, top: 16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            TextButton(
                              onPressed: () {
                                try {
                                  widget.onCancelClick();
                                  Navigator.pop(context);
                                } catch (_) {}
                              },
                              child: Text("Cancel",
                                  style: context.textTheme.titleMedium
                                      ?.copyWith(
                                          color: AppColors.grey,
                                          decoration: TextDecoration.underline,
                                          decorationColor:
                                              AppColors.primaryColor)),
                            ),
                            const SizedBox(width: 16),
                            InkWell(
                                onTap: () {
                                  try {
                                    if (selectedDate != null) {
                                      widget.onApplyClick(
                                          selectedDate!, selectedDate!);
                                      Navigator.pop(context);
                                    }
                                  } catch (_) {}
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: AppColors.primaryColor,
                                      borderRadius: BorderRadius.circular(8)),
                                  padding: EdgeInsets.symmetric(
                                      horizontal: Constant.horizontalPadding.w,
                                      vertical: Constant.verticalPadding.h / 3),
                                  child: Text("Save",
                                      style: context.textTheme.titleMedium
                                          ?.copyWith(
                                        color: AppColors.whiteColor,
                                      )),
                                )),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

void showCustomDateRangePicker(
  BuildContext context, {
  required bool dismissible,
  required DateTime minimumDate,
  required DateTime maximumDate,
  DateTime? initialDate,
  required Function(DateTime selectedDate) onDateSelected,
  required Function() onCancelClick,
  required Color backgroundColor,
  required Color primaryColor,
}) {
  /// Request focus to take it away from any input field that might be in focus
  FocusScope.of(context).requestFocus(FocusNode());

  /// Show the CustomDateRangePicker dialog box
  showDialog<dynamic>(
    context: context,
    builder: (BuildContext context) => CustomDateRangePicker(
      barrierDismissible: dismissible,
      backgroundColor: backgroundColor,
      primaryColor: primaryColor,
      minimumDate: minimumDate,
      maximumDate: maximumDate,
      initialStartDate: initialDate,
      onApplyClick: (DateTime startDate, DateTime endDate) {
        // For single date selection, we only use the startDate
        onDateSelected(startDate);
      },
      onCancelClick: onCancelClick,
    ),
  );
}



// class CustomDateRangePicker extends StatefulWidget {
//   final DateTime minimumDate;

//   final DateTime maximumDate;

//   final bool barrierDismissible;

//   final DateTime? initialStartDate;

//   final DateTime? initialEndDate;

//   /// The primary color used for the date range picker.
//   final Color primaryColor;

//   /// The background color used for the date range picker.
//   final Color backgroundColor;

//   /// A callback function that is called when the user applies the selected date range.
//   final Function(DateTime, DateTime) onApplyClick;

//   /// A callback function that is called when the user cancels the selection of the date range.
//   final Function() onCancelClick;

//   const CustomDateRangePicker({
//     super.key,
//     this.initialStartDate,
//     this.initialEndDate,
//     required this.primaryColor,
//     required this.backgroundColor,
//     required this.onApplyClick,
//     this.barrierDismissible = true,
//     required this.minimumDate,
//     required this.maximumDate,
//     required this.onCancelClick,
//   });

//   @override
//   CustomDateRangePickerState createState() => CustomDateRangePickerState();
// }

// class CustomDateRangePickerState extends State<CustomDateRangePicker>
//     with TickerProviderStateMixin {
//   AnimationController? animationController;

//   DateTime? startDate;

//   DateTime? endDate;

//   @override
//   void initState() {
//     animationController = AnimationController(
//         duration: const Duration(milliseconds: 400), vsync: this);
//     startDate = widget.initialStartDate;
//     endDate = widget.initialEndDate;
//     animationController?.forward();
//     super.initState();
//   }

//   @override
//   void dispose() {
//     animationController?.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Center(
//       child: Scaffold(
//         backgroundColor: Colors.transparent,
//         body: InkWell(
//           splashColor: Colors.transparent,
//           focusColor: Colors.transparent,
//           highlightColor: Colors.transparent,
//           hoverColor: Colors.transparent,
//           onTap: () {
//             if (widget.barrierDismissible) {
//               Navigator.pop(context);
//             }
//           },
//           child: Center(
//             child: Padding(
//               padding: const EdgeInsets.all(24.0),
//               child: Container(
//                 decoration: BoxDecoration(
//                   color: widget.backgroundColor,
//                   borderRadius: const BorderRadius.all(Radius.circular(24.0)),
//                   boxShadow: <BoxShadow>[
//                     BoxShadow(
//                         color: Colors.grey.withOpacity(0.2),
//                         offset: const Offset(4, 4),
//                         blurRadius: 8.0),
//                   ],
//                 ),
//                 child: InkWell(
//                   borderRadius: const BorderRadius.all(Radius.circular(24.0)),
//                   onTap: () {},
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     mainAxisSize: MainAxisSize.min,
//                     children: <Widget>[
//                       // Row(
//                       //   children: <Widget>[
//                       //     Expanded(
//                       //       child: Column(
//                       //         mainAxisAlignment: MainAxisAlignment.center,
//                       //         crossAxisAlignment: CrossAxisAlignment.center,
//                       //         children: <Widget>[
//                       //           Text(
//                       //             'From',
//                       //             textAlign: TextAlign.left,
//                       //             style: TextStyle(
//                       //               fontWeight: FontWeight.w400,
//                       //               fontSize: 16,
//                       //               color: Colors.grey.shade700,
//                       //             ),
//                       //           ),
//                       //           const SizedBox(
//                       //             height: 4,
//                       //           ),
//                       //           Text(
//                       //             startDate != null
//                       //                 ? DateFormat('EEE, dd MMM')
//                       //                     .format(startDate!)
//                       //                 : '--/-- ',
//                       //             style: TextStyle(
//                       //               fontWeight: FontWeight.bold,
//                       //               fontSize: 16,
//                       //               color: Colors.grey.shade700,
//                       //             ),
//                       //           ),
//                       //         ],
//                       //       ),
//                       //     ),
//                       //     Container(
//                       //       height: 74,
//                       //       width: 1,
//                       //       color: Theme.of(context).dividerColor,
//                       //     ),
//                       //     Expanded(
//                       //       child: Column(
//                       //         mainAxisAlignment: MainAxisAlignment.center,
//                       //         crossAxisAlignment: CrossAxisAlignment.center,
//                       //         children: <Widget>[
//                       //           Text(
//                       //             'To',
//                       //             style: TextStyle(
//                       //               fontWeight: FontWeight.w400,
//                       //               fontSize: 16,
//                       //               color: Colors.grey.shade700,
//                       //             ),
//                       //           ),
//                       //           const SizedBox(
//                       //             height: 4,
//                       //           ),
//                       //           Text(
//                       //             endDate != null
//                       //                 ? DateFormat('EEE, dd MMM')
//                       //                     .format(endDate!)
//                       //                 : '--/-- ',
//                       //             style: TextStyle(
//                       //               fontWeight: FontWeight.bold,
//                       //               fontSize: 16,
//                       //               color: Colors.grey.shade700,
//                       //             ),
//                       //           ),
//                       //         ],
//                       //       ),
//                       //     )
//                       //   ],
//                       // ),
//                       // const Divider(
//                       //   height: 1,
//                       // ),
//                       CustomCalendar(
//                         minimumDate: widget.minimumDate,
//                         maximumDate: widget.maximumDate,
//                         initialEndDate: widget.initialEndDate,
//                         initialStartDate: widget.initialStartDate,
//                         primaryColor: widget.primaryColor,
//                         startEndDateChange:
//                             (DateTime startDateData, DateTime endDateData) {
//                           setState(() {
//                             startDate = startDateData;
//                             endDate = endDateData;
//                           });
//                         },
//                         onCancelClick: widget.onCancelClick,
//                       ),
//                       Padding(
//                         padding: const EdgeInsets.only(
//                             left: 16, right: 16, bottom: 16, top: 16),
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             // Expanded(
//                             //   child: Container(
//                             //     height: 48,
//                             //     decoration: const BoxDecoration(
//                             //       borderRadius:
//                             //           BorderRadius.all(Radius.circular(24.0)),
//                             //     ),
//                             //     child: OutlinedButton(
//                             //       style: ButtonStyle(
//                             //         side: WidgetStateProperty.all(
//                             //             BorderSide(color: widget.primaryColor)),
//                             //         shape: WidgetStateProperty.all(
//                             //           const RoundedRectangleBorder(
//                             //             borderRadius: BorderRadius.all(
//                             //                 Radius.circular(24.0)),
//                             //           ),
//                             //         ),
//                             //         backgroundColor: WidgetStateProperty.all(
//                             //             widget.primaryColor),
//                             //       ),
//                             //       onPressed: () {
//                             //         try {
//                             //           widget.onCancelClick();
//                             //           Navigator.pop(context);
//                             //         } catch (_) {}
//                             //       },
//                             //       child: const Center(
//                             //         child: Text(
//                             //           'Cancel',
//                             //           style: TextStyle(
//                             //             fontWeight: FontWeight.w500,
//                             //             fontSize: 18,
//                             //             color: Colors.white,
//                             //           ),
//                             //         ),
//                             //       ),
//                             //     ),
//                             //   ),
//                             // ),
//                             TextButton(
//                               onPressed: () {
//                                 try {
//                                   widget.onCancelClick();
//                                   Navigator.pop(context);
//                                 } catch (_) {}
//                               },
//                               child: Text("Cancel",
//                                   style: context.textTheme.titleMedium
//                                       ?.copyWith(
//                                           color: AppColors.grey,
//                                           decoration: TextDecoration.underline,
//                                           decorationColor:
//                                               AppColors.primaryColor)),
//                             ),
//                             const SizedBox(width: 16),
//                             InkWell(
//                                 onTap: () {
//                                   try {
//                                     widget.onApplyClick(startDate!, endDate!);
//                                     Navigator.pop(context);
//                                   } catch (_) {}
//                                 },
//                                 child: Container(
//                                   decoration: BoxDecoration(
//                                       color: AppColors.primaryColor,
//                                       borderRadius: BorderRadius.circular(8)),
//                                   padding: EdgeInsets.symmetric(
//                                       horizontal: Constant.horizontalPadding.w,
//                                       vertical: Constant.verticalPadding.h / 3),
//                                   child: Text("Save",
//                                       style: context.textTheme.titleMedium
//                                           ?.copyWith(
//                                         color: AppColors.whiteColor,
//                                       )),
//                                 )),

//                             // Expanded(
//                             //   child: Container(
//                             //     // height: 48,
//                             //     decoration: const BoxDecoration(
//                             //       borderRadius:
//                             //           BorderRadius.all(Radius.circular(24.0)),
//                             //     ),
//                             //     child: InkWell(
//                             //       // style: ButtonStyle(
//                             //       //   side: WidgetStateProperty.all(
//                             //       //       BorderSide(color: widget.primaryColor)),
//                             //       //   shape: WidgetStateProperty.all(
//                             //       //     const RoundedRectangleBorder(
//                             //       //       borderRadius: BorderRadius.all(
//                             //       //           Radius.circular(24.0)),
//                             //       //     ),
//                             //       //   ),
//                             //       //   backgroundColor: WidgetStateProperty.all(
//                             //       //       widget.primaryColor),
//                             //       // ),
//                             //       onTap: () {
//                             //         try {
//                             //           widget.onApplyClick(startDate!, endDate!);
//                             //           Navigator.pop(context);
//                             //         } catch (_) {}
//                             //       },
//                             //       child: const Center(
//                             //         child: Text(
//                             //           'Apply',
//                             //           style: TextStyle(
//                             //             fontWeight: FontWeight.w500,
//                             //             fontSize: 14,
//                             //             color: Colors.white,
//                             //           ),
//                             //         ),
//                             //       ),
//                             //     ),
//                             //   ),
//                             // ),
//                           ],
//                         ),
//                       )
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

// /// Displays a custom date range picker dialog box.
// /// `context` The context in which to show the dialog.
// /// `dismissible` A boolean value indicating whether the dialog can be dismissed by tapping outside of it.
// /// `minimumDate` A DateTime object representing the minimum allowable date that can be selected in the date range picker.
// /// `maximumDate` A DateTime object representing the maximum allowable date that can be selected in the date range picker.
// /// `startDate` A nullable DateTime object representing the initial start date of the date range selection.
// /// `endDate` A nullable DateTime object representing the initial end date of the date range selection.
// /// `onApplyClick` A function that takes two DateTime parameters representing the selected start and end dates, respectively, and is called when the user taps the "Apply" button.
// /// `onCancelClick` A function that is called when the user taps the "Cancel" button.
// /// `backgroundColor` The background color of the dialog.
// /// `primaryColor` The primary color of the dialog.
// /// `fontFamily` The font family to use for the text in the dialog.

// void showCustomDateRangePicker(
//   BuildContext context, {
//   required bool dismissible,
//   required DateTime minimumDate,
//   required DateTime maximumDate,
//   DateTime? startDate,
//   DateTime? endDate,
//   required Function(DateTime startDate, DateTime endDate) onApplyClick,
//   required Function() onCancelClick,
//   required Color backgroundColor,
//   required Color primaryColor,
//   String? fontFamily,
// }) {
//   /// Request focus to take it away from any input field that might be in focus
//   FocusScope.of(context).requestFocus(FocusNode());

//   /// Show the CustomDateRangePicker dialog box
//   showDialog<dynamic>(
//     context: context,
//     builder: (BuildContext context) => CustomDateRangePicker(
//       barrierDismissible: true,
//       backgroundColor: backgroundColor,
//       primaryColor: primaryColor,
//       minimumDate: minimumDate,
//       maximumDate: maximumDate,
//       initialStartDate: startDate,
//       initialEndDate: endDate,
//       onApplyClick: onApplyClick,
//       onCancelClick: onCancelClick,
//     ),
//   );
// }

// class CustomCalendar extends StatefulWidget {
//   /// The minimum date that can be selected on the calendar
//   final DateTime? minimumDate;

//   /// The maximum date that can be selected on the calendar
//   final DateTime? maximumDate;

//   /// The initial start date to be shown on the calendar
//   final DateTime? initialStartDate;

//   /// The initial end date to be shown on the calendar
//   final DateTime? initialEndDate;

//   /// The primary color to be used in the calendar's color scheme
//   final Color primaryColor;

//   /// A function to be called when the selected date range changes
//   final Function(DateTime, DateTime)? startEndDateChange;

//   final Function() onCancelClick;

//   const CustomCalendar({
//     super.key,
//     this.initialStartDate,
//     this.initialEndDate,
//     this.startEndDateChange,
//     this.minimumDate,
//     this.maximumDate,
//     required this.onCancelClick,
//     required this.primaryColor,
//   });

//   @override
//   CustomCalendarState createState() => CustomCalendarState();
// }

// class CustomCalendarState extends State<CustomCalendar> {
//   List<DateTime> dateList = <DateTime>[];

//   DateTime currentMonthDate = DateTime.now();

//   DateTime? startDate;

//   DateTime? endDate;

//   @override
//   void initState() {
//     setListOfDate(currentMonthDate);
//     if (widget.initialStartDate != null) {
//       startDate = widget.initialStartDate;
//     }
//     if (widget.initialEndDate != null) {
//       endDate = widget.initialEndDate;
//     }
//     super.initState();
//   }

//   @override
//   void dispose() {
//     super.dispose();
//   }

//   // void setListOfDate(DateTime monthDate) {
//   //   dateList.clear();
//   //   // Get the last day of the previous month
//   //   final DateTime newDate = DateTime(monthDate.year, monthDate.month, 0);
//   //   // Calculate how many days back we need to go to get to Sunday
//   //   int previousMonthDays = newDate.weekday;
//   //   // If the first day of the month is not Sunday, calculate how many days we need to subtract to get to Sunday
//   //   if (previousMonthDays != 7) {
//   //     previousMonthDays = newDate.weekday ; // Get the weekday (1=Mon, 7=Sun)
//   //   } else {
//   //     previousMonthDays = 0;
//   //   }
//   //   // Add previous month's days (from Sunday of the last week to the end of the last month)
//   //   for (int i = 0; i < previousMonthDays; i++) {
//   //     dateList.add(newDate.subtract(Duration(days: previousMonthDays - i)));
//   //   }
//   //   // Add current month's dates (7 days per week, ensuring the right number of days are displayed)
//   //   for (int i = 0; i < (42 - previousMonthDays); i++) {
//   //     dateList.add(newDate.add(Duration(days: i + 1)));
//   //   }
//   // }

//   void setListOfDate(DateTime monthDate) {
//     dateList.clear();
//     final DateTime newDate = DateTime(monthDate.year, monthDate.month, 0);
//     int previousMothDay = 0;
//     if (newDate.weekday < 7) {
//       previousMothDay = newDate.weekday;
//       for (int i = 1; i <= previousMothDay; i++) {
//         dateList.add(newDate.subtract(Duration(days: previousMothDay - i)));
//       }
//     }
//     for (int i = 0; i < (42 - previousMothDay); i++) {
//       dateList.add(newDate.add(Duration(days: i + 1)));
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onHorizontalDragEnd: (DragEndDetails details) {
//         if (details.velocity.pixelsPerSecond.dx > 0) {
//           // Swiped right (go to previous month)
//           setState(() {
//             currentMonthDate = DateTime(
//               currentMonthDate.year,
//               currentMonthDate.month - 1,
//             );
//             setListOfDate(currentMonthDate);
//           });
//         } else if (details.velocity.pixelsPerSecond.dx < 0) {
//           // Swiped left (go to next month)
//           setState(() {
//             currentMonthDate = DateTime(
//               currentMonthDate.year,
//               currentMonthDate.month + 1,
//             );
//             setListOfDate(currentMonthDate);
//           });
//         }
//       },
//       child: Column(
//         children: <Widget>[
//           Padding(
//             padding: const EdgeInsets.only(
//               left: 12.0,
//               right: 0,
//               top: 12,
//               bottom: 12,
//             ),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Row(
//                   children: <Widget>[
//                     Padding(
//                       padding:
//                           EdgeInsets.only(right: 12.w, top: 12.h, bottom: 12.h),
//                       child: Material(
//                         color: Colors.transparent,
//                         child: InkWell(
//                           borderRadius:
//                               const BorderRadius.all(Radius.circular(24.0)),
//                           onTap: () {
//                             setState(() {
//                               currentMonthDate = DateTime(currentMonthDate.year,
//                                   currentMonthDate.month, 0);
//                               setListOfDate(currentMonthDate);
//                             });
//                           },
//                           child: const Icon(
//                             Icons.keyboard_arrow_left,
//                             color: Colors.grey,
//                           ),
//                         ),
//                       ),
//                     ),
//                     Center(
//                       child: Text(
//                         DateFormat('MMMM   yyyy').format(currentMonthDate),
//                         style: const TextStyle(
//                           fontWeight: FontWeight.w600,
//                           fontSize: 16,
//                         ),
//                       ),
//                     ),
//                     Padding(
//                       padding:
//                           EdgeInsets.only(left: 12.w, top: 12.h, bottom: 12.h),
//                       child: Material(
//                         color: Colors.transparent,
//                         child: InkWell(
//                           borderRadius:
//                               const BorderRadius.all(Radius.circular(24.0)),
//                           onTap: () {
//                             setState(() {
//                               currentMonthDate = DateTime(currentMonthDate.year,
//                                   currentMonthDate.month + 2, 0);
//                               setListOfDate(currentMonthDate);
//                             });
//                           },
//                           child: const Icon(
//                             Icons.keyboard_arrow_right,
//                             color: Colors.grey,
//                           ),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//                 TextButton(
//                   onPressed: () {
//                     try {
//                       widget.onCancelClick();
//                       Navigator.pop(context);
//                     } catch (_) {}
//                   },
//                   child: Image.asset(
//                     AssetConstants.crossIcon,
//                     color: AppColors.primaryColor,
//                     width: 15.w,
//                     height: 15.h,
//                   ),
//                 )
//               ],
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.only(right: 8, left: 8, bottom: 8),
//             child: Row(
//               children: getDaysNameUI(),
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.only(right: 8, left: 8),
//             child: Column(
//               children: getDaysNoUI(),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   List<Widget> getDaysNameUI() {
//     final List<Widget> listUI = <Widget>[];
//     for (int i = 0; i < 7; i++) {
//       listUI.add(
//         Expanded(
//           child: Center(
//             child: Text(
//               DateFormat('EEE').format(dateList[i]),
//               style: TextStyle(
//                   fontSize: 14.sp,
//                   fontWeight: FontWeight.w500,
//                   color: AppColors.grey),
//             ),
//           ),
//         ),
//       );
//     }
//     return listUI;
//   }

//   List<Widget> getDaysNoUI() {
//     final List<Widget> noList = <Widget>[];
//     int count = 0;

//     for (int i = 0; i < dateList.length / 7; i++) {
//       final List<Widget> listUI = <Widget>[];

//       for (int j = 0; j < 7; j++) {
//         final DateTime date = dateList[count];
//         bool isBeforeToday =
//             date.isBefore(DateTime.now().subtract(const Duration(days: 1)));
//         // Check if the day is Saturday (6) or Sunday (7)
//         listUI.add(
//           Expanded(
//             child: AspectRatio(
//               aspectRatio: 1.0,
//               child: Stack(
//                 children: <Widget>[
//                   Padding(
//                     padding: const EdgeInsets.only(top: 3, bottom: 3),
//                     child: Material(
//                       color: Colors.transparent,
//                       child: Padding(
//                         padding: EdgeInsets.only(
//                           top: 2,
//                           bottom: 2,
//                           left: isStartDateRadius(date) ? 4 : 0,
//                           right: isEndDateRadius(date) ? 4 : 0,
//                         ),
//                         child: Container(
//                           decoration: BoxDecoration(
//                             color: startDate != null && endDate != null
//                                 ? getIsItStartAndEndDate(date) ||
//                                         getIsInRange(date)
//                                     ? widget.primaryColor.withOpacity(0.4)
//                                     : Colors.transparent
//                                 : Colors.transparent,
//                             borderRadius: BorderRadius.only(
//                               bottomLeft: isStartDateRadius(date)
//                                   ? const Radius.circular(24.0)
//                                   : const Radius.circular(0.0),
//                               topLeft: isStartDateRadius(date)
//                                   ? const Radius.circular(24.0)
//                                   : const Radius.circular(0.0),
//                               topRight: isEndDateRadius(date)
//                                   ? const Radius.circular(24.0)
//                                   : const Radius.circular(0.0),
//                               bottomRight: isEndDateRadius(date)
//                                   ? const Radius.circular(24.0)
//                                   : const Radius.circular(0.0),
//                             ),
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                   Material(
//                     color: Colors.transparent,
//                     child: InkWell(
//                       borderRadius:
//                           const BorderRadius.all(Radius.circular(32.0)),
//                       onTap: () {
//                         if (currentMonthDate.month == date.month) {
//                           // Ensure date is after today
//                           final DateTime today = DateTime.now();
//                           if (date.isAfter(today) || _isSameDay(date, today)) {
//                             if (widget.minimumDate != null &&
//                                 widget.maximumDate != null) {
//                               final DateTime newMinimumDate = DateTime(
//                                   widget.minimumDate!.year,
//                                   widget.minimumDate!.month,
//                                   widget.minimumDate!.day - 1);
//                               final DateTime newMaximumDate = DateTime(
//                                   widget.maximumDate!.year,
//                                   widget.maximumDate!.month,
//                                   widget.maximumDate!.day + 1);
//                               if (date.isAfter(newMinimumDate) &&
//                                   date.isBefore(newMaximumDate)) {
//                                 onDateClick(date);
//                               }
//                             } else if (widget.minimumDate != null) {
//                               final DateTime newMinimumDate = DateTime(
//                                   widget.minimumDate!.year,
//                                   widget.minimumDate!.month,
//                                   widget.minimumDate!.day - 1);
//                               if (date.isAfter(newMinimumDate)) {
//                                 onDateClick(date);
//                               }
//                             } else if (widget.maximumDate != null) {
//                               final DateTime newMaximumDate = DateTime(
//                                   widget.maximumDate!.year,
//                                   widget.maximumDate!.month,
//                                   widget.maximumDate!.day + 1);
//                               if (date.isBefore(newMaximumDate)) {
//                                 onDateClick(date);
//                               }
//                             } else {
//                               onDateClick(date);
//                             }
//                           }
//                         }
//                       },
//                       child: Padding(
//                         padding: const EdgeInsets.all(2),
//                         child: Container(
//                           decoration: BoxDecoration(
//                             color: getIsItStartAndEndDate(date)
//                                 ? widget.primaryColor
//                                 : Colors.transparent,
//                             borderRadius:
//                                 const BorderRadius.all(Radius.circular(32.0)),
//                             border: Border.all(
//                               color: getIsItStartAndEndDate(date)
//                                   ? Colors.white
//                                   : Colors.transparent,
//                               width: 1,
//                             ),
//                             boxShadow: getIsItStartAndEndDate(date)
//                                 ? <BoxShadow>[
//                                     BoxShadow(
//                                       color: Colors.grey.withOpacity(0.6),
//                                       blurRadius: 4,
//                                       offset: const Offset(0, 0),
//                                     ),
//                                   ]
//                                 : null,
//                           ),
//                           child: Center(
//                               child: Text(
//                             '${date.day}',
//                             style: TextStyle(
//                               color: isBeforeToday
//                                   ? j == 6
//                                       ? Colors.red
//                                       : AppColors.grey
//                                   // Color for past dates
//                                   : getIsItStartAndEndDate(date)
//                                       ? AppColors.secondaryColor
//                                       : currentMonthDate.month == date.month
//                                           ? j == 6
//                                               ? Colors.red
//                                               : widget.primaryColor
//                                           : j == 6
//                                               ? Colors.red
//                                               : AppColors.grey.withOpacity(0.6),
//                               fontSize: MediaQuery.of(context).size.width > 360
//                                   ? 18
//                                   : 16,
//                               fontWeight: getIsItStartAndEndDate(date)
//                                   ? FontWeight.bold
//                                   : FontWeight.normal,
//                             ),
//                           )),
//                         ),
//                       ),
//                     ),
//                   ),
//                   Positioned(
//                     bottom: 9,
//                     right: 0,
//                     left: 0,
//                     child: Container(
//                       height: 6,
//                       width: 6,
//                       decoration: BoxDecoration(
//                         color: DateTime.now().day == date.day &&
//                                 DateTime.now().month == date.month &&
//                                 DateTime.now().year == date.year
//                             ? getIsInRange(date)
//                                 ? Colors.white
//                                 : widget.primaryColor
//                             : Colors.transparent,
//                         shape: BoxShape.circle,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         );

//         count += 1;
//       }

//       noList.add(
//         Row(
//           mainAxisAlignment: MainAxisAlignment.center,
//           crossAxisAlignment: CrossAxisAlignment.center,
//           mainAxisSize: MainAxisSize.min,
//           children: listUI,
//         ),
//       );
//     }

//     return noList;
//   }

// // Helper method to check if two dates are the same day
//   bool _isSameDay(DateTime date1, DateTime date2) {
//     return date1.year == date2.year &&
//         date1.month == date2.month &&
//         date1.day == date2.day;
//   }

//   bool getIsInRange(DateTime date) {
//     if (startDate != null && endDate != null) {
//       if (date.isAfter(startDate!) && date.isBefore(endDate!)) {
//         return true;
//       } else {
//         return false;
//       }
//     } else {
//       return false;
//     }
//   }

//   bool getIsItStartAndEndDate(DateTime date) {
//     if (startDate != null &&
//         startDate!.day == date.day &&
//         startDate!.month == date.month &&
//         startDate!.year == date.year) {
//       return true;
//     } else if (endDate != null &&
//         endDate!.day == date.day &&
//         endDate!.month == date.month &&
//         endDate!.year == date.year) {
//       return true;
//     } else {
//       return false;
//     }
//   }

//   bool isStartDateRadius(DateTime date) {
//     if (startDate != null &&
//         startDate!.day == date.day &&
//         startDate!.month == date.month) {
//       return true;
//     } else if (date.weekday == 1) {
//       return true;
//     } else {
//       return false;
//     }
//   }

//   bool isEndDateRadius(DateTime date) {
//     if (endDate != null &&
//         endDate!.day == date.day &&
//         endDate!.month == date.month) {
//       return true;
//     } else if (date.weekday == 7) {
//       return true;
//     } else {
//       return false;
//     }
//   }

//   // void onDateClick(DateTime date) {
//   //   if (startDate == null) {
//   //     startDate = date;
//   //   } else if (startDate != date && endDate == null) {
//   //     endDate = date;
//   //   } else if (startDate!.day == date.day && startDate!.month == date.month) {
//   //     startDate = null;
//   //   } else if (endDate!.day == date.day && endDate!.month == date.month) {
//   //     endDate = null;
//   //   }
//   //   if (startDate == null && endDate != null) {
//   //     startDate = endDate;
//   //     endDate = null;
//   //   }
//   //   if (startDate != null && endDate != null) {
//   //     if (!endDate!.isAfter(startDate!)) {
//   //       final DateTime d = startDate!;
//   //       startDate = endDate;
//   //       endDate = d;
//   //     }
//   //     if (date.isBefore(startDate!)) {
//   //       startDate = date;
//   //     }
//   //     if (date.isAfter(endDate!)) {
//   //       endDate = date;
//   //     }
//   //   }
//   //   setState(() {
//   //     try {
//   //       widget.startEndDateChange!(startDate!, endDate!);
//   //     } catch (_) {}
//   //   });
//   // }
//   void onDateClick(DateTime date) {
//     if (startDate == null) {
//       startDate = date;
//     } else if (startDate != date && endDate == null) {
//       // Ensure start and end dates are properly set, even if they span two months
//       if (date.isBefore(startDate!)) {
//         endDate = startDate;
//         startDate = date;
//       } else {
//         endDate = date;
//       }
//     } else if (startDate!.isAtSameMomentAs(date)) {
//       // If the user selects the same date again, reset the start date
//       startDate = null;
//     } else if (endDate!.isAtSameMomentAs(date)) {
//       // If the user selects the same end date again, reset the end date
//       endDate = null;
//     } else {
//       // If both start and end dates are already set
//       if (date.isBefore(startDate!)) {
//         startDate = date;
//       } else if (date.isAfter(endDate!)) {
//         endDate = date;
//       }
//     }

//     // If only the start date is set, allow the user to select the end date
//     if (startDate != null && endDate == null) {
//       endDate =
//           startDate; // Just to ensure the end date exists if only one date is selected
//     }

//     // Ensure the dates are always ordered correctly (start date before end date)
//     if (startDate != null && endDate != null && !endDate!.isAfter(startDate!)) {
//       final DateTime temp = startDate!;
//       startDate = endDate;
//       endDate = temp;
//     }

//     // Update the state and notify the widget about the new range
//     setState(() {
//       try {
//         widget.startEndDateChange!(startDate!, endDate!);
//       } catch (_) {}
//     });
//   }
// }
