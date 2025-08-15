part of 'components/library_transferable_skills.dart';

class TransferableSkills extends StatefulWidget {
  const TransferableSkills({super.key});

  @override
  State<TransferableSkills> createState() => _TransferableSkillsState();
}

class _TransferableSkillsState extends State<TransferableSkills>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animationController = AnimationController(
    duration: const Duration(milliseconds: 500),
    vsync: this,
  );
  late Animation<double> _scaleAnimation;

  final TransformationController _transformationController =
      TransformationController();

  static final ValueNotifier<ShowNode?> _currentNodeNotifier =
      ValueNotifier<ShowNode?>(null);

  @override
  void initState() {
    super.initState();
    const InitialDialogRenderer(screen: AppRoutes.transferableSkills)
        .showInitialDialog(context, isTSkillDialog: true);
    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  final ScreenshotController screenshotController = ScreenshotController();

  Future<Uint8List?> takeScreenshot(
      ScreenshotController screenshotController) async {
    // if (Platform.isAndroid) {
    //   if (await Permission.manageExternalStorage.request().isDenied) {
    //     SnackbarsType.error(context, 'Permission Denied.');
    //   }
    // }

    Uint8List? screenshot = await screenshotController.capture(pixelRatio: 3.0);
    if (screenshot == null) {
      print("Screenshot capture failed!");
      return null;
    }

    return screenshot;
  }

  File? pdf;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TransferableSkillsBloc()..add(GetData()),
      child: ScaffoldWrapper(
        child: Scaffold(
          appBar: CustomAppBar(
            title: 'My Transferable Skills',
            trailingIcon: [
              BlocBuilder<TransferableSkillsBloc, TransferableSkillsState>(
                builder: (context, state) {
                  final userName = context.read<AppBloc>().state.user.name;
                  return ThreeDotsMenu(menuItems: const [
                    'Download',
                    'Share'
                  ], menuActions: [
                    () async {
                      ShowOverlay.removeAllOverlays(context);
                      if (!context
                          .read<AppBloc>()
                          .state
                          .user
                          .isSubscriptionPaid) {
                        Constant.showSubscriptionDialog(context,
                            isTransferable: true);
                        return;
                      }
                      SnackbarsType.success(
                          duration: const Duration(milliseconds: 5000),
                          context,
                          'Your Transferable Skills Report is downloading...');
                      setState(() {
                        state.isScreenshot = true;
                      });
                      if (state.isScreenshot) {
                        Future.delayed(const Duration(milliseconds: 2000))
                            .then((i) async {
                          final screenShot =
                              await takeScreenshot(screenshotController);
                          if (screenShot != null) {
                            pdf = await generateTSkillPDF(
                              screenShot: screenShot,
                              userName: userName,
                              model: state.model ?? TransferableSkillsModel(),
                            );
                          }
                          setState(() {
                            state.isScreenshot = false;
                          });
                        });
                      }
                    },
                    () {
                      ShowOverlay.removeAllOverlays(context);
                      if (!context
                          .read<AppBloc>()
                          .state
                          .user
                          .isSubscriptionPaid) {
                        Constant.showSubscriptionDialog(context,
                            isTransferable: true);
                        return;
                      }
                      SnackbarsType.success(
                          duration: const Duration(milliseconds: 5000),
                          context,
                          'Creating Transferable Skills Report...');
                      setState(() {
                        state.isScreenshot = true;
                      });
                      if (state.isScreenshot) {
                        Future.delayed(const Duration(milliseconds: 2000))
                            .then((i) async {
                          final screenShot =
                              await takeScreenshot(screenshotController);
                          if (screenShot != null) {
                            final File? pdf = await generateTSkillPDF(
                              isSupportPeople: true,
                              screenShot: screenShot,
                              userName: userName,
                              model: state.model ?? TransferableSkillsModel(),
                            );
                            if (pdf != null) {
                              CommonDialog(
                                  isSupport: true,
                                  customDialog: ShareDialog(
                                    tSkillReport: pdf,
                                    bloc:
                                        context.read<TransferableSkillsBloc>(),
                                  )).showCustomDialog(context);
                            }
                          }
                          setState(() {
                            state.isScreenshot = false;
                          });
                        });
                      }
                    },
                  ]);
                },
              ),
              SizedBox(width: 16.w),
            ],
          ),
          body: BlocConsumer<TransferableSkillsBloc, TransferableSkillsState>(
            listener: (context, state) {
              if (state.result.status == ResultStatus.successful &&
                  state.result.event is ShareTSkillReportEvent) {
                SnackbarsType.success(
                    context, 'Report sent to Support People successfully!');
                context.pop();
              } else if (state.result.status == ResultStatus.successful &&
                  state.result.event is ShareTSkillReportEvent) {
                SnackbarsType.error(context, 'Error: ${state.result.message}');
              }
              if (state.result.event is ToggleLike &&
                  state.result.status == ResultStatus.error) {
                SnackbarsType.error(context, state.result.message);
              }
            },
            builder: (context, state) {
              if (_currentNodeNotifier.value != state.showNode ||
                  state.showNode == ShowNode.none) {
                _onNodeChange(state.showNode);
              }
              return state.loading == false && state.model == null
                  ? const Center(
                      child: Text('Failed To Load Data'),
                    )
                  : !state.loading
                      ? InteractiveViewer(
                          transformationController: _transformationController,
                          boundaryMargin: EdgeInsets.symmetric(
                              horizontal: 150.w, vertical: 350.h),
                          minScale: 0.1,
                          maxScale: 4.0,
                          constrained: false,
                          child: Screenshot(
                            controller: screenshotController,
                            child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(50),
                                ),
                                width: 679,
                                height: 588,
                                child: ValueListenableBuilder<ShowNode?>(
                                  valueListenable: _currentNodeNotifier,
                                  builder: (context, currentNode, _) {
                                    final model = state.model ??
                                        TransferableSkillsModel();
                                    return Stack(
                                      children: [
                                        CenterNodes(
                                            transformationController:
                                                _transformationController,
                                            isScreenshot: state.isScreenshot),
                                        if (state.isScreenshot)
                                          ..._getAllSkillNodes(model, state),
                                        if (!state.isScreenshot)
                                          _getSkillNode(
                                            currentNode,
                                            state.model ??
                                                TransferableSkillsModel(),
                                            isScreenshot: false,
                                          ),
                                      ],
                                    );
                                  },
                                )),
                          ),
                        )
                      : const Center(
                          child: CircularProgressIndicator(
                          color: AppColors.secondaryColor,
                        ));
            },
          ),
        ),
      ),
    );
  }

  Widget animateNode(Widget node, Duration delay, bool isAppearing) {
    final ValueNotifier<double> scaleNotifier =
        ValueNotifier<double>(isAppearing ? 0.0 : 1.0);

    Future.delayed(delay, () {
      scaleNotifier.value =
          isAppearing ? 1.0 : 0.0; // Reverse the scaling when disappearing
    });

    return ValueListenableBuilder<double>(
      valueListenable: scaleNotifier,
      builder: (context, scale, child) {
        return AnimatedScale(
          scale: scale,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
          child: node,
        );
      },
    );
  }

  List<Widget> _getAllSkillNodes(
      TransferableSkillsModel model, TransferableSkillsState state) {
    final nodes = [
      if (model.isAthlete ?? true)
        _getSkillNode(ShowNode.athletePrimarySport, model),
      if (model.isAthlete ?? true)
        _getSkillNode(ShowNode.atheleteSportsPosition, model),
      _getSkillNode(ShowNode.favoriteSchoolSubject, model),
      _getSkillNode(ShowNode.favoriteHobby1, model),
      _getSkillNode(ShowNode.favoriteHobby2, model),
      // if (model.hasMilitaryService ?? true)
      //   _getSkillNode(ShowNode.military, model),
    ];

    // When state.isScreenshot is true, animate nodes to appear
    bool isAppearing = state.isScreenshot;

    return nodes.asMap().entries.map((entry) {
      final index = entry.key;
      final node = entry.value;

      return animateNode(
          node, Duration(milliseconds: 300 * index), isAppearing);
    }).toList();
  }

  Widget _getSkillNode(ShowNode? showNode, TransferableSkillsModel model,
      {bool isScreenshot = true}) {
    Widget skillNode = Container();
    switch (showNode) {
      case ShowNode.athletePrimarySport:
        skillNode = SkillNodes(
          model: model,
          showNode: ShowNode.athletePrimarySport,
          nodeAngle: 0.02,
          alignment: Alignment.topCenter,
        );
        break;
      case ShowNode.atheleteSportsPosition:
        skillNode = SkillNodes(
          model: model,
          showNode: ShowNode.atheleteSportsPosition,
          nodeAngle: 1.4,
          padding: const EdgeInsets.only(bottom: 155, right: 5),
          alignment: Alignment.centerRight,
        );
        break;
      case ShowNode.favoriteSchoolSubject:
        skillNode = SkillNodes(
          model: model,
          showNode: ShowNode.favoriteSchoolSubject,
          nodeAngle: 2.5,
          padding: const EdgeInsets.only(right: 59, bottom: 73),
          alignment: Alignment.bottomRight,
        );
        break;
      case ShowNode.favoriteHobby1:
        skillNode = SkillNodes(
          model: model,
          showNode: ShowNode.favoriteHobby1,
          nodeAngle: 3.7,
          padding: const EdgeInsets.only(left: 72, bottom: 64),
          alignment: Alignment.bottomLeft,
        );
        break;
      case ShowNode.favoriteHobby2:
        skillNode = SkillNodes(
          model: model,
          showNode: ShowNode.favoriteHobby2,
          nodeAngle: 5.0,
          padding: const EdgeInsets.only(bottom: 155, left: 5),
          alignment: Alignment.centerLeft,
        );
        break;
      default:
        skillNode = Container();
    }
    return isScreenshot
        ? skillNode
        : ScaleTransition(scale: _scaleAnimation, child: skillNode);
  }

  // Widget _getSkillNode(ShowNode? showNode, TransferableSkillsModel model,
  //     {bool isScreenshot = true}) {
  //   Widget skillNode = Container();
  //   switch (showNode) {
  //     case ShowNode.favoriteHobby1:
  //       skillNode = SkillNodes(
  //         model: model,
  //         showNode: ShowNode.favoriteHobby1,
  //         nodeAngle: 0.02,
  //         alignment: Alignment.topCenter,
  //       );
  //       break;
  //     case ShowNode.favoriteHobby2:
  //       skillNode = SkillNodes(
  //         model: model,
  //         showNode: ShowNode.favoriteHobby2,
  //         nodeAngle: 5.0,
  //         padding: const EdgeInsets.only(bottom: 155, left: 5),
  //         alignment: Alignment.centerLeft,
  //       );
  //       break;
  //     case ShowNode.atheleteSportsPosition:
  //       skillNode = SkillNodes(
  //         model: model,
  //         showNode: ShowNode.atheleteSportsPosition,
  //         nodeAngle: 3.7,
  //         padding: const EdgeInsets.only(left: 72, bottom: 64),
  //         alignment: Alignment.bottomLeft,
  //       );
  //       break;
  //     // case ShowNode.athletePrimarySport:
  //     //   skillNode = SkillNodes(
  //     //     model: model,
  //     //     showNode: ShowNode.athlete,
  //     //     nodeAngle: 3.7,
  //     //     padding: const EdgeInsets.only(left: 72, bottom: 64),
  //     //     alignment: Alignment.bottomLeft,
  //     //   );
  //     //   break;
  //     case ShowNode.favoriteSchoolSubject:
  //       skillNode = SkillNodes(
  //         model: model,
  //         showNode: ShowNode.favoriteSchoolSubject,
  //         nodeAngle: 1.4,
  //         padding: const EdgeInsets.only(bottom: 155, right: 5),
  //         alignment: Alignment.centerRight,
  //       );
  //       break;
  //     case ShowNode.military:
  //       skillNode = SkillNodes(
  //         model: model,
  //         showNode: ShowNode.military,
  //         nodeAngle: 2.5,
  //         padding: const EdgeInsets.only(right: 59, bottom: 73),
  //         alignment: Alignment.bottomRight,
  //       );
  //       break;
  //     default:
  //       skillNode = Container();
  //   }
  //   return isScreenshot
  //       ? skillNode
  //       : ScaleTransition(scale: _scaleAnimation, child: skillNode);
  // }

  void _onNodeChange(ShowNode? showNode) {
    if (_currentNodeNotifier.value == showNode) {
      /// Close the currently opened node if the same node is tapped
      _animationController.duration = const Duration(milliseconds: 250);
      _scaleAnimation = Tween<double>(begin: 1.0, end: 0.0).animate(
        CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
      );

      _animationController.forward(from: 0.0).then((_) {
        _currentNodeNotifier.value = ShowNode.none;
      });
    } else {
      /// Close previous node
      _animationController.duration = const Duration(milliseconds: 250);
      _scaleAnimation = Tween<double>(begin: 1.0, end: 0.0).animate(
        CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
      );

      _animationController.forward(from: 0.0).then((_) {
        /// Open new node
        _currentNodeNotifier.value = showNode;
        _animationController.duration = const Duration(milliseconds: 250);
        _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
          CurvedAnimation(
              parent: _animationController, curve: Curves.easeInOut),
        );

        _animationController.forward(from: 0.0);
      });
    }
  }
}
