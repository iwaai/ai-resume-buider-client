// import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:second_shot/blocs/app/app_bloc.dart';
import 'package:second_shot/blocs/auth/auth_bloc.dart';
import 'package:second_shot/blocs/home/notifications/notifications_bloc.dart';
import 'package:second_shot/blocs/registration_questions/registration_questions_bloc.dart';
import 'package:second_shot/blocs/resume_builder/resume_builder_bloc.dart';
import 'package:second_shot/blocs/subscription/subscription_bloc.dart';
// import 'package:second_shot/firebase_options.dart';
import 'package:second_shot/presentation/router/navigations.dart';
import 'package:second_shot/presentation/theme/theme.dart';
import 'package:second_shot/services/gemini_service.dart';
import 'package:second_shot/services/local_storage.dart';
import 'package:second_shot/services/network_connectivity.dart';
import 'package:second_shot/services/pdf_service.dart';

void main() async {
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      systemNavigationBarColor: Colors.black,
    ),
  );
  WidgetsFlutterBinding.ensureInitialized();
  await LocalStorage().init();
  // await Firebase.initializeApp(
  //   options: DefaultFirebaseOptions.currentPlatform,
  // );
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      builder: (context, child) => MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (context) => AppBloc()..add(OnInitEvent()),
              lazy: true,
            ),
            BlocProvider(
              create: (context) => NotificationsBloc(),
              lazy: true,
            ),
            BlocProvider(
              lazy: true,
              create: (context) => AuthBloc(
                context.read<AppBloc>(),
                context.read<NotificationsBloc>(),
              ),
            ),
            BlocProvider(
              lazy: true,
              create: (context) => RegistrationQuestionsBloc(),
            ),
            BlocProvider(
              lazy: true,
              create: (context) => SubscriptionBloc(context.read<AppBloc>()),
            ),
            BlocProvider(
              lazy: true,
              create: (context) => ResumeBloc(
                geminiService: GeminiService(
                    apiKey: 'AIzaSyCV4m_sC4-oe1uqza-sFWh3vfJzIHxnXN0'),
                pdfService: PDFService(),
              ),
            ),
          ],
          child: MediaQuery(
            data: MediaQuery.of(context)
                .copyWith(textScaler: TextScaler.linear(1)),
            child: MaterialApp.router(
              builder: (context, child) {
                InternetConnectionChecker().checkConnectivity(context);

                return child!;
              },
              // useInheritedMediaQuery: true,
              // locale: DevicePreview.locale(context),
              // builder: DevicePreview.appBuilder,,
              routerConfig: GoRouters.routes,
              debugShowCheckedModeBanner: false,
              theme: AppTheme().lightTheme,
            ),
          )),
    );
  }
}
