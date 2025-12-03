import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_test/colors/colors.dart';
import '../bloc/post_details/post_detail_bloc.dart';
import '../bloc/post_details/post_detail_event.dart';
import '../bloc/post_details/post_detail_state.dart';
import '../repositories/post_repository.dart';
import '../utils/app_bar.dart';

class PostDetailScreen extends StatelessWidget {
  final int postId;
  final PostRepository repository;

  const PostDetailScreen({
    super.key,
    required this.postId,
    required this.repository,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
      PostDetailBloc(repository: repository)..add(LoadPostDetailEvent(postId)),
      child: Scaffold(
        appBar: const CustomAppBar(
          title: "Post Details",
          showBackButton: true,
        ),
        backgroundColor: kwhite,
        body: BlocBuilder<PostDetailBloc, PostDetailState>(
          builder: (context, state) {
            if (state is PostDetailLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is PostDetailLoaded) {
              final post = state.post;
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      post.title,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      post.body,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ],
                ),
              );
            } else if (state is PostDetailError) {
              return Center(child: Text(state.message));
            } else {
              return const SizedBox.shrink();
            }
          },
        ),
      ),
    );
  }
}
