library resume_builder;

import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:second_shot/blocs/home/my_library/my_library_bloc.dart';
import 'package:second_shot/blocs/home/resume_builder/create_resume/create_resume_bloc.dart';
import 'package:second_shot/blocs/resume_builder/resume_builder_bloc.dart';
import 'package:second_shot/blocs/resume_builder/resume_builder_event.dart';
import 'package:second_shot/blocs/resume_builder/resume_builder_state.dart';

// Import models with aliases to avoid conflicts
import 'package:second_shot/models/resume_data_model.dart' as template_models;
import 'package:second_shot/models/resume_template.dart';

import 'package:second_shot/presentation/components/components_barrels.dart';
import 'package:second_shot/presentation/router/route_constants.dart';
import 'package:second_shot/presentation/theme/theme_utils/app_colors.dart';
import 'package:second_shot/presentation/views/resume_builder/template_selection_screen.dart';
import 'package:second_shot/services/resume_pdf_generator.dart';
import 'package:second_shot/utils/constants/assets.dart';
import 'package:second_shot/utils/constants/constant.dart';
import 'package:second_shot/utils/constants/result.dart';
import 'package:second_shot/utils/extensions.dart';

import '../../../../../blocs/home/resume_builder/resume_builder_bloc.dart';
import '../../../../../models/get_resume_model.dart';
import '../../../../../models/library_model.dart';
import '../../../../../utils/constants/validators.dart';
import '../../../auth/Components/number_formate.dart';
import '../../components/dialogs_renderer.dart';

part '../add_resume.dart';
part '../resume_builder.dart';
part '../resume_details.dart';
part '../resume_steps/step1_information.dart';
part '../resume_steps/step2_objective.dart';
part '../resume_steps/step3_education.dart';
part '../resume_steps/step4_licences.dart';
part '../resume_steps/step5_skills.dart';
part '../resume_steps/step6_experience.dart';
part '../resume_steps/step7_volunteer.dart';
part '../resume_steps/step8_honors.dart';
part 'add_more_button.dart';
part 'date_selection_dropdowns.dart';
part 'resume_heaider_section.dart';
part 'resume_section_details.dart';
part 'skill_selection_dialog.dart';
part 'skills_selection_textfield.dart';
part 'stepper_box.dart';
part 'stepper_header_text.dart';
part 'stepper_line.dart';
part '../../components/steppers.dart';
part 'technical_skills_widget.dart';
part 'tips_widget.dart';