part of 'components/library_resume_builder.dart';

class ResumeBuilder extends StatefulWidget {
  const ResumeBuilder({super.key});

  @override
  State<ResumeBuilder> createState() => _ResumeBuilderState();
}

class _ResumeBuilderState extends State<ResumeBuilder> {
  @override
  void initState() {
    super.initState();
    const InitialDialogRenderer(screen: AppRoutes.resumeBuilder)
        .showInitialDialog(context);
  }

  String formatDateString(String dateStr) {
    DateTime dateTime = DateTime.parse(dateStr);
    var formatter = DateFormat('MMM dd, yyyy');
    return formatter.format(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    final libBloc = GoRouterState.of(context).extra as MyLibraryBloc;
    return BlocProvider(
      create: (context) {
        return ResumeBuilderBloc(libraryBloc: libBloc..add(GetDataEvent()))
          ..add(GetMyResumeEvent());
      },
      child: ScaffoldWrapper(
          child: Scaffold(
        appBar: const CustomAppBar(title: 'My Resume'),
        body: Center(
  child: Builder(
    builder: (context) {
      return ElevatedButton(
        onPressed: () => context.push(
          AppRoutes.addResume,
          extra: context.read<ResumeBuilderBloc>()
            ..add(SelectAResume(model: ResumeModel.initial())),
        ),
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          backgroundColor: Colors.blue, // Button color
          foregroundColor: Colors.white, // Text color
          textStyle: TextStyle(
            fontWeight: FontWeight.w600,
            letterSpacing: 0,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
        ),
        child: Text('Create New Resume'),
      );
    },
  ),
),
      )),
    );
  }
}
