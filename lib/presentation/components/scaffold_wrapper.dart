import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:second_shot/presentation/router/route_constants.dart';
import 'package:second_shot/utils/constants/assets.dart';

class ScaffoldWrapper extends StatelessWidget {
  final Scaffold child;

  const ScaffoldWrapper(
      {super.key, required this.child, this.showChatbot = false});

  final bool showChatbot;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: showChatbot
          ? Padding(
              padding: EdgeInsets.only(bottom: 50.0.h),
              child: FloatingActionButton(
                heroTag: 'chatBotTag',
                onPressed: () => context.push(AppRoutes.chatBot),
                child: Image.asset(AssetConstants.chatbotIcon),
              ),
            )
          : null,
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(AssetConstants.scaffoldBG),
            fit: BoxFit.cover,
          ),
        ),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: child,
        ),
      ),
    );
  }
}
