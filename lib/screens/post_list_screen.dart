import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/post_list/post_list_bloc.dart';
import '../bloc/post_list/post_list_event.dart';
import '../bloc/post_list/post_list_state.dart';
import '../colors/colors.dart';
import '../cubit/post_timer_cubit.dart';
import '../repositories/post_repository.dart';
import '../utils/app_bar.dart';
import '../widgets/post_list_item.dart';
import 'post_detail_screen.dart';

class PostListScreen extends StatelessWidget {
  const PostListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: "Posts",
        showBackButton: false,
      ),
      backgroundColor: kwhite,
      body: BlocConsumer<PostListBloc, PostListState>(
        listener: (context, state) {
          if (state is PostListLoaded && state.message != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message!)),
            );
          }
          if (state is PostListError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        builder: (context, state) {
          if (state is PostListLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is PostListLoaded) {
            // Initialize timers once
            context.read<PostTimerCubit>().initializeTimers(state.posts);

            return RefreshIndicator(
              onRefresh: () async {
                context.read<PostListBloc>().add(LoadPostsEvent());
              },
              child: ListView.builder(
                itemCount: state.posts.length,
                itemBuilder: (context, index) {
                  final post = state.posts[index];
                  final isRead = state.readPostIds.contains(post.id);

                  return PostListItem(
                    post: post,
                    isRead: isRead,
                    onTap: () {
                      // Mark as read
                      context
                          .read<PostListBloc>()
                          .add(MarkPostReadEvent(post.id));
                      // Pause timer while navigating
                      context
                          .read<PostTimerCubit>()
                          .pauseTimerForPost(post.id);

                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) {
                            final repo = context.read<PostRepository>();
                            return PostDetailScreen(
                              postId: post.id,
                              repository: repo,
                            );
                          },
                        ),
                      );
                    },
                  );
                },
              ),
            );
          } else if (state is PostListError) {
            return Center(
              child: Text(
                state.message,
                textAlign: TextAlign.center,
              ),
            );
          } else {
            return const SizedBox.shrink();
          }

        },
      ),
    );
  }
}
