part of 'library_transferable_skills.dart';

class CenterNodes extends StatefulWidget {
  const CenterNodes(
      {super.key,
      required this.transformationController,
      required this.isScreenshot});

  final TransformationController transformationController;
  final bool isScreenshot;

  @override
  _CenterNodesState createState() => _CenterNodesState();
}

class _CenterNodesState extends State<CenterNodes>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<Matrix4> _animation;
  Offset _tapPosition = Offset.zero;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  double dx = 0, dy = 0;
  ShowNode? showNode1;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final center = Offset(size.width / 2, size.height / 2);
    dx = center.dx - _tapPosition.dx;
    dy = center.dy - _tapPosition.dy;
    if (widget.isScreenshot) {
      screenShotAnimate(
          scale: 0.6,
          horizontal: dx - dx + size.width / 2.85,
          vertical: dy - dy + size.height / 10.0);
    }
    return Container(
      padding: const EdgeInsets.only(top: 150),
      alignment: Alignment.topCenter,
      child: SizedBox(
        width: 240,
        height: 235,
        child: BlocBuilder<TransferableSkillsBloc, TransferableSkillsState>(
          builder: (context, state) {
            final bloc = context.read<TransferableSkillsBloc>();
            final model = state.model;
            return Stack(
              children: [
                // Center Image
                Image.asset(
                  'assets/center.png',
                  width: 240,
                  height: 235,
                ),
                // Name
                Center(
                  child: Container(
                    width: 88,
                    padding: const EdgeInsets.only(bottom: 37),
                    alignment: Alignment.bottomCenter,
                    child: Text(
                      textAlign: TextAlign.end,
                      context.read<AppBloc>().state.user.name,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 8.5,
                        overflow: TextOverflow.ellipsis,
                        fontWeight: FontWeight.bold,
                        color: AppColors.blackColor,
                      ),
                    ),
                  ),
                ),
                // Profile Image
                GestureDetector(
                  onTapUp: (details) {
                    _animateToNode(
                      details: details,
                      horizontal: dx - dx,
                      vertical: dy - dy,
                      showNode: ShowNode.none,
                    );
                    bloc.add(GreenNodePressed(showNode: ShowNode.none));
                  },
                  child: Center(
                    child: Container(
                      margin: const EdgeInsets.only(top: 23),
                      height: 67,
                      width: 67,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                      ),
                      child: ClipOval(
                        child: CachedNetworkImage(
                          imageUrl:
                              context.read<AppBloc>().state.user.profileImg,
                          fit: BoxFit.cover,
                          errorWidget: (context, str, obj) {
                            return Container(
                              alignment: Alignment.center,
                              child: SkillText(
                                fontWeight: FontWeight.w600,
                                fontSize: 18,
                                skillName: context
                                    .read<AppBloc>()
                                    .state
                                    .user
                                    .name
                                    .getInitials(),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ),

                /// Top Node Athlete Primary Sport
                GreenNode(
                  onNodePress: (details) {
                    if (state.model?.isAthlete == false) return;
                    _animateToNode(
                      details: details,
                      horizontal: dx - dx,
                      vertical: dy - dy + size.height / 10,
                      showNode: ShowNode.athletePrimarySport,
                    );
                    ShowOverlay.removeAllOverlays(context);
                    if (state.showNode != ShowNode.athletePrimarySport) {
                      bloc.add(GreenNodePressed(
                          showNode: ShowNode.athletePrimarySport));
                    } else {
                      bloc.add(GreenNodePressed(showNode: ShowNode.none));
                    }
                  },
                  alignment: Alignment.topCenter,
                  text:
                      "${model?.isAthlete == true ? model?.athlete?.primarySport?.sportName : '-----'}",
                  margin: const EdgeInsets.only(left: 5),
                ),

                /// Top Right Node Athlete Sport Position
                GreenNode(
                  onNodePress: (details) {
                    if (state.model?.isAthlete == false) return;
                    ShowOverlay.removeAllOverlays(context);
                    if (context.read<AppBloc>().state.user.isSubscriptionPaid) {
                      _animateToNode(
                        horizontal: dx - dx - size.width / 2.5,
                        vertical: dy - dy,
                        details: details,
                        showNode: ShowNode.atheleteSportsPosition,
                      );

                      bloc.add(GreenNodePressed(
                          showNode: ShowNode.atheleteSportsPosition));
                    } else {
                      Constant.showSubscriptionDialog(context,
                          isTransferable: true);
                    }
                  },
                  alignment: Alignment.topRight,
                  text: !context.read<AppBloc>().state.user.isSubscriptionPaid
                      ? 'Unlock'
                      : "${model?.isAthlete == true ? model?.athlete?.sportPosition?.positionName : '-----'}",
                  margin: const EdgeInsets.only(top: 65.5, right: 0.5),
                ),

                /// Bottom Right Node Favourite School Subject
                GreenNode(
                  onNodePress: (details) {
                    ShowOverlay.removeAllOverlays(context);
                    if (context.read<AppBloc>().state.user.isSubscriptionPaid) {
                      _animateToNode(
                        horizontal: dx - dx - size.width / 3.5,
                        vertical: dy - dy - size.height / 10,
                        details: details,
                        showNode: ShowNode.favoriteSchoolSubject,
                      );

                      bloc.add(GreenNodePressed(
                          showNode: ShowNode.favoriteSchoolSubject));
                    } else {
                      Constant.showSubscriptionDialog(context,
                          isTransferable: true);
                    }
                  },
                  alignment: Alignment.bottomRight,
                  text: !context.read<AppBloc>().state.user.isSubscriptionPaid
                      ? 'Unlock'
                      : "${model?.favoriteMiddleSchoolSubject?.subjectName}",
                  margin: const EdgeInsets.only(right: 23.5, bottom: 1.5),
                ),

                /// Bottom Left Node Favourite Hobby 1
                GreenNode(
                  onNodePress: (details) {
                    if (context.read<AppBloc>().state.user.isSubscriptionPaid) {
                      _animateToNode(
                        horizontal: dx - dx + size.width / 3.5,
                        vertical: dy - dy - size.height / 10,
                        details: details,
                        showNode: ShowNode.favoriteHobby1,
                      );

                      bloc.add(
                          GreenNodePressed(showNode: ShowNode.favoriteHobby1));
                    } else {
                      Constant.showSubscriptionDialog(context,
                          isTransferable: true);
                    }
                    ShowOverlay.removeAllOverlays(context);
                  },
                  alignment: Alignment.bottomLeft,
                  text: !context.read<AppBloc>().state.user.isSubscriptionPaid
                      ? 'Unlock'
                      : "${model?.favoriteHobby1?.hobbieName}",
                  margin: const EdgeInsets.only(left: 23.5, bottom: 1.5),
                ),

                /// Top Left Node Favourite Hobby 2
                GreenNode(
                  onNodePress: (details) {
                    ShowOverlay.removeAllOverlays(context);
                    if (context.read<AppBloc>().state.user.isSubscriptionPaid) {
                      _animateToNode(
                        horizontal: dx - dx + size.width / 2.5,
                        vertical: dy - dy,
                        details: details,
                        showNode: ShowNode.favoriteHobby2,
                      );

                      bloc.add(
                          GreenNodePressed(showNode: ShowNode.favoriteHobby2));
                    } else {
                      Constant.showSubscriptionDialog(context,
                          isTransferable: true);
                    }
                  },
                  alignment: Alignment.topLeft,
                  text: !context.read<AppBloc>().state.user.isSubscriptionPaid
                      ? 'Unlock'
                      : "${model?.favoriteHobby2?.hobbieName}",
                  margin: const EdgeInsets.only(top: 65.5, left: 0.5),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  void screenShotAnimate({required double scale, horizontal, vertical}) {
    Matrix4 targetMatrix = Matrix4.identity()
      ..translate(horizontal, vertical)
      ..scale(scale);

    _animation = Matrix4Tween(
      begin: widget.transformationController.value,
      end: targetMatrix,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );
    _animationController.addListener(() {
      widget.transformationController.value = _animation.value;
    });

    _animationController.forward(from: 0.0);
    showNode1 = ShowNode.none;
    Future.delayed(const Duration(milliseconds: 3300)).then((i) {
      Matrix4 targetMatrix = Matrix4.identity()
        ..translate(dx - dx, dy - dy)
        ..scale(1.0);

      _animation = Matrix4Tween(
        begin: widget.transformationController.value,
        end: targetMatrix,
      ).animate(
        CurvedAnimation(
          parent: _animationController,
          curve: Curves.easeInOut,
        ),
      );
      _animationController.addListener(() {
        widget.transformationController.value = _animation.value;
      });

      _animationController.forward(from: 0.0);
    });
  }

  void _animateToNode({
    required double horizontal,
    required double vertical,
    required TapUpDetails details,
    required ShowNode? showNode,
  }) {
    _tapPosition = details.globalPosition;
    if (showNode == showNode1) {
      Matrix4 targetMatrix = Matrix4.identity()
        ..translate(dx - dx, dy - dy)
        ..scale(1.0);

      _animation = Matrix4Tween(
        begin: widget.transformationController.value,
        end: targetMatrix,
      ).animate(
        CurvedAnimation(
          parent: _animationController,
          curve: Curves.easeInOut,
        ),
      );
      showNode1 = ShowNode.none;
    } else {
      Matrix4 targetMatrix = Matrix4.identity()
        ..translate(horizontal, vertical)
        ..scale(1.0);

      _animation = Matrix4Tween(
        begin: widget.transformationController.value,
        end: targetMatrix,
      ).animate(
        CurvedAnimation(
          parent: _animationController,
          curve: Curves.easeInOut,
        ),
      );
      showNode1 = showNode;
    }
    _animationController.addListener(() {
      widget.transformationController.value = _animation.value;
    });

    _animationController.forward(from: 0.0);
  }
}
