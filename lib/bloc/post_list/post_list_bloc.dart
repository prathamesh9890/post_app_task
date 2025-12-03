import 'package:flutter_bloc/flutter_bloc.dart';
import '../../repositories/post_repository.dart';
import 'post_list_event.dart';
import 'post_list_state.dart';

class PostListBloc extends Bloc<PostListEvent, PostListState> {
  final PostRepository repository;

  PostListBloc({required this.repository}) : super(PostListInitial()) {
    on<LoadPostsEvent>(_onLoadPosts);
    on<MarkPostReadEvent>(_onMarkPostRead);
  }

  Future<void> _onLoadPosts(
      LoadPostsEvent event, Emitter<PostListState> emit) async {
    emit(PostListLoading());

    try {
      final readIds = await repository.getReadPostIds();

      final (posts, fromCache) = await repository.getPostsWithCache();

      String? infoMsg;
      if (fromCache) {
        infoMsg =
        'Showing cached data. Latest data will appear when online is available.';
      }

      emit(
        PostListLoaded(
          posts: posts,
          readPostIds: readIds,
          fromCache: fromCache,
          message: infoMsg,
        ),
      );
    } catch (e) {
      emit(PostListError('Failed to load posts. Please try again.'));
    }
  }

  Future<void> _onMarkPostRead(
      MarkPostReadEvent event, Emitter<PostListState> emit) async {
    if (state is! PostListLoaded) return;
    final current = state as PostListLoaded;
    final updatedRead = Set<int>.from(current.readPostIds)..add(event.postId);

    emit(current.copyWith(readPostIds: updatedRead));

    // Persist read IDs in background
    try {
      await repository.saveReadPostIds(updatedRead);
    } catch (_) {
      // ignore, weak failure
    }
  }
}
