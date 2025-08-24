// models/resume_template.dart
enum ResumeTemplateType {
  classic,
  modern,
  creative,
  professional
}

class ResumeTemplate {
  final String id;
  final String name;
  final String description;
  final ResumeTemplateType type;
  final String previewImagePath;
  final bool isPremium;

  const ResumeTemplate({
    required this.id,
    required this.name,
    required this.description,
    required this.type,
    required this.previewImagePath,
    this.isPremium = false,
  });

  static List<ResumeTemplate> getAvailableTemplates() {
    return [
      const ResumeTemplate(
        id: 'julia_template',
        name: 'Julia Professional',
        description: 'Modern two-column design with photo section',
        type: ResumeTemplateType.professional,
        previewImagePath: 'assets/templates/julia_preview.png',
      ),
         const ResumeTemplate(
        id: 'mary_rose_template',
        name: 'Mary Rose Elegant',
        description: 'Sophisticated design with circular photo and contact bar',
        type: ResumeTemplateType.professional,
        previewImagePath: 'assets/templates/mary_rose_preview.png',
      ),
      // const ResumeTemplate(
      //   id: 'classic_template',
      //   name: 'Classic Simple',
      //   description: 'Clean and simple single column layout',
      //   type: ResumeTemplateType.classic,
      //   previewImagePath: 'assets/templates/classic_preview.png',
      // ),
      const ResumeTemplate(
        id: 'modern_template',
        name: 'Modern Tech',
        description: 'Contemporary design with accent colors',
        type: ResumeTemplateType.modern,
        previewImagePath: 'assets/templates/modern_preview.png',
        isPremium: true,
      ),
      const ResumeTemplate(
        id: 'creative_template',
        name: 'Creative Portfolio',
        description: 'Artistic layout for creative professionals',
        type: ResumeTemplateType.creative,
        previewImagePath: 'assets/templates/creative_preview.png',
        isPremium: true,
      ),
    ];
  }
}