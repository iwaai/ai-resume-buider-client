part of 'library_transferable_skills.dart';

class ShowOverlay {
  bool isOverlayVisible = false;
  OverlayEntry? overlayEntry;
  final GlobalKey nodeKey = GlobalKey();
  final LayerLink layerLink = LayerLink();
  static List<OverlayEntry> overlayEntries = [];

  static void removeAllOverlays(BuildContext context) {
    for (var entry in List.from(overlayEntries)) {
      entry.remove();
    }
    overlayEntries.clear();
    for (var entry in BlueNode.overLays) {
      entry.isOverlayVisible = false;
    }
  }

  void showOverlay({
    required BuildContext context,
    required ToolTipPosition overLayPosition,
    required Topic topic,
    required String nodeId,
    required bool isFavorite,
    required TransferableSkillsBloc bloc,
    required ShowNode showNode,
  }) {
    if (isOverlayVisible) return;

    removeAllOverlays(context);

    RenderBox renderBox =
        nodeKey.currentContext!.findRenderObject() as RenderBox;
    Offset buttonPosition = renderBox.localToGlobal(Offset.zero);
    double buttonHeight = renderBox.size.height;

    overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        left: buttonPosition.dx,
        child: CompositedTransformFollower(
          offset: Offset(
              overLayPosition == ToolTipPosition.isLeft
                  ? 3
                  : overLayPosition == ToolTipPosition.isRight
                      ? -156
                      : -77,
              buttonHeight + 8),
          showWhenUnlinked: false,
          link: layerLink,
          child: Material(
            color: Colors.transparent,
            child: SkillPopup(
              bloc: bloc,
              tipPosition: overLayPosition,
              topic: topic,
              isFavorite: isFavorite,
              showNode: showNode,
            ),
          ),
        ),
      ),
    );

    Overlay.of(context).insert(overlayEntry!);
    overlayEntries.add(overlayEntry!);

    isOverlayVisible = true;
  }

  void removeOverlay() {
    if (isOverlayVisible && overlayEntry != null) {
      overlayEntry!.remove();
      overlayEntries.remove(overlayEntry);
      isOverlayVisible = false;
    }
  }
}
