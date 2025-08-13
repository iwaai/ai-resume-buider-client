part of 'library_resume_builder.dart';

class StepperHeaderText extends StatelessWidget {
  StepperHeaderText({
    super.key,
    required this.step,
  });

  final int step;

  final Map<int, Map<String, String>> stepContent = {
    1: {
      'header': 'Personal Information',
      'description':
          'We’ve collected your contact information from your profile. Feel free to make changes.',
    },
    2: {
      'header': 'Objective',
      'description':
          """Writing an objective on a resume is a great way to quickly communicate your career goals and how you can contribute to the job you're applying for. Keep in mind you can change this for each job that you are applying for.""",
    },
    3: {
      'header': 'Education',
      'description': 'List your degrees you have earned.',
    },
    4: {
      'header': 'Licenses & Certifications',
      'description':
          'List your relevant licenses and certifications to highlight your skills and qualifications. Include details like issuing organizations, dates, and credentials to strengthen your profile.',
    },
    5: {
      'header': 'Select Soft Skills',
      'description':
          'Add personal qualities like communication, teamwork, and problem-solving.',
    },
    6: {
      'header': 'Work Experience',
      'description':
          'Narrate your professional endeavours and milestones to showcase your skills, achievements, and career progress.',
    },
    7: {
      'header': 'Volunteer Experience',
      'description':
          'Highlight your volunteer work to show dedication to community service and a positive impact, demonstrating your commitment to helping others.',
    },
    8: {
      'header': 'Honors & Awards',
      'description':
          'Highlight your recognition and awards to showcase your achievements, distinguish your expertise, and demonstrate your professional excellence.',
    },
  };

  final String defaultHeader = 'Add Technical Skills';
  final String defaultDescription =
      'Add job-specific abilities such as coding, data analysis, or using specialized tools.';

  @override
  Widget build(BuildContext context) {
    final content = stepContent[step] ??
        {'header': defaultHeader, 'description': defaultDescription};

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 500),
      child: Column(
        key: ValueKey<int>(step),
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(content['header']!, style: context.textTheme.titleLarge),
          Text(content['description']!, style: context.textTheme.bodyMedium),
          SizedBox(height: 10.h),
        ],
      ),
    );
  }
}
