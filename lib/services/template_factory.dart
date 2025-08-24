// services/pdf_generators/template_factory.dart
import 'dart:io';
import 'package:second_shot/models/resume_data_model.dart';
import 'package:second_shot/models/resume_template.dart';
import 'package:second_shot/presentation/components/resume_templates/julia_template_generator.dart';
import 'package:second_shot/presentation/components/resume_templates/mary_rose_template_generator.dart';

abstract class TemplateGenerator {
  Future<File> generatePDF(ResumeData resumeData, String outputPath);
}

class TemplateFactory {
  static TemplateGenerator getGenerator(ResumeTemplate template) {
    switch (template.id) {
      case 'julia_template':
        return JuliaTemplateGeneratorImpl();
            case 'mary_rose_template':
        return MaryRoseTemplateGeneratorImpl();
      // case 'classic_template':
      //   return ClassicTemplateGenerator();
      case 'modern_template':
        return ModernTemplateGenerator();
      case 'creative_template':
        return CreativeTemplateGenerator();
      default:
        return JuliaTemplateGeneratorImpl(); // Default fallback
    }
  }
}

class JuliaTemplateGeneratorImpl implements TemplateGenerator {
  @override
  Future<File> generatePDF(ResumeData resumeData, String outputPath) {
    return JuliaTemplateGenerator.generatePDF(resumeData, outputPath);
  }
}
class MaryRoseTemplateGeneratorImpl implements TemplateGenerator {
  @override
  Future<File> generatePDF(ResumeData resumeData, String outputPath) {
    return MaryRoseTemplateGenerator.generatePDF(resumeData, outputPath);
  }
}

// Placeholder generators for other templates
class ClassicTemplateGenerator implements TemplateGenerator {
  @override
  Future<File> generatePDF(ResumeData resumeData, String outputPath) async {
    // TODO: Implement classic template
    // For now, fallback to Julia template
    return JuliaTemplateGenerator.generatePDF(resumeData, outputPath);
  }
}

class ModernTemplateGenerator implements TemplateGenerator {
  @override
  Future<File> generatePDF(ResumeData resumeData, String outputPath) async {
    // TODO: Implement modern template
    // For now, fallback to Julia template
    return JuliaTemplateGenerator.generatePDF(resumeData, outputPath);
  }
}

class CreativeTemplateGenerator implements TemplateGenerator {
  @override
  Future<File> generatePDF(ResumeData resumeData, String outputPath) async {
    // TODO: Implement creative template
    // For now, fallback to Julia template
    return JuliaTemplateGenerator.generatePDF(resumeData, outputPath);
  }
}