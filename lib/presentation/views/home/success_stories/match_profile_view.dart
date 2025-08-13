import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:second_shot/blocs/home/success_stories/success_stories_bloc.dart';
import 'package:second_shot/utils/constants/constant.dart';

import '../components/success_story_card.dart';

class MatchProfileView extends StatelessWidget {
  const MatchProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SuccessStoriesBloc, SuccessStoriesState>(
      builder: (context, state) {
        return RefreshIndicator(
          onRefresh: () async {
            context
                .read<SuccessStoriesBloc>()
                .add(MatchProfileData(onRefresh: true));
          },
          child: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: Constant.horizontalPadding, vertical: 8.h),
            child: state.loading && state.matchProfileList.isEmpty
                ? const Center(
                    child:
                        CircularProgressIndicator()) // Show loading indicator initially
                : ListView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    children: [
                      if (state.matchProfileList.isEmpty)
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.7.h,
                          child: const Center(child: Text("No Story Found")),
                        )
                      else
                        ListView.builder(
                          itemCount: state.matchProfileList.length,
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            final story = state.matchProfileList[index];
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
                              child: SucessStoryCard(
                                storyModel: story,
                              ),
                            );
                          },
                        ),
                      if (state
                          .fetchingMore) // Show loading at the bottom for pagination
                        const Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Center(child: CircularProgressIndicator()),
                        ),
                    ],
                  ),
          ),
        );
      },
    );
  }
}
