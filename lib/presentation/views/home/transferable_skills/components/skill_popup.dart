part of 'library_transferable_skills.dart';

enum ToolTipPosition {
  isCenter,
  isRight,
  isLeft,
  none,
}

class SkillPopup extends StatelessWidget {
  const SkillPopup({
    super.key,
    required this.tipPosition,
    required this.topic,
    required this.isFavorite,
    required this.bloc,
    required this.showNode,
  });

  final ToolTipPosition tipPosition;
  final Topic topic;
  final bool isFavorite;
  final TransferableSkillsBloc bloc;
  final ShowNode showNode;

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: bloc,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: tipPosition == ToolTipPosition.isLeft
            ? CrossAxisAlignment.start
            : tipPosition == ToolTipPosition.isRight
                ? CrossAxisAlignment.end
                : CrossAxisAlignment.center,
        children: [
          Container(
            margin: tipPosition == ToolTipPosition.isLeft
                ? const EdgeInsets.only(left: 15)
                : tipPosition == ToolTipPosition.isRight
                    ? const EdgeInsets.only(right: 15)
                    : EdgeInsets.zero,
            height: 12,
            width: 12,
            child: const CustomPaint(
              foregroundPainter: CustomTriangle(),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.skillPopupColor),
              borderRadius: BorderRadius.circular(14),
              color: AppColors.skillPopupColor,
            ),
            width: 200,
            padding: tipPosition == ToolTipPosition.isLeft
                ? const EdgeInsets.all(12).copyWith(left: 8)
                : const EdgeInsets.all(12).copyWith(right: 8),
            child: Stack(
              children: [
                BlocBuilder<TransferableSkillsBloc, TransferableSkillsState>(
                  builder: (context, state) {
                    /// Find the updated topic from the correct ShowNode list
                    final updatedTopic = _getUpdatedTopic(state);
                    bool isUpdatedFavorite = updatedTopic?.isFavorite ?? false;
                    return Align(
                      alignment: Alignment.topRight,
                      child: InkWell(
                        onTap: () {
                          String nodeId = _getNodeId(state);
                          context.read<TransferableSkillsBloc>().add(
                                ToggleLike(
                                  nodeName: showNode,
                                  nodeId: nodeId,
                                  descriptionId: topic.id ?? 'DescriptionId',
                                ),
                              );
                        },
                        child: Image.asset(
                          AssetConstants.favouriteStartIcon,
                          height: 19,
                          width: 26,
                          color: isUpdatedFavorite
                              ? AppColors.secondaryColor
                              : null,
                        ),
                      ),
                    );
                  },
                ),
                Align(
                  alignment: tipPosition == ToolTipPosition.isLeft
                      ? Alignment.topRight
                      : tipPosition == ToolTipPosition.isLeft
                          ? Alignment.topLeft
                          : Alignment.center,
                  child: Container(
                    alignment: Alignment.topCenter,
                    margin: const EdgeInsets.only(right: 30),
                    child: Text(
                      softWrap: true,
                      topic.description ?? 'Description',
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Dynamically gets the updated topic from the correct ShowNode
  Topic? _getUpdatedTopic(TransferableSkillsState state) {
    List<Topic>? topics;
    switch (showNode) {
      case ShowNode.favoriteHobby1:
        topics = state.model?.favoriteHobby1?.topics;
        break;
      case ShowNode.favoriteHobby2:
        topics = state.model?.favoriteHobby2?.topics;
        break;
      case ShowNode.atheleteSportsPosition:
        topics = state.model?.athlete?.sportPosition?.topics;
        break;
      case ShowNode.athletePrimarySport:
        topics = state.model?.athlete?.primarySport?.topics;
        break;
      case ShowNode.favoriteSchoolSubject:
        topics = state.model?.favoriteMiddleSchoolSubject?.topics;
        break;
      case ShowNode.military:
        topics = state.model?.military?.rank?.topics;
        break;
      default:
        return null;
    }
    return topics?.firstWhere(
      (t) => t.id == topic.id,
      orElse: () => topic,
    );
  }

  /// Dynamically gets the correct node ID based on the ShowNode type
  String _getNodeId(TransferableSkillsState state) {
    switch (showNode) {
      case ShowNode.favoriteHobby1:
        return state.model?.favoriteHobby1?.id ?? 'hobbyId';
      case ShowNode.favoriteHobby2:
        return state.model?.favoriteHobby2?.id ?? 'hobbyId';
      case ShowNode.atheleteSportsPosition:
        return state.model?.athlete?.sportPosition?.id ?? 'athleteId';
      case ShowNode.athletePrimarySport:
        return state.model?.athlete?.primarySport?.id ?? 'sportId';
      case ShowNode.favoriteSchoolSubject:
        return state.model?.favoriteMiddleSchoolSubject?.id ?? 'subjectId';
      case ShowNode.military:
        return state.model?.military?.rank?.id ?? 'rankId';
      default:
        return 'defaultId';
    }
  }
}
