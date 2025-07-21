part of 'library_resume_builder.dart';

class TipsWidget extends StatefulWidget {
  const TipsWidget({
    super.key,
    required this.step,
  });

  final int step;

  @override
  State<TipsWidget> createState() => _TipsWidgetState();
}

class _TipsWidgetState extends State<TipsWidget> {
  bool isExpanded = false;
  int oldStep = -1;

  void change() {
    if (oldStep != widget.step) {
      isExpanded = false;
      oldStep = widget.step;
    }
  }

  @override
  Widget build(BuildContext context) {
    change();
    return InkWell(
      onTap: () => setState(() => isExpanded = !isExpanded),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(16.sp),
            decoration: BoxDecoration(
              color: AppColors.whiteColor,
              borderRadius: BorderRadius.circular(10.r).copyWith(
                bottomLeft: const Radius.circular(0),
                bottomRight: const Radius.circular(0),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'What to write about',
                  style: context.textTheme.bodyLarge,
                ),
                Icon(
                  isExpanded
                      ? Icons.keyboard_arrow_down_sharp
                      : Icons.keyboard_arrow_down_sharp,
                  size: 25.sp,
                )
              ],
            ),
          ),
          AnimatedSwitcher(
            key: ValueKey<int>(widget.step),
            duration: const Duration(milliseconds: 500),
            child: isExpanded
                ? Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(14.sp),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.r).copyWith(
                          topLeft: const Radius.circular(0),
                          topRight: const Radius.circular(0),
                        ),
                        gradient: AppColors.primaryGradient),
                    child: getResumeSection(widget.step))
                : null,
          ),
        ],
      ),
    );
  }

  Widget getResumeSection(int index) {
    switch (index) {
      case 1:
        return const ResumeHeaderSection(
          showDivider: false,
          headerColor: AppColors.secondaryColor,
          header: 'Sanethia Thomas',
          sections: [
            ResumeSectionDetails(
              textColor: AppColors.secondaryColor,
              title: 'sanethia@yoursecondshot.com',
              subTitle: '555-123-4567',
            )
          ],
        );
      case 2:
        return const ResumeHeaderSection(
          showDivider: false,
          headerColor: AppColors.secondaryColor,
          header: 'Objective',
          sections: [
            ResumeSectionDetails(
              textColor: AppColors.secondaryColor,
              points: [
                'To obtain a faculty position in higher education to teach computer science and athlete development.'
              ],
            )
          ],
        );
      case 3:
        return const ResumeHeaderSection(
          showDivider: false,
          headerColor: AppColors.secondaryColor,
          header: 'Education',
          sections: [
            ResumeSectionDetails(
              textColor: AppColors.secondaryColor,
              title: 'University of Florida, Gainesville, FL',
              date: 'JUNE 2016- JUNE 2019',
              points: [
                'Doctor of Philosophy in Computer Information & Science & Engineering',
                'Human Centered Computing, User Experience, Athlete Development',
              ],
            )
          ],
        );
      case 4:
        return const ResumeHeaderSection(
          showDivider: false,
          headerColor: AppColors.secondaryColor,
          header: 'Certificates',
          sections: [
            ResumeSectionDetails(
              textColor: AppColors.secondaryColor,
              title: 'Specialist (PAADS), Gainesville, FL',
              date: 'Jan 2016 - Feb 2019',
              points: ['Professional Association of Athlete Development'],
            )
          ],
        );
      case 5:
        return const ResumeHeaderSection(
          showDivider: false,
          headerColor: AppColors.secondaryColor,
          header: 'Soft Skills',
          sections: [
            ResumeSectionDetails(
              textColor: AppColors.secondaryColor,
              points: [
                'Problem-Solver',
                'Strategic Thinker',
                'Detailed Oriented',
                'Process Oriented',
              ],
            )
          ],
        );
      case 6:
        return const ResumeHeaderSection(
          showDivider: false,
          headerColor: AppColors.secondaryColor,
          header: 'Work Experience',
          sections: [
            ResumeSectionDetails(
              textColor: AppColors.secondaryColor,
              title: 'University of Florida, Gainesville, FL',
              subTitle: 'Assistant Instructional Professor',
              date: 'JUNE 2019- Current',
              points: [
                'I develop and teach core computing classes for Computer & Information Science & Engineering Department',
                'I develop and lead experiential learning experiences for AI in computing nationally and internationally',
              ],
            )
          ],
        );
      case 7:
        return const ResumeHeaderSection(
          showDivider: false,
          headerColor: AppColors.secondaryColor,
          header: 'Volunteer Service',
          sections: [
            ResumeSectionDetails(
              textColor: AppColors.secondaryColor,
              title: 'Cape Town South Africa Study Abroad',
              date: 'JUNE 2024',
              points: [
                'I developed UF’s first AI study abroad program in Cape Town, South Africa, partnering with three nonprofit organizations to create software solutions. Projects included an AI predictive analysis map for 65,000 displaced residents, text and image generation for 269 acres of wetland conservation area, and an intelligent tutoring system for 400 students. I also organized guest speakers from local AI technology companies',
              ],
            ),
          ],
        );
      default:
        return const ResumeHeaderSection(
          showDivider: false,
          headerColor: AppColors.secondaryColor,
          header: 'Honors',
          sections: [
            ResumeSectionDetails(
              textColor: AppColors.secondaryColor,
              title: 'Cape Town South Africa Study Abroad',
              date: 'JUNE 2024',
              points: ['AI Teacher of the Year, University of Florida'],
            )
          ],
        );
    }
  }
}
