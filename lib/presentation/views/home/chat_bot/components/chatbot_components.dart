import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:second_shot/presentation/components/user_pfp.dart';
import 'package:second_shot/utils/extensions.dart';

import '../../../../theme/theme_utils/app_colors.dart';

class MessageBubble extends StatelessWidget {
  const MessageBubble({
    super.key,
    required this.isMe,
    required this.message,
    required this.time,
  });

  final bool isMe;
  final String message;
  final String time;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: isMe ? Alignment.topRight : Alignment.topLeft,
      padding: EdgeInsets.symmetric(vertical: 12.h),
      margin: isMe ? EdgeInsets.only(left: 42.w) : EdgeInsets.only(right: 42.w),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Flexible(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment:
                  isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [
                AnimatedContainer(
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.easeInOut,
                    constraints: BoxConstraints(maxWidth: 0.75.sw),
                    padding:
                        EdgeInsets.symmetric(vertical: 12.h, horizontal: 18.w),
                    decoration: BoxDecoration(
                      borderRadius: isMe
                          ? BorderRadius.all(Radius.circular(20.r))
                              .copyWith(bottomRight: Radius.zero)
                          : BorderRadius.all(Radius.circular(20.r))
                              .copyWith(bottomLeft: Radius.zero),
                      gradient: isMe
                          ? AppColors.primaryGradient
                          : LinearGradient(colors: [
                              AppColors.chatWhite,
                              AppColors.chatWhite
                            ]),
                    ),
                    child: AnimatedCrossFade(
                      duration: const Duration(milliseconds: 500),
                      crossFadeState: message != 'Loading'
                          ? CrossFadeState.showSecond
                          : CrossFadeState.showFirst,
                      firstChild: const TypingIndicator(),
                      secondChild: Text(
                        message,
                        style: context.textTheme.labelLarge?.copyWith(
                            color: isMe
                                ? AppColors.whiteColor
                                : AppColors.blackColor),
                      ),
                    )),
                if (message != 'Loading')
                  Text(
                    time,
                    style: const TextStyle(fontWeight: FontWeight.w500),
                  ),
              ],
            ),
          ),
          SizedBox(width: 10.w),
          if (isMe) const UserPfp(),
        ],
      ),
    );
  }
}

class TypingIndicator extends StatefulWidget {
  const TypingIndicator({super.key});

  @override
  _TypingIndicatorState createState() => _TypingIndicatorState();
}

class _TypingIndicatorState extends State<TypingIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 350),
      vsync: this,
    )..repeat();

    _animation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 40.w,
      height: 20.h,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: List.generate(3, (index) {
          return AnimatedBuilder(
            animation: _animation,
            builder: (context, child) {
              return Opacity(
                opacity:
                    (index / 3.0 - _animation.value).abs() < 0.3 ? 1.0 : 0.3,
                child: child,
              );
            },
            child: Container(
              width: 8.w,
              height: 8.h,
              decoration: const BoxDecoration(
                color: AppColors.secondaryColor,
                shape: BoxShape.circle,
              ),
            ),
          );
        }),
      ),
    );
  }
}
