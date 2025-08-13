part of 'library_resume_builder.dart';

class ResumeHeaderSection extends StatefulWidget {
  const ResumeHeaderSection({
    super.key,
    required this.header,
    required this.sections,
    this.headerColor,
    this.showDivider = true,
  });

  final String header;
  final Color? headerColor;
  final bool showDivider;
  final List<ResumeSectionDetails> sections;

  @override
  State<ResumeHeaderSection> createState() => _ResumeHeaderSectionState();
}

class _ResumeHeaderSectionState extends State<ResumeHeaderSection>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _slideAnimation = Tween<Offset>(
            begin: const Offset(0, 10.0), end: Offset.zero)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _slideAnimation,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(widget.header,
              style: context.textTheme.titleLarge?.copyWith(
                  fontFamily: 'Times',
                  fontSize: 18.sp,
                  color: widget.headerColor)),
          Column(
            children: widget.sections,
          ),
          if (widget.showDivider) const Divider()
        ],
      ),
    );
  }
}
