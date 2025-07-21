part of 'library_transferable_skills.dart';

class SkillNodes extends StatefulWidget {
  const SkillNodes({
    super.key,
    this.nodeAngle = 0,
    required this.alignment,
    this.padding,
    required this.showNode,
    required this.model,
  });

  final double nodeAngle;
  final AlignmentGeometry alignment;
  final EdgeInsetsGeometry? padding;
  final ShowNode showNode;
  final TransferableSkillsModel model;

  @override
  State<SkillNodes> createState() => _SkillNodesState();
}

class _SkillNodesState extends State<SkillNodes> {
  List<Topic> topics = [];
  String nodeId = '';

  void _getTopics() {
    topics = [];

    switch (widget.showNode) {
      case ShowNode.favoriteHobby1:
        topics = widget.model.favoriteHobby1?.topics ?? [];
        nodeId = widget.model.favoriteHobby1?.id ?? 'favoriteHobby1';
        break;

      case ShowNode.favoriteHobby2:
        topics = widget.model.favoriteHobby2?.topics ?? [];
        nodeId = widget.model.favoriteHobby2?.id ?? 'favoriteHobby2';
        break;

      case ShowNode.atheleteSportsPosition:
        if (widget.model.isAthlete == true) {
          topics = widget.model.athlete?.sportPosition?.topics ?? [];
          nodeId = widget.model.athlete?.sportPosition?.id ?? 'sportPosition';
        }
        break;
      case ShowNode.athletePrimarySport:
        if (widget.model.isAthlete == true) {
          topics = widget.model.athlete?.primarySport?.topics ?? [];
          nodeId = widget.model.athlete?.primarySport?.id ?? 'primarySport';
        }
        break;

      case ShowNode.favoriteSchoolSubject:
        topics = widget.model.favoriteMiddleSchoolSubject?.topics ?? [];
        nodeId = widget.model.favoriteMiddleSchoolSubject?.id ??
            'favoriteMiddleSchoolSubject';
        break;

      case ShowNode.military:
        if (widget.model.hasMilitaryService == true) {
          topics = widget.model.military?.rank?.topics ?? [];
          nodeId = widget.model.military?.rank?.id ?? 'rank';
        }
        break;

      default:
        topics = [];
    }

    // Ensure topics always have at least 5 elements
    while (topics.length < 5) {
      topics.add(Topic(id: '', description: 'Placeholder', isFavorite: false));
    }
  }

  @override
  void initState() {
    super.initState();
    _getTopics();
  }

  @override
  void didUpdateWidget(covariant SkillNodes oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Only update topics if showNode has changed
    if (widget.showNode != oldWidget.showNode) {
      _getTopics();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      key: widget.key,
      padding: widget.padding,
      alignment: widget.alignment,
      child: Transform.rotate(
        angle: widget.nodeAngle,
        child: SizedBox(
          width: 295.0,
          height: 160.0,
          child: Stack(
            children: [
              // center skill nodes image
              Center(
                child: Image.asset(
                  'assets/skill_nodes.png',
                  width: 295.0,
                  height: 160.0,
                ),
              ),
              // top left corner
              // Node 0
              BlueNode(
                  showNode: widget.showNode,
                  nodeId: nodeId,
                  topic: topics[0],
                  topAlignment: Alignment.topLeft,
                  containerAlignment: Alignment.bottomRight,
                  containerHeight: 54.0,
                  containerWidth: 102.0,
                  overlayIndex: 0,
                  nodeAngle: widget.nodeAngle),
              // bottom left corner
              // Node 1
              BlueNode(
                  showNode: widget.showNode,
                  nodeId: nodeId,
                  topic: topics[1],
                  topAlignment: Alignment.bottomLeft,
                  containerAlignment: Alignment.topRight,
                  containerHeight: 91.0,
                  containerWidth: 81.0,
                  overlayIndex: 1,
                  nodeAngle: widget.nodeAngle),
              // top right corner
              // Node 2
              BlueNode(
                  showNode: widget.showNode,
                  nodeId: nodeId,
                  topic: topics[2],
                  topAlignment: Alignment.topRight,
                  containerAlignment: Alignment.bottomLeft,
                  containerHeight: 54.0,
                  containerWidth: 101.0,
                  overlayIndex: 2,
                  nodeAngle: widget.nodeAngle),
              // bottom right corner
              // Node 3
              BlueNode(
                  showNode: widget.showNode,
                  nodeId: nodeId,
                  topic: topics[3],
                  topAlignment: Alignment.bottomRight,
                  containerAlignment: Alignment.topLeft,
                  containerHeight: 94.0,
                  containerWidth: 76.0,
                  overlayIndex: 3,
                  nodeAngle: widget.nodeAngle),
              // top center
              // Node 4
              BlueNode(
                  showNode: widget.showNode,
                  nodeId: nodeId,
                  topic: topics[4],
                  topAlignment: Alignment.topCenter,
                  containerAlignment: Alignment.bottomRight,
                  containerHeight: 83.0,
                  containerWidth: 52.0,
                  overlayIndex: 4,
                  nodeAngle: widget.nodeAngle)
            ],
          ),
        ),
      ),
    );
  }
}
