import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:second_shot/models/resume_data_model.dart';

class GeminiService {
  late final GenerativeModel _model;

  GeminiService({required String apiKey}) {
    _model = GenerativeModel(
      model: 'gemini-1.5-flash',
      apiKey: apiKey,
    );
  }

  Future<ResumeData> extractResumeData(File imageFile) async {
    try {
      final imageBytes = await imageFile.readAsBytes();

      final prompt = '''
      Analyze this resume image and extract ALL information into a comprehensive structured JSON format. 
      Please extract the following information and return it as a valid JSON object with complete details:

      {
        "personalInfo": {
          "fullName": "extracted full name",
          "email": "extracted email address",
          "phone": "extracted phone number with country code if available",
          "address": "complete address including city, state, country",
          "linkedIn": "LinkedIn profile URL or username",
          "github": "GitHub profile URL or username",
          "portfolio": "personal website or portfolio URL",
          "twitter": "Twitter handle or URL",
          "instagram": "Instagram handle or URL",
          "behance": "Behance profile URL",
          "dribbble": "Dribbble profile URL",
          "otherLinks": ["any other social media links or professional profiles"]
        },
        "summary": "complete professional summary, objective, or career goal statement",
        "experience": [
          {
            "company": "company/organization name",
            "position": "job title or role",
            "duration": "employment period (e.g., Jan 2020 - Present)",
            "location": "work location (city, state/country)",
            "description": "detailed job description and responsibilities",
            "achievements": ["specific achievement 1", "quantified result 2", "accomplishment 3"]
          }
        ],
        "projects": [
          {
            "title": "project name",
            "description": "detailed project description",
            "duration": "project timeline or completion date",
            "technologies": ["technology1", "technology2", "framework3"],
            "githubLink": "GitHub repository URL if mentioned",
            "liveLink": "live demo or deployment URL if mentioned",
            "features": ["key feature 1", "functionality 2", "capability 3"]
          }
        ],
        "education": [
          {
            "institution": "school/university/college name",
            "degree": "degree type and name (e.g., Bachelor of Science)",
            "fieldOfStudy": "major/specialization",
            "graduationYear": "graduation year or expected graduation",
            "gpa": "GPA or grade if mentioned",
            "location": "institution location",
            "achievements": ["academic honors", "relevant coursework", "thesis title"]
          }
        ],
        "skills": [
          "technical skill 1", "programming language", "software tool", 
          "framework", "methodology", "soft skill", "domain expertise"
        ],
        "awards": [
          {
            "title": "award or recognition name",
            "organization": "awarding organization or institution",
            "year": "year received",
            "description": "brief description or significance of the award"
          }
        ],
        "certifications": [
          "certification name - issuing organization (year)",
          "professional license - authority (validity period)",
          "course completion certificate - platform (date)"
        ],
        "languages": [
          {
            "name": "language name",
            "proficiency": "proficiency level (e.g., Native, Fluent, Intermediate, Basic)"
          }
        ],
        "hobbies": [
          "hobby or interest 1", "recreational activity", "personal interest"
        ],
        "references": [
          "reference contact information or 'Available upon request'",
          "professional reference with title and company"
        ]
      }

      EXTRACTION RULES:
      1. Return ONLY valid JSON, no markdown formatting, no additional text
      2. If any information is not found, use empty string "" or empty array []
      3. Be extremely thorough - extract ALL visible text and information
      4. For dates, maintain the original format but ensure consistency
      5. Group similar skills together (technical skills, soft skills, tools, etc.)
      6. Extract complete sentences for descriptions and summaries
      7. Capture ALL social media links, websites, and professional profiles
      8. Include location information wherever mentioned
      9. Extract quantified achievements and results (numbers, percentages, metrics)
      10. Identify and separate projects from work experience
      11. Look for awards, honors, recognitions, and achievements in all sections
      12. Extract ALL programming languages, frameworks, tools, and technologies
      13. Include course names, thesis titles, and academic achievements
      14. Capture volunteer work, internships, and part-time positions
      15. Extract professional certifications, licenses, and course completions
      16. Include language proficiency levels if mentioned
      17. Look for hobbies, interests, and personal activities
      18. Extract reference information or note if "references available upon request"
      19. Pay attention to URLs, email addresses, and contact information
      20. Include company locations, project durations, and timeline information
      21. Extract technical project details, GitHub links, and live demo URLs
      22. Include GPA, honors, dean's list, and other academic achievements
      23. Look for leadership roles, team sizes, and management experience
      24. Extract industry-specific terminology and domain expertise
      25. Include conference presentations, publications, and speaking engagements
      
      IMPORTANT: Scan the ENTIRE resume image carefully. Don't miss any sections, headers, footers, or side panels. Extract every piece of information visible in the document.
      ''';

      final content = [
        Content.multi([
          TextPart(prompt),
          DataPart('image/jpeg', imageBytes),
        ])
      ];

      final response = await _model.generateContent(content);
      final responseText = response.text?.trim() ?? '';

      // Clean the response to ensure it's valid JSON
      String cleanedResponse = responseText;
      if (cleanedResponse.startsWith('```json')) {
        cleanedResponse = cleanedResponse.substring(7);
      }
      if (cleanedResponse.endsWith('```')) {
        cleanedResponse =
            cleanedResponse.substring(0, cleanedResponse.length - 3);
      }
      cleanedResponse = cleanedResponse.trim();

      final Map<String, dynamic> jsonData = json.decode(cleanedResponse);
      return ResumeData.fromJson(jsonData);
    } catch (e) {
      throw Exception('Failed to extract resume data: $e');
    }
  }
}
