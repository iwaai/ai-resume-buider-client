import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:second_shot/blocs/home/success_stories/success_stories_bloc.dart';
import 'package:second_shot/presentation/theme/theme_utils/app_colors.dart';
import 'package:second_shot/presentation/views/home/components/success_story_card.dart';
import 'package:second_shot/utils/constants/constant.dart';

class ExploreProfileView extends StatelessWidget {
  const ExploreProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: Constant.horizontalPadding.w, vertical: 12.h),
      child: BlocBuilder<SuccessStoriesBloc, SuccessStoriesState>(
        builder: (context, state) {
          return NotificationListener<ScrollNotification>(
            onNotification: (ScrollNotification scrollNotification) {
              // if (scrollNotification.metrics.pixels ==
              //         scrollNotification.metrics.maxScrollExtent &&
              //     !state.loading &&
              //     !state.fetchingMore &&
              //     context.read<SuccessStoriesBloc>().exploreProfilePage <=
              //         context.read<SuccessStoriesBloc>().exploreTotalPage) {
              //   print('Fetching more profiles...');
              //   if (state.exploreProfileList.length >= 10) {
              //     context.read<SuccessStoriesBloc>().add(ExploreProfileData());
              //   }
              // }

              return false;
            },
            child: state.loading &&
                    state.exploreProfileList.isEmpty &&
                    context.read<SuccessStoriesBloc>().exploreProfilePage == 1
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : state.exploreProfileList.isEmpty
                    ? const Center(
                        child: Text("Not Stories Found"),
                      )
                    : ListView(
                        children: [
                          ListView.builder(
                            itemCount: state.exploreProfileList.length,
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              final storydata = state.exploreProfileList[index];
                              return GestureDetector(
                                // onTap: () {
                                //   Navigator.push(
                                //       context,
                                //       MaterialPageRoute(
                                //         builder: (context) =>
                                //             SuccessProfileDetail(
                                //                 successStory: storydata),
                                //       ));
                                // },
                                child: SucessStoryCard(storyModel: storydata),
                              );
                            },
                          ),

                          if (state.exploreProfileList.isNotEmpty &&
                              context
                                      .read<SuccessStoriesBloc>()
                                      .exploreProfilePage <=
                                  context
                                      .read<SuccessStoriesBloc>()
                                      .exploreTotalPage)
                            TextButton(
                              style: ButtonStyle(
                                overlayColor: WidgetStateProperty.all(Colors
                                    .transparent), // Removes splash effect
                                // splashFactory: NoSplash
                                //     .splashFactory, // Ensures no ripple effect
                              ),
                              onPressed: () {
                                context
                                    .read<SuccessStoriesBloc>()
                                    .add(ExploreProfileData(onRefresh: false));
                              },
                              child: state.fetchingMore
                                  ? const Center(
                                      child: CircularProgressIndicator())
                                  : const Text(
                                      'Load More',
                                      style: TextStyle(
                                        color: AppColors.secondaryColor,
                                      ),
                                    ),
                            )

                          // if (state.loading &&
                          //     state.exploreProfileList.isNotEmpty &&
                          //     context
                          //             .read<SuccessStoriesBloc>()
                          //             .exploreProfilePage >
                          //         1)
                          // const Padding(
                          //   padding: EdgeInsets.all(16.0),
                          //   child: Center(child: CircularProgressIndicator()),
                          // )
                        ],
                      ),
          );
        },
      ),
    );
  }
}
