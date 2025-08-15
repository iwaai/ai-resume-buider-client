part of 'library_resume_builder.dart';

class ResumeSectionDetails extends StatelessWidget {
  const ResumeSectionDetails({
    super.key,
    this.title,
    this.subTitle,
    this.date,
    this.points,
    this.textColor,
  });

  final String? title;
  final Color? textColor;
  final String? subTitle;
  final String? date;
  final List? points;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// Title
        if (title != null && title != 'null')
          Text(title!,
              style: context.textTheme.bodyMedium
                  ?.copyWith(fontFamily: 'Times', color: textColor)),

        /// Subtitle
        if (subTitle != null && subTitle != 'null')
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(subTitle!,
                  style: context.textTheme.bodyMedium
                      ?.copyWith(fontFamily: 'Times', color: textColor)),
              SizedBox(height: 4.0.h), // Adjust as needed
            ],
          ),

        /// Date
        if (date != null &&
            date != 'null - null' &&
            date != formatDate(DateTime.now()) &&
            date !=
                '${formatDate(DateTime.now())} - ${formatDate(DateTime.now())}')
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(date!,
                  style: context.textTheme.bodyMedium
                      ?.copyWith(fontFamily: 'Times', color: textColor)),
              SizedBox(height: 6.0.h),
            ],
          ),

        /// Points
        if (points != null && points!.isNotEmpty)
          SizedBox(
            width: double.infinity, // Ensures full width usage
            child: Wrap(
              alignment: WrapAlignment.start,
              spacing: 10.0.w,
              runSpacing: 4.0.h,
              children: points!
                  .where((point) => point != 'null' && point.trim().isNotEmpty)
                  .map((point) {
                return RichText(
                  text: TextSpan(
                    style: context.textTheme.bodyMedium
                        ?.copyWith(fontFamily: 'Times', color: textColor),
                    children: [
                      TextSpan(
                        text: '• ',
                        style: TextStyle(
                            fontFamily: 'Times',
                            fontSize: 15.0.sp,
                            color: textColor),
                      ),
                      TextSpan(
                        style: const TextStyle(
                          fontFamily: 'Times',
                        ),
                        text: point,
                      ),
                    ],
                  ),
                  softWrap: true,
                  overflow: TextOverflow.clip,
                );
              }).toList(),
            ),
          ),
      ],
    );
  }
}
