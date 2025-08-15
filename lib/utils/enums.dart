enum Education {
  middleSchool,
  highSchool,
  college,
  recentCollegeGraduate,
  earlyProfessional,
  careerChangeProfessional;

  // Adding a method to the enum
  @override
  String toString() {
    switch (this) {
      case Education.middleSchool:
        return 'Middle School';
      case Education.highSchool:
        return 'High School';
      case Education.college:
        return 'College';
      case Education.recentCollegeGraduate:
        return 'Recent College Graduate';
      case Education.earlyProfessional:
        return 'Masters';
      case Education.careerChangeProfessional:
        return 'PHD';
      default:
        return '';
    }
  }
}

enum ConfirmationStatus { Yes, No }

enum GoalStatus {
  pending,
  in_progress,
  completed;

  @override
  String toString() {
    switch (this) {
      case GoalStatus.pending:
        return "Pending";
      case GoalStatus.in_progress:
        return "In Progress";
      case GoalStatus.completed:
        return "Completed";
      default:
        return "Unknown Goal";
    }
  }
}

enum SkillEnums {
  leadership,
  communication,
  strategy,
  hardWork,
  teamWork;

  @override
  String toString() {
    switch (this) {
      case SkillEnums.leadership:
        return "Leadership";
      case SkillEnums.communication:
        return "Communication";
      case SkillEnums.strategy:
        return "Strategy";
      case SkillEnums.hardWork:
        return "Hard Work";
      case SkillEnums.teamWork:
        return "Team Work";
      default:
        return "Unknown Skill";
    }
  }
}

const List<String> afterHighSchoolSpecializations = [
  'I don\'t know',
  'Accounting',
  'Agricultural and Biological Engineering',
  'Anthropology',
  'Architecture',
  'Arts',
  'Astronomy',
  'Biochemistry',
  'Biomedical Engineering',
  'Business Administration',
  'Chemical Engineering',
  'Chemistry',
  'Civil Engineering',
  'Communications',
  'Computer Engineering',
  'Computer Science',
  'Criminology',
  'Digital Arts and Sciences',
  'Economics',
  'Electrical Engineering',
  'English',
  'Environmental Science',
  'Finance',
  'Food Science and Human Nutrition',
  'History',
  'Journalism',
  'Linguistics',
  'Management',
  'Marketing',
  'Materials Science and Engineering',
  'Mathematics',
  'Mechanical Engineering',
  'Microbiology and Cell Science',
  'Music',
  'Neuroscience',
  'Nursing',
  'Philosophy',
  'Physics',
  'Political Science',
  'Psychology',
  'Sociology',
  'Sport Management',
  'Statistics',
  'Theatre',
  'Wildlife Ecology and Conservation',
];

const List<String> highSchoolSpecializations = [
  'I don\'t know',
  'Accounting',
  'Agricultural and Biological Engineering',
  'Anthropology',
  'Architecture',
  'Arts',
  'Astronomy',
  'Biochemistry',
  'Biomedical Engineering',
  'Business Administration',
  'Chemical Engineering',
  'Chemistry',
  'Civil Engineering',
  'Communications',
  'Computer Engineering',
  'Computer Science',
  'Criminology',
  'Digital Arts and Sciences',
  'Economics',
  'Electrical Engineering',
  'English',
  'Environmental Science',
  'Finance',
  'Food Science and Human Nutrition',
  'History',
  'Journalism',
  'Linguistics',
  'Management',
  'Marketing',
  'Materials Science and Engineering',
  'Mathematics',
  'Mechanical Engineering',
  'Microbiology and Cell Science',
  'Music',
  'Neuroscience',
  'Nursing',
  'Philosophy',
  'Physics',
  'Political Science',
  'Psychology',
  'Sociology',
  'Sport Management',
  'Statistics',
  'Theatre',
  'Wildlife Ecology and Conservation',
  'Automotive Trade Schools',
  'Construction Trade Schools',
  'Culinary Trade Schools',
  'Cosmetology Schools',
  'Healthcare Trade Schools',
  'Information Technology (IT) Trade Schools',
  'Welding Schools',
  'Electrician Trade Schools',
  'Plumbing Trade Schools',
  'Aviation Trade Schools',
  'Graphic Design and Multimedia Schools',
  'Manufacturing and Industrial Trade Schools',
  'AirForce',
  'Army',
  'Coast Guard',
  'Marine Corps',
  'National Guard',
  'Navy',
];
