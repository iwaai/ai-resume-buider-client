import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:second_shot/presentation/theme/theme_utils/app_colors.dart';
import 'package:second_shot/utils/constants/assets.dart';
import 'package:second_shot/utils/extensions.dart';

import '../../../../blocs/app/app_bloc.dart';
import 'components/chat_textfield.dart';
import 'components/chatbot_components.dart';

class Chatbot extends StatelessWidget {
  Chatbot({super.key});

  final TextEditingController controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 300), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.only(top: 25.h),
        decoration: BoxDecoration(
          gradient: AppColors.primaryGradient,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.all(16.0.sp).copyWith(left: 10.w),
              child: Row(
                children: [
                  IconButton(
                      onPressed: () => context.pop(),
                      icon: const Icon(
                        Icons.arrow_back_outlined,
                        color: AppColors.whiteColor,
                      )),
                  Hero(
                    tag: 'chatBotTag',
                    child: Image.asset(
                      AssetConstants.chatbotIcon,
                      height: 42.h,
                      width: 42.w,
                    ),
                  ),
                  SizedBox(width: 10.w),
                  Text(
                    'AI Chat',
                    style: context.textTheme.titleLarge
                        ?.copyWith(color: AppColors.whiteColor),
                  ),
                ],
              ),
            ),
            BlocConsumer<AppBloc, AppState>(
              listener: (context, state) {},
              builder: (context, state) {
                _scrollToBottom();
                return Expanded(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 16.sp)
                        .copyWith(bottom: 90.h, top: 1.5.h),
                    decoration: BoxDecoration(
                        border: Border.all(color: AppColors.whiteColor),
                        borderRadius:
                            BorderRadius.vertical(top: Radius.circular(30.r)),
                        color: AppColors.whiteColor),
                    child: state.botChat.isNotEmpty
                        ? ListView.builder(
                            controller: _scrollController,
                            padding: EdgeInsets.zero,
                            physics: const BouncingScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: state.botChat.length,
                            itemBuilder: (context, index) {
                              final message = state.botChat[index];
                              return MessageBubble(
                                isMe: message.isMe,
                                time: message.timeStamp,
                                message: message.message,
                              );
                            },
                          )
                        : Center(
                            child: Text(
                              'Start a new conversation!',
                              style: context.textTheme.bodyMedium,
                            ),
                          ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
      bottomSheet: ChatTextField(
        controller: controller,
        onSend: () {
          context
              .read<AppBloc>()
              .add(ChatBotEvent(message: controller.text.trim()));
          controller.clear();
        },
      ),
    );
  }
}
