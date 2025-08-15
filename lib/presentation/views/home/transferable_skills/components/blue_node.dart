part of 'library_transferable_skills.dart';

class BlueNode extends StatefulWidget {
  const BlueNode({
    super.key,
    required this.topAlignment,
    required this.containerAlignment,
    required this.containerHeight,
    required this.containerWidth,
    required this.overlayIndex,
    required this.nodeAngle,
    required this.topic,
    required this.nodeId,
    required this.showNode,
  });

  final AlignmentGeometry topAlignment;
  final AlignmentGeometry containerAlignment;
  final double containerHeight;
  final double containerWidth;
  final double nodeAngle;
  final int overlayIndex;
  final Topic topic;
  final String nodeId;
  final ShowNode showNode;

  static List<ShowOverlay> overLays = List.generate(5, (i) => ShowOverlay());

  @override
  State<BlueNode> createState() => _BlueNodeState();
}

class _BlueNodeState extends State<BlueNode> {
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: widget.topAlignment,
      child: Container(
        alignment: widget.containerAlignment,
        width: widget.containerWidth,
        height: widget.containerHeight,
        child: Transform.rotate(
          angle: _nodeTextAngle(),
          child: BlocBuilder<TransferableSkillsBloc, TransferableSkillsState>(
            builder: (context, state) {
              return CompositedTransformTarget(
                link: state.isScreenshot
                    ? LayerLink()
                    : BlueNode.overLays[widget.overlayIndex].layerLink,
                child: InkWell(
                  onTap: () {
                    if (BlueNode
                        .overLays[widget.overlayIndex].isOverlayVisible) {
                      BlueNode.overLays[widget.overlayIndex].removeOverlay();
                    } else {
                      BlueNode.overLays[widget.overlayIndex].showOverlay(
                          topic: widget.topic,
                          isFavorite: widget.topic.isFavorite ?? false,
                          context: context,
                          nodeId: widget.nodeId,
                          showNode: widget.showNode,
                          overLayPosition: overlayPosition(),
                          bloc: context.read<TransferableSkillsBloc>());
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    key: state.isScreenshot
                        ? null
                        : BlueNode.overLays[widget.overlayIndex].nodeKey,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      // border: Border.all(color: Colors.red),
                    ),
                    alignment: Alignment.center,
                    height: 45,
                    width: 45,
                    child: SkillText(
                      fontWeight: FontWeight.w600,
                      fontSize: 6,
                      skillName:
                          widget.topic.title?.replaceAll(' ', '\n') ?? '',
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  double _nodeTextAngle() {
    switch (widget.nodeAngle) {
      case 0.02:
        return -0.02;
      case 5.0:
        return 1.30;
      case 3.7:
        return 2.60;
      case 1.4:
        return 4.87;
      case 2.5:
        return 3.78;
      default:
        return 0.0;
    }
  }

  ToolTipPosition overlayPosition() {
    // TopCenterNode
    if (widget.nodeAngle == 0.02) {
      print('Top Angle');
      switch (widget.overlayIndex) {
        case 0:
          return ToolTipPosition.isLeft;
        case 1:
          return ToolTipPosition.isLeft;
        case 2:
          return ToolTipPosition.isRight;
        case 3:
          return ToolTipPosition.isRight;
        case 4:
          return ToolTipPosition.isCenter;
        default:
          return ToolTipPosition.isCenter;
      }
      // TopLeftNode
    } else if (widget.nodeAngle == 4.7) {
      return ToolTipPosition.isLeft;
    }
    // BottomLeftNode
    else if (widget.nodeAngle == 3.5) {
      switch (widget.overlayIndex) {
        case 0:
          return ToolTipPosition.isRight;
        case 1:
          return ToolTipPosition.isRight;
        case 2:
          return ToolTipPosition.isLeft;
        case 3:
          return ToolTipPosition.isLeft;
        case 4:
          return ToolTipPosition.isCenter;
        default:
          return ToolTipPosition.isLeft;
      }
    }
    // TopRightNode
    else if (widget.nodeAngle == 1.7) {
      return ToolTipPosition.isRight;
    }
    //  BottomRightNode
    else if (widget.nodeAngle == 2.5) {
      switch (widget.overlayIndex) {
        case 0:
          return ToolTipPosition.isRight;
        case 1:
          return ToolTipPosition.isRight;
        case 2:
          return ToolTipPosition.isCenter;
        case 3:
          return ToolTipPosition.isLeft;
        case 4:
          return ToolTipPosition.isCenter;
        default:
          return ToolTipPosition.isLeft;
      }
    } else {
      return ToolTipPosition.isLeft;
    }
  }
}
