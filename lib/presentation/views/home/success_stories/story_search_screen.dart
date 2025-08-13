import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:second_shot/blocs/home/success_stories/success_stories_bloc.dart';
import 'package:second_shot/presentation/components/components_barrels.dart';
import 'package:second_shot/presentation/views/home/components/success_story_card.dart';
import 'package:second_shot/utils/constants/constant.dart';

class StorySearchScreen extends StatelessWidget {
  StorySearchScreen({
    super.key,
  });

  final searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final bloc = GoRouterState.of(context).extra as SuccessStoriesBloc;
    return ScaffoldWrapper(
        child: Scaffold(
      appBar: const CustomAppBar(
        title: "Search",
      ),
      body: BlocProvider.value(
        value: bloc,
        child: BlocBuilder<SuccessStoriesBloc, SuccessStoriesState>(
          builder: (context, state) {
            return Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: Constant.horizontalPadding.h),
                  child: PrimaryTextField(
                    controller: searchController,
                    hintText: 'Search',
                    suffixWidget: GestureDetector(
                        onTap: () {
                          if (state.isMatchProfileTab == false) {
                            context.read<SuccessStoriesBloc>().add(
                                SearchStoryEvent(
                                    search: searchController.text));
                          }
                        },
                        child: const Icon(Icons.search)),
                    onChanged: (value) {
                      if (state.isMatchProfileTab == true) {
                        context.read<SuccessStoriesBloc>().add(
                            LocalSearchStoryEvent(
                                search: searchController.text));
                      }
                    },
                  ),
                ),
                state.loading
                    ? const Center(
                        child: CircularProgressIndicator(),
                      )
                    : Expanded(
                        child: (state.filterMatchProfileList.isEmpty &&
                                state.filterExploreProfile.isEmpty)
                            ? const Center(
                                child: Text("Not Found"),
                              )
                            : GridView.builder(
                                padding: EdgeInsets.symmetric(
                                    horizontal: Constant.horizontalPadding.w),
                                itemCount: state.isMatchProfileTab == true
                                    ? state.filterMatchProfileList.length
                                    : state.filterExploreProfile.length,
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  mainAxisSpacing: 16,
                                  crossAxisSpacing: 10,
                                  childAspectRatio: 0.8,
                                ),
                                itemBuilder: (context, index) {
                                  return GestureDetector(
                                    // onTap: () {
                                    //   Navigator.push(
                                    //       context,
                                    //       MaterialPageRoute(
                                    //         builder: (context) =>
                                    //             SuccessProfileDetail(
                                    //           successStory: state
                                    //                       .isMatchProfileTab ==
                                    //                   true
                                    //               ? state.filterMatchProfileList[
                                    //                   index]
                                    //               : state.filterExploreProfile[
                                    //                   index],
                                    //         ),
                                    //       ));
                                    // },
                                    child: SucessStoryCard(
                                        storyModel: state.isMatchProfileTab ==
                                                true
                                            ? state
                                                .filterMatchProfileList[index]
                                            : state
                                                .filterExploreProfile[index]),
                                  );
                                }),
                      )
              ],
            );
          },
        ),
      ),
    ));
  }
}
