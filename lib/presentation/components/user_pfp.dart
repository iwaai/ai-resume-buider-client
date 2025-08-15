import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:second_shot/blocs/app/app_bloc.dart';
import 'package:second_shot/utils/extensions.dart';

import '../theme/theme_utils/app_colors.dart';

class UserPfp extends StatelessWidget {
  final double? radius;
  const UserPfp({super.key, this.radius});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppBloc, AppState>(
      builder: (context, state) {
        return CircleAvatar(
          backgroundColor: AppColors.userBackgroundGreenColor,
          radius: radius,
          backgroundImage: state.user.profileImg.isNotEmpty
              ? CachedNetworkImageProvider(
                  state.user.profileImg,
                  // fit: BoxFit.cover,
                  // imageUrl: state.user.profileImg,
                  // placeholder: (context, str) =>
                  //     const CircularProgressIndicator(),
                  // errorWidget: (context, url, error) =>
                  //     Text(state.user.name.getInitials(),),
                )
              : null,
          child: state.user.profileImg.isEmpty
              ? Text(
                  state.user.name.getInitials(),
                  // fit: BoxFit.cover,
                  // imageUrl: state.user.profileImg,
                  // placeholder: (context, str) =>
                  //     const CircularProgressIndicator(),
                  // errorWidget: (context, url, error) =>
                  //     Text(state.user.name.getInitials(),),
                )
              : null,
        );
      },
    );
  }
}
